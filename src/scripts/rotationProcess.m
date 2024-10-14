%  ROTATIONPROCESS - Simulation of oblated spheroids in a plane wave with
%  their rotation paths

n = 20;
angles = linspace(0, pi/2, n);
dt = 0.05;
end_t = 2;
t = 0:dt:end_t;

particles = Particle.empty(n, 0);
for j = 1:n
  particles(j) = Particle( ...
    'brownian', false, ...
    'halfAxes', [ 50, 50, 1 ], ...
    'pos', [0, 0, 0], ...
    'rot', [angles(j), 0, 0]);
end

sim = Simulation( particles );
sim = sim.options( ...
  'lambda', 650, ...
  'dt', dt, ...
  'end_t', end_t, ...
  'pol', [ 1, 0, 0 ], ...
  'dir', [ 0, 0, 1 ]);

sim = sim.start();
sim.visualizePlot3();

% data = zeros(numel(t), 3*n);
% for i = 1:n
%   rotations = Transformation.toAngles( sim.rotMats(:, :, :, i) );
% 
%   [a, b, c] = deal(0, 0, 0);
%   for j = 1:numel(t)
% 
%   data(:, (i-1)*3+1:(i-1)*3+3) = rotations.';
% end

%%
figure;
sgtitle(['rotation paths of a oblated spheroid starting rotated ' ...
  'around x axis']);
paths = zeros(3, numel(t), n);

dimension = {'alpha', 'beta', 'gamma'};
for i = 1:3
  subplot(3, 1, i);
  for j = 1:n
    [a, b, c] = deal(0, 0, 0);
    rotations = Transformation.toAngles( sim.rotMats(:, :, :, j) );

    % Used for angles more than one full rotation
    % for k = 2:numel(t)
    %   if rotations(1, k) - rotations(1, k-1) > 4
    %     rotations(1, k:end) = rotations(1, k:end) - 2*pi;
    %   end
    %   if rotations(1, k) - rotations(1, k-1) < -4
    %     rotations(1, k:end) = rotations(1, k:end) + 2*pi;
    %   end
    % end

    if i == 1
      rotations = abs(rotations);
    end
    plot(t, rotations(i, :)); hold on
  end
  xlabel('time / s')
  ylabel('rotation / rad')
  title(dimension(i))
end
