% Constant force introduction to an ellipsoid without brownian motion
% causes a lateral drift of the spheroid

n = 13;
a = 7.5;
b = 2.5;

dt = 0.02;
end_t = 0.27;
t = 0:dt:end_t;

startPosRots = zeros(6, n);
startPosRots(5, :) = linspace(0, pi/2, n);
halfAxes = [a, a, b];

force = [0, 0, -9.81];
torque = [0; 0; 0];


%% Simulation with constant force
sim = Simulation( ...
    'brownian', false, ...
    'halfAxes', halfAxes, ...
    'posRots', startPosRots, ...
    't', t);

for i = 1:n
  for j = 2:numel(t)
    actPosRot = sim.posRots(:, j-1, i);
    force_m = Transformation.rotMatToParticle( actPosRot(4:6) ) * force.';
    sim.posRots(:, j, i) = sim.particleStep( ...
      actPosRot, [force_m; torque], dt);
  end
end



%% Plotting the results
% Visualize Ellipsoid
%visualizeEllipsoid( halfAxes, [0, 0, 0, pi/4, 0, 0].' );

% Plot xz
m = ceil((n + 1) /2);
ls = linspace(0, 1, m);
gradient1 = [1-ls; ls; zeros(1, m)];
gradient2 = [zeros(1, m); 1-ls; ls];
gradient = [gradient1, gradient2(:, 2:end)];

figure
for i = 1:n
  plot(sim.posRots(1, :, i), sim.posRots(3, :, i), ...
    'color', gradient(:, i), ...
    'LineWidth', 1.5);
  hold on
end

endPos = sim.posRots(1:3, end, :);
endPos = reshape( endPos, [3, n] );
plot(endPos(1, :), endPos(3, :), 'k--*');

title(sprintf('Trajectory of a spheroid (%.1f, %.1f) settling', a, b))
xlabel('x')
ylabel('z')
angleStrings = arrayfun(@(num) sprintf('%.1f', num), ...
  startPosRots(5, :)*180/pi, ...
  'UniformOutput', false);
legend(angleStrings)
grid on
