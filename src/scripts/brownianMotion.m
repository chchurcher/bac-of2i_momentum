% Brownian Motion of an ellipsoid without external forces

halfAxes = [6, 10, 10];
startPosRot = [0; 0; 0; pi/6; pi/4; 0];
fnopt_m = zeros(6, 1);

dt = 10;
end_t = 3600;
t = 0:dt:end_t;


%% Simulation of the Brownian Motion (Random Walk) without external Forces
sim = Simulation( ...
          'brownian', true, ...
          'halfAxes', halfAxes, ...
          'posRots', startPosRot, ...
          't', t);

posRots = zeros(6, numel( t ));
posRots(:, 1) = startPosRot;
for i = 2:numel(t)
    posRots(:, i) = sim.particleStep(posRots(:, i-1), fnopt_m, dt);
end


%% Plotting the results
% Visualize Ellipsoid
visualizeEllipsoid( halfAxes, startPosRot );

% Plot3
figure;
xyz = num2cell(posRots(1:3, :), 2);
[X, Y, Z] = xyz{:};
plot3(X, Y, Z); hold on

title('Brownian Motion of Ellipsoid')
xlabel('X');
ylabel('Y');
zlabel('Z');

grid on;

% Rotation of ellipsoid
figure;
sgtitle('Unit vector z'' of Particle in Lab-System');

z = pagemtimes( Transformation.rotMatToLab( posRots(4:6, :)), [0; 0; 1]);
z = reshape(z, [3, numel( t )]);
for i = 1:3
  subplot(3, 1, i);
  plot(t, z(i, :)); hold on
  ylim([-1, 1])
  xlabel('time / s')
end

subplot(3, 1, 1);
ylabel('x * z''')
title('x-component')

subplot(3, 1, 2);
ylabel('y * z''')
title('y-component')
subplot(3, 1, 3);

xlabel('time / s')
title('z-component')
