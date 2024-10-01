function output = rotmat( angles )
%ROTMAT Rotation matrix from particle into the lab system
%   Uses the Roll-, Nick-, Gierangles; or (z-y'-x'') convention
%   
%   Inputs:
%       angles - rotation vector omega in rad, array-shaped (3,n) or (3,1)
%
%   Outputs:
%       rotMat - rotation matrices, array-shaped (3,3,n) or (3,3)

    % Check if input is alright
    if size(angles, 1) ~= 3
        error('Input must be an array with shape (3,n) or (3)');
    end
    
    % Initialize the output matrix
    n = size(angles, 2);
    output = zeros(3, 3, n);
    
    for i = 1:n
        c = cos(angles(:, i));
        s = sin(angles(:, i));
        
        rotMatX = [   1 ,    0 ,    0 ;
                      0 ,  c(1), -s(1);
                      0 ,  s(1),  c(1)];
        
        rotMatY = [ c(2),    0 ,  s(2);
                      0 ,    1 ,    0 ;
                   -s(2),    0 ,  c(2)];
        
        rotMatZ = [ c(3), -s(3),    0 ;
                    s(3),  c(3),    0 ;
                      0 ,    0 ,    1 ];
        
        output(:, :, i) = rotMatZ * rotMatY * rotMatX;
    end
    
    % If only one rotation matrix, return it as 2D array instead of 3D
    if n == 1, output = output(:, :, 1); end
end

