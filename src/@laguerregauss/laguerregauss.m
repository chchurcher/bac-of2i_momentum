classdef laguerregauss
  %  Laguerre gauss beam wave excitation for full Maxwell equations
  
  properties
    w_0     %  beam waist
  end
  
  properties (Hidden)
    rules   %  quadrature rules 
    imat    %  index for embedding medium
  end
  
  methods 
    function obj = laguerregauss( varargin )
      %  Initialize laguerre gauss object.
      %
      %  Usage :
      %    obj = laguerregauss( w_0, varargin )
      %  Input
      %    w_0    :  beam waist of beam
      obj = init( obj, varargin{ : } );
    end
  end

end 
