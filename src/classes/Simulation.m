classdef Simulation
  %SIMULATION Performs a simulations of different particles in a plane wave

  properties
    particles
    positions
    lambda
    dt
    end_t
    pol
    dir
  end

  methods

    function obj = Simulation( particles )
      %TRAJECTORY Constructor method
      obj.particles = particles;
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

    function obj = start( obj )

      t = 0:obj.dt:obj.end_t;
      obj.positions = zeros( 3, numel( t ), numel( obj.particles ) );

      k0 = 2 * pi / obj.lambda;
      
      %  planewave excitation
      exc = galerkin.planewave( obj.pol, obj.dir );
      
      %  boundary elements with linear shape functions
      tau = BoundaryEdge( Constants.material(), ...
        obj.particles(1).triLab, [ 2, 1 ] );
      
      %  initialize BEM solver
      rules = quadboundary.rules( 'quad3', triquad( 3 ) );
      bem = galerkin.bemsolver( tau, 'rules', rules, 'waitbar', 1 );
      
      multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
      multiWaitbar( 'Particles', 0, 'Color', 'g', 'CanCancel', 'on' );

      for i = 1 : numel( obj.particles )
        p = obj.particles(i);
        obj.positions(:, 1, i) = p.pos;
        %  loop over timesteps
        for j = 2 : numel( t )
          %  solution of BEM equations
          [ sol1, bem ] = solve( bem, exc( tau, k0 ) );
          
          %  optical force and torque
          [ fopt, nopt, ~ ] = optforce( sol1 );
          
          % Converstion pico into nano
          fopt = fopt.*1e-3;
          nopt = nopt.*1e-3;

          p = p.step( fopt, nopt, obj.dt );
          obj.positions(:, j, i) = p.pos;
      
          multiWaitbar( 'BEM solver', j / numel( t ) );
        end
        multiWaitbar( 'Particles', i / numel( obj.particles ) );
      end
      multiWaitbar( 'CloseAll' );

    end

    function visualizePlot3(obj)
      %VISUALIZEPLOT3 Trajectory in a plot3 chart

      figure;
      for i = 1:numel( obj.particles )
        xyz = num2cell(obj.positions(:,:,i), 2);
        [X, Y, Z] = xyz{:};
        plot3(X, Y, Z); hold on
      end

      title('Plot3 of Trajectory')
      xlabel('X');
      ylabel('Y');
      zlabel('Z');

      grid on;
    end
  end
end

