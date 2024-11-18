classdef Constants
    %CONSTANTS used in the project
    
    properties (Constant)
        k_B = 1.380649e-23
        T = 293.15
        eta_water = 1.0016e-3
        w0 = 4.78e3
        lambda = 532
        v_fluid = 0.3e6
    end

    methods (Static)
      function mat = material()
        mat1 = Material( 1.33 ^ 2, 1 );
        mat2 = Material( 1.59 ^ 2, 1 );  % epstable( 'gold.dat' )
        mat = [ mat1, mat2 ];
      end
    end
end

