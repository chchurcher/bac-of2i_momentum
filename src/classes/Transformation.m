classdef Transformation
    %TRANSFORMATION The static functions are used to transform
    %   position and angular vectors into different coordinate systems
    
    methods (Static)
        function rotationMatrix = getRotationMatrix(angles)
            c = cos(angles);
            s = sin(angles);
            
            rotMatX = [   1 ,    0 ,    0 ;
                          0 ,  c(1), -s(1);
                          0 ,  s(1),  c(1)];

            rotMatY = [ c(2),    0 ,  s(2);
                          0 ,    1 ,    0 ;
                       -s(2),    0 ,  c(2)];

            rotMatZ = [ c(3), -s(3),    0 ;
                        s(3),  c(3),    0 ;
                          0 ,    0 ,    1 ];

            rotationMatrix = rotMatX * rotMatY * rotMatZ;
        end

        function rotatedVector = rotateUnitVectorZ(angle)
            rotatedVector = getRotationMatrix(-angle) * [0, 0, 1];
        end

        function rotatedVectors = rotateVectors(angles)
            [~, num_angles] = size(angles);
            rotatedVectors = zeros(3, num_angles);
            for i = 1:num_angles
                rotatedVectors(:, i) = rotateUnitVectorZ(angles(:, i));
            end
        end

        function [X, Y, Z, U, V, W] = getVectors(positions, rotations)
            rotatedVectors = rotateVectors(rotations);
            uvw = positions + rotatedVectors;
            [X, Y, Z] = num2cell(positions, 2);
            [U, V, W] = num2cell(uvw, 2);
        end
    end
end

