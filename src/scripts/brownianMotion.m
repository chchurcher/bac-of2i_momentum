% Brownian motion of an ellipsoid without external forces or torques

% Set seed of the random generator for repreducity
% rng(10);

% Constants
halfAxis = 1e-6 * [100, 1, 1];
delta_t = 0.1;
end_t = 10;

K = ResistanceTensor.ellipsoid(halfAxis);
D = ResistanceTensor.diffusionMatrix(K);

t = 0:delta_t:end_t;
figure;

for sim = 1:6
    particle = Particle(D);
    
    trayectory = zeros(numel(t), 3);
    mu = zeros(6, 1);

    w = mvnrnd(mu, D, numel(t));
    deltaPosRot = sqrt(2 * delta_t) * w;
    
    for i = 1:numel(t)
        particle = particle.step(deltaPosRot(i, :));
        trayectory(i, :) = particle.position;
    end

    subplot(3, 2, sim);
    plot( t, trayectory, 'o-' ); hold on
    set( gca, 'ColorOrderIndex', 1 );
    
    title( ' Simulation number ' + string(sim) );
    xlabel( 'Time (s)' );
    ylabel( 'Position (m)' );
    legend( 'x', 'y', 'z' );
end
