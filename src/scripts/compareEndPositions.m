% Simulation of oblated spheroids in a plane wave with their endpositions
% and rotations

% Number of particles with different starting rotations
n = 20;
angles = linspace(0, pi, n);

particles = Particle.empty(n, 0);
for i = 1:n
  particles(i) = Particle( ...
    'brownian', false, ...
    'halfAxes', [ 50, 50, 1 ], ...
    'pos', [0, 0, 0], ...
    'rot', [angles(i), 0, 0]);
end

exc = galerkin.planewave( [1, 0, 0], [0, 0, 1] );
sim = Simulation( particles );
sim = sim.options( ...
  'lambda', 650, ...
  'dt', 0.05, ...
  'end_t', 2, ...
  'exc', exc);

sim = sim.start();
sim.visualizePlot3();

endPos = sim.positions(:, end, :);
endPos = reshape( endPos, [3, n] );


%% Plotting the results
figure;
sgtitle(['End positions of particle depending on starting rotation ' ...
  '\alpha(0)']);

for j = 1:3
  subplot(3, 1, j);
  plot(angles, endPos(j, :)); hold on
end

subplot(3, 1, 1);
xlabel('\alpha(0) / rad')
ylabel('x / m')

subplot(3, 1, 2);
xlabel('\alpha(0) / rad')
ylabel('y / m')

subplot(3, 1, 3);
xlabel('\alpha(0) / rad')
ylabel('z / m')
