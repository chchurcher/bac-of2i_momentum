classdef SimulationTest < matlab.unittest.TestCase
  
  methods(TestClassSetup)
    % Shared setup for the entire test class
  end
  
  methods(TestMethodSetup)
    % Setup for each test
  end
  
  methods(Test)
    % Test methods
    
    function rotationalSphereTest(testCase)
      
      % The force on the spheres should not depend on the rotation of the
      % spheres

      n = 5;
      t = [0, 0.1];
      startPosRot = [repmat(1e3*rand(3, 1), 1, n); pi*rand(3, n)];
      % startPosRot = [repmat(1e3*rand(3, 1), 1, n); repmat(pi*rand(3, 1), 1, n)];
      exc = laguerregauss( 4.78e3, [1, 0] );
      sim = Simulation( ...
        'brownian', false, ...
        'halfAxes', 1e2 * [ 1, 1, 1 ], ...
        'posRots', startPosRot, ...
        'lambda', 532, ...
        't', t, ...
        'exc', exc, ...
        'flow', [0, 0, 1]);
      sim = sim.start();

      pos = sim.posRots(1:3, end, :);
      pos = reshape( pos, [3, n] );
      dPos = pos ./ pos(:, 1);
      testCase.verifyEqual(dPos, ones(3, n), 'RelTol', 1e-3);
    end
  end
end