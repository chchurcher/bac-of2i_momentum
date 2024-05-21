classdef ResistanceTensor
    %RESISTANCETENSOR Class for calculating different resistance tensors
    %   of arbitrary shapes

    methods (Static)
        function K = ellipsoid(halfAxes)
            %RESISTANCETENSOR for an ellipsoid with half axes [a1, a2, a3]
            alpha = zeros(1,3);
            K_t = zeros(3);
            K_r = zeros(3);
            
            fun_delta = @(lambda) sqrt(( halfAxes(1) ^ 2 + lambda ) ...
                .* ( halfAxes(2) ^ 2 + lambda ) ...
                .* ( halfAxes(3) ^ 2 + lambda ));
            fun_chi = @(lambda) 1 ./ fun_delta( lambda );
            chi = integral( fun_chi, 0, inf );
            
            for i = 1:3
                fun_alpha = @(lambda) ...
                    1 ./ (( halfAxes(i) ^ 2 + lambda ) .* fun_delta( lambda ));
                alpha(i) = integral( fun_alpha, 0, inf );
            end
            
            for i = 1:3
                K_t(i, i) = ( 16 * pi ) / ( chi + halfAxes(i) ^ 2 * alpha(i) );
           
                j = mod(i, 3) + 1;
                k = mod(i + 1, 3) + 1;
                K_r(i, i) = ( 16 * pi * ( halfAxes(j) ^ 2 + halfAxes(k) ^ 2 )) ...
                    / ( 3 * ( halfAxes(j) ^ 2 * alpha(j) + halfAxes(k) ^ 2 * alpha(k) ));
            end

            K = zeros(6);
            K(1:3, 1:3) = K_t;
            K(4:6, 4:6) = K_r;
        end
    end
end
