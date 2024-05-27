classdef Particle
    %PARTICLE Class of the properties of one distinct particle
    
    properties
        position;
        rotation;
        unitVecMat;
        diffusionTensor;
        isBrownianMotion;
    end
    
    methods
        function obj = Particle(diffusionTensor)
            %Construct an instance of a particle
            obj.diffusionTensor = diffusionTensor;
            obj.position = zeros(3, 1);
            obj.rotation = zeros(3, 1);
            obj.unitVecMat = eye(3);
            obj.isBrownianMotion = true;
        end

        function obj = setBrownianMotion(obj, isBrownianMotion)
            obj.isBrownianMotion = isBrownianMotion;
        end

        function posRot = getPosRot(obj)
            posRot = [obj.position; obj.rotation];
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
                deltaPosRot = deltaPosRot + sqrt(2 * delta_t) * w.';
            end

            obj.position = obj.position + obj.unitVecMat * deltaPosRot(1:3);
            obj.rotation = obj.rotation + deltaPosRot(4:6);
            rotMat = Transformation.getRotationMatrix(deltaPosRot(4:6));
            obj.unitVecMat = obj.unitVecMat * rotMat;
        end
    end
end
