% FIG4_LYAPUNOV_ROA
% Section IV / Algorithm 1: quadratic Lyapunov (LMI) method for ROA estimation.
%
%   1. Solve the LMI (10) for a doubly positive P certifying local stability
%      under the sector [Sigma1, Sigma2].
%   2. Evaluate Vdot(x) = 2 x' P (A x + B*NN(Cx)) on a grid and shade the
%      region where Vdot < 0 (Fig. 4a).
%   3. Grow the sublevel set { x >= 0 : x'Px <= rho } and keep the largest rho
%      whose first-quadrant boundary satisfies Vdot < 0 (Algorithm 1); overlay
%      its level curve. For the shipped controller this recovers rho ~ 32.
%
% Requires: YALMIP + an SDP solver (e.g. SeDuMi/SDPT3) on the MATLAB path, and
%           ../src (nn_forward, load_weights).  https://yalmip.github.io

clear; clc; close all;
addpath('../src');

% --- plant and sector -----------------------------------------------------
A = [-7 5; 6 1];
B = [1; 2];
C = [1 1];
Sigma1 = -3;        % A + B*Sigma1*C Metzler
Sigma2 = -1.276;    % A + B*Sigma2*C Hurwitz

W = load_weights('../weights');

% --- solve the LMI (10) for a doubly positive P ---------------------------
P = sdpvar(size(A,1), size(A,1));
F = [ P >= 0, P(:) >= 0, ...
      (A + B*Sigma1*C)'*P + P*(A + B*Sigma1*C) <= 0, ...
      (A + B*Sigma2*C)'*P + P*(A + B*Sigma2*C) <= 0 ];
sol = optimize(F, [], sdpsettings('solver', '', 'verbose', 0));
assert(sol.problem == 0, 'LMI infeasible: %s', sol.info);
P = value(P);
fprintf('Lyapunov matrix P =\n'); disp(P);

% --- Vdot over a grid in the positive orthant -----------------------------
[x1, x2] = meshgrid(0:0.02:18, 0:0.02:14);
V    = zeros(size(x1));
Vdot = zeros(size(x1));
for k = 1:numel(x1)
    x = [x1(k); x2(k)];
    u = nn_forward(W, C*x);
    xdot = A*x + B*u;
    V(k)    = x'*P*x;
    Vdot(k) = 2 * x'*P*xdot;
end

% --- Algorithm 1: largest invariant sublevel rho (first-quadrant boundary) -
theta = linspace(0, pi/2, 400);
rho_max = 0;
for rho = 1:1:200
    ok = true;
    for th = theta
        d = [cos(th); sin(th)];
        x = sqrt(rho / (d'*P*d)) * d;                 % boundary point, x'Px = rho
        if 2 * x'*P*(A*x + B*nn_forward(W, C*x)) >= 0
            ok = false; break;
        end
    end
    if ok, rho_max = rho; else, break; end
end
fprintf('Largest certified invariant sublevel: rho = %g\n', rho_max);

% --- plot Fig. 4a ---------------------------------------------------------
figure('Color', 'w'); hold on; box on;
mask = zeros(size(Vdot)); mask(Vdot <= 0) = 1; mask(Vdot > 0) = 2;
contourf(x1, x2, mask, [0 1 2], 'LineColor', 'none');
colormap([1 1 1; 0.6 0.8 1; 1 0.8 0.8]);     % white/unused, blue: Vdot<0, red: Vdot>0
caxis([0 2]); alpha(0.5);
[cc, hh] = contour(x1, x2, V, unique([6 15 rho_max]), 'k');
hh.LineWidth = 1.4; clabel(cc, hh, 'FontSize', 12);
xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', 20);
ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', 20);
pB = patch(NaN, NaN, [0.6 0.8 1], 'DisplayName', '$\dot{V}(x) < 0$');
pR = patch(NaN, NaN, [1 0.8 0.8], 'DisplayName', '$\dot{V}(x) > 0$');
legend([pB pR], 'Interpreter', 'latex', 'FontSize', 14, 'Location', 'northeast');
title(sprintf('$\\dot V$ sign and ROA sublevel $x^\\top P x \\le %g$', rho_max), ...
      'Interpreter', 'latex');
