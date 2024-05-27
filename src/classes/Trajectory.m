classdef Trajectory
    %TRAJECTORY Saves the positions and rotations of a particle depending
    %   on the timesteps
    
    properties
        positions
        rotations
        unrotatedVector
    end
    
    methods
        function obj = appendStep(obj, particle)
            %APPEND_STEP Apppend the position and rotation into the class
            obj.positions = [obj.positions, particle.position];
            obj.rotations = [obj.rotations, particle.rotation];
        end

        function visualize(obj)
            %VISUALIZE Trajectory in a quiver3 chart
            [X, Y, Z, U, V, W] = Transformation.getVectors(obj.positions, obj.rotations);

            figure
            quiver3(X, Y, Z, U, V, W);

            % Change optics
            xlabel('X');
            ylabel('Y');
            zlabel('Z');

            grid on;
            axis equal;

            % minLimit = min([X(:); Y(:); Z(:)]);
            % maxLimit = max([X(:); Y(:); Z(:)]);
            % 
            % xlim([minLimit maxLimit]);
            % ylim([minLimit maxLimit]);
            % zlim([minLimit maxLimit]);
        end
    end
end

