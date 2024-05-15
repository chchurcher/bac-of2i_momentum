%  DEMOFORCE01 - Force for nanoparticle.

%  nanosphere
diameter = 60;
p = trisphere( 144, diameter );
p = transform( p, 'scale', [ 2, 1, 1.5 ] );

t = 30;
[ sint, cost ] = deal( sind( t ), cosd( t ) );
p = transform( p, 'rot', [ cost, 0, -sint; 0, 1, 0; sint, 0, cost ] );

%  dielectric functions for water and gold
mat1 = Material( 1.33 ^ 2, 1 );
mat2 = Material( epstable( 'gold.dat' ), 1 );
%  material properties
mat = [ mat1, mat2 ];

%  boundary elements with linear shape functions
tau = BoundaryEdge( mat, p, [ 2, 1 ] );
%  initialize BEM solver
rules = quadboundary.rules( 'quad3', triquad( 3 ) );
bem = galerkin.bemsolver( tau, 'rules', rules, 'waitbar', 1 );
%  T-matrix solver
lmax = 4;
tsolver = multipole.tsolver( mat, 1, lmax );
mie = multipole.miesolver( mat2, mat1, diameter, lmax );

%  planewave excitation
exc = galerkin.planewave( [ 1, 0, 0 ], [ 0, 0, 1 ] );
% exc = galerkin.planewave( [ 0, 0, 1 ], [ 1, 0, 0 ] );

%  light wavelength in vacuum
lambda = linspace( 400, 800, 20 );
k0 = 2 * pi ./ lambda;
%  allocate optical force and torque arrays
[ fopt1, fopt2, nopt1, nopt2 ] = deal( zeros( numel( k0 ), 3 ) );
data = [];

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavenumbers
for i1 = 1 : numel( k0 )
  %  solution of BEM equations
  [ sol1, bem ] = solve( bem, exc( tau, k0( i1 ) ) );
  %  optical force and torque
  [ fopt1( i1, : ), nopt1( i1, : ), f1 ] = optforce( sol1 );
  
  %  T-matrix
  sol2 = bem \ tsolver( tau, k0( i1 ) );
  tmat = eval( tsolver, sol2 );
  % tmat = eval( mie, k0( i1 ) );
  %  inhomogeneity for plane wave
  finc = @( pos, k0 ) fields( exc, Point( mat, 1, pos ), k0 );
  q = qinc( tmat, finc );
  %  optical force
  sol3 = tmat \ q;
  [ fopt2( i1, : ), nopt2( i1, : ), data ] = optforce( sol3, data );
  % [ fopt2( i1, : ), nopt2( i1, : ) ] = tmatrix_force( tmat, finc );

  multiWaitbar( 'BEM solver', i1 / numel( k0 ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );


%%  final plot
%  force
figure
plot( lambda, fopt1, 'o-' );  hold on
set( gca, 'ColorOrderIndex', 1 );
plot( lambda, fopt2, '+-' );

xlabel( 'Wavelength (nm)' );
ylabel( 'Optical force (pN)' );
legend( 'x', 'y', 'z' );

figure
plot( lambda, nopt1, 'o-' );  hold on
set( gca, 'ColorOrderIndex', 1 );
plot( lambda, nopt2, '+-' );

xlabel( 'Wavelength (nm)' );
ylabel( 'Optical torque (pN x nm)' );
legend( 'x', 'y', 'z' );
