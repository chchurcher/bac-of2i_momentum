%  SINGLETRAJWTORY - Simulation of the trajetory of a single ellipsoid 
%  in a plane wave

n = 1;

particles = Particle.empty(1, 0);
particles(1) = Particle( ...
  'brownian', false, ...
  'halfAxes', [ 50, 50, 1 ], ...
  'pos', [0, 0, 0], ...
  'rot', [0, 0, 0]);

% exc = galerkin.planewave( [1, 0, 0], [0, 0, 1] );
exc = LaguerreGaussBeam( 0.1 );
sim = Simulation( particles );
sim = sim.options( ...
  'lambda', 650, ...
  'dt', 0.05, ...
  'end_t', 2, ...
  'exc', exc);

sim = sim.start();
sim.visualizePlot3();
