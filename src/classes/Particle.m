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
            %Simulation Construct an instance of this class
            %   diffu
            obj.diffusionTensor = diffusionTensor;
            obj.position = zeros(3, 1);
            obj.rotation = zeros(3, 1);
            obj.unitVecMat = eye(3);
        end

        function posRot = getPosRot(obj)
            posRot = [obj.position; obj.rotation];
        end

        function obj = step(obj, deltaPosRot)
            obj.position = obj.position + obj.unitVecMat * deltaPosRot(1:3);
            obj.rotation = obj.rotation + deltaPosRot(4:6);
            rotMat = CoordinateTransformation.getRotMat(deltaPosRot(4:6));
            obj.unitVecMat = obj.unitVecMat * rotMat;
        end
    end
end
