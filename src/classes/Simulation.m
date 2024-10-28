classdef Simulation
  %SIMULATION Performs a simulations of different particles in a plane wave

  properties
    posRots
    fnopts_m
    isBrownianMotion;
    isPreventRotation;
    lambda
    t
    exc
    flow
    halfAxes
    diffusionTensor
    numElements
  end

  methods
    function obj = Simulation( varargin )
      %SIMULATION Constructor method

      obj.numElements = 60;
      obj.flow = [0, 0, 0];
      obj.halfAxes = [1, 1, 1];
      obj.isBrownianMotion = true;
      obj.isPreventRotation = false;
      obj.lambda = Constants.lambda;
      startPosRots = [];

      for i = 1 : 2 : numel( varargin )
        val = varargin{ i + 1 };
        switch varargin{ i }
          case 'brownian'
            obj.isBrownianMotion = val;
          case 'prevent_rotation'
            obj.isPreventRotation = val;
          case 'posRots'
            startPosRots = val;
          case 'halfAxes'
            obj.halfAxes = val;
          case 'lambda'
            obj.lambda = val;
          case 't'
            obj.t = val;
          case 'exc'
            obj.exc = val;
          case 'flow'
            obj.flow = val;
          case 'numElements'
            obj.numElements = val;
        end
      end

      obj.diffusionTensor = DiffusionTensor.ellipsoid( obj.halfAxes );

      n = size(startPosRots, 2);
      obj.posRots = zeros( 6, numel( obj.t ), n );
      obj.posRots(:, 1, :) = startPosRots;
      obj.fnopts_m = zeros(6, numel( obj.t ), n );
    end

    function [bem, tau] = getBemTau( obj )
      ts = trisphere( obj.numElements, 1 );
      ts = transform( ts, 'scale', obj.halfAxes );

      %  boundary elements with linear shape functions
      tau = BoundaryEdge( Constants.material(), ts, [ 2, 1 ] );
  
      %  initialize BEM solver
      rules = quadboundary.rules( 'quad3', triquad( 3 ) );
      bem = galerkin.bemsolver( tau, 'rules', rules, 'waitbar', 1 );
    end

    function obj = start( obj )
      [bem, tau] = obj.getBemTau();

      multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
      multiWaitbar( 'Particles', 0, 'Color', 'g', 'CanCancel', 'on' );

      n = size(obj.posRots, 3);
      for i = 1:n

        %  loop over timesteps
        for j = 2:numel( obj.t )

          actPosRot = obj.posRots(:, j-1, i);
          fnopt_m = obj.calcForce( actPosRot, bem, tau ) * 1e6;
          obj.fnopts_m(:, j-1, i) = fnopt_m;
          
          dt = obj.t(j) - obj.t(j-1);
          obj.posRots(:, j, i) = obj.particleStep( actPosRot, fnopt_m, dt );
      
          multiWaitbar( 'BEM solver', j / numel( obj.t ) );

        end

        multiWaitbar( 'Particles', i / n );
      end
      multiWaitbar( 'CloseAll' );

    end

    function fnopt_m = calcForce( obj, actPosRot, bem, tau )

      % Save static posRot in Transformation
      Transformation.posRot( actPosRot );
      k0 = 2 * pi / obj.lambda;

      %  solution of BEM equations
      [ sol1, ~ ] = solve( bem, obj.exc( tau, k0 ) );

      %  optical force and torque
      [ fopt, nopt, ~ ] = optforce( sol1 );
      fnopt_m = [ fopt.'; nopt.' ];

      % Scaling of the forces
      fnopt_m = 1.65e-5 * fnopt_m;

    end

    function newPosRot = particleStep( obj, actPosRot, fnopt_m, dt )

      rotMat = Transformation.rotMatToLab( actPosRot(4:6) );

      % Add number
      dPosRot_m = 1 / (Constants.k_B * Constants.T) ...
        * dt * obj.diffusionTensor * fnopt_m;

      if obj.isBrownianMotion
        mu = zeros(6, 1);
        w = mvnrnd(mu, obj.diffusionTensor);
        if obj.isPreventRotation, w(4:6) = 0; end
        dPosRot_m = dPosRot_m + sqrt(2 * dt) * w.';
      end

      % Change position
      newPosRot = zeros(6, 1);
      newPosRot(1:3) = actPosRot(1:3) + rotMat * dPosRot_m(1:3) ...
        + obj.flow.' * dt;

      % Change angle
      dRotMat_m = Transformation.rotMatToLab( dPosRot_m(4:6) );
      rotMat_m = rotMat * dRotMat_m;
      newPosRot(4:6) = Transformation.toAngles( rotMat_m );
    end

    function visualizePlot3(obj)
      %VISUALIZEPLOT3 Trajectory in a plot3 chart

      n = size(obj.posRots, 3);

      figure;
      for i = 1:n
        xyz = num2cell(obj.posRots(1:3, :, i), 2);
        [X, Y, Z] = xyz{:};
        plot3(X, Y, Z);
        hold on
      end

      title('Plot3 of Trajectory')
      xlabel('X');
      ylabel('Y');
      zlabel('Z');

      grid on;
    end
  end
end

