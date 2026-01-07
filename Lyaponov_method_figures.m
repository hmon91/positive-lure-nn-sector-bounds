% Clear workspace and command window
clear; clc; 
% close all

% System Parameters
A = [-7 5; 6 1];
B = [1; 2];
C = [1 1];

contourvalues = [6 15 32];

W1 = load('W1n.csv');
W2 = load('W2n.csv');
W3 = load('W3n.csv');

% Define sector bounds Sigma1 and Sigma2
Sigma1 = -3;  % Lower bound of the sector
Sigma2 = -1.276;  % Upper bound of the sector

% Define decision variables
P = sdpvar(size(A,1), size(A,1));

% Constraints
Constraints = [P >= 0, P(:)>=0, (A + B*Sigma1*C)'*P + P*(A + B*Sigma1*C) <= 0, (A + B*Sigma2*C)'*P + P*(A + B*Sigma2*C) <= 0];
% Constraints = [P >= 0, P(:)>=0, (A + B*Sigma2*C)'*P + P*(A + B*Sigma2*C) <= 0];

% Options for solver
options = sdpsettings('solver', 'sedumi', 'verbose', 1);

% Solve the LMIs
sol = optimize(Constraints, [], options);

% Check if the solution is feasible
if sol.problem == 0
    disp('Feasible solution found.');
    P_value = value(P)
    Q1_value = value((A + B*Sigma1*C)'*P + P*(A + B*Sigma1*C))
    Q2_value = value((A + B*Sigma2*C)'*P + P*(A + B*Sigma2*C))
else
    disp('No feasible solution found. The system may not be locally stable within the specified sector bounds.');
    disp(sol.info);
    return;
end

% Define a grid of points within a reasonable range
[x1, x2] = meshgrid(0:0.01:18, 0:0.01:14);
num_points = numel(x1);
V_dot = zeros(size(x1));
V = zeros(size(x1));
V_condition1 = zeros(size(x1));
V_condition2 = zeros(size(x1));

for i = 1:num_points
    x = [x1(i); x2(i)];

    % Compute V(x)
    V(i) = x' * P_value * x;
    
    % Compute u(x) based on sector bounds (we'll use the midpoint)
    % Sigma_mid = (Sigma1 + Sigma2) / 2;
    % u = Sigma_mid * C * x;
    u = NN(W1,W2,W3,C*x);
    
    % Compute x_dot
    x_dot = A * x + B * u;
    
    % Compute V_dot(x)
    V_dot(i) = x' * P_value * x_dot + x_dot' * P_value * x;
    % x' * P * (Ax + Bu) + (x'A' + u'B') * P * x = x'PAx+x'PBu + x'A'Px+u'B'Px = x'(PA+A'P)x+2x'PBu
    V_condition1(i) = x' * Q1_value * x;
    V_condition2(i) = x' * Q2_value * x;
end
region_V_dot_negative = (V_dot <= 0);

% % Plot Region 1: V_dot < 0
% figure;
% contourf(x1, x2, double(region_V_dot_negative), 'LineColor', 'none');
% xlabel('x_1');
% ylabel('x_2');
% title('Region where V_{dot} < 0');
% % colorbar;
% axis equal;
% hold on
% % Plot level set V(x) = rho
% % figure
% contour(x1, x2, V,contourvalues,'black','ShowText','on');
% legend('Negative Vdot','V Contours/Sublevel sets');


%% Enhanced Plotting Section with Red/Blue V̇ Regions
figure;
hold on;

% Region codes:
% 0 = neutral (unused here)
% 1 = V̇ < 0 → light blue
% 2 = V̇ > 0 → light red
region_mask = zeros(size(V_dot));
region_mask(V_dot <= 0) = 1;
region_mask(V_dot >  0) = 2;

% Plot using custom colormap
contourf(x1, x2, region_mask, [0 1 2], 'LineColor', 'none');
colormap([1 1 1; 0.6 0.8 1; 1 0.8 0.8]);  % white, blue, red
caxis([0 2]);
alpha(0.5);

% Overlay sublevel sets of V(x)
[C, h] = contour(x1, x2, V, contourvalues, 'k');
h.LineWidth = 1.4;
clabel(C, h, 'FontSize', 14, 'Interpreter', 'latex');


% Labels and formatting
xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', 24);
ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', 24);
% title('Regions where $\dot{V}(x) \lessgtr 0$ with $V(x)$ Sublevel Sets', ...
%     'Interpreter', 'latex', 'FontSize', 16);

% Custom legend patches
patchBlue = patch(NaN, NaN, [0.6 0.8 1], 'DisplayName', '$\dot{V}(x) < 0$');
patchRed = patch(NaN, NaN, [1 0.8 0.8], 'DisplayName', '$\dot{V}(x) > 0$');
plot(NaN, NaN, 'k', 'LineWidth', 1.4, 'DisplayName', '$V(x)$ level sets');
legend([patchBlue, patchRed], {'$\dot{V}(x) < 0$', '$\dot{V}(x) > 0$'}, ...
    'Interpreter', 'latex', 'FontSize', 30, 'Location', 'northeast');
legend boxoff;


% Final touch
grid on;
box on;
axis equal tight;

% Optional export
% set(gcf, 'Units', 'inches', 'Position', [0, 0, 6.5, 5.5]);  % Width x Height in inches
% set(gcf, 'PaperUnits', 'inches');
% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperPosition', [0 0 6.5 5.5]);  % Same as figure dimensions
% print(gcf, 'Vdotregions', '-depsc2', '-painters');
% exportgraphics(gcf, 'vdotregions.eps', 'ContentType', 'vector');



% % clc
% % clear
% % close all
% 
% A = [-7 5; 6 1];
% B = [1; 2];
% C = [1 1];
% 
% W1 = load('W1n.csv');
% W2 = load('W2n.csv');
% W3 = load('W3n.csv');
% 
% % P = [0.1235 0.1323; 0.1323 0.3919];
% rho = 115;
% 
% tspan = [0 10];
% num_trajectories = 500;
% valid_x0s = [];
% trajectories = {};
% 
% while length(valid_x0s) < num_trajectories
%     x0_candidate = abs(20 * (2 * rand(size(A,1),1) - 1));
%     if x0_candidate' * P * x0_candidate < rho
%         valid_x0s = [valid_x0s, x0_candidate];
%     end
% end
% 
% fig = figure('Color', 'w');  % White background
% hold on;
% 
% % Shaded ROA region
% theta = linspace(0, 2*pi, 300);
% [x_ellipse, y_ellipse] = deal(zeros(1, length(theta)));
% for i = 1:length(theta)
%     dir = [cos(theta(i)); sin(theta(i))];
%     scale = sqrt(rho / (dir' * P * dir));
%     point = scale * dir;
%     x_ellipse(i) = point(1);
%     y_ellipse(i) = point(2);
% end
% fill(x_ellipse, y_ellipse, [0.7 0.7 0.7], ...
%     'FaceAlpha', 0.5, 'EdgeColor', 'none', ...
%     'DisplayName', 'ROA');
% 
% % Initial conditions
% plot(valid_x0s(1,:), valid_x0s(2,:), 'k*', ...
%     'LineWidth', 1.2, 'DisplayName', '$x_0$');
% 
% % Trajectories
% for i = 1:num_trajectories
%     x0 = valid_x0s(:,i);
%     global output_history
%     output_history = zeros(1+size(B,2)+size(C,1),1);
%     f = @(t, x) A * x + B * NNcontrol(W1, W2, W3, C * x, t);
%     [~, x] = ode45(f, tspan, x0);
%     trajectories{i} = x;
% 
%     if i == 1
%         % First trajectory shows in legend
%         plot(x(:,1), x(:,2), 'b', 'LineWidth', 1.2, ...
%             'DisplayName', 'Trajectories');
%     else
%         plot(x(:,1), x(:,2), 'b', 'LineWidth', 1.2, ...
%             'HandleVisibility', 'off');
%     end
% end
% 
% % Labels and grid
% xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', 24);
% ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', 24);
% xlim([0 17]);
% ylim([0 9]);
% grid on;
% box on;
% 
% % Legend
% legend('FontSize', 20, 'Interpreter', 'latex', 'Location', 'northeast');
% % axis equal tight;
% % % Save
% set(gcf, 'Units', 'inches', 'Position', [0, 0, 6.5, 6.5]);  % Width x Height in inches
% set(gcf, 'PaperUnits', 'inches');
% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperPosition', [0 0 6.5 6]);  % Same as figure dimensions
% print(gcf, 'Fig7', '-depsc2', '-painters');
% 
% % print(gcf, 'Fig7', '-depsc2', '-painters');
% % print(gcf, 'Fig7', '-depsc');
% % exportgraphics(gcf, 'Fig7.eps', 'ContentType', 'vector');
C=[1 1];


%% NN Controller
function control_input = NNcontrol(W1,W2,W3,yminus,t)
    global output_history
    v1 = W1*yminus;
    w1 = tanh(v1);
    v2 = W2*w1;
    w2 = tanh(v2);
    v3 = W3*w2;
    control_input = v3;
    output_data = [t; control_input; yminus];
    output_history = [output_history output_data];
end

%% Local Functions
function NNoutput = NN(W1, W2, W3, z)
    v_1 = W1*z;
    w_1 = tanh(v_1);
    v_2 = W2*w_1;
    w_2 = tanh(v_2);
    v_3 = W3*w_2;
    NNoutput = v_3;
end

