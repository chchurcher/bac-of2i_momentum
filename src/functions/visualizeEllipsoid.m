function visualizeEllipsoid(halfAxes, posRot)

ellipsoid = @(xyz) (xyz(1)/halfAxes(1)).^2 + (xyz(2)/halfAxes(2)).^2 ...
  + (xyz(3)/halfAxes(3)).^2 - 1;
fun = @(x,y,z) ellipsoid(Transformation.toParticle(posRot, [x;y;z]));

figure;
interval = [-5 5 -5 5 -5 5].*200;
fimplicit3(fun, interval);

title('Quiver3 of Ellipsoid')
xlabel('X');
ylabel('Y');
zlabel('Z');

grid on;
axis equal;
end

