#! /usr/bin/env python

import numpy as np
import logging
import sys
import torch
import argparse
from torch import optim

sys.path.append("../")

from manifold_flow.training import ManifoldFlowTrainer, losses, ConditionalManifoldFlowTrainer, callbacks
from experiments.utils.various import _create_model, _filename, _load_training_dataset, _create_modelname, _load_simulator

logger = logging.getLogger(__name__)


def train(args):
    _create_modelname(args)
    logger.info(
        "Training model %s with algorithm %s and %s latent dims on data set %s (data dim %s, true latent dim %s)",
        args.modelname,
        args.algorithm,
        args.modellatentdim,
        args.dataset,
        args.datadim,
        args.truelatentdim,
    )

    # Bug fix related to some num_workers > 1 and CUDA. Bad things happen otherwise!
    torch.multiprocessing.set_start_method("spawn", force=True)

    # Data
    simulator = _load_simulator(args)
    dataset = _load_training_dataset(args)

    logger.info("Parameters: %s", simulator.parameter_dim())

    # Model
    model = _create_model(args, context_features=simulator.parameter_dim())

    # Train
    if simulator.parameter_dim() is None:
        trainer = ManifoldFlowTrainer(model)
    else:
        trainer = ConditionalManifoldFlowTrainer(model)

    common_kwargs = {"dataset": dataset, "batch_size": args.batchsize, "initial_lr":args.lr, "scheduler": optim.lr_scheduler.CosineAnnealingLR}

    if args.algorithm == "pie":
        logger.info("Starting training PIE on NLL")
        learning_curves = trainer.train(
            loss_functions=[losses.nll],
            loss_labels=["NLL"],
            loss_weights=[1.0],
            epochs=args.epochs,
            callbacks=[callbacks.save_model_after_every_epoch(_filename("model", None, args)[:-3] + "_epoch_{}.pt")],
            forward_kwargs={"mode": "pie"},
            **common_kwargs,
        )
        learning_curves = np.vstack(learning_curves).T

    elif args.algorithm == "flow":
        logger.info("Starting training standard flow on NLL")
        learning_curves = trainer.train(
            loss_functions=[losses.nll],
            loss_labels=["NLL"],
            loss_weights=[1.0],
            epochs=args.epochs,
            callbacks=[callbacks.save_model_after_every_epoch(_filename("model", None, args)[:-3] + "_epoch_{}.pt")],
            **common_kwargs,
        )
        learning_curves = np.vstack(learning_curves).T

    elif args.algorithm == "slice":
        logger.info("Starting training slice of PIE, phase 1: pretraining on reconstruction error")
        learning_curves = trainer.train(
            loss_functions=[losses.mse],
            loss_labels=["MSE"],
            loss_weights=[1.0],
            epochs=args.epochs // 3,
            callbacks=[callbacks.save_model_after_every_epoch(_filename("model", None, args)[:-3] + "_epoch_A{}.pt")],
            forward_kwargs={"mode": "projection"},
            **common_kwargs,
        )
        learning_curves = np.vstack(learning_curves).T

        logger.info("Starting training slice of PIE, phase 2: mixed training")
        learning_curves_ = trainer.train(
            loss_functions=[losses.mse, losses.nll],
            loss_labels=["MSE", "NLL"],
            loss_weights=[1.0, 0.01],
            epochs=args.epochs // 3,
            parameters=model.inner_transform.parameters(),
            callbacks=[callbacks.save_model_after_every_epoch(_filename("model", None, args)[:-3] + "_epoch_B{}.pt")],
            forward_kwargs={"mode": "slice"},
            **common_kwargs,
        )
        learning_curves_ = np.vstack(learning_curves_).T
        learning_curves = np.vstack((learning_curves, learning_curves_))

        logger.info("Starting training slice of PIE, phase 3: training only inner flow on NLL")
        learning_curves_ = trainer.train(
            loss_functions=[losses.mse, losses.nll],
            loss_labels=["MSE", "NLL"],
            loss_weights=[0.0, 1.0],
            epochs=args.epochs // 3,
            parameters=model.inner_transform.parameters(),
            callbacks=[callbacks.save_model_after_every_epoch(_filename("model", None, args)[:-3] + "_epoch_C{}.pt")],
            forward_kwargs={"mode": "slice"},
            **common_kwargs,
        )
        learning_curves_ = np.vstack(learning_curves_).T
        learning_curves = np.vstack((learning_curves, learning_curves_))

    else:
        logger.info("Starting training MF, phase 1: pretraining on reconstruction error")
        learning_curves = trainer.train(
            loss_functions=[losses.mse],
            loss_labels=["MSE"],
            loss_weights=[1.0],
            epochs=args.epochs // 3,
            callbacks=[callbacks.save_model_after_every_epoch(_filename("model", None, args)[:-3] + "_epoch_A{}.pt")],
            forward_kwargs={"mode": "projection"},
            **common_kwargs,
        )
        learning_curves = np.vstack(learning_curves).T

        logger.info("Starting training MF, phase 2: mixed training")
        learning_curves_ = trainer.train(
            loss_functions=[losses.mse, losses.nll],
            loss_labels=["MSE", "NLL"],
            loss_weights=[1.0, 0.01],
            epochs=args.epochs // 3,
            parameters=model.inner_transform.parameters(),
            callbacks=[callbacks.save_model_after_every_epoch(_filename("model", None, args)[:-3] + "_epoch_B{}.pt")],
            forward_kwargs={"mode": "mf"},
            **common_kwargs,
        )
        learning_curves_ = np.vstack(learning_curves_).T
        learning_curves = np.vstack((learning_curves, learning_curves_))

        logger.info("Starting training MF, phase 3: training only inner flow on NLL")
        learning_curves_ = trainer.train(
            loss_functions=[losses.mse, losses.nll],
            loss_labels=["MSE", "NLL"],
            loss_weights=[0.0, 1.0],
            epochs=args.epochs // 3,
            parameters=model.inner_transform.parameters(),
            callbacks=[callbacks.save_model_after_every_epoch(_filename("model", None, args)[:-3] + "_epoch_C{}.pt")],
            forward_kwargs={"mode": "mf"},
            **common_kwargs,
        )
        learning_curves_ = np.vstack(learning_curves_).T
        learning_curves = np.vstack((learning_curves, learning_curves_))

    # Save
    logger.info("Saving model")
    torch.save(model.state_dict(), _filename("model", None, args))
    np.save(_filename("learning_curve", None, args), learning_curves)


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument("--modelname", type=str, default=None, help="Model name.")
    parser.add_argument("--algorithm", type=str, default="mf", choices=["flow", "pie", "mf", "slice"])
    parser.add_argument("--dataset", type=str, default="spherical_gaussian", choices=["spherical_gaussian", "conditional_spherical_gaussian"])

    parser.add_argument("--truelatentdim", type=int, default=2)
    parser.add_argument("--datadim", type=int, default=3)
    parser.add_argument("--epsilon", type=float, default=0.01)

    parser.add_argument("--modellatentdim", type=int, default=2)
    parser.add_argument("--outertransform", type=str, default="affine-coupling")
    parser.add_argument("--innertransform", type=str, default="affine-coupling")
    parser.add_argument("--lineartransform", type=str, default="permutation")
    parser.add_argument("--outerlayers", type=int, default=5)
    parser.add_argument("--innerlayers", type=int, default=5)
    parser.add_argument("--conditionalouter", action="store_true")
    parser.add_argument("--outercouplingmlp", action="store_true")
    parser.add_argument("--outercouplinglayers", type=int, default=3)
    parser.add_argument("--outercouplinghidden", type=int, default=256)

    parser.add_argument("--epochs", type=int, default=60)
    parser.add_argument("--batchsize", type=int, default=200)
    parser.add_argument("--lr", type=float, default=1.0e-3)

    parser.add_argument("--dir", type=str, default="../")
    parser.add_argument("--debug", action="store_true")

    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    logging.basicConfig(
        format="%(asctime)-5.5s %(name)-20.20s %(levelname)-7.7s %(message)s", datefmt="%H:%M", level=logging.DEBUG if args.debug else logging.INFO
    )
    logger.info("Hi!")
    train(args)
    logger.info("All done! Have a nice day!")
