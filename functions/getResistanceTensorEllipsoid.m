function [ K_t, K_r ] = getResistanceTensorEllipsoid( halfAxes )

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

    if i == 1; j = 2; k = 3; end
    if i == 2; j = 3; k = 1; end
    if i == 3; j = 1; k = 2; end
    K_r(i, i) = ( 16 * pi * ( halfAxes(j) ^ 2 + halfAxes(k) ^ 2 )) ...
        / ( 3 * ( halfAxes(j) ^ 2 * alpha(j) + halfAxes(k) ^ 2 * alpha(k) ));
end
end
