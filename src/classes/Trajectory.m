classdef Trajectory
  %TRAJECTORY Saves the positions and rotations of a particle depending
  %   on the timesteps

  properties
    particle
    positions
    lambda
    dt
    end_t
    pol
    dir
  end

  methods

    function obj = Trajectory( particle )
      %TRAJECTORY Constructor method
      obj.particle = particle;
    end

    function obj = options( obj, varargin )
      for i = 1 : 2 : numel( varargin )
        val = varargin{ i + 1 };
        switch varargin{ i }
          case 'lambda'
            obj.lambda = val;
          case 'dt'
            obj.dt = val;
          case 'end_t'
            obj.end_t = val;
          case 'pol'
            obj.pol = val;
          case 'dir'
            obj.dir = val;
        end
      end
    end

    function obj = simulate( obj )

      p = obj.particle;
      t = 0:obj.dt:obj.end_t;

      obj.positions = zeros( 3, numel( t ) );
      obj.positions(:, 1) = p.pos;

      k0 = 2 * pi / obj.lambda;
      
      %  planewave excitation
      exc = galerkin.planewave( obj.pol, obj.dir );
      
      %  boundary elements with linear shape functions
      tau = BoundaryEdge( Constants.material(), ...
        obj.particle.triLab, [ 2, 1 ] );
      
      %  initialize BEM solver
      rules = quadboundary.rules( 'quad3', triquad( 3 ) );
      bem = galerkin.bemsolver( tau, 'rules', rules, 'waitbar', 1 );
      
      multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
      %  loop over timesteps
      for i = 2 : numel( t )
          %  solution of BEM equations
          [ sol1, bem ] = solve( bem, exc( tau, k0 ) );
          
          %  optical force and torque
          [ fopt, nopt, ~ ] = optforce( sol1 );
          
          fopt = fopt.*1e-3;
          nopt = nopt.*1e-3;

          p = p.step( fopt, nopt, obj.dt );
          obj.positions(:, i) = p.pos;
      
          multiWaitbar( 'BEM solver', i / numel( t ) );
      end
      multiWaitbar( 'CloseAll' );

    end

    function visualizeQuiverZaxis(obj)
      %VISUALIZEQUIVER3 Trajectory in a quiver3 chart
      [X, Y, Z, U, V, W] = Transformation.getQuiversZaxis(obj.positions);

      figure;
      quiver3(X, Y, Z, U, V, W);

      title('Quiver z-Axis of Trajectory')
      xlabel('X');
      ylabel('Y');
      zlabel('Z');

      grid on;
      axis equal;
    end

    function visualizeQuiverAxes(obj, halfAxes)
      %VISUALIZEQUIVER3 Trajectory in a quiver3 chart
      [X, Y, Z, U, V, W] = Transformation.getQuiverAxes(obj.positions, halfAxes);

      figure;
      quiver3(X, Y, Z, U, V, W);

      title('Quiver Halfaxes of Trajectory')
      xlabel('X');
      ylabel('Y');
      zlabel('Z');

      grid on;
      axis equal;
    end

    function visualizePlot3(obj)
      %VISUALIZEPLOT3 Trajectory in a plot3 chart
      xyz = num2cell(obj.positions, 2);
      [X, Y, Z] = xyz{:};

      figure;
      plot3(X, Y, Z);

      title('Plot3 of Trajectory')
      xlabel('X');
      ylabel('Y');
      zlabel('Z');

      grid on;
    end
  end
end

