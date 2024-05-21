classdef ResistanceTensorTest < matlab.unittest.TestCase
    
    methods(TestClassSetup)
        % Shared setup for the entire test class
    end
    
    methods(TestMethodSetup)
        % Setup for each test
    end
    
    methods(Test)
        % Test methods
        
        function ellipsoidTest(testCase)
            % Implementation of the fluctuation dissipation theorem for
            % the spherical limit
            a = 4.5;
            D_tt = 1 / (6*pi * a) * eye(3);
            D_rr = 1 / (8*pi * a^3) * eye(3);

            D = zeros(6);
            D(1:3, 1:3) = D_tt;
            D(4:6, 4:6) = D_rr;

            halfAxes = a * ones(3, 1);
            K = ResistanceTensor.ellipsoid(halfAxes);

            I = D * K;
            testCase.verifyEqual(I, eye(6), 'AbsTol', 1e-6);
        end
    end
    
end