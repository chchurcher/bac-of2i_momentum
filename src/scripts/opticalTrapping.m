%  OPTICALTRAPPING - Simulation of the trajetory of a particles trapped by 
%  in a laguerre gauss beam

n = 1;
t = [0:0.1:2.5, 2.52:0.02:3.5, 3.6:0.1:6];
% t = 0:0.01:6;

%% Calculation of the flow
startPosRot = zeros(6, n);
startPosRot(1, :) = 10e3;
startPosRot(3, :) = -1000e3;
startPosRot(5, :) = linspace(0, pi/2, n);

exc = laguerregauss( Constants.w0, [1, 0] );
sim = Simulation( ...
  'brownian', false, ...
  'halfAxes', 500 * [ 1, 1, 0.5 ], ...
  'posRots', startPosRot, ...
  't', t, ...
  'exc', exc, ...
  'numElements', 250, ...
  'flow', Constants.v_fluid * [0, 0, 1]);
sim = sim.start();

%% Vizuslize the 3d path of the particle
sim.visualizePlot3();


%% Visualize the 2d paths of the particle
positions = sim.posRots(1:3, :, :) * 1e-3;  % Convert in µm

figure
for i = 1:n
  plot(positions(3, :, i), positions(1, :, i));
  hold on
end

title('Trajectory of optically trapped particles')
xlabel('z (\mu m)')
ylabel('x (\mu m)')
xlim([-1000, 1000])
ylim([0, 20])
grid on


figure
for i = 1:n
  plot(positions(3, :, i), positions(2, :, i));
  hold on
end

title('Trajectory of optically trapped particles')
xlabel('z (\mu m)')
ylabel('y (\mu m)')
xlim([-1000, 1000])
ylim([0, 20])
grid on