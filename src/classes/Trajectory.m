classdef Trajectory
    %TRAJECTORY Saves the positions and rotations of a particle depending
    %   on the timesteps
    
    properties
        posRots
        unrotatedVector
    end
    
    methods
        function obj = appendStep(obj, particle)
            %APPENDSTEP Apppend the position and rotation into the class
            obj.posRots = [obj.posRots, particle.posRot];
        end

        function visualizeQuiverZaxis(obj)
            %VISUALIZEQUIVER3 Trajectory in a quiver3 chart
            [X, Y, Z, U, V, W] = Transformation.getQuiversZaxis(obj.posRots);

            figure;
            quiver3(X, Y, Z, U, V, W);

            title('Quiver z-Axis of Trajectory')
            xlabel('X');
            ylabel('Y');
            zlabel('Z');

            grid on;
            axis equal;
        end

        function visualizeQuiverAxes(obj, halfAxes)
            %VISUALIZEQUIVER3 Trajectory in a quiver3 chart
            [X, Y, Z, U, V, W] = Transformation.getQuiverAxes(obj.posRots, halfAxes);

            figure;
            quiver3(X, Y, Z, U, V, W);

            title('Quiver Halfaxes of Trajectory')
            xlabel('X');
            ylabel('Y');
            zlabel('Z');

            grid on;
            axis equal;
        end

        function visualizePlot3(obj)
            %VISUALIZEPLOT3 Trajectory in a plot3 chart
            xyz = num2cell(obj.posRots(1:3,:), 2);
            [X, Y, Z] = xyz{:};

            figure;
            plot3(X, Y, Z);

            title('Plot3 of Trajectory')
            xlabel('X');
            ylabel('Y');
            zlabel('Z');

            grid on;
        end
    end
end

