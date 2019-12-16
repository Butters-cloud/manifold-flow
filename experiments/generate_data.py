#! /usr/bin/env python

import argparse
import sys
import numpy as np
import logging

sys.path.append("../")

from experiments.utils.various import load_simulator
from experiments.utils.names import create_filename

logger = logging.getLogger(__name__)


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument("--dataset", type=str, default="spherical_gaussian", choices=["spherical_gaussian", "conditional_spherical_gaussian"])

    parser.add_argument("--truelatentdim", type=int, default=2)
    parser.add_argument("--datadim", type=int, default=3)
    parser.add_argument("--epsilon", type=float, default=0.01)
    parser.add_argument("--train", type=int, default=100000)
    parser.add_argument("--test", type=int, default=1000)

    parser.add_argument("--dir", type=str, default="../")
    parser.add_argument("--debug", action="store_true")

    return parser.parse_args()


def generate(args):
    # Simulator
    simulator = load_simulator(args)

    # Parameters?
    conditional = simulator.parameter_dim() is not None

    parameters_train = simulator.sample_from_prior(args.train) if conditional else None
    parameters_test = np.array([simulator.default_parameters() for _ in range(args.test)]).reshape((args.test, -1)) if conditional else None

    # Sample
    logger.info("Generating %s training samples at parameters %s", args.train, parameters_train)
    x_train = simulator.sample(args.train, parameters=parameters_train)

    logger.info("Generating %s test samples at parameters %s", args.test, parameters_test)
    x_test = simulator.sample(args.test, parameters=parameters_test)

    # Save
    np.save(create_filename("sample", "x_train", args), x_train)
    np.save(create_filename("sample", "x_test", args), x_test)
    if conditional:
        np.save(create_filename("sample", "parameters_train", args), parameters_train)
        np.save(create_filename("sample", "parameters_test", args), parameters_test)


if __name__ == "__main__":
    args = parse_args()
    logging.basicConfig(
        format="%(asctime)-5.5s %(name)-20.20s %(levelname)-7.7s %(message)s", datefmt="%H:%M", level=logging.DEBUG if args.debug else logging.INFO
    )
    logger.info("Hi!")
    generate(args)
    logger.info("All done! Have a nice day!")
