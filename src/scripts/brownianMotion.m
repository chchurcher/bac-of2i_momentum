% Brownian motion of an ellipsoid without external forces or torques

% Set seed of the random generator for reproducity
rng(10);

% Constants
halfAxis = 1e-6 * [1, 10, 10];
delta_t = 0.1;
end_t = 10;

t = 0:delta_t:end_t;

forcTorq = zeros(6, numel(t));
% forcTorq = repmat(forcTorq, 1, numel(t));
forcTorq(:,1:25) = repmat(1e-15 * [1; 0; 0; 0; 1e-2; 0], 1, 25);
forcTorq(:,26:50) = repmat(1e-15 * [1; 0; 0; 0; 0; 0], 1, 25);

K = ResistanceTensor.ellipsoid(halfAxis);
D = ResistanceTensor.diffusionMatrix(K);

particle = Particle(D);
trajectory = Trajectory();

for i = 1:numel(t)
    particle = particle.step(forcTorq(:, i), delta_t);
    trajectory = trajectory.appendStep(particle);
end

trajectory.visualize();
