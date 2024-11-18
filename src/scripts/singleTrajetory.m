%  SINGLETRAJETORY - Simulation of the trajetory of a single ellipsoid 
%  in a plane wave


halfAxes = [250, 250, 750];
startPosRots = [0; 0; 0; pi/3; 0; 0];
t = 0:0.025:8;

exc = planewave2( [1, 0, 0], [0, 0, 1] );
sim = Simulation( ...
  'brownian', false, ...
  'halfAxes', halfAxes, ...
  'posRots', startPosRots, ...
  't', t, ...
  'exc', exc, ...
  'numElements', 144);

sim = sim.start();
% sim.visualizePlot3();


%% Plot with ellipsoid
posRots = sim.posRots(:, :, 1);
posRots(1, :) = sim.posRots(3, :, 1);
posRots(3, :) = sim.posRots(1, :, 1);
figure;
xyz = num2cell(posRots(1:3, :), 2);
[X, Y, Z] = xyz{:};
plot3(X*1e-3, Y*1e-3, Z*1e-3);
hold on

n = size(posRots, 2);
for i = [1, ceil(n/4), ceil(2*n/4), ceil(3*n/4), n]
  p = trisphere( 144, 1 );
  p = transform( p, 'scale', halfAxes * 1e-2 );
  p = transform( p, 'rot', Transformation.rotMatToParticle(posRots(4:6, i)) );
  p = transform( p, 'rot', Transformation.rotMatToParticle( [0, pi/2, 0] ));
  p = transform( p, 'shift', 1e-3*posRots(1:3, i).' );
  
  plot( p, 'EdgeColor', 'b' ); hold on
end

title('Trajectory of a prolate spheroid in a planewave', ...
    'Interpreter', 'latex', 'FontSize', 14)
xlabel('$Z\ /\ \mathrm{\mu m}$', ...
    'Interpreter', 'latex', 'FontSize', 12);
ylabel('$Y\ /\ \mathrm{\mu m}$', ...
    'Interpreter', 'latex', 'FontSize', 12);
zlabel('$X\ /\ \mathrm{\mu m}$', ...
    'Interpreter', 'latex', 'FontSize', 12);

ax = gca;
ax.FontSize = 10;
view(30, 30)

axis equal
grid on;