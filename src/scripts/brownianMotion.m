% Brownian motion of an ellipsoid without external forces or torques

% Set seed of the random generator for reproducity
rng(10);

% Constants
halfAxis = 1e-6 * [100, 1, 1];
delta_t = 0.1;
end_t = 10;

t = 0:delta_t:end_t;

forcTorq = zeros(6, numel(t));
% forcTorq = repmat(forcTorq, 1, numel(t));
forcTorq(:,1:5) = repmat(1e-10 * [1; 0; 0; 0; 0; 0], 1, 5);
forcTorq(:,6:10) = repmat(1e-10 * [0; 0; 0; 1e-8; 0; 0], 1, 5);

K = ResistanceTensor.ellipsoid(halfAxis);
D = ResistanceTensor.diffusionMatrix(K);

particle = Particle(D);
trajectory = Trajectory();

mu = zeros(6, 1);
w = mvnrnd(mu, D, numel(t));
deltaPosRot = 1 / (Constants.k_B * Constants.T) ...
    * delta_t * D * forcTorq + sqrt(2 * delta_t) * w.';

for i = 1:numel(t)
    particle = particle.step(deltaPosRot(:, i));
    trajectory = trajectory.appendStep(particle);
end

trajectory.visualize();
