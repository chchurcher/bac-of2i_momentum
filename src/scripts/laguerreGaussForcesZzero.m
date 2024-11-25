n = 101;
posRots = zeros(6, n);
posRots(1, :) = linspace(-15e3, 15e3, n);


%% Calculation of the forces in focus plane
AB = [1, 0];
AB = AB .* Constants.lgScaling;
AB = AB .* sqrt(1.65);
exc = laguerregauss( Constants.w0, AB );
sim = Simulation( ...
  'brownian', false, ...
  'halfAxes', 500 * [ 1, 1, 1 ], ...
  'lambda', Constants.lambda, ...
  'posRots', posRots, ...
  'numElements', 256, ...
  'exc', exc);
[bem, tau] = sim.getBemTau();

multiWaitbar( 'Forces', 0, 'Color', 'g', 'CanCancel', 'on' );
fnopts_m = zeros( 6, n );
for i = 1:n
  fnopts_m(:, i) = sim.calcForce( posRots(:, i), bem, tau );
  multiWaitbar( 'Forces', i / n );
end

clear bem tau
multiWaitbar( 'CloseAll' );


%% Plot the results
figure
rotMats = Transformation.rotMatToLab( posRots(4:6, :) );
fopts_m = reshape( fnopts_m(1:3, :), [3, 1, n] );
fopts = pagemtimes( rotMats, fopts_m );
plot(1e-3 * posRots(1, :), fopts(1, :), 'Color', 'blue'); hold on
plot(1e-3 * posRots(1, :), fopts(3, :), 'Color', 'red');

% title('Optical forces in laguerre gauss beam in focus plane')
legend('$F_x$', '$F_z$', 'FontSize', 12)
xlabel('$x\ /\ \mathrm{\mu m}$', 'FontSize', 12)
ylabel('$\textnormal{Force}\ F\ /\ \mathrm{pN}$', 'FontSize', 12)
gca.FontSize = 10;
