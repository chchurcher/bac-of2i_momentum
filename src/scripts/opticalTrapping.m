%  OPTICALTRAPPING - Simulation of the trajetory of a particles trapped by 
%  in a laguerre gauss beam

n = 5;
% t = [0:0.1:2.5, 2.52:0.02:3.5, 3.6:0.1:6];
t = 0:0.005:8;

%% Calculation of the flow
startPosRot = zeros(6, n);
startPosRot(1, :) = linspace(0, 20e3, n);
startPosRot(3, :) = -1000e3;

AB = [1, 0] .* Constants.lgScaling .* sqrt(1.65e9);
exc = laguerregauss( Constants.w0, AB );
sim = Simulation( ...
  'brownian', false, ...
  'halfAxes', halfAxes, ...
  'posRots', startPosRot, ...
  't', t, ...
  'exc', exc, ...
  'numElements'f, 520, ...
  'flow', Constants.v_fluid * [0, 0, 1]);
sim = sim.start();

%% Vizuslize the 3d path of the particle
sim.visualizePlot3();


%% Visualize the 2d paths of the particle
positions = sim.posRots(1:3, :, :) * 1e-3;  % Convert in µm

figure

waist_z = linspace(-1e6, 1e6, 100);
mats = Constants.material;
mat = mats(1);
k1 = mat.k( 2*pi/Constants.lambda );
zR =  1/2 * k1 * Constants.w0^2;
w = @(z) Constants.w0 * sqrt(1 + (z/zR).^2);
waist_x = w(waist_z);
plot(waist_z*1e-3, waist_x*1e-3, 'Color', [0.4, 0.4, 0.4]);
hold on

f_max = 0;
for i = 1:n
  fnopts_m = sim.fnopts_m(:, :, i);
  f_abs = sqrt(sum(fnopts_m(1:3, :).^2, 1)) .* 1e-3;
  f_max = max(f_max, max(f_abs));

  scatter(positions(3, :, i), positions(1, :, i), ...
    2, f_abs, 'filled'); 
  hold on
  
end

%scatter(-1e6, 0, 5, 1, 'filled'); hold on
scatter(-1e6, 0, 5, 1.2*f_max, 'filled'); hold on
colormap("hot");

% title('Trajectory of optically trapped particles')
xlabel('$z\ /\ \mathrm{\mu m}$', ...
  'Interpreter', 'latex', 'FontSize', 12)
ylabel('$x\ /\ \mathrm{\mu m}$', ...
  'Interpreter', 'latex', 'FontSize', 12)
xlim([-1000, 1000])
ylim([0, 22])
colorbar
grid on

%% Visualize the radial distance to the z-axis
figure
v_max = 0;
for i = 1:n
  fnopts_m = sim.fnopts_m(:, :, i);
  f_abs = sqrt(sum(fnopts_m(1:3, :).^2, 1));
  % f_max = max(f_max, max(f_abs));
  radius = sqrt(positions(1, :, i).^2 + positions(2, :, i).^2);
  dPosZ = zeros(1, numel(t));
  dPosZ(1:end-1) = positions(3, 2:end, i) - positions(3, 1:end-1, i);
  dt = zeros(1, numel(t));
  dt(1:end-1) = t(2:end) - t(1:end-1);
  v = (dPosZ ./ dt) ./ (Constants.v_fluid * 1e-3);
  v_max = max(v_max, max(v));

  scatter(positions(3, :, i), radius, ...
    2, f_abs, 'filled'); 
  hold on
  
end

%scatter(-1e6, 0, 5, 1, 'filled'); hold on
%scatter(-1e6, 0, 5, 1.2*v_max, 'filled'); hold on
colormap("hot");

% title('Trajectory of optically trapped particles')
xlabel('$z\ /\ \mathrm{\mu m}$', ...
  'Interpreter', 'latex', 'FontSize', 12)
ylabel('$r\ /\ \mathrm{\mu m}$', ...
  'Interpreter', 'latex', 'FontSize', 12)
xlim([-1000, 1000])
ylim([0, 22])
c = colorbar;
grid on


%% Plot with ellipsoid
figure;
scaling = [1e-3, 1e-3, 1e-3];

for j = 1:n
  posRots = sim.posRots(:, :, j);
  posRots(1, :) = sim.posRots(2, :, j) .* scaling(2);
  posRots(2, :) = sim.posRots(3, :, j) .* scaling(3);
  posRots(3, :) = sim.posRots(1, :, j) .* scaling(1);
  
  xyz = num2cell(posRots(1:3, :), 2);
  [X, Y, Z] = xyz{:};
  plot3(X, Y, Z, ...
    'LineWidth', 1, 'Color', 'k');
  hold on
  
  for i = 1:100:1600
    p = trisphere( 144, 1 );
    p = transform( p, 'scale', halfAxes .* 2e-3);
    p = transform( p, 'rot', Transformation.rotMatToParticle(posRots(4:6, i)) );
    p = transform( p, 'rot', Transformation.rotMatToLab( [-pi/2, -pi/2, 0] ));
    p = transform( p, 'scale', [1, 0.5e2, 1]);
    p = transform( p, 'shift', posRots(1:3, i).' );
    
    plot( p, 'FaceColor', [0, 255, 0], 'FaceAlpha', 0.7 ); hold on
  end
end

%title('Trajectory of a prolate spheroid in a planewave', ...
%    'Interpreter', 'latex', 'FontSize', 14);
xlabel('$y\ /\ \mathrm{\mu m}$', ...
    'Interpreter', 'latex', 'FontSize', 12);
ylabel('$z\ /\ \mathrm{\mu m}$', ...
    'Interpreter', 'latex', 'FontSize', 12);
zlabel('$x\ /\ \mathrm{\mu m}$', ...
    'Interpreter', 'latex', 'FontSize', 12);

ax = gca;
ax.FontSize = 10;
%axis equal;
grid on;

zlim([0, 20]);
xlim([-50, 50]);
ylim([-1000, 1000]);

view(90, 0);
camlight('Left');