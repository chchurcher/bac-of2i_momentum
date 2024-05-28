classdef TrajectoryForceTest < matlab.unittest.TestCase

    properties
        delta_t;
        t;
        forcTorq;
        spheroidSettlingData;
    end
    
    methods(TestMethodSetup)
        function setup(testCase)
            testCase.delta_t = 1;
            testCase.t = 0:testCase.delta_t:200;
            testCase.forcTorq = zeros(6, numel(testCase.t));
        end
    end
    
    methods(Test)
        % Test methods
        
        function constantForceTest(testCase)
            testCase.verifyFail("Unimplemented test");
        end

        function lateralDriftSedimentTest(testCase)
            % From: https://arxiv.org/pdf/2403.05443v1
            halfAxes = [7.5, 2.5, 2.5];
            gravity = repmat([0; 0; -9.81; 0; 0; 0], 1, numel(testCase.t));
            
            D = DiffusionTensor.ellipsoid(halfAxes);

            for inclination = 0:pi/20:pi/2
                particle = Particle(D);
                particle = particle.setBrownianMotion(false);
                trajectory = Trajectory();
    
                particle.rotation = [0, pi/4, 0];
                particle.unitVecMat = Transformation ...
                    .getRotationMatrix(particle.rotation);
                
                for i = 1:numel(testCase.t)
                    particle = particle.step(gravity(:, i), testCase.delta_t);
                    trajectory = trajectory.appendStep(particle);
                end
                
                trajectory.visualizePlot3();
            end
        end
    end
    
end