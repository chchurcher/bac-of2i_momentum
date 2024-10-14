%  ENDPOSITIONXROT - Simulation of oblated spheroids in a plane wave with
%  their endpositions and rotations

n = 20;
angles = linspace(0.2, 0.23, n);

particles = Particle.empty(n, 0);
for i = 1:n
  particles(i) = Particle( ...
    'brownian', false, ...
    'halfAxes', [ 50, 50, 1 ], ...
    'pos', [0, 0, 0], ...
    'rot', [angles(i), 0, 0]);
end

sim = Simulation( particles );
sim = sim.options( ...
  'lambda', 650, ...
  'dt', 0.05, ...
  'end_t', 2, ...
  'pol', [ 1, 0, 0 ], ...
  'dir', [ 0, 0, 1 ]);

sim = sim.start();
sim.visualizePlot3();

endPositions = sim.positions(:, end, :);
endRotations = Transformation.toAngles( sim.rotMats(:, :, end, :) );

figure;
sgtitle(['end positions and rotations of a oblated spheroid rotated ' ...
  'around x axis']);

subplot(2, 1, 1);
a1 = plot(angles, endPositions(1, :), 'r-x'); hold on
a2 = plot(angles, endPositions(2, :), 'g-x'); hold on
a3 = plot(angles, endPositions(3, :), 'b-x');
title('end positions');
xlabel('start rotation / rad');
ylabel('end position / nm');
legend([a1, a2, a3], {'x', 'y', 'z'})

subplot(2, 1, 2);
b1 = plot(angles, endRotations(1, :), 'r-x'); hold on
b2 = plot(angles, endRotations(2, :), 'g-x'); hold on
b3 = plot(angles, endRotations(3, :), 'b-x');
title('end rotations');
xlabel('start rotation / rad');
ylabel('end rotation / rad');
legend([b1, b2, b3], {'alpha', 'beta', 'gamma'})
