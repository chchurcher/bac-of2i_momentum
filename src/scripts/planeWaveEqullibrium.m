% Simulations of different shaped ellipsoids in a plane wave
% The ellipsoids reach a equilibrium rotated mainly 

n = 19;
halfAxes = zeros(n, 3);
halfAxes(:, 1) = 100;
halfAxes(:, 2) = 100;
halfAxes(:, 3) = linspace(100, 1000, n);

startPosRots = zeros(6, 1);
startPosRots(4, :) = pi/2 * rand;
startPosRots(5, :) = pi/2 * rand;

t = 0:0.025:8;
exc = planewave2( [1, 0, 0], [0, 0, 1] );


%% Calculation of spheroids with different half axes in a plane wave
multiWaitbar( 'Simulations', 0, 'Color', 'g', 'CanCancel', 'on' );
sims = Simulation.empty(n, 0);
for i = 1:n
  sims(i) = Simulation( ...
      'brownian', false, ...
      'halfAxes', halfAxes(i, :), ...
      'posRots', startPosRots, ...
      't', t, ...
      'exc', exc, ...
      'numElements', 144, ...
      'stop_equillibrium', true);
  sims(i) = sims(i).start();
  multiWaitbar( 'Simulations', i / n );
end
multiWaitbar( 'Simulations', 'Close' );




%% Plotting the end positions
endPos = zeros(6, n);
endForce_m = zeros(3, n);
for i = 1:n
  endPos(:, i) = sims(i).posRots(:, end);
  endForce_m(:, i) = sims(i).fnopts_m(1:3, end-1);
end

rotMats = Transformation.rotMatToLab( endPos(4:6, :) );
endForce_m = reshape( endForce_m, [3, 1, n] );
endForce = pagemtimes(rotMats , endForce_m);
endForce = reshape(endForce, [3, n]);

%% Plotting the end rotation
figure;
scaling = 1e-3;

plot3(0, 0, 0, ...
  'LineWidth', 1, 'Color', 'k');
hold on

for j = 1:2:n
  endIndex = find(sum(sims(j).posRots), 1, 'last');
  endPosRot = sims(j).posRots(:, endIndex);

  p = trisphere( 144, 1 );
  p = transform( p, 'scale', halfAxes(j, :) * scaling);
  p = transform( p, 'rot', Transformation.rotMatToParticle( endPosRot(4:6)) );
  p = transform( p, 'shift', [1, 0, 0] * j * 200 * scaling );
  
  plot( p ); hold on
end

title('Rotation of prolate spheroids in plane wave after long time', ...
    'Interpreter', 'latex', 'FontSize', 14);
xlabel('$X\ /\ \mathrm{\mu m}$', ...
    'Interpreter', 'latex', 'FontSize', 12);
ylabel('$Y\ /\ \mathrm{\mu m}$', ...
    'Interpreter', 'latex', 'FontSize', 12);
zlabel('$Z\ /\ \mathrm{\mu m}$', ...
    'Interpreter', 'latex', 'FontSize', 12);

axis equal;
grid on;

ylim([-0.5, 0.5]);
zlim([-0.5, 0.5]);
view(-6, 25);
camlight('Left');