clc
clear
close all

A = [-7 5; 6 1];
B = [1; 2];
C = [1 1];

W1 = load('W1n.csv');
W2 = load('W2n.csv');
W3 = load('W3n.csv');

% P = [0.1235 0.1323; 0.1323 0.3919];

P =[0.4339    0.8152;0.8152    2.0583];
rho = 115;

tspan = [0 10];
num_trajectories = 500;
valid_x0s = [];
trajectories = {};

while length(valid_x0s) < num_trajectories
    x0_candidate = abs(20 * (2 * rand(size(A,1),1) - 1));
    if x0_candidate' * P * x0_candidate < rho
        valid_x0s = [valid_x0s, x0_candidate];
    end
end

fig = figure('Color', 'w');  % White background
hold on;

% Shaded ROA region
theta = linspace(0, 2*pi, 300);
[x_ellipse, y_ellipse] = deal(zeros(1, length(theta)));
for i = 1:length(theta)
    dir = [cos(theta(i)); sin(theta(i))];
    scale = sqrt(rho / (dir' * P * dir));
    point = scale * dir;
    x_ellipse(i) = point(1);
    y_ellipse(i) = point(2);
end
fill(x_ellipse, y_ellipse, [0.7 0.7 0.7], ...
    'FaceAlpha', 0.5, 'EdgeColor', 'none', ...
    'DisplayName', 'ROA');

% Initial conditions
plot(valid_x0s(1,:), valid_x0s(2,:), 'k*', ...
    'LineWidth', 1.2, 'DisplayName', '$x_0$');

% Trajectories
for i = 1:num_trajectories
    x0 = valid_x0s(:,i);
    global output_history
    output_history = zeros(1+size(B,2)+size(C,1),1);
    f = @(t, x) A * x + B * NNcontrol(W1, W2, W3, C * x, t);
    [~, x] = ode45(f, tspan, x0);
    trajectories{i} = x;

    if i == 1
        % First trajectory shows in legend
        plot(x(:,1), x(:,2), 'b', 'LineWidth', 1.2, ...
            'DisplayName', 'Trajectories');
    else
        plot(x(:,1), x(:,2), 'b', 'LineWidth', 1.2, ...
            'HandleVisibility', 'off');
    end
end

% Labels and grid
xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', 24);
ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', 24);
xlim([0 17]);
ylim([0 8]);
grid on;
box on;

% Legend
legend('FontSize', 20, 'Interpreter', 'latex', 'Location', 'northeast');
% axis equal tight;
% % Save
% set(gcf, 'Units', 'inches', 'Position', [0, 0, 6.5, 6.5]);  % Width x Height in inches
% set(gcf, 'PaperUnits', 'inches');
% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperPosition', [0 0 6.5 6]);  % Same as figure dimensions
print(gcf, 'Fig7', '-depsc2', '-painters');

% print(gcf, 'Fig7', '-depsc2', '-painters');
% print(gcf, 'Fig7', '-depsc');
% exportgraphics(gcf, 'Fig7.eps', 'ContentType', 'vector');


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
