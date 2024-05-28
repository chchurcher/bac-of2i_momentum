classdef Transformation
    %TRANSFORMATION The static functions are used to transform
    %   position and angular vectors into different coordinate systems
    
    methods (Static)
        function rotMat = rotMatToLab(angles)
            %ROTAIONMATRIX From particle into lab coordinate system
            % The Roll-, Nick-, Gierangles are used (z-y'-x'')
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

            rotMat = rotMatZ * rotMatY * rotMatX;
        end

        function rotMat = rotMatToParticle(angles)
            rotMat = Transformation.rotMatToLab(angles).';
        end

        function rotatedVector = rotateUnitVectorZ(angle)
            rotatedVector = Transformation.getRotationMatrix(-angle) * [0; 0; 1];
        end

        function rotatedVectors = rotateVectors(angles)
            [~, num_angles] = size(angles);
            rotatedVectors = zeros(3, num_angles);
            for i = 1:num_angles
                rotatedVectors(:, i) = Transformation.rotateUnitVectorZ(angles(:, i));
            end
        end

        function [X, Y, Z, U, V, W] = getVectors(positions, rotations)
            rotatedVectors = Transformation.rotateVectors(rotations);
            xyz = num2cell(positions, 2);
            uvw = num2cell(positions + rotatedVectors, 2);
            [X, Y, Z] = xyz{:};
            [U, V, W] = uvw{:};
        end
    end
end
