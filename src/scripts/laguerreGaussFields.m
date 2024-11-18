z = -500;
n = 101;
lambda = Constants.lambda;
k = 2*pi/lambda;

%% Calculation of the fields
xyz = linspace(-5*lambda, 5*lambda, n);
[XX, YY] = meshgrid(xyz, xyz);
pos = [XX(:), YY(:), z*ones(size(XX(:)))];
Transformation.posRot( zeros(6, 1) );

[ e, h ] = laguerreGaussFun( pos, k, 376.7, 1.5*lambda );

%% Plot the E- and H-fields in z plane

figure('Position', [100 400 1200 400]);
tiledlayout(1,3)
sgtitle(sprintf('E- and H-Fields in z=%.2f µm plane', 1e-3*z*lambda));

subtitles = { 'E_x', 'E_y', 'E_z' };
for i = 1:3
  nexttile;
  cdata = e(:, i);
  cdata = reshape(cdata, [n, n]);
  cdata = real(cdata);
  imagesc(1e-3*xyz, 1e-3*xyz, cdata)
  colorbar

  title(subtitles(i))
  xlabel('x (µm)')
  ylabel('y (µm)')
end