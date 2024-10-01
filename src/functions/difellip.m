function D = difellip( hax )
%DIFELLIPSOID Diffusion tensor for an ellipsoid
%   Calculates by the stokes-einstein relation from the resistance tensor
%   
%   Inputs:
%       hax - half axes of the ellipsoid [ax, ay, az]
%
%   Outputs:
%       D - diffusion tensor (6x6)

    alpha = zeros(1,3);
    K_t = zeros(3);
    K_r = zeros(3);
    
    fun_delta = @(lambda) sqrt(( hax(1) ^ 2 + lambda ) ...
        .* ( hax(2) ^ 2 + lambda ) ...
        .* ( hax(3) ^ 2 + lambda ));
    fun_chi = @(lambda) 1 ./ fun_delta( lambda );
    chi = integral( fun_chi, 0, inf );
    
    for i = 1:3
        fun_alpha = @(lambda) ...
            1 ./ (( hax(i) ^ 2 + lambda ) .* fun_delta( lambda ));
        alpha(i) = integral( fun_alpha, 0, inf );
    end
    
    for i = 1:3
        K_t(i, i) = ( 16 * pi ) / ( chi + hax(i) ^ 2 * alpha(i) );
   
        j = mod(i, 3) + 1;
        k = mod(i + 1, 3) + 1;
        K_r(i, i) = ( 16 * pi * ( hax(j) ^ 2 + hax(k) ^ 2 )) ...
            / ( 3 * ( hax(j) ^ 2 * alpha(j) + hax(k) ^ 2 * alpha(k) ));
    end

    K = zeros(6);
    K(1:3, 1:3) = K_t;
            K(4:6, 4:6) = K_r;

    D = Constants.k_B * Constants.T / Constants.eta_water * inv(K); %#ok<MINV>
end

