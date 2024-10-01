classdef Constants
    %CONSTANTS used in the project
    
    properties (Constant)
        k_B = 1.380649e-23
        T = 300
        eta_water = 1e-3
    end

    methods (Static)
      function mat = material()
        mat1 = Material( 1.33 ^ 2, 1 );
        mat2 = Material( epstable( 'gold.dat' ), 1 );
        mat = [ mat1, mat2 ];
      end
    end
end

