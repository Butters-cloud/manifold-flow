import torch
from torch import nn
import numpy as np

from aef.models.flows import FlowSequential, MADE, BatchNormFlow, Reverse


class Projection(nn.Module):
    def __init__(self, input_dim, output_dim):
        super().__init__()
        assert input_dim >= output_dim
        self.input_dim = input_dim
        self.output_dim = output_dim

    def forward(self, inputs, mode="direct"):
        if mode == "direct":
            u = inputs[:, :self.output_dim]
            return u
        else:
            u = inputs
            x = torch.zeros(inputs.size(0), self.input_dim)
            x[:, self.output_dim] = inputs
            return x


class TwoStepAutoencodingFlow(nn.Module):
    def __init__(self, data_dim, latent_dim=10, n_mades_inner=3, n_mades_outer=3, n_hidden=100):
        super(TwoStepAutoencodingFlow, self).__init__()

        modules = []
        for _ in range(n_mades_outer):
            modules += [
                MADE(data_dim, n_hidden, None, act='relu'),
                BatchNormFlow(data_dim),
                Reverse(data_dim)
            ]
        self.outer_flow = FlowSequential(*modules)

        self.projection = Projection(data_dim, latent_dim)

        modules = []
        for _ in range(n_mades_inner):
            modules += [
                MADE(latent_dim, n_hidden, None, act='relu'),
                BatchNormFlow(latent_dim),
                Reverse(latent_dim)
            ]
        self.inner_flow = FlowSequential(*modules)

    def forward(self, x):
        # Encode
        h, log_det_outer = self.outer_flow(x)
        h = self.projection(h)
        u, log_det_inner = self.inner_flow(h)

        # Decode
        h = self.inner_flow(u, mode="inverse")
        h = self.projection(h, mode="inverse")
        x = self.outer_flow(h, mode="inverse")

        # Log prob
        log_prob = (-0.5 * u.pow(2) - 0.5 * np.log(2 * np.pi)).sum(-1, keepdim=True)
        log_prob = log_prob + log_det_outer + log_det_inner

        return x, log_prob, u

    def log_prob(self, x):
        # Encode
        h, log_det_outer = self.outer_flow(x)
        h = self.projection(h)
        u, log_det_inner = self.inner_flow(h)

        # Log prob
        log_prob = (-0.5 * u.pow(2) - 0.5 * np.log(2 * np.pi)).sum(-1, keepdim=True)
        log_prob = log_prob + log_det_outer + log_det_inner

        return log_prob

    def sample(self, u=None, n=1):
        h = self.inner_flow.sample(noise=u, num_samples=n)
        h = self.projection(h, mode="inverse")
        x = self.outer_flow(h, mode="inverse")
        return x
