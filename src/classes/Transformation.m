classdef Transformation
  %TRANSFORMATION Static functions for coordinate transformation
  %   Transformes vectors from the particle fixed coordinate system into
  %   lab fixed coordinate system

  methods (Static)
    function rotMat = rotMatToLab(angles)
      %ROTMATTOLAB Rotation matrix from particle into the lab system
      %   Uses the Roll-, Nick-, Gierangles; or (z-y'-x'') convention
      %
      %   Inputs:
      %       angles - rotation vector omega, array-shaped (3,n) or (3,1)
      %
      %   Outputs:
      %       rotMat - rotation matrices, array-shaped (3,3,n) or (3,3)

      % Check if input is alright
      if isequal(size(angles), [1, 3])
        angles = angles .';
      end
      if size(angles, 1) ~= 3
        error('Input must be an array with shape (3,n) or (3,1)');
      end

      % Initialize the output matrix
      n = size(angles, 2);
      rotMat = zeros(3, 3, n);

      for i = 1:n
        c = cos(angles(:, i));
        s = sin(angles(:, i));

        rotMatX = [   1 ,    0 ,    0 ;
          0 ,  c(1), -s(1);
          0 ,  s(1),  c(1)];

        rotMatY = [ c(2),    0 ,  s(2);
          0 ,    1 ,    0 ;
          -s(2),    0 ,  c(2)];

        rotMatZ = [ c(3), -s(3),    0 ;
          s(3),  c(3),    0 ;
          0 ,    0 ,    1 ];

        rotMat(:, :, i) = rotMatZ * rotMatY * rotMatX;
      end

      % If only one rotation matrix, return it as 2D array instead of 3D
      if n == 1, rotMat = rotMat(:, :, 1); end
    end

    function rotMatTp = rotMatToParticle(angles)
      %ROTMATTOPARTICLE Rotation matrix from lab into the particle system
      %   Uses the Roll-, Nick-, Gierangles; or (z-y'-x'') convention
      %
      %   Inputs:
      %       angles - rotation vector omega, array-shaped (3,n) or (3,1)
      %
      %   Outputs:
      %       rotMatTp - rotation matrices, array-shaped (3,3,n) or (3,3)

      % Input is checked in ROTMATTOLAB function
      rotMat = Transformation.rotMatToLab(angles);

      % Get the size of the input array
      n = size(rotMat, 3);
      rotMatTp = zeros(3, 3, n);

      % Transpose each 3x3 matrix
      for i = 1:n
        rotMatTp(:, :, i) = rotMat(:, :, i)';
      end

      % If only one rotation matrix, return it as 2D array instead of 3D
      if n == 1, rotMatTp = rotMatTp(:, :, 1); end
    end

    function vector = toLab(posRot, vector_m)
      %TOLAB Converts a vector in particle to the lab system
      %
      %   Inputs:
      %       posRot - position (1:3,n) and rotation (4:6,n) of the
      %       particle, array-shaped (6,n) or (6)
      %       vector_m - vector in particle that should be rotated into
      %       lab system
      %
      %   Outputs:
      %       vector - vector in lab system, array-shaped (3,n) or (3)

      [posRotRows, n] = size(posRot);
      [vecRows, vecCols] = size(vector_m);
      if posRotRows ~= 6 || vecRows ~= 3 || vecCols ~= n
        error('Incompatible dimensions: posRot should be 6xn and vec should be 3xn');
      end

      rotMat = Transformation.rotMatToLab(posRot(4:6,:));
      vector = zeros(3, n);
      for i = 1:n
        vector(:, i) = rotMat(:, :, i) * vector_m(:, i) + posRot(1:3,i);
      end

      % If n==1, return it as vector instead of 2d array
      if n == 1, vector = vector(:, 1); end
    end

    function vector_m = toParticle(posRot, vector)
      %TOPARTICLE Converts a vector in lab to the particle system
      %
      % Inputs:
      %   posRot - position (1:3,n) and rotation (4:6,n) of the
      %   particle, array-shaped (6,n) or (6)
      %   vector - vector in lab system that should be rotated into
      %   particle system
      %
      % Outputs:
      %   vector_m - vector in particle system, array-shaped (3,n) or (3)

      [posRotRows, n] = size(posRot);
      [vecRows, vecCols] = size(vector);
      if posRotRows ~= 6 || vecRows ~= 3 || vecCols ~= n
        error('Incompatible dimensions: posRot should be 6xn and vec should be 3xn');
      end

      rotMat = Transformation.rotMatToParticle(posRot(4:6, :));
      vector_m = zeros(3, n);
      for i = 1:n
        vector_m(:, i) = rotMat(:, :, i) * (vector(:, i) - posRot(1:3,i));
      end

      % If n==1, return it as vector instead of 2d array
      if n == 1, vector_m = vector_m(:, 1); end
    end

    function angles = toAngles(rotMats)
      %TOANGELS Used to calculate a possible angle to acive the rotMat
      %
      % Inputs:
      %   rotMats - rotation matrices shaped (3,3,n) or (3,3)
      %
      % Outputs:
      %   angles - euler angles of the rotation matrices (3,n) or (3,1)

      [x, y, n] = size(rotMats);
      if x ~= 3 || y ~= 3
        error('Incompatible dimensions: rotMats must be (3,3,n)');
      end

      angles = zeros( 3, n );

      for i = 1:n
        angles(1, i) = atan2( rotMats(3, 2 ,i), rotMats(3, 3, i) );
        angles(2, i) = asin( -rotMats(3, 1, i) );
        angles(3, i) = atan2( rotMats(2, 1, i), rotMats(1, 1, i) );
      end
    end

    function out = posRot( data )
      persistent PosRot;
      if nargin, PosRot = data; end
      out = PosRot;
    end

    function [X, Y, Z, U, V, W] = getQuiverZaxis(posRots)
      %GETQUIVERSZAXIS Used for ploting a trajectory in the quiver3 plot
      %   The unit vector in z direction in the particle system is
      %   plotted
      %
      %   Inputs:
      %       posRots - position and rotation list of the particle,
      %       array-shaped (6,n) or (6)
      unitZ = repmat([0; 0; 1], 1, size(posRots, 2));
      labZ = Transformation.toLab(posRots, unitZ);
      xyz = num2cell(posRots(1:3, :), 2);
      uvw = num2cell(labZ - posRots(1:3, :), 2);
      [X, Y, Z] = xyz{:};
      [U, V, W] = uvw{:};
    end

    function [X, Y, Z, U, V, W] = getQuiverAxes(posRots, halfAxes)
      n = size(posRots, 2);
      particleVec = zeros(3, 3*n);
      particleVec(:,1:n) = repmat([halfAxes(1); 0; 0], 1, n);
      particleVec(:,1*n+1:2*n) = repmat([0; halfAxes(2); 0], 1, n);
      particleVec(:,2*n+1:3*n) = repmat([0; 0; halfAxes(3)], 1, n);

      posRots = repmat(posRots, 1, 3);
      posLab = Transformation.toLab(posRots, particleVec);
      xyz = num2cell(posRots(1:3, :), 2);
      uvw = num2cell(posLab - posRots(1:3,:), 2);
      [X, Y, Z] = xyz{:};
      [U, V, W] = uvw{:};
    end
  end
end
