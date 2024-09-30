halfAxes = [0.3; 0.2; 0.1];
posRot = [0; 1; 0; pi/6; 0; 0];

% [X, Y, Z, U, V, W] = Transformation.getQuiverAxes(posRots, halfAxes);
% figure;
% quiver3(X, Y, Z, U, V, W);


f = @(xyz) (xyz(1)/halfAxes(1)).^2 + (xyz(2)/halfAxes(2)).^2 + (xyz(3)/halfAxes(3)).^2 - 1;
f2 = @(x,y,z) f(Transformation.toParticle(posRot, [x;y;z]));

figure;
interval = [-5 5 -5 5 -5 5].*1;
fimplicit3(f2, interval);

title('Quiver3 of Ellipsoid')
xlabel('X');
ylabel('Y');
zlabel('Z');

grid on;
axis equal;