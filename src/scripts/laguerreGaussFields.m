n = 21;

x = linspace(-0.1, 0.1, n);
y = linspace(-0.1, 0.1, n);
z = linspace(-0.1, 0.1, n);

[XX, YY, ZZ] = meshgrid(x, y, z);
pos = [XX(:), YY(:), ZZ(:)];
[ e, h ] = laguerreGaussFun( pos, 2*pi/650, 0.1 );

t = linspace(0, pi, 1);

figure;
for k = 1:numel( t )
  et = e .* exp(1i * t(k));

  quiver3(pos(:, 1), pos(:, 2), pos(:, 3), ...
  et(:, 1), et(:, 2), et(:, 3), 100)
  xlabel('x')
  ylabel('y')
  zlabel('z')

  pause( 1 );
end
