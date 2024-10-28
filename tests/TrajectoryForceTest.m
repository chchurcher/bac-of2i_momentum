classdef TrajectoryForceTest < matlab.unittest.TestCase


  methods(Test)
    function lateralDriftSedimentTest(testCase)
      % From: https://arxiv.org/pdf/2403.05443v1

      n = 20;
      dt = 1;
      end_t = 2e3;
      t = 0:dt:end_t;

      a = 7.5;
      b = 2.5;
      halfAxes = [a, a, b];

      e = sqrt(1 - b^2 / a^2);
      C_para = 8*e^3/3 / (-2*e + (1+e^2) * log((1+e)/(1-e)));
      C_perp = 16*e^3/3 / (2*e + (3*e^2-1) * log((1+e)/(1-e)));

      force = [0, 0, -9.81];
      startPosRots = zeros(6, n);
      startPosRots(5, :) = linspace(0, pi/2, n);

      sim = Simulation( ...
        'brownian', true, ...
        'prevent_rotation', true, ...
        'halfAxes', halfAxes, ...
        'posRots', startPosRots, ...
        't', t);

      for i = 1:n
        for j = 2:numel(t)
          actPosRot = sim.posRots(:, j-1, i);
          force_m = Transformation.rotMatToParticle( ...
            actPosRot(4:6) ) * force.';
          sim.posRots(:, j, i) = sim.particleStep( ...
            actPosRot, [force_m; 0; 0; 0], dt);
        end
      end

      beta = pi/2 - sim.posRots(5, 1, :);
      
      pos = sim.posRots(1:3, end, :);
      actual = atan2(pos(3, :), pos(1, :)) + pi/2;
      %fprintf('Alpha=%.2f: X=%.6f, Z=%.6f\n', ...
      %    alpha, pos(1), pos(3));

      expected = zeros(1, n);
      for i = 1:n
        fun = @(delta) C_para / C_perp * tan(beta(i)) ...
          - tan(beta(i) - delta);
        expected(i) = fzero(fun, 0);
      end
      testCase.verifyEqual(actual, expected, ...
        'AbsTol', 1e-8, 'RelTol', 1e-4);
    end

    function lateralDriftDirectionTest(testCase)
      gravity = repmat([0, 0, -9.81], 10, 1);
      torque = zeros(1, 3);
      halfAxes = [5, 1, 1];

      particle = Particle( ...
        'brownian', false, ...
        'halfAxes', halfAxes, ...
        'pos', [0, 0, 0], ...
        'rot', [0, pi/4, pi/4]);

      for i = 1:10
        particle = particle.step(gravity(i, :), torque, [0, 0, 0], testCase.delta_t);
      end

      % Test for drift into positive x and y direction
      testCase.verifyGreaterThan(particle.pos(1), 0);
      testCase.verifyGreaterThan(particle.pos(2), 0);
    end
  end

end