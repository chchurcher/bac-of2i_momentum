function [e, h] = laguerreGaussFun( pos, k1, w0 )
% FIELDS2 - Electromagnetic fields for a laguerre gauss beam
% 
% Input
%    pt     :  integration points
%    k0     :  wavelength of light in vacuum
%  Output
%    e      :  electric field
%    h      :  magnetic field

A = 1e3;
m = 1;
zR =  1/2 * k1 * w0^2;

%  allocate output
e = zeros( size( pos, 1 ), 3 );
h = zeros( size( pos, 1 ), 3 );

% abstract functions
w = @(z) w0 * sqrt(1 + (z/zR).^2);
u_0 = @(r, z) 1./(1+1i*z/zR) .* exp(-(r./w0).^2./(1+1i*z/zR));
sq2 = sqrt(2);
u_m = @(r, z, m) ((sq2.*r./w(z)).^m .* exp(-1i*m*atan(z/zR)));

x = pos(:, 1);
y = pos(:, 2);
z = pos(:, 3);

%  electric and magnetic field
r = sqrt(x.^2 + y.^2);

e(:, 1) = A * u_0(r, z) .* u_m(r, z, m) .* exp(1i*k1*z);
e(:, 3) = ((m*(1i*y+x)./(k1*r.^2)) - ((1i*x)./(1i*z-zR)) ...
  - ((4i*x)./(k1*w(z).^2))) .* e(:, 1);

h(:, 2) = A * u_0(r, z) .* u_m(r, z, m) .* exp(1i*k1*z);
h(:, 3) = ((m*(1i*y-1)./(k1*r.^2)) - ((1i*y)./(1i*z-zR)) ...
  - ((4i*y)./(k1*w(z).^2))) .* h(:, 2);

end