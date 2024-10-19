n = 101;
lambda = 650;
k = 2*pi/lambda;

xyz = linspace(-5*lambda, 5*lambda, n);

% [XX, YY, ZZ] = meshgrid(xyz, xyz, xyz);
% pos = [XX(:), YY(:), ZZ(:)];
% [ e, h ] = laguerreGaussFun( pos, k, 376.7, 1.5*lambda );


% figure;
% quiver3(pos(:, 1), pos(:, 2), pos(:, 3), ...
% e(:, 1), e(:, 2), e(:, 3), 100)
% xlabel('x')
% ylabel('y')
% zlabel('z')

[XX, YY] = meshgrid(xyz, xyz);
pos = [XX(:), YY(:), zeros(size(XX(:)))];
[ e, h ] = laguerreGaussFun( pos, k, 376.7, 1.5*lambda );

%%
figure;
for i = 1:3
  subplot(1, 3, i);
  cdata = e(:, i);
  cdata = reshape(cdata, [n, n]);
  cdata = real(cdata);
  imagesc(cdata)
  colorbar
end