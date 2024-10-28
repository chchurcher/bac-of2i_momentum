m = 7;
angles = linspace(0, pi/2, m);

n = 200;
posRots = zeros(6, n);
posRots(1, :) = linspace(-15e3, 15e3, n);


%% Calculation of the forces in focus plane

sims = Simulation.empty(m, 0);
exc = laguerregauss( Constants.w0, [1, 0] );

multiWaitbar('Particles', 'Color', 'g', 'CanCancel', 'on'  );
for j = 1:m
  posRots_m = posRots;
  posRots_m(5, :) = angles(j);
  sims(j) = Simulation( ...
    'brownian', false, ...
    'halfAxes', halfAxes, ...
    'posRots', posRots_m, ...
    'numElements', 500, ...
    'exc', exc);
  [bem, tau] = sims(j).getBemTau();
  
  multiWaitbar( 'Forces', 0, 'Color', 'g', 'CanCancel', 'on' );
  for i = 1:n
    fnopt_m = sims(j).calcForce( posRots_m(:, i), bem, tau );
    sims(j).fnopts_m(:, 1, i) = fnopt_m;
    multiWaitbar( 'Forces', i / n );
  end
  multiWaitbar('Particles', j / m );
end

clear bem tau
multiWaitbar( 'CloseAll' );


%% Plot the results
figure
tiledlayout(3,1)
sgtitle(sprintf('Optical forces of ellipsoids in z=0 with [%d, %d, %d] nm', halfAxes))

subtitles = { 'F_x', 'F_y', 'F_z' };
for i = 1:3
  nexttile;

  for j = 1:m
    fnopts_m = sims(j).fnopts_m(:, 1, :);
    fnopts_m = reshape( fnopts_m, [6, n] );
    fopt = pagemtimes(Transformation.rotMatToLab( [0, angles(j), 0] ), fnopts_m(1:3,:));
    plot(1e-3 * posRots(1, :), fopt(i, :), ...
      'LineWidth', 1.5);
    hold on
  end

  
  title(subtitles(i))
  xlabel('x (µm)')
  ylabel('Force (pN)')
end

nexttile(1);
angleStrings = arrayfun(@(num) sprintf('%.1f', num), ...
  angles*180/pi, ...
  'UniformOutput', false);
lg = legend(angleStrings);
lg.Layout.Tile = 'East';
