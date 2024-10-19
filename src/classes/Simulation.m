classdef Simulation
  %SIMULATION Performs a simulations of different particles in a plane wave

  properties
    particle
    positions
    rotMats
    lambda
    dt
    end_t
    exc
    flow
  end

  methods

    function obj = Simulation( particle )
      %SIMULATION Constructor method
      obj.particle = particle;
    end

    function obj = options( obj, varargin )
      obj.flow = [0, 0, 0];

      for i = 1 : 2 : numel( varargin )
        val = varargin{ i + 1 };
        switch varargin{ i }
          case 'lambda'
            obj.lambda = val;
          case 'dt'
            obj.dt = val;
          case 'end_t'
            obj.end_t = val;
          case 'exc'
            obj.exc = val;
          case 'flow'
            obj.flow = val;
        end
      end
    end

    function obj = start( obj )

      multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );

      t = 0:obj.dt:obj.end_t;
      k0 = 2 * pi / obj.lambda;

      obj.positions = zeros( 3, numel( t ) );
      obj.rotMats = zeros( 3, 3, numel( t ) );

      p = obj.particle;
      obj.positions(:, 1) = p.pos;
      obj.rotMats(:, :, 1) = p.rotMat_m;

      %  loop over timesteps
      for j = 2 : numel( t )

        %  boundary elements with linear shape functions
        tau = BoundaryEdge( Constants.material(), ...
          p.triLab, [ 2, 1 ] );
  
        %  initialize BEM solver
        rules = quadboundary.rules( 'quad3', triquad( 3 ) );
        bem = galerkin.bemsolver( tau, 'rules', rules, 'waitbar', 1 );
        
        %  solution of BEM equations
        [ sol1, ~ ] = solve( bem, obj.exc( tau, k0 ) );
        
        %  optical force and torque
        [ fopt, nopt, ~ ] = optforce( sol1 );
        fopt = fopt *1e-3;
        nopt = nopt *1e-3;
        disp(['Force=', num2str(fopt)]);

        p = p.step( fopt, nopt, obj.flow, obj.dt );
        obj.positions(:, j) = p.pos;
        obj.rotMats(:, :, j) = p.rotMat_m;
    
        multiWaitbar( 'BEM solver', j / numel( t ) );

      end
      multiWaitbar( 'CloseAll' );

    end

    function visualizePlot3(obj)
      %VISUALIZEPLOT3 Trajectory in a plot3 chart

      figure;
      xyz = num2cell(obj.positions(:,:), 2);
      [X, Y, Z] = xyz{:};
      plot3(X, Y, Z);

      title('Plot3 of Trajectory')
      xlabel('X');
      ylabel('Y');
      zlabel('Z');

      grid on;
    end
  end
end

