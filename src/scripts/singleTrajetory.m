%  SINGLETRAJETORY - Simulation of the trajetory of a single ellipsoid 
%  in a plane wave


halfAxes = [250, 250, 750];
startPosRots = [0; 0; 0; pi/3; 0; 0];
t = 0:0.025:4;

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
scaling = 1e-3;
posRots = sim.posRots(:, :, 1);
posRots(1, :) = sim.posRots(2, :, 1);
posRots(2, :) = sim.posRots(3, :, 1);
posRots(3, :) = sim.posRots(1, :, 1);
figure;
xyz = num2cell(posRots(1:3, :), 2);
[X, Y, Z] = xyz{:};
plot3(X * scaling, Y * scaling, Z * scaling, ...
  'LineWidth', 1, 'Color', 'k');
hold on

n = size(posRots, 2);
N = 6;
for i = [1, ceil((1:1:N-2)*n / (N-1) ), n]
  p = trisphere( 144, 1 );
  p = transform( p, 'scale', halfAxes * scaling);
  p = transform( p, 'rot', Transformation.rotMatToParticle(posRots(4:6, i)) );
  p = transform( p, 'rot', Transformation.rotMatToLab( [-pi/2, -pi/2, 0] ));
  p = transform( p, 'shift', posRots(1:3, i).' * scaling );
  
  plot( p ); hold on
end

title('Trajectory of a prolate spheroid in a planewave', ...
    'Interpreter', 'latex', 'FontSize', 14);
xlabel('$Y\ /\ \mathrm{\mu m}$', ...
    'Interpreter', 'latex', 'FontSize', 12);
ylabel('$Z\ /\ \mathrm{\mu m}$', ...
    'Interpreter', 'latex', 'FontSize', 12);
zlabel('$X\ /\ \mathrm{\mu m}$', ...
    'Interpreter', 'latex', 'FontSize', 12);

ax = gca;
ax.FontSize = 10;
zlim([-0.2, 2]);
ylim([-0.5, 10]);

% view(90, 0)

axis equal
grid on;