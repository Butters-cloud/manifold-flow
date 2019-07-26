#! /usr/bin/env python

import numpy as np
import logging
import sys
import torch
import argparse

sys.path.append("../")

from aef.models.autoencoding_flow import TwoStepAutoencodingFlow
from aef.models.flow import Flow
from aef.trainer import AutoencodingFlowTrainer, NumpyDataset
from aef.losses import nll, mse
from aef_data.images import get_data

logger = logging.getLogger(__name__)


def train(
    model_filename,
    dataset="tth",
    data_dim=None,
    latent_dim=10,
    flow_steps_inner=5,
    flow_steps_outer=5,
    batch_size=128,
    epochs=(20, 20),
    alpha=1.0e-3,
    lr=(1.0e-4, 1.0e-6),
    base_dir=".",
):
    logger.info("Starting training of model %s on data set %s", model_filename, dataset)

    # Data
    if dataset == "tth":
        x = np.load("{}/data/tth/x_train.npy".format(base_dir))
        x_means = np.mean(x, axis=0)
        x_stds = np.std(x, axis=0)
        x = (x - x_means[np.newaxis, :]) / x_stds[np.newaxis, :]
        y = np.ones(x.shape[0])
        data = NumpyDataset(x, y)
        data_dim = 48
        mode = "vector"
        logger.info("Loaded tth data with %s dimensions", data_dim)

    elif dataset == "gaussian":
        assert data_dim is not None
        x = np.load(
            "{}/data/gaussian/gaussian_8_{}_x_train.npy".format(base_dir, data_dim)
        )
        y = np.ones(x.shape[0])
        data = NumpyDataset(x, y)
        mode = "vector"
        logger.info("Loaded linear Gaussian data with %s dimensions", data_dim)

    elif dataset == "spherical_gaussian":
        assert data_dim is not None
        x = np.load(
            "{}/data/spherical_gaussian/spherical_gaussian_15_{}_x_train.npy".format(
                base_dir, data_dim
            )
        )
        y = np.ones(x.shape[0])
        data = NumpyDataset(x, y)
        mode = "vector"
        logger.info("Loaded spherical Gaussian data with %s dimensions", data_dim)

    elif dataset == "cifar":
        dataset, data_dim = get_data(
            "cifar-10-fast", 8, base_dir + "/data/", train=True
        )
        mode = "image"
        logger.info("Loaded CIFAR data with dimensions %s", data_dim)

    elif dataset == "imagenet":
        dataset, data_dim = get_data(
            "imagenet-64-fast", 8, base_dir + "/data/", train=True
        )
        mode = "image"
        logger.info("Loaded ImageNet data with dimensions %s", data_dim)

    else:
        raise NotImplementedError("Unknown dataset {}".format(dataset))

    # Stop simulations where latent dim is larger than x dim
    if isinstance(data_dim, int) and latent_dim > data_dim:
        logger.info("Latent dim is larger than data dim, skipping this")
        return

    # Model
    if latent_dim is None:
        logger.info("Creating plain flow")
        model = Flow(data_dim=data_dim, steps=flow_steps_outer, mode=mode)

    else:
        logger.info("Creating auto-encoding flow with %s latent dimensions")
        model = TwoStepAutoencodingFlow(
            data_dim=data_dim,
            latent_dim=latent_dim,
            steps_inner=flow_steps_inner,
            steps_outer=flow_steps_outer,
            mode=mode,
        )

    # Trainer
    trainer = AutoencodingFlowTrainer(model, double_precision=True)

    # Train
    if latent_dim is None:
        logger.info("Starting training on NLL")
        trainer.train(
            optimizer=torch.optim.Adam,
            dataset=data,
            loss_functions=[nll],
            loss_labels=["NLL"],
            loss_weights=[1.0],
            batch_size=batch_size,
            epochs=epochs,
            verbose="all",
            initial_lr=lr[0],
            final_lr=lr[1],
        )
    else:
        logger.info("Starting training on MSE")
        trainer.train(
            optimizer=torch.optim.Adam,
            dataset=data,
            loss_functions=[mse],
            loss_labels=["MSE"],
            loss_weights=[1.0],
            batch_size=batch_size,
            epochs=epochs // 2,
            verbose="all",
            initial_lr=lr[0],
            final_lr=lr[1],
        )
        logger.info("Starting training on MSE and NLL")
        trainer.train(
            optimizer=torch.optim.Adam,
            dataset=data,
            loss_functions=[mse, nll],
            loss_labels=["MSE", "NLL"],
            loss_weights=[1.0, alpha],
            batch_size=batch_size,
            epochs=epochs - epochs // 2,
            verbose="all",
            initial_lr=lr[0],
            final_lr=lr[1],
            parameters=model.outer_transform.parameters(),
        )

    # Save
    logger.info(
        "Saving model to %s", "{}/data/models/{}.pt".format(base_dir, model_filename)
    )
    torch.save(
        model.state_dict(), "{}/data/models/{}.pt".format(base_dir, model_filename)
    )


def parse_args():
    parser = argparse.ArgumentParser(
        description="Strong lensing experiments: simulation"
    )
    parser.add_argument("name", type=str, help="Model name.")
    parser.add_argument(
        "--dataset",
        type=str,
        default="tth",
        choices=["cifar", "imagenet", "tth", "gaussian", "spherical_gaussian"],
    )
    parser.add_argument("-x", type=int, default=None)
    parser.add_argument("--latent", type=int, default=None)
    parser.add_argument("--steps", type=int, default=10)
    parser.add_argument("--alpha", type=float, default=0.01)
    parser.add_argument("--epochs", type=int, default=20)
    parser.add_argument("--batchsize", type=int, default=128)
    parser.add_argument("--lr", type=float, default=1.0e-4)
    parser.add_argument("--lrdecay", type=float, default=0.1)
    parser.add_argument(
        "--dir",
        type=str,
        default="/Users/johannbrehmer/work/projects/ae_flow/autoencoded-flow",
    )
    parser.add_argument("--debug", action="store_true")
    return parser.parse_args()


if __name__ == "__main__":

    args = parse_args()
    logging.basicConfig(
        format="%(asctime)-5.5s %(name)-20.20s %(levelname)-7.7s %(message)s",
        datefmt="%H:%M",
        level=logging.DEBUG if args.debug else logging.INFO,
    )
    logger.info("Hi!")

    train(
        model_filename=args.name,
        dataset=args.dataset,
        data_dim=args.x,
        latent_dim=args.latent,
        flow_steps_inner=args.steps,
        flow_steps_outer=args.steps,
        batch_size=args.batchsize,
        epochs=args.epochs,
        alpha=args.alpha,
        lr=(args.lr, args.lr * args.lrdecay),
        base_dir=args.dir,
    )

    logger.info("All done! Have a nice day!")
