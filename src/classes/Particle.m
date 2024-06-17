classdef Particle
    %PARTICLE Class of the properties of one distinct particle
    
    properties
        posRot;
        unitVecMat;
        diffusionTensor;
        isBrownianMotion;
        isPreventRotation;
    end
    
    methods
        function obj = Particle(diffusionTensor)
            %Construct an instance of a particle
            obj.diffusionTensor = diffusionTensor;
            obj.posRot = zeros(6, 1);
            obj.unitVecMat = eye(3);
            obj.isBrownianMotion = true;
            obj.isPreventRotation = false;
        end

        function obj = setBrownianMotion(obj, isBrownianMotion)
            obj.isBrownianMotion = isBrownianMotion;
        end

        function obj = setPreventRotation(obj, isPreventRotation)
            obj.isPreventRotation = isPreventRotation;
        end

        function obj = step(obj, forcTorqLab, delta_t)

            forcTorqPart = zeros(6, 1);
            forcTorqPart(1:3) = obj.unitVecMat \ forcTorqLab(1:3);
            forcTorqPart(4:6) = obj.unitVecMat \ forcTorqLab(4:6);

            deltaPosRot = 1 / (Constants.k_B * Constants.T) ...
                * delta_t * obj.diffusionTensor * forcTorqPart;
            
            if obj.isBrownianMotion
                mu = zeros(6, 1);
                w = mvnrnd(mu, obj.diffusionTensor);
                if obj.isPreventRotation, w(4:6) = 0; end
                deltaPosRot = deltaPosRot + sqrt(2 * delta_t) * w.';
            end

            obj.posRot(1:3) = obj.posRot(1:3) + obj.unitVecMat * deltaPosRot(1:3);
            obj.posRot(4:6) = obj.posRot(4:6) + deltaPosRot(4:6);
            rotMat = Transformation.rotMatToLab(deltaPosRot(4:6));
            obj.unitVecMat = obj.unitVecMat * rotMat;
        end
    end
end
