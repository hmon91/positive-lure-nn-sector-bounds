% FIG3_NN_SECTOR_AND_GAMMA
% Reproduces Fig. 3a: the trained NN controller output NN(y) against the stable
% sector lines Sigma1*y and Sigma2*y, together with the admissible Gamma set
% y in [-12.2, 12.2] within which NN stays inside the sector [Sigma1, Sigma2].
%
% Requires: ../src on the path (nn_forward, load_weights).

clear; clc; close all;
addpath('../src');

W = load_weights('../weights');   % {W1, W2, W3}
Sigma1 = -3;        % lower sector  (A + B*Sigma1*C Metzler)
Sigma2 = -1.276;    % upper sector  (A + B*Sigma2*C Hurwitz)
ybar   = 12.2;      % maximal element of the Gamma set

y  = linspace(-15, 15, 500);
nn = nn_forward(W, y);            % batched scalar evaluation, 1 x N

figure('Color', 'w'); hold on; grid on; box on;
plot(y, nn,        'k', 'LineWidth', 2.5);
plot(y, Sigma1*y,  'b', 'LineWidth', 2.5);
plot(y, Sigma2*y,  'r', 'LineWidth', 2.5);

% dashed markers at +/- ybar and the shaded Gamma strip
for xv = [-ybar, ybar]
    plot([xv xv], [0, Sigma2*xv], '--', 'Color', [0.4 0.4 0.4], 'LineWidth', 1.8);
end
fill([-ybar ybar ybar -ybar], [-0.7 -0.7 0.7 0.7], [0.9 0.9 0.2], ...
     'FaceAlpha', 0.5, 'EdgeColor', 'none');
text(-ybar, -3, sprintf('%.1f', -ybar), 'HorizontalAlignment', 'center', 'FontSize', 16);
text( ybar,  3, sprintf('%.1f',  ybar), 'HorizontalAlignment', 'center', 'FontSize', 16);

xlabel('$y$', 'Interpreter', 'latex', 'FontSize', 20);
ylabel('Output', 'Interpreter', 'latex', 'FontSize', 20);
legend({'$\mathrm{NN}(y)$', '$\Sigma_1 y$', '$\Sigma_2 y$', '', '', '$\Gamma$ set'}, ...
       'Interpreter', 'latex', 'FontSize', 16, 'Location', 'northeast');
