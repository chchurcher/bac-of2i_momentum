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

        function visualizeQuiver3(obj)
            %VISUALIZEQUIVER3 Trajectory in a quiver3 chart
            [X, Y, Z, U, V, W] = Transformation.getVectors(obj.positions, obj.rotations);

            figure;
            quiver3(X, Y, Z, U, V, W);

            title('Quiver3 of Trajectory')
            xlabel('X');
            ylabel('Y');
            zlabel('Z');

            grid on;
            axis equal;
        end

        function visualizePlot3(obj)
            %VISUALIZEPLOT3 Trajectory in a quiver3 chart
            xyz = num2cell(obj.positions, 2);
            [X, Y, Z] = xyz{:};

            figure;
            plot3(X, Y, Z);

            title('Plot3 of Trajectory')
            xlabel('X');
            ylabel('Y');
            zlabel('Z');

            grid on;
            axis equal;
        end
    end
end

