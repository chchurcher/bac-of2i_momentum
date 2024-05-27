% Brownian motion of an ellipsoid without external forces or torques

% Set seed of the random generator for reproducity
rng(10);

% Constants
halfAxes = 1e-6 * [1, 10, 10];
delta_t = 0.1;
end_t = 10;

t = 0:delta_t:end_t;
forcTorq = zeros(6, numel(t));

D = DiffusionTensor.ellipsoid(halfAxes);
particle = Particle(D);
particle = particle.setBrownianMotion(true);
trajectory = Trajectory();

for i = 1:numel(t)
    particle = particle.step(forcTorq(:, i), delta_t);
    trajectory = trajectory.appendStep(particle);
end

trajectory.visualize();
