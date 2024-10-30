classdef BrownianMotionTest < matlab.unittest.TestCase

  properties
    numRuns;
    showCharts;
    alpha;
    startPosition;
  end

  methods(TestMethodSetup)
    function setup(testCase)
      % Set seed of the random generator for reproducity
      rng(73);
      testCase.numRuns = 200;
      testCase.showCharts = true;
      testCase.alpha = 0.05;
    end
  end

  methods(Test)
    % Test methods

    function gaussianDistributionTest(testCase)
      n = testCase.numRuns;
      startPosRots = repmat( [-0.5; 1; 0.5; 0; 0; 0], 1, n );
      halfAxes = [10, 5, 1];

      delta_t = 1e9;
      end_t = 50e9;
      t = 0:delta_t:end_t;

      sim = Simulation( ...
        'brownian', true, ...
        'prevent_rotation', true, ...
        'halfAxes', halfAxes, ...
        'posRots', startPosRots);
      
      posRots = sim.posRots;
      for i = 1:n
        for j = 2:numel(t)
          posRots(:, j, i) = sim.particleStep( ...
            posRots(:, j-1, i), zeros(6, 1), delta_t);
        end
      end

      finalPositions = posRots(1:3, end, :);
      finalPositions = reshape(finalPositions, [3, n]);

      D = DiffusionTensor.ellipsoid( halfAxes );
      expectedMu = startPosRots(1:3, :);
      expectedSigma = sqrt(2*diag(D)*end_t);
      for d = 1:3
        %Test for being a normal distribution
        [h, pValue, W] = swtest(finalPositions(d,:));
        testCase.verifyEqual(h, false);
        fprintf('Dimen=%d: pValue=%.2f, W=%.6f\n', ...
          d, pValue, W);

        pd = fitdist(finalPositions(d,:)', 'Normal');

        %Test the variance
        chi2Lower = chi2inv(testCase.alpha/2, n-1);
        chi2Upper = chi2inv(1 - testCase.alpha/2, n-1);
        sigmaCiLower = (n-1) * pd.sigma / chi2Upper;
        sigmaCiUpper = (n-1) * pd.sigma / chi2Lower;
        fprintf('Dimen=%d: sigma=%.4s [%.4s,%.4s]\n', ...
          d, expectedSigma(d), sigmaCiLower, sigmaCiUpper);
        testCase.verifyGreaterThan(expectedSigma(d), sigmaCiLower);
        testCase.verifyLessThan(expectedSigma(d), sigmaCiUpper);

        %Test the mean
        tCritical = tinv(1 - testCase.alpha/2, n-1);
        marginOfError = tCritical * (pd.sigma / sqrt(n));
        muCiLower = pd.mu - marginOfError;
        muCiUpper = pd.mu + marginOfError;
        fprintf('Dimen=%d: mu=%.4f [%.4s,%.4s]\n', ...
          d, expectedMu(d), muCiLower, muCiUpper);
        testCase.verifyGreaterThan(expectedMu(d), muCiLower);
        testCase.verifyLessThan(expectedMu(d), muCiUpper);
      end

      if testCase.showCharts
        BrownianMotionTest.plotHistogram(finalPositions, ...
          expectedMu, expectedSigma);
      end
    end
  end

  methods(Static)
    function plotHistogram(finalPositions, mu, sigma)
      figure;
      sgtitle('Gaussian distribution test [10, 5, 1]');
      dimension = ['x', 'y', 'z'];
      for d = 1:3
        subplot(1, 3, d);
        [counts, edges] = histcounts(finalPositions(d, :), 20);
        edgeDiff = edges(2) - edges(1);
        counts = counts / sum(counts);
        counts = counts / edgeDiff;
        values = linspace(edges(1), edges(end), 100);
        pdf = normpdf(values, mu(d), sigma(d));

        bar(edges(1:end-1) + edgeDiff / 2, counts, 'histc');
        hold on;
        plot(values, pdf, '-r');
        title([dimension(d), '-Direction']);
      end
    end
  end

end