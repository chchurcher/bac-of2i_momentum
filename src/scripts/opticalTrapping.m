%  OPTICALTRAPPING - Simulation of the trajetory of a particles trapped by 
%  in a laguerre gauss beam

n = 1;
% t = [0:0.1:2.5, 2.52:0.02:3.5, 3.6:0.1:6];
t = 0:0.05:6;

%% Calculation of the flow
startPosRot = zeros(6, n);
startPosRot(1, :) = 1e3 * linspace(2, 10, n);  % in nm
% startPosRot(1, :) = 5e3;
startPosRot(3, :) = -1000e3 * ones(1, n);

exc = laguerregauss( 4.78e3, [1, 0] );
sim = Simulation( ...
  'brownian', false, ...
  'halfAxes', 1000 * [ 1, 1, 1 ], ...
  'posRots', startPosRot, ...
  'lambda', 532, ...
  't', t, ...
  'exc', exc, ...
  'flow', 0.3e6 * [0, 0, 1]);
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