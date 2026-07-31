% FIG5_LOCAL_SECTOR_BOUNDS
% Reproduces Fig. 5 of the paper: the local sector bound [gamma1, gamma2]
% (Theorem 4) of the trained tanh controller, evaluated over a growing input
% range y in [0, ybar]. As ybar increases the bounds widen and gamma2 rises
% toward the critical upper sector Sigma2 = -1.276; it reaches Sigma2 near
% ybar = 12.2, which is the largest admissible Gamma set.
%
% Requires: ../src on the path (nn_forward, local_sector_bound, ...).

clear; clc; close all;
addpath('../src');

W = load_weights('../weights');          % {W1, W2, W3}, 1-10-10-1 controller
Sigma2 = -1.276;                         % critical upper sector (A+B*Sigma2*C Hurwitz)

ybar_list = [6, 10, 12.2, 15];           % Gamma = [0, ybar] for each panel

figure('Color', 'w');
for k = 1:numel(ybar_list)
    ybar = ybar_list(k);
    y = linspace(0, ybar, 200);

    % network output and its local sector bounds on [0, ybar]
    nn = nn_forward(W, y);                          % 1 x N
    [g1, g2] = local_sector_bound(W, 0, ybar);      % scalars gamma1, gamma2

    subplot(2, 2, k); hold on; grid on; box on;
    fill([y, fliplr(y)], [g1*y, fliplr(g2*y)], [1 1 0.4], ...
         'FaceAlpha', 0.25, 'EdgeColor', 'none');
    plot(y, nn,       'k',   'LineWidth', 1.8);
    plot(y, g1*y,     'b--', 'LineWidth', 1.3);
    plot(y, g2*y,     'r--', 'LineWidth', 1.3);
    plot(y, Sigma2*y, ':',   'Color', [0.4 0.4 0.4], 'LineWidth', 1.2);

    title(sprintf('$y \\in [0,\\,%.1f]$,\\; $\\gamma_1=%.2f$,\\; $\\gamma_2=%.2f$', ...
                  ybar, g1, g2), 'Interpreter', 'latex');
    xlabel('$y$', 'Interpreter', 'latex');
    ylabel('Output', 'Interpreter', 'latex');
    legend({'sector band', '$\mathrm{NN}(y)$', '$\gamma_1 y$', '$\gamma_2 y$', ...
            '$\Sigma_2 y$'}, 'Interpreter', 'latex', 'Location', 'southwest');
end
sgtitle('Local sector bounds for different input ranges', 'Interpreter', 'latex');
