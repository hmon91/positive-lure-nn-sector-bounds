% FIG6_ROA_COMPARISON
% Reproduces Fig. 6b: overlay of the ROA estimates produced by the three
% methods on the numerical example (Table I), all in the positive orthant:
%
%   - Lyapunov (LMI)         : x' P_lm x <= 32
%   - IQC-based [Yin et al.] : x' P_qc x <= 1
%   - Local Aizerman (Lem.3) : C x <= 5.12   (linear underapproximation)
%
% Self-contained: the certificate matrices are the values reported in the paper.

clear; clc; close all;

C    = [1, 1];
P_lm = [0.1235, 0.1323; 0.1323, 0.3919];   % Lyapunov LMI certificate
P_qc = [0.1675, -0.0224; -0.0224, 0.0668]; % IQC certificate [4]
aiz  = 5.12;                               % local Aizerman linear bound

x1 = linspace(0, 18, 400);
x2 = linspace(0, 10, 400);
[X1, X2] = meshgrid(x1, x2);

V_lm = P_lm(1,1)*X1.^2 + 2*P_lm(1,2)*X1.*X2 + P_lm(2,2)*X2.^2;
V_qc = P_qc(1,1)*X1.^2 + 2*P_qc(1,2)*X1.*X2 + P_qc(2,2)*X2.^2;
lin  = C(1)*X1 + C(2)*X2;

figure('Color', 'w'); hold on; grid on; box on;
contour(X1, X2, V_lm, [32 32],  'r', 'LineWidth', 2);
contour(X1, X2, V_qc, [1 1],    'b', 'LineWidth', 2);
contour(X1, X2, lin,  [aiz aiz],'g', 'LineWidth', 2);

xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', 16);
legend({'Lyapunov ($x^\top P_{lm} x \le 32$)', ...
        'IQC ($x^\top P_{qc} x \le 1$)', ...
        'Local Aizerman ($C x \le 5.12$)'}, ...
        'Interpreter', 'latex', 'Location', 'northeast', 'FontSize', 12);
title('Comparison of ROA estimates', 'Interpreter', 'latex', 'FontSize', 15);
axis square;
