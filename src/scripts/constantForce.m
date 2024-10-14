% Constant force introduction to an ellipsoid without brownian motion

halfAxes = [6, 10, 10];
startPosition = [0, 0, 0];
startRotation = [pi/6, pi/4, 0];

dt = 0.1;
end_t = 10;
t = 0:dt:end_t;

force = [0, 0, 1];
torque = [0, 0, 0.1];


%% Simulation with constant force
particle = Particle( ...
          'brownian', false, ...
          'halfAxes', halfAxes, ...
          'pos', startPosition, ...
          'rot', startRotation);

positions = zeros(3, numel( t ));
rotMats = zeros(3, 3, numel( t ));
for i = 1:numel(t)
    particle = particle.step(force, torque, dt);
    positions(:, i) = particle.pos;
    rotMats(:, :, i) = particle.rotMat_m;
end


%% Plotting the results
% Visualize Ellipsoid
visualizeEllipsoid( halfAxes, [startPosition, startRotation].' );

% Plot3
figure;
xyz = num2cell(positions, 2);
[X, Y, Z] = xyz{:};
plot3(X, Y, Z); hold on

title('Trajectory of constant Force on Ellipsoid')
xlabel('X');
ylabel('Y');
zlabel('Z');

grid on;

% Rotation of ellipsoid
figure;
sgtitle('Unit vector z'' of Particle in Lab-System');

z = pagemtimes( rotMats, [0; 0; 1]);
z = reshape(z, [3, numel( t )]);
for i = 1:3
  subplot(3, 1, i);
  plot(t, z(i, :)); hold on
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
