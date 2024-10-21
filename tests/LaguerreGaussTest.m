classdef LaguerreGaussTest < matlab.unittest.TestCase
  
  methods(TestClassSetup)
    % Shared setup for the entire test class
  end
  
  methods(TestMethodSetup)
    % Setup for each test
  end
  
  methods(Test)
    % Test methods
    
    function coordinateTransformationTest(testCase)
      n = 10;
      verts_m = 100*rand( [3, n] );

      posRot = [100*rand([3, 1]); pi*rand([3, 1])];
      verts = Transformation.toLab( repmat( posRot, 1, n ), verts_m );

      Transformation.posRot( posRot );
      [e_act, h_act] = laguerreGaussFun( verts_m.' );

      Transformation.posRot( zeros(6, 1) );
      [e_exp, h_exp] = laguerreGaussFun( verts.' );

      
      testCase.verifyEqual(e_act, e_exp, 'RelTol', 1e-6);
      testCase.verifyEqual(h_act, h_exp, 'RelTol', 1e-6);
    end
  end
  
end