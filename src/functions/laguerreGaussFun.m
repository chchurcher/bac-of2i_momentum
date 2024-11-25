function [e, h] = laguerreGaussFun( pos_m, k1, Z1, w0, AB )
% FIELDS2 - Electromagnetic fields for a laguerre gauss beam
% 
% Input
%    pos_m  :  integration points
%    k1     :  wavelength of light
%    Z1     :  wave impedance
%    w0     :  beam waist
%    AB     :  polarization
%  Output
%    e      :  electric field
%    h      :  magnetic field

if nargin < 2, k1 = 2*pi/650; end
if nargin < 3, Z1 = 1; end
if nargin < 4, w0 = Constants.w0; end

if nargin < 5
  A = 1 / sqrt(2);
  B = 1i / sqrt(2);
else
  A = AB(1);
  B = AB(2);
end

m = 2;
zR =  1/2 * k1 * w0^2;

pos_size = size( pos_m );

if pos_size(end) ~= 3
  error('Postition array must be in shape (..,3)')
end

pos_num = prod(pos_size(1:end-1));
pos_m = reshape(pos_m, [pos_num, 3]);

%  allocate output
e = zeros( [pos_num, 3] );
h = zeros( [pos_num, 3] );

% abstract functions
w = @(z) w0 * sqrt(1 + (z/zR).^2);

u_0 = @(r, z) (1./(1+1i*z/zR) .* exp(-(r.^2/w0.^2)./(1+1i*z/zR)));
% With time dependence of beam
% u_0 = @(r, z) (1./(1+1i*z/zR) .* exp(-(r.^2/w0.^2)./(1+1i*z/zR)) ...
%  .* exp(1i*k1*r/(2*pi)));

u_m = @(r, phi, z) ((sqrt(2).*r./w(z)).^m .* exp(-1i*m*atan2(z, zR)) ...
  .* exp(1i*m*phi));

posRot = Transformation.posRot;
pos = Transformation.toLab( repmat(posRot, 1, pos_num), pos_m.' );
x = pos(1, :).';
y = pos(2, :).';
z = pos(3, :).';

%  electric and magnetic field
r = sqrt(x.^2 + y.^2);
phi = atan2(y, x);

e(:, 1) = A * u_0(r, z) .* u_m(r, phi, z) .* exp(1i*k1*z);
e(:, 2) = B * u_0(r, z) .* u_m(r, phi, z) .* exp(1i*k1*z);
e(:, 3) = ...
  ((m*(1i*x+y)./(k1*r.^2)) - ((1i*x)./(1i*z-zR)) ...
  - ((4i*x)./(k1*w(z).^2))) .* e(:, 1) + ...
  ((m*(1i*y-x)./(k1*r.^2)) - ((1i*y)./(1i*z-zR)) ...
  - ((4i*y)./(k1*w(z).^2))) .* e(:, 2);

h(:, 1) = (-B/Z1) * u_0(r, z) .* u_m(r, phi, z) .* exp(1i*k1*z);
h(:, 2) = (A/Z1) * u_0(r, z) .* u_m(r, phi, z) .* exp(1i*k1*z);
h(:, 3) = ...
  ((m*(1i*x+y)./(k1*r.^2)) - ((1i*x)./(1i*z-zR)) ...
  - ((4i*x)./(k1*w(z).^2))) .* h(:, 1) + ...
  ((m*(1i*y-x)./(k1*r.^2)) - ((1i*y)./(1i*z-zR)) ...
  - ((4i*y)./(k1*w(z).^2))) .* h(:, 2);

e = Transformation.rotMatToParticle( posRot(4:6) ) * e.';
h = Transformation.rotMatToParticle( posRot(4:6) ) * h.';

e = reshape(e.', [pos_size(1:end-1), 3]);
h = reshape(h.', [pos_size(1:end-1), 3]);
end