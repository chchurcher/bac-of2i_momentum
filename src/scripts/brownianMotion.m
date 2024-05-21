% Brownian motion of an ellipsoid without external forces or torques

% Set seed of the random generator for reproducity
rng(10);

% Constants
halfAxis = 1e-6 * [100, 1, 1];
delta_t = 0.1;
end_t = 10;

forcTorq = zeros(6, numel(t));
% forcTorq = repmat(forcTorq, 1, numel(t));
forcTorq(:,1:5) = repmat(1e-10 * [1; 0; 0; 0; 0; 0], 1, 5);
forcTorq(:,6:10) = repmat(1e-10 * [0; 0; 0; 1e-8; 0; 0], 1, 5);

K = ResistanceTensor.ellipsoid(halfAxis);
D = ResistanceTensor.diffusionMatrix(K);

t = 0:delta_t:end_t;
particle = Particle(D);
trayectory = zeros(numel(t), 6);

mu = zeros(6, 1);
w = mvnrnd(mu, D, numel(t));
deltaPosRot = 1 / (Constants.k_B * Constants.T) ...
    * delta_t * D * forcTorq + sqrt(2 * delta_t) * w.';

for i = 1:numel(t)
    particle = particle.step(deltaPosRot(:, i));
    trayectory(i, :) = particle.getPosRot();
end

figure;
yyaxis left;
plot( t, trayectory(:,1), 'o-', 'Color', 'r' ); hold on
plot( t, trayectory(:,2), 'o-', 'Color', 'g' ); hold on
plot( t, trayectory(:,3), 'o-', 'Color', 'b' );
ylabel( 'Position (m)' );

yyaxis right;
plot( t, trayectory(:,4), 'x-', 'Color', 'r' ); hold on
plot( t, trayectory(:,5), 'x-', 'Color', 'g' ); hold on
plot( t, trayectory(:,6), 'x-', 'Color', 'b' );
ylabel( 'Angle (rad)' );


title( ' Simulation number ' + string(sim) );
xlabel( 'Time (s)' );
legend( 'x', 'y', 'z', 'alpha', 'beta', 'gamma' );
