%  Forces of prolate spheroids in a plane wave with different starting
%  rotations

n = 50;

halfAxes = [750, 750, 250];

startPosRots = zeros(6, n);
angles = linspace(-pi/2, pi/2, n);
startPosRots(4, :) = angles;

t = 0:0.005:0.005;
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

%% Plotting the forces
figure;
tiledLayout = tiledlayout(1, 2,  'TileSpacing', 'Compact', 'Padding', 'Compact');
%title(tiledLayout, 'Forces on prolate spheroids in plane waves', ...
%  'Interpreter', 'latex', 'FontSize', 14);

fnopts_m = reshape( sim.fnopts_m(:, 1, :), [6, 1, n] );
rotMat = Transformation.rotMatToParticle( startPosRots(4:6, :) );

fopt = pagemtimes( rotMat, fnopts_m(1:3, 1, :) );
nopt = pagemtimes( rotMat, fnopts_m(4:6, 1, :) );

fopt = reshape( fopt, [3, n] );
nopt = reshape( nopt, [3, n] );

% Plotting the forces and torques in particles system
% fopt = reshape( fnopts_m(1:3, 1, :), [3, n] );
% nopt = reshape( fnopts_m(4:6, 1, :), [3, n] );

nexttile(1);
plot(angles * 180 / pi, fopt(1, :) * 1e-12); hold on
plot(angles * 180 / pi, fopt(2, :) * 1e-12); hold on
plot(angles * 180 / pi, fopt(3, :) * 1e-12);
legend('$F_x$', '$F_y$', '$F_z$', ...
  'Interpreter', 'latex', 'FontSize', 12);
ylabel('$\textnormal{Force}\ F \ /\ \mathrm{N}$', ...
  'Interpreter', 'latex', 'FontSize', 12);

nexttile(2);
plot(angles * 180 / pi, nopt(1, :) * 1e-12); hold on
plot(angles * 180 / pi, nopt(2, :) * 1e-12); hold on
plot(angles * 180 / pi, nopt(3, :) * 1e-12);
legend('$T_x$', '$T_y$', '$T_z$', ...
  'Interpreter', 'latex', 'FontSize', 12);
ylabel('$\textnormal{Torque}\ T \ /\ \mathrm{Nm}$', ...
  'Interpreter', 'latex', 'FontSize', 12);


for i = 1:2
  nexttile(i);
  xlabel('$\varphi_x \, / \, \mathrm{^\circ}$', ...
      'Interpreter', 'latex', 'FontSize', 12);
  xlim([-90, 90]);
  xticks(-90:45:90);
  ax = gca;
  ax.FontSize = 10;
end


%% Plotting the torque potentials
figure;
%title('Torque potentials', ...
%  'Interpreter', 'latex', 'FontSize', 14);

torquePotential = zeros(3, n);
for i = 1:n
  torquePotential(:, i) = -sum(nopt(:, 1:i), 2);
end

plot(angles * 180 / pi, torquePotential(1, :)); hold on
plot(angles * 180 / pi, torquePotential(2, :)); hold on
plot(angles * 180 / pi, torquePotential(3, :));

legend('$V_x$', '$V_y$', '$V_z$', ...
  'Interpreter', 'latex', 'FontSize', 12);
ylabel('$\textnormal{Torque Potential}\ V \ /\ \mathrm{Nm rad}$', ...
  'Interpreter', 'latex', 'FontSize', 12);
xlabel('$\varphi_x \, / \, \mathrm{^\circ}$', ...
    'Interpreter', 'latex', 'FontSize', 12);
xlim([-90, 90]);
xticks(-90:45:90);
ax = gca;
ax.FontSize = 10;