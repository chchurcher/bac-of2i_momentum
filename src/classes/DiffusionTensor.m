classdef DiffusionTensor
    %DIFFUSIONTENSOR Class for calculating different diffusion tensors
    %   of arbitrary shapes

    methods (Static)
        function D = ellipsoid(halfAxes)
            %DIFFUSIONTENSOR for an ellipsoid with half axes [a1, a2, a3]
            K = ResistanceTensor.ellipsoid(halfAxes);
            D = DiffusionTensor.fromResistanceTensor(K);
        end

        function D = fromResistanceTensor(K)
            D = Constants.k_B * Constants.T / Constants.eta_water * inv(K); %#ok<MINV>
        end
    end
end
