n = 50;
posRots = zeros(6, n);
posRots(1, :) = linspace(-15e3, 15e3, n);


%% Calculation of the forces in focus plane
exc = laguerregauss( Constants.w0, [1, 0] );
sim = Simulation( ...
  'brownian', false, ...
  'halfAxes', 500 * [ 1, 1, 1 ], ...
  'posRots', posRots, ...
  'numElements', 60, ...
  'exc', exc);
[bem, tau] = sim.getBemTau();

multiWaitbar( 'Forces', 0, 'Color', 'g', 'CanCancel', 'on' );
fnopts_m = zeros( 6, n );
for i = 1:n
  fnopts_m(:, i) = sim.calcForce( posRots(:, i), bem, tau );
  multiWaitbar( 'Forces', i / n );
end
multiWaitbar( 'CloseAll' );


%% Plot the results
figure
plot(1e-3 * posRots(1, :), fnopts_m(1, :), 'Color', 'blue', 'Marker', '+'); hold on
plot(1e-3 * posRots(1, :), fnopts_m(3, :), 'Color', 'red', 'Marker', 'x');

title('Optical forces in laguerre gauss beam in focus plane')
legend('F_x', 'F_z')
xlabel('x (µm)')
ylabel('Force (pN)')
