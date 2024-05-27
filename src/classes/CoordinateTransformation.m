classdef CoordinateTransformation
    %COORDINATETRANSFORMATION The static functions are used to transform
    %   position and angular vectors into different coordinate systems
    
    methods (Static)
        function posMat = getDirectionMatrix(inLab)
            %Transforms a position_angular 6 entry vector given in the lab 
            %   system to the position_angular vector in the particle 
            %   system

            posInParticle
        end

        function rotMat = getRotMat(angles)
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

            rotMat = rotMatX * rotMatY * rotMatZ;
        end

        function 
    end
end

