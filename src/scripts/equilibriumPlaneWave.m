% Simulations of different shaped ellipsoids in a plane wave
% The ellipsoids reach a equilibrium rotated mainly 

n = 19;
halfAxess = zeros(n, 3);
halfAxess(:, 1) = linspace(100, 1000, n);
halfAxess(:, 2) = linspace(100, 1000, n);
halfAxess(:, 3) = linspace(100, 1000, n);

startPosRots = zeros(6, 1);
startPosRots(4, :) = -pi/4;
startPosRots(5, :) = -pi/4;

t = 0:0.001:0.001;
exc = planewave2( [1, 0, 0], [0, 0, 1] );


%% Calculation of a spheroid in a plane wave
multiWaitbar( 'Simulations', 0, 'Color', 'g', 'CanCancel', 'on' );
sims = Simulation.empty(n, 0);
for i = 1:n
  sims(i) = Simulation( ...
      'brownian', false, ...
      'halfAxes', halfAxess(i, :), ...
      'posRots', startPosRots, ...
      't', t, ...
      'exc', exc, ...
      'numElements', 144);
  sims(i) = sims(i).start();
  multiWaitbar( 'Simulations', i / n );
end
multiWaitbar( 'Simulations', 'Close' );


%% Plotting the rotation process
figure;
tiledlayout(3,1)
sgtitle({'Rotation process of oblate ellipsoids [a, a, 100]', ...
  'z''=(0,0,1) in (x,y,z)'});

for i = 1:n
  rotMats = Transformation.rotMatToLab( sims(i).posRots(4:6, :) );
  z = pagemtimes(rotMats , [0; 0; 1]);
  z = reshape(z, [3, numel( t )]);

  for j = 1:3
    nexttile(j);
    plot(t, z(j, :)); hold on
  end
end

nexttile(1);
xlabel('time / s')
ylabel('x * z''')
ylim([-1, 1])
title('x-component')

nexttile(2);
xlabel('time / s')
ylabel('y * z''')
ylim([-1, 1])
title('y-component')

nexttile(3);
xlabel('time / s')
ylabel('z * z''')
ylim([-1, 1])
title('z-component')

nexttile(1);
lg = legend(num2str(halfAxess(:, 1)));
lg.Layout.Tile = 'East';


%% Plotting the forces over time
figure;
tiledlayout(3,1)
sgtitle('Forces over time on oblate ellipsoids [a, a, 100]');

for i = 1:n
  rotMats = Transformation.rotMatToLab( sims(i).posRots(4:6, :) );
  fopts_m = sims(i).fnopts_m(1:3, :);
  fopts_m = reshape( fopts_m, [3, 1, numel(t)] );
  fopts = pagemtimes(rotMats , fopts_m);
  fopts = reshape(fopts, [3, numel( t )]);

  for j = 1:3
    nexttile(j);
    plot(t(1:end-1), fopts(j, 1:end-1)); hold on
  end
end

nexttile(1);
xlabel('time / s')
ylabel('Force (pN)')
title('F_x')

nexttile(2);
xlabel('time / s')
ylabel('Force (pN)')
title('F_y')

nexttile(3);
xlabel('time / s')
ylabel('Force (pN)')
title('F_z')

nexttile(1);
lg = legend(num2str(halfAxess(:, 1)));
lg.Layout.Tile = 'East';


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

%%
figure;
sgtitle('Force on particle depending on half axes');

for i = 1:3
  plot(halfAxess(:, 1), endForce(i, :)); hold on
end
xlabel('a / nm')
ylabel('Force / pN')
legend({'F_x', 'F_y', 'F_z'})