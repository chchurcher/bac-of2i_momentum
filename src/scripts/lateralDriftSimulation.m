% Constant force introduction to an ellipsoid without brownian motion
% causes a lateral drift of the spheroid

n = 13;
angles = linspace(0, -pi/2, n);
halfAxes = [7.5, 7.5, 2.5];

dt = 1e-10;
end_t = 2e-9;
t = 0:dt:end_t;

force = 1e-9 * [0, 0, -9.81];
torque = [0, 0, 0];


%% Simulation with constant force
positions = zeros(3, numel( t ), n);
K = ResistanceTensor.ellipsoid( halfAxes );
D = (Constants.k_B * Constants.T * 6e24) \ K;
endPositions = zeros( 3, n );

for i = 1:n
  particle = Particle( ...
    'brownian', false, ...
    'halfAxes', halfAxes, ...
    'pos', [0, 0, 0], ...
    'rot', [0, angles(i), 0]);

  % Overwrite with different viscosity n=0.1667
  particle.diffusionTensor = D;

  for j = 1:numel(t)
    particle = particle.step(force, torque, dt);
    positions(:, j, i) = particle.pos;
  end
  endPositions(:, i) = particle.pos;
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
  plot(positions(1, :, i), positions(3, :, i), ...
    'color', gradient(:, i), ...
    'LineWidth', 1.5);
  hold on
end

plot(endPositions(1, :), endPositions(3, :), 'k--*');

title('Trajectory of a spheroid settling at an angle')
xlabel('x')
ylabel('z')
angleStrings = arrayfun(@(num) sprintf('%.1f', num), angles*180/pi, ...
  'UniformOutput', false);
legend(angleStrings)
grid on
