function [e, h] = fields2( obj, pt, k0 )
% FIELDS2 - Electromagnetic fields for a laguerre gauss beam
% 
% Input
%    pt     :  integration points
%    k0     :  wavelength of light in vacuum
%  Output
%    e      :  electric field
%    h      :  magnetic field

%  material properties
mat = pt.tau( 1 ).mat( obj.imat );

%  wavelength and impedance in medium
[ k1, Z1 ] = deal( mat.k( k0 ), mat.Z( k0 ) );

%  positions 
pos = eval( pt );

if any( pt.tau( 1 ).inout == obj.imat )
  [e, h] = laguerreGaussFun( pos, k1, Z1, obj.w_0, [1, 0] );
end
end