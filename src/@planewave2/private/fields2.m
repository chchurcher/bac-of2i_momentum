function [ e, h ] = fields2( obj, pt, k0 )
%  FIELDS2 - Electromagnetic fields for planewave excitation.
%
%  Usage for obj = galerkin.planewave :
%    [ e, h ] = fields2( obj, pt, k0 )
%  Input
%    pt     :  integration points
%    k0     :  wavelength of light in vacuum
%  Output
%    e      :  electric field
%    h      :  magnetic field

%  material properties
mat = pt.tau( 1 ).mat( obj.imat );
%  wavelength and impedance in medium
[ k1, Z1 ] = deal( mat.k( k0 ), mat.Z( k0 ) );


% !! Change coordinate system to lab system !!
pos_m = eval( pt );
pos_size = size( pos_m );

pos_num = prod(pos_size(1:end-1));
pos_m = reshape(pos_m, [pos_num, 3]);

posRot = Transformation.posRot;
pos = Transformation.toLab( repmat(posRot, 1, pos_num), pos_m.' );
pos = pos.';

%  allocate output
e = zeros( [pos_num, 3] );
h = zeros( [pos_num, 3] );

if any( pt.tau( 1 ).inout == obj.imat )
  dir = repmat( obj.dir, pos_num, 1 );
  
  %  electric and magnetic field
  e = obj.pol .* exp( 1i * k1 * dot( pos, dir, 2 ) );
  h = cross( dir, e, 2 ) / Z1;

  e = Transformation.rotMatToParticle( posRot(4:6) ) * e.';
  h = Transformation.rotMatToParticle( posRot(4:6) ) * h.';
  
  e = reshape(e.', [pos_size(1:end-1), 3]);
  h = reshape(h.', [pos_size(1:end-1), 3]);
end
