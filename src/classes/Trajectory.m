classdef Trajectory
    %TRAJECTORY Saves the positions and rotations of a particle depending
    %   on the timesteps
    
    properties
        positions
        rotations
        unrotatedVector
    end
    
    methods
        function obj = Trajectory(unrotatedVector)
            %TRAJECTORY Construct a new class for saving the trajectory of
            %   a particle
            %   unrotatedVector is the vector without rotation
            obj.unrotatedVector = unrotatedVector;
        end
        
        function obj = appendStep(obj, particle)
            %APPEND_STEP Apppend the position and rotation into the class
            obj.positions = [obj.positions, particle.position];
            obj.rotations = [obj.rotations, particle.rotation];
        end

        function visualize(obj)
            %VISUALIZE Trajectory in a quiver3 chart
            [X, Y, Z, U, V, W] = Transformation.getVectors(obj.positions, obj.rotations);
            quiver3(X, Y, Z, U, V, W);
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            grid on;
        end
    end
end

