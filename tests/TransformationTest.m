classdef TransformationTest < matlab.unittest.TestCase
    
    methods(Test)
        function rotationMatrixTest(testCase)
            % Rotation by phi
            actual = Transformation.rotMatToLab([pi/2; 0; 0]);
            expected = [1, 0, 0; 0, 0, -1; 0, 1, 0];
            testCase.verifyEqual(actual, expected, 'AbsTol', 1e-6);

            actual = Transformation.rotMatToParticle([pi/2; pi/2; pi/2]);
            expected = [0, 0, -1; 0, 1, 0; 1, 0, 0];
            testCase.verifyEqual(actual, expected, 'AbsTol', 1e-6);

            sq2 = 1/sqrt(2);
            sq2p2 = 1/ (sqrt(2) * 2) + 1/2;
            sq2m2 = 1/ (sqrt(2) * 2) - 1/2;
            actual = Transformation.rotMatToLab([pi/4; pi/4; pi/4]);
            expected = [0.5, sq2m2, sq2p2; 0.5, sq2p2, sq2m2; -sq2, 0.5, 0.5];
            testCase.verifyEqual(actual, expected, 'AbsTol', 1e-6);
        end

        function identityTest(testCase)
            n = 10;
            rng(19);
            posRot = rand(6,n);

            expected = rand(3,n);
            vec_m = Transformation.toParticle(posRot, expected);
            actual = Transformation.toLab(posRot, vec_m);
            testCase.verifyEqual(actual, expected, 'RelTol', 1e-6);
        end

        function manyRotationsTest(testCase)
            rotations = [pi; pi; pi];
            rotMat = Transformation.rotMatToLab(rotations);
            testCase.verifyEqual(rotMat, eye(3), 'AbsTol', 1e-6);
        end
    end
    
end