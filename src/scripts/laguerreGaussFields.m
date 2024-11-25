n = 101;
lambda = Constants.lambda;
z = -0*lambda;
k = 2*pi/lambda;


AB = [1, 1i];
AB = AB .* (1 / (sqrt(2)));
AB = AB .* Constants.lgScaling;
% AB = AB .* sqrt(1.65);

%% Calculation of the fields
xyz = linspace(-5*lambda, 5*lambda, n);
[XX, YY] = meshgrid(xyz, xyz);
pos = [XX(:), YY(:), z*ones(size(XX(:)))];
Transformation.posRot( zeros(6, 1) );

[ e, h ] = laguerreGaussFun( pos, k, 376.7, 1.5*lambda, AB);

%% Calculate the power of the beam
e(isnan(e)) = 0;
h(isnan(h)) = 0;

S = (1/2) * real(cross(e, conj(h)));
power = sum(S(:, 3) * (20 * lambda / (n - 1)).^2, 'all' );

disp(['Power = ', num2str(power)]);
disp(['Factor = ', num2str(1/sqrt(power))]);

%% Plot the E- and H-fields in z plane

figure('Position', [100 400 1200 400]);
tLay = tiledlayout(1,3);
% sgtitle(tLay, 'E- and H-Fields in $z=-5\lambda$', ...
%   'Interpreter', 'latex', 'FontSize', 14);

subtitles = { '$E_x$', '$E_y$', '$E_z$' };
for i = 1:3
  nexttile;
  cdata = e(:, i);
  cdata = reshape(cdata, [n, n]);
  cdata = real(cdata);
  imagesc(1e-3*xyz, 1e-3*xyz, cdata)
  colorbar

  title(subtitles(i))
  xlabel('$x\ /\ \mu m$')
  ylabel('$y\ /\ \mu m$')
end