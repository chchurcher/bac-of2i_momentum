halfAxes = [1, 2, 3];
posRots = [[3, 1, 1, 0, pi/6, 0];
           [0, 0, 0, 0, pi/6, pi/2]]';
[X, Y, Z, U, V, W] = Transformation.getQuiverAxes(posRots, halfAxes);
figure;
quiver3(X, Y, Z, U, V, W);

title('Quiver3 of Ellipsoid')
xlabel('X');
ylabel('Y');
zlabel('Z');

grid on;
axis equal;