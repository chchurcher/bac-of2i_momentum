classdef TrajectoryForceTest < matlab.unittest.TestCase

  properties
    delta_t;
    t;
    forcTorq;
  end

  methods(TestMethodSetup)
    function setup(testCase)
      testCase.delta_t = 1;
      testCase.t = 0:testCase.delta_t:200;
      testCase.forcTorq = zeros(6, numel(testCase.t));
    end
  end

  methods(Test)
    function lateralDriftSedimentTest(testCase)
      % From: https://arxiv.org/pdf/2403.05443v1
      a = 7.5;
      b = 2.5;
      e = sqrt(1 - b^2 / a^2);
      C_para = 8*e^3/3 / (-2*e + (1+e^2) * log((1+e)/(1-e)));
      C_perp = 16*e^3/3 / (2*e + (3*e^2-1) * log((1+e)/(1-e)));

      force = repmat([0, 0, -9.81], numel(testCase.t), 1);
      torque = zeros(1, 3);

      for alpha = 0:pi/20:pi/2
        particle = Particle( ...
          'brownian', false, ...
          'halfAxes', [a, b, b ], ...
          'pos', [0, 0, 0], ...
          'rot', [0, alpha, 0]);

        for i = 1:numel(testCase.t)
          particle = particle.step(force(i, :), torque, testCase.delta_t);
        end

        beta = pi/2 - alpha;
        fun = @(delta) C_para / C_perp * tan(beta) ...
          - tan(beta - delta);
        pos = particle.pos;
        %fprintf('Alpha=%.2f: X=%.6f, Z=%.6f\n', ...
        %    alpha, pos(1), pos(3));

        expected = fzero(fun, 0);
        actual = atan2(pos(3), pos(1)) + pi/2;
        testCase.verifyEqual(actual, expected, ...
          'AbsTol', 1e-8, 'RelTol', 1e-4);
      end
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
        particle = particle.step(gravity(i, :), torque, testCase.delta_t);
      end

      % Test for drift into positive x and y direction
      testCase.verifyGreaterThan(particle.pos(1), 0);
      testCase.verifyGreaterThan(particle.pos(2), 0);
    end
  end

end