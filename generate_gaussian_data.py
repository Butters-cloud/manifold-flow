#! /usr/bin/env python

import numpy as np
import logging
import argparse
from scipy.stats import norm

logging.basicConfig(
    format="%(asctime)-5.5s %(name)-20.20s %(levelname)-7.7s %(message)s",
    datefmt="%H:%M",
    level=logging.INFO,
)


def simulator(epsilon, latent_dim, data_dim, n, transform):
    z = np.random.normal(0., 1., size=(n, latent_dim))
    logp = np.log(norm(loc=0., scale=1.).pdf(z))

    if latent_dim < data_dim:
        z_eps = np.random.normal(0., epsilon, size=(n, data_dim - latent_dim))
        z = np.concatenate((z, z_eps), axis=1)

        logp_eps = np.log(norm(loc=0., scale=epsilon).pdf(z_eps))
        logp = np.concatenate((logp, logp_eps), axis=1)

    this_transform = transform[:data_dim, :data_dim]
    x = this_transform.dot(z.T).T
    logp = np.sum(logp, axis=1) + np.log(np.abs(np.linalg.det(this_transform)))
    
    return x, z, logp


def generate(
        epsilon,
        latent_dim=8,
        data_dims=[8,16,32,64,128],
        n_train=1000000,
        n_test=10000,
        base_dir=".",
):
    transform = np.random.normal(loc=0., scale=1., size=(max(data_dims), max(data_dims)))
    np.save("{}/data/gaussian/gaussian_transform.npy".format(base_dir), transform)

    for data_dim in data_dims:
        x_train, z_train, logp_train = simulator(epsilon, latent_dim, data_dim, n_train, transform)
        x_test, z_test, logp_test = simulator(epsilon, latent_dim, data_dim, n_test, transform)

        np.save("{}/data/gaussian/gaussian_{}_{}_x_train.npy".format(base_dir, latent_dim, data_dim), x_train)
        np.save("{}/data/gaussian/gaussian_{}_{}_x_test.npy".format(base_dir, latent_dim, data_dim), x_test)
        np.save("{}/data/gaussian/gaussian_{}_{}_z_train.npy".format(base_dir, latent_dim, data_dim), z_train)
        np.save("{}/data/gaussian/gaussian_{}_{}_z_test.npy".format(base_dir, latent_dim, data_dim), z_test)
        np.save("{}/data/gaussian/gaussian_{}_{}_logp_train.npy".format(base_dir, latent_dim, data_dim), logp_train)
        np.save("{}/data/gaussian/gaussian_{}_{}_logp_test.npy".format(base_dir, latent_dim, data_dim), logp_test)


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--epsilon", type=float, default=0.001)
    parser.add_argument("--dir", type=str, default=".")
    return parser.parse_args()


if __name__ == "__main__":
    logging.info("Hi!")
    args = parse_args()
    generate(args.epsilon, base_dir=args.dir)
    logging.info("All done! Have a nice day!")
