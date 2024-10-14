%  Simulation of oblated spheroids in a plane wave

%% Calculation of a spheroid in a plane wave
n = 20;
angles = linspace(0, pi/2, n);
dt = 0.05;
end_t = 2;
t = 0:dt:end_t;

particles = Particle.empty(n, 0);
for j = 1:n
  particles(j) = Particle( ...
    'brownian', false, ...
    'halfAxes', [ 50, 50, 1 ], ...
    'pos', [0, 0, 0], ...
    'rot', [angles(j), 0, 0]);
end

exc = galerkin.planewave( [1, 0, 0], [0, 0, 1] );

sim = Simulation( particles );
sim = sim.options( ...
  'lambda', 650, ...
  'dt', dt, ...
  'end_t', end_t, ...
  'exc', exc);

sim = sim.start();
sim.visualizePlot3();

%% Plotting the results
figure;
sgtitle({'Unit vector z'' of particle in lab system', ...
  'z''=(0,0,1) in (x,y,z)'});

for i = 1:n
  z = pagemtimes( sim.rotMats( :, :, :, i), [0; 0; 1]);
  z = reshape(z, [3, numel( t )]);
  for j = 1:3
    subplot(3, 1, j);
    plot(t, z(j, :)); hold on
  end
end

subplot(3, 1, 1);
xlabel('time / s')
ylabel('x * z''')
title('x-component')

subplot(3, 1, 2);
xlabel('time / s')
ylabel('y * z''')
title('y-component')
subplot(3, 1, 3);

xlabel('time / s')
ylabel('z * z''')
title('z-component')
