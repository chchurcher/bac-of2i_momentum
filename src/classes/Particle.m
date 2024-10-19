classdef Particle
  %PARTICLE Class of the properties of one distinct particle

  properties
    pos;
    rotMat_m;  % rotational matrix to rotate particles vectors to lab
    diffusionTensor;
    isBrownianMotion;
    isPreventRotation;
    triLab;  % particle in bem toolbox in the lab system
    halfAxes;
  end

  methods
    function obj = Particle( varargin )
    %PARTICLE Constructor for a ellipsoidal particle
      obj.pos = zeros( 3, 1 );
      obj.rotMat_m = eye( 3 );
      obj.diffusionTensor = zeros( 6 );

      for i = 1 : 2 : numel( varargin )
        val = varargin{ i + 1 };
        switch varargin{ i }
          case 'brownian'
            obj.isBrownianMotion = val;
          case 'prevent_rotation'
            obj.isPreventRotation = val;
          case 'pos'
            obj.pos = val;
          case 'rot'
            obj.rotMat_m = Transformation.rotMatToLab( val );
          case 'halfAxes'
            obj.halfAxes = val;
        end
      end

      %Construct an instance of a particle
      obj.diffusionTensor = DiffusionTensor.ellipsoid( obj.halfAxes );
      obj.triLab = trisphere( 60, 1 );
      obj.triLab = transform( obj.triLab, 'scale', obj.halfAxes );
      obj.triLab = transform( obj.triLab, 'rot', obj.rotMat_m );
      obj.triLab = transform( obj.triLab, 'shift', obj.pos );
    end

    function obj = step( obj, fopt, nopt, flow, dt )

      % Calculate force and torque in particles system (marked)
      fnopt_m = zeros( 6, 1 );
      fnopt_m(1:3) = obj.rotMat_m \ fopt.';
      fnopt_m(4:6) = obj.rotMat_m \ nopt.';

      % Add number
      dPosRot_m = 1 / (Constants.k_B * Constants.T) ...
        * dt * obj.diffusionTensor * fnopt_m;

      if obj.isBrownianMotion
        mu = zeros(6, 1);
        w = mvnrnd(mu, obj.diffusionTensor);
        if obj.isPreventRotation, w(4:6) = 0; end
        dPosRot_m = dPosRot_m + sqrt(2 * dt) * w.';
      end

      dRotMat_m = Transformation.rotMatToLab(dPosRot_m(4:6));

      verts_m = obj.triLab.verts - obj.pos;
      verts_m = dRotMat_m * verts_m.';

      obj.pos = obj.pos + (obj.rotMat_m * dPosRot_m(1:3)).';
      obj.pos = obj.pos + flow * dt;
      obj.triLab.verts = verts_m.' + obj.pos;

      obj.rotMat_m = obj.rotMat_m * dRotMat_m;
    end
  end
end
