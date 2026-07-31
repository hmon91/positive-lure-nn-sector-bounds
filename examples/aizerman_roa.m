% AIZERMAN_ROA
% Section III / VI-a: ROA estimate via the local positive Aizerman conjecture
% (Lemma 3). For M = A + B*Sigma2*C Metzler and Hurwitz, a positive left
% eigenvector v (v'M < 0) yields the linear ROA underapproximation
%
%       C x0  <=  (v_min / v_max) * ybar ,
%
% with ybar = 12.2 the maximal element of the Gamma set. This reproduces the
% paper value C x0 <= 5.12. Closed-loop trajectories starting inside the set
% are then simulated to illustrate convergence (Fig. 3b).
%
% Requires: ../src (nn_forward, load_weights).

clear; clc; close all;
addpath('../src');

A = [-7 5; 6 1];
B = [1; 2];
C = [1 1];
Sigma2 = -1.276;
ybar   = 12.2;

W = load_weights('../weights');

% --- Lemma 3: positive left eigenvector of M = A + B*Sigma2*C -------------
M = A + B*Sigma2*C;
assert(all(M([2 3]) >= 0), 'M must be Metzler.');
assert(all(real(eig(M)) < 0), 'M must be Hurwitz.');

[Vec, D] = eig(M');
[~, idx] = max(real(diag(D)));       % dominant (least-negative) eigenvalue
v = abs(real(Vec(:, idx)));          % positive left eigenvector
ratio = min(v) / max(v);
bound = ratio * ybar;
fprintf('v = [%.4f, %.4f],  v_min/v_max = %.4f\n', v(1), v(2), ratio);
fprintf('Aizerman ROA:  C x0 <= %.3f\n', bound);

% --- simulate closed-loop trajectories from x0 with C x0 <= bound ---------
odefun = @(t, x) A*x + B*nn_forward(W, C*x);
tspan  = [0 10];

figure('Color', 'w'); hold on; grid on; box on;
% region boundary C x = bound in the first quadrant
fill([0 bound 0], [0 0 bound], [0.7 0.7 0.7], 'FaceAlpha', 0.4, 'EdgeColor', 'none', ...
     'DisplayName', 'ROA ($C x_0 \le b$)');

rng(0);
n_traj = 60; drawn = 0; first = true;
while drawn < n_traj
    x0 = 15 * rand(2, 1);            % candidate in the positive orthant
    if C*x0 > bound, continue; end
    [~, x] = ode45(odefun, tspan, x0);
    if first
        plot(x(:,1), x(:,2), 'b', 'LineWidth', 1.0, 'DisplayName', 'trajectories');
        first = false;
    else
        plot(x(:,1), x(:,2), 'b', 'LineWidth', 1.0, 'HandleVisibility', 'off');
    end
    plot(x0(1), x0(2), 'k*', 'HandleVisibility', 'off');
    drawn = drawn + 1;
end
plot(0, 0, 'ro', 'MarkerFaceColor', 'r', 'DisplayName', 'equilibrium');

xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', 20);
ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', 20);
legend('Interpreter', 'latex', 'FontSize', 14, 'Location', 'northeast');
title(sprintf('Local Aizerman ROA: $C x_0 \\le %.2f$', bound), 'Interpreter', 'latex');
