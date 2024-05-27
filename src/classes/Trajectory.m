classdef Trajectory
    %TRAJECTORY Saves the positions and rotations of a particle depending
    %   on the timesteps
    
    properties
        positions
        rotations
        axesLengths
    end
    
    methods
        function obj = Trajectory(axesLengths)
            %TRAJECTORY Construct a new class for saving the trajectory of
            %   a particle
            %   AxesLengths is the lengths of the in the plot
            obj.axesLengths = axesLengths;
        end
        
        function obj = appendStep(obj, particle)
            %APPEND_STEP Apppend the position and rotation into the class
            obj.positions.append(particle.position);
            obj.rotations.append(particle.rotation);
        end

        function visualize(obj)
            %Visulaizes the trajectory in a quiver3 chart
            [X, Y, Z] = obj.positions;
            
        end
    end
end

