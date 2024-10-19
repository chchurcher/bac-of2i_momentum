%  OPTICALTRAPPING - Simulation of the trajetory of a particles trapped by 
%  in a laguerre gauss beam

n = 2;
posX = 1e3 * linspace(5, 10, n);  % in nm
dt = 0.05;
end_t = 2;
t = 0:dt:end_t;

%% Calculation of the flow
particles = Particle.empty(n, 0);
for j = 1:n
  particles(j) = Particle( ...
    'brownian', false, ...
    'halfAxes', 500 * [ 1, 1, 1 ], ...
    'pos', [0, posX(j), 0], ...
    'rot', [0, 0, 0]);
end

exc = laguerregauss( 5e3 );
sim = Simulation( particles );
sim = sim.options( ...
  'lambda', 650, ...
  'dt', dt, ...
  'end_t', end_t, ...
  'exc', exc, ...
  'flow', [0, 0, 0]);
%  'flow', 3e5/dt * [0, 0, 1]);

sim = sim.start();
sim.visualizePlot3();

%% Visualize the optical trapping of the particle
positions = sim.positions;

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