classdef Particle
    %PARTICLE Class of the properties of one distinct particle
    
    properties
        position;
        rotation;
        unitVecMat;
        diffusionTensor;
    end
    
    methods
        function obj = Particle(diffusionTensor)
            %Construct an instance of a particle
            obj.diffusionTensor = diffusionTensor;
            obj.position = zeros(3, 1);
            obj.rotation = zeros(3, 1);
            obj.unitVecMat = eye(3);
        end

        function posRot = getPosRot(obj)
            posRot = [obj.position; obj.rotation];
        end

        function obj = step(obj, forceTorqueLab, delta_t)
            largeUnitMat = [inv(obj.unitVecMat), zeros(3);
                           zeros(3), inv(obj.unitVecMat)];
            forceTorqueParticle = largeUnitMat * forceTorqueLab;

            mu = zeros(6, 1);
            w = mvnrnd(mu, obj.diffusionTensor);

            deltaPosRot = 1 / (Constants.k_B * Constants.T) ...
                * delta_t * obj.diffusionTensor * forceTorqueParticle;% ...
                % + sqrt(2 * delta_t) * w.';

            obj.position = obj.position + obj.unitVecMat * deltaPosRot(1:3);
            obj.rotation = obj.rotation + deltaPosRot(4:6);
            rotMat = Transformation.getRotationMatrix(deltaPosRot(4:6));
            obj.unitVecMat = obj.unitVecMat * rotMat;
        end
    end
end
