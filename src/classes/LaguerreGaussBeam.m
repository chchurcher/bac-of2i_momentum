classdef LaguerreGaussBeam
  %  Laguerre gauss beam wave excitation for full Maxwell equations

  properties
    w_0     %  beam waist
  end

  properties (Hidden)
    rules   %  quadrature rules
    imat    %  index for embedding medium
  end

  methods
    function obj = LaguerreGaussBeam( varargin )
      %  Initialize plane wave object.
      %
      %  Usage :
      %    obj = galerkin.planewave( w_0, r_R, varargin )
      %  Input
      %    w_0    :  beam waist of beam
      obj = init( obj, varargin{ : } );
    end

    function obj = init( obj, w_0, varargin )
      %  INIT - Initialize laguerre gauss beam object

      %  set up parser
      p = inputParser;
      p.KeepUnmatched = true;
      addParameter( p, 'rules', quadboundary.rules );
      addParameter( p, 'imat', 1 );
      %  parse input
      parse( p, varargin{ : } );

      %  plane wave polarization and light propagation direction
      obj.w_0 = w_0;
      %  integration rules and index for embedding medium
      obj.rules = p.Results.rules;
      obj.imat  = p.Results.imat;
    end

    function qinc = eval( obj, tau, k0 )
      %  EVAL - Inhomogeneities for laguerre gauss beam excitation.
      %
      %  Usage for obj = galerkin.planewave :
      %    qinc = eval( obj, tau, k0 )
      %  Input
      %    tau    :  boundary elements
      %    k0     :  wavelength of light in vacuum
      %  Output
      %    qinc   :  structure containing inhomogeneities for Galerkin scheme

      %  function for computation of electromagnetic fields
      fun = @( pt ) laguerreGaussFun( obj, pt, k0 );
      %  inhomogeneities
      [ e, h ] = qbasis( tau, fun, obj.rules );
      qinc = struct( 'e', e, 'h', h, 'tau', tau, 'k0', k0 );
    end
  end
end
