%  OBLATESPHEROID - Simulations of oblated spheroids in a plane wave

n = 20;

angles = linspace(0, pi/2, n);

for i = 1:n
  particles = Particle.empty(n, 0);
  for j = 1:n
    particles(j) = Particle( ...
      'brownian', false, ...
      'halfAxes', [ 50, 50, 1 ], ...
      'pos', [0, 0, 0], ...
      'rot', [0, angles(i), angles(j)]);
  end

  sim = Simulation( particles );
  sim = sim.options( ...
    'lambda', 650, ...
    'dt', 0.05, ...
    'end_t', 2, ...
    'pol', [ 1, 0, 0 ], ...
    'dir', [ 0, 0, 1 ]);
  
  sim = sim.start();
  sim.
end

disp( 'Simulation' )
disp( sim.particles.rotMat_m )
sim.visualizePlot3();
