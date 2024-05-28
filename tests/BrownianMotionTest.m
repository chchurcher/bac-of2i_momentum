classdef BrownianMotionTest < matlab.unittest.TestCase

    properties
        numRuns;
        showCharts;
    end

    methods(TestMethodSetup)
        function setup(testCase)
            % Set seed of the random generator for reproducity
            rng(37);
            testCase.numRuns = 200;
            testCase.showCharts = true;
        end
    end

    methods(Test)
        % Test methods
        
        function gaussianDistributionTest(testCase)

            D = DiffusionTensor.ellipsoid(1e-12 * [3, 1, 1]);
            finalPositions = zeros(testCase.numRuns, 3);

            delta_t = 1;
            end_t = 50;
            t = 0:delta_t:end_t;

            for i = 1:testCase.numRuns
                particle = Particle(D);
                particle = particle.setBrownianMotion(true);
                
                for j = 1:numel(t)
                    particle = particle.step(zeros(6, 1), delta_t);
                end

                finalPositions(i, :) = particle.position;
            end

            expectedMu = zeros(3, 1);
            expectedSigma = sqrt(2*diag(D)*end_t);
            for d = 1:3
                %Test for being a normal distribution
                [h, pValue, W] = swtest(finalPositions(:,d));
                testCase.verifyEqual(h, false);
                fprintf('Dimen=%d: pValue=%.2f, W=%.6f\n', ...
                    d, pValue, W);

                %Test the params
                pd = fitdist(finalPositions(:,d), 'Normal');
                testCase.verifyEqual(pd.mu, expectedMu(d), 'AbsTol', 1e-2);
                testCase.verifyEqual(pd.sigma, expectedSigma(d), 'RelTol', 0.1);
            end

            if testCase.showCharts
                BrownianMotionTest.plotHistogram(finalPositions, expectedSigma);               
            end
        end
    end

    methods(Static)
        function plotHistogram(finalPositions, sigma)
            figure;
            title('Gaussian distribution test')
            dimension = ['x', 'y', 'z'];
            for d = 1:3
                subplot(1, 3, d);
                [counts, edges] = histcounts(finalPositions(:, d), 20);
                edgeDiff = edges(2) - edges(1);
                counts = counts / sum(counts);
                counts = counts / edgeDiff;
                values = linspace(edges(1), edges(end), 100);
                pdf = normpdf(values, 0, sigma);
                
                bar(edges(1:end-1) + edgeDiff / 2, counts, 'histc');
                hold on;
                plot(values, pdf);
                title([dimension(d), '-Direction']);
            end
        end
    end
    
end