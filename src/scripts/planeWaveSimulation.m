%  Simulation of oblated spheroids in a plane wave with different starting
%  rotations

n = 1;
halfAxes = [250, 250, 750];

startPosRots = zeros(6, n);
% startPosRots(5, :) = linspace(0, pi, n);
startPosRots(4, :) = pi/3;

t = 0:0.005:0.3;
exc = planewave2( [1, 0, 0], [0, 0, 1] );


%% Calculation of a spheroid in a plane wave
sim = Simulation( ...
    'brownian', false, ...
    'halfAxes', halfAxes, ...
    'posRots', startPosRots, ...
    't', t, ...
    'exc', exc, ...
    'numElements', 144);
sim = sim.start();
sim.visualizePlot3();

%% Plotting the rotation process
figure;
tiledlayout(3,1)
sgtitle({'Unit vector z'' of particle in lab system at angles \alpha', ...
  'z''=(0,0,1) in (x,y,z)'});

for i = 1:n
  rotMats = Transformation.rotMatToLab( sim.posRots(4:6, :, i) );
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
angleStrings = arrayfun(@(num) sprintf('%.0f', num), ...
  startPosRots(4, :)*180/pi, ...
  'UniformOutput', false);
lg = legend(angleStrings);
lg.Layout.Tile = 'East';


%% Plotting the end positions
endPos = sim.posRots(1:3, end, :);
endPos = reshape( endPos, [3, n] );

figure;
sgtitle(['End positions of particle depending on starting rotation ' ...
  '\alpha(0)']);

for i = 1:3
  subplot(3, 1, i);
  plot(startPosRots(4, :), endPos(i, :)); hold on
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

