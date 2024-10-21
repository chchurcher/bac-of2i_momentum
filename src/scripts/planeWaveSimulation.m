%  Simulation of oblated spheroids in a plane wave with different starting
%  rotations

n = 1;
halfAxes = [500, 500, 1];

startPosRots = zeros(6, n);
startPosRots(4, :) = linspace(0, pi, n);

dt = 0.02;
end_t = 2;
t = 0:dt:end_t;
exc = galerkin.planewave( [1, 0, 0], [0, 0, 1] );


%% Calculation of a spheroid in a plane wave
sim = Simulation( ...
    'brownian', false, ...
    'halfAxes', halfAxes, ...
    'posRots', startPosRots, ...
    't', t, ...
    'exc', exc, ...
    'numElements', 144);
sim = sim.start();
%sim.visualizePlot3();

%% Plotting the rotation process
figure;
sgtitle({'Unit vector z'' of particle in lab system', ...
  'z''=(0,0,1) in (x,y,z)'});

for i = 1:n
  z = pagemtimes( Transformation.rotMatToLab( sim.posRots(4:6, :, i) ), [0; 0; 1]);
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
