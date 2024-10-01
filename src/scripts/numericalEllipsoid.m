%  NUMERICALELLIPSOID - Triangulated ellipsoid in laser beam.

% simulation steps
delta_t = 0.05;
end_t = 2;
t = 0:delta_t:end_t;
[ pos, rot ] = deal( zeros( 3, numel( t ) ) );

%  nanosphere
pos(:, 1) = [ 0; 0; 0 ];
rot(:, 1) = [ 0; 0; 0 ];
hax = [ 50, 50, 1 ];

R = rotmat( rot(:, 1) );
M = R;

p = trisphere( 144, 1 );
p = transform( p, 'scale', hax );
p = transform( p, 'rot', R );
% p = transform( p, 'shift', pos );

%  dielectric functions for water and gold
mat1 = Material( 1.33 ^ 2, 1 );
mat2 = Material( epstable( 'gold.dat' ), 1 );
mat = [ mat1, mat2 ];

%  diffusion tensor
D = difellip( hax );

%  light wavelength in vacuum
lambda = 650;
k0 = 2 * pi ./ lambda;

%  allocate optical force and torque arrays
[ fopt1, nopt1 ] = deal( zeros( 3, numel( t ) ) );
data = [];

%  planewave excitation
exc = galerkin.planewave( [ 1, 0, 0 ], [ 0, 0, 1 ] );

%  boundary elements with linear shape functions
tau = BoundaryEdge( mat, p, [ 2, 1 ] );

%  initialize BEM solver
rules = quadboundary.rules( 'quad3', triquad( 3 ) );
bem = galerkin.bemsolver( tau, 'rules', rules, 'waitbar', 1 );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over timesteps
for i = 2 : numel( t )
    %  solution of BEM equations
    [ sol1, bem ] = solve( bem, exc( tau, k0 ) );
    
    %  optical force and torque
    [ fopt1( :, i ), nopt1( :, i ), f1 ] = optforce( sol1 );
    
    fn = cat( 1, M \ fopt1( :, i ), M \ nopt1( :, i ));
    fn = fn.*1e-3;
    
    delta = 1 / (Constants.k_B * Constants.T) * delta_t * D * fn;
    
    pos(:, i) = pos(:, i - 1) + M * delta(1:3);
    rot(:, i) = rot(:, i - 1) + delta(4:6);
    R = rotmat( delta(4:6) );
    p = transform( p, 'rot', R );
    M = M * R;

    multiWaitbar( 'BEM solver', i / numel( t ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

posRots = cat( 1, pos, rot );
[X, Y, Z, U, V, W] = Transformation.getQuiverZaxis( posRots );
figure;
quiver3(X, Y, Z, U, V, W);

title('Quiver3 of Ellipsoid')
xlabel('X');
ylabel('Y');
zlabel('Z');

grid on;
axis equal;