%  OPTICALTRAPPING - Simulation of the trajetory of a particles trapped by 
%  in a laguerre gauss beam

n = 1;
posX = 1e3 * linspace(5, 15, n);  % in nm
dt = 0.1;
end_t = 6;
t = 0:dt:end_t;

%% Calculation of the flow
particles = Particle.empty(n, 0);
for j = 1:n
  particles(j) = Particle( ...
    'brownian', false, ...
    'halfAxes', 500 * [ 1, 1, 1 ], ...
    'pos', [posX(j), 0, -1000e3], ...
    'rot', [0, 0, 0]);
end

exc = laguerregauss( 5e3 );
sim = Simulation( particles );
sim = sim.options( ...
  'lambda', 650, ...
  'dt', dt, ...
  'end_t', end_t, ...
  'exc', exc, ...
  'flow', 0.3e6 * [0, 0, 1]);
%  'flow', [0, 0, 0]);

sim = sim.start();

%% Vizuslize the 3d path of the particle
sim.visualizePlot3();

%% Visualize the 2d paths of the particle
positions = sim.positions * 1e-3;

figure
for i = 1:n
  plot(positions(3, :, i), positions(1, :, i));
  hold on
end

title('Trajectory of optically trapped particles')
xlabel('z (\mu m)')
ylabel('x (\mu m)')
grid on


figure
for i = 1:n
  plot(positions(3, :, i), positions(2, :, i));
  hold on
end

title('Trajectory of optically trapped particles')
xlabel('z (\mu m)')
ylabel('y (\mu m)')
grid on