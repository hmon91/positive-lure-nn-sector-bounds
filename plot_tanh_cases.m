close all
clear

% Define range for plotting
nu = linspace(-3, 3, 500);

% Define tanh function
tanh_nu = tanh(nu)

% Set your positive nu values
nu_bar = 1.5;
nu_underline = 0.8;

% Compute slopes for dashed lines
slope_bar = tanh(nu_bar) / nu_bar;
slope_underline = tanh(nu_underline) / nu_underline;

% Generate lines passing through origin
line_bar = slope_bar * nu;
line_underline = slope_underline * nu;

% Plotting
figure;
hold on;
plot(nu, tanh_nu, 'b', 'LineWidth', 2);
plot(nu, line_bar, '--r', 'LineWidth', 1.5);
plot(nu, line_underline, '--g', 'LineWidth', 1.5);

% Highlight points
plot(nu_bar, tanh(nu_bar), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
plot(nu_underline, tanh(nu_underline), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');

% Add vertical dashed lines from nu_bar and nu_underline to tanh function
plot([nu_bar, nu_bar], [0, tanh(nu_bar)], '--k', 'LineWidth', 1.2);
plot([nu_underline, nu_underline], [0, tanh(nu_underline)], '--k', 'LineWidth', 1.2);

% Fill the sector bound region between \underline{\nu} and \bar{\nu} with transparency
nu_fill = linspace(nu_underline, nu_bar, 200);
fill([nu_fill, fliplr(nu_fill)], [slope_bar * nu_fill, fliplr(slope_underline * nu_fill)], 'y', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

% Axes limits
xlim([-3 3]);
ylim([-1.2 1.2]);

% Draw x and y axes
plot([-3, 3], [0, 0], 'k', 'LineWidth', 1.5); % X-axis
plot([0, 0], [-1.2, 1.2], 'k', 'LineWidth', 1.5); % Y-axis

% Add small triangle arrowheads at the ends of axes
fill([2.9, 3, 2.9], [-0.05, 0, 0.05], 'k', 'EdgeColor', 'k'); % X-axis arrow
fill([-0.05, 0, 0.05], [1.1, 1.2, 1.1], 'k', 'EdgeColor', 'k'); % Y-axis arrow

ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
ax.Box = 'off';
ax.XColor = 'k';
ax.YColor = 'k';
ax.TickLength = [0 0]; % Remove ticks
ax.XTickLabel = []; % Remove X-axis numbers
ax.YTickLabel = []; % Remove Y-axis numbers
ax.LineWidth = 1.2;
ax.TickDir = 'both';

% Label \bar{\nu} and \underline{\nu} correctly in LaTeX format
text(nu_bar, -0.1, '$\bar{\nu}$', 'FontSize', 17, 'HorizontalAlignment', 'center', 'Interpreter', 'latex');
text(nu_underline, -0.1, '$\underline{\nu}$', 'FontSize', 17, 'HorizontalAlignment', 'center', 'Interpreter', 'latex');

% Axes labels and grid
xlabel('$\nu$', 'FontSize', 17, 'Interpreter', 'latex');
ylabel('$\tanh(\nu)$', 'FontSize', 17, 'Interpreter', 'latex');
% title('tanh Function with Linear Dashed Lines', 'FontSize', 14);
grid on;
legend('$\tanh(\nu)$', '$\beta \nu$', '$\alpha \nu$', 'Location', 'southeast', ...
    'Interpreter', 'latex', 'Fontsize', 17);
hold off;
fig_name = strcat('posnu');
print(fig_name,'-dpng')
print(fig_name,'-depsc2')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define range for plotting
nu = linspace(-3, 3, 500);

% Define tanh function
tanh_nu = tanh(nu);

% Set your negative nu values
nu_bar = -1.5;
nu_underline = -0.8;

% Compute slopes for dashed lines
slope_bar = tanh(nu_bar) / nu_bar;
slope_underline = tanh(nu_underline) / nu_underline;

% Generate lines passing through origin
line_bar = slope_bar * nu;
line_underline = slope_underline * nu;

% Plotting
figure;
hold on;
plot(nu, tanh_nu, 'b', 'LineWidth', 2);
plot(nu, line_bar, '--r', 'LineWidth', 1.5);
plot(nu, line_underline, '--g', 'LineWidth', 1.5);

% Highlight points
plot(nu_bar, tanh(nu_bar), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
plot(nu_underline, tanh(nu_underline), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');

% Add vertical dashed lines from nu_bar and nu_underline to tanh function
plot([nu_bar, nu_bar], [0, tanh(nu_bar)], '--k', 'LineWidth', 1.2);
plot([nu_underline, nu_underline], [0, tanh(nu_underline)], '--k', 'LineWidth', 1.2);

% Fill the sector bound region between \underline{\nu} and \bar{\nu} with transparency
nu_fill = linspace(nu_underline, nu_bar, 200);
fill([nu_fill, fliplr(nu_fill)], [slope_bar * nu_fill, fliplr(slope_underline * nu_fill)], 'y', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

% Axes limits
xlim([-3 3]);
ylim([-1.2 1.2]);

% Draw x and y axes
plot([-3, 3], [0, 0], 'k', 'LineWidth', 1.5); % X-axis
plot([0, 0], [-1.2, 1.2], 'k', 'LineWidth', 1.5); % Y-axis

% Add small triangle arrowheads at the ends of axes
fill([2.9, 3, 2.9], [-0.05, 0, 0.05], 'k', 'EdgeColor', 'k'); % X-axis arrow
fill([-0.05, 0, 0.05], [1.1, 1.2, 1.1], 'k', 'EdgeColor', 'k'); % Y-axis arrow

ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
ax.Box = 'off';
ax.XColor = 'k';
ax.YColor = 'k';
ax.TickLength = [0 0]; % Remove ticks
ax.XTickLabel = []; % Remove X-axis numbers
ax.YTickLabel = []; % Remove Y-axis numbers
ax.LineWidth = 1.2;
ax.TickDir = 'both';

% Label \bar{\nu} and \underline{\nu} correctly in LaTeX format
text(nu_bar, 0.08, '$\underline{\nu}$', 'FontSize', 17, 'HorizontalAlignment', 'center', 'Interpreter', 'latex');
text(nu_underline, 0.08, '$\overline{\nu}$', 'FontSize', 17, 'HorizontalAlignment', 'center', 'Interpreter', 'latex');

% Axes labels and grid
xlabel('$\nu$', 'FontSize', 17, 'Interpreter', 'latex');
ylabel('$\tanh(\nu)$', 'FontSize', 17, 'Interpreter', 'latex');
% title('Negative Interval', 'FontSize', 14);
grid on;
legend('$\tanh(\nu)$', '$\beta \nu$', '$\alpha \nu$', 'Location', 'southeast', ...
    'Interpreter', 'latex', 'Fontsize', 17);
hold off;
fig_name = strcat('negnu');
print(fig_name,'-dpng')
print(fig_name,'-depsc2')

%%
% Define range for plotting
nu = linspace(-3, 3, 500);

% Define tanh function
tanh_nu = tanh(nu);

% Set one negative and one positive nu value
nu_bar = 1.5;
nu_underline = -0.8;

% Compute slopes for dashed lines
slope_bar = tanh(nu_bar) / nu_bar;
slope_underline = tanh(nu_underline) / nu_underline;

% Generate lines passing through origin for the required regions
nu_positive = linspace(0, nu_bar, 250);
nu_negative = linspace(nu_underline, 0, 250);
line_bar_positive = slope_bar * nu_positive;
line_underline_negative = slope_underline * nu_negative;
line_identity = nu; % y = x dashed line
line_identity_positive = nu_positive;
line_identity_negative = nu_negative;


% Plotting
figure;
hold on;
plot(nu, tanh_nu, 'b', 'LineWidth', 2);
plot(nu_positive, line_bar_positive, '--r', 'LineWidth', 1.5);
plot(nu_negative, line_underline_negative, '-.r', 'LineWidth', 1.5);
plot(nu_positive, line_identity_positive, '--g', 'LineWidth', 1.5); % y = x line in green
plot(nu_negative, line_identity_negative, '-.g', 'LineWidth', 1.5); % y = x line in green

% Highlight points
plot(nu_bar, tanh(nu_bar), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
plot(nu_underline, tanh(nu_underline), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');

% Add vertical dashed lines from nu_bar and nu_underline to tanh function
plot([nu_bar, nu_bar], [0, tanh(nu_bar)], '--k', 'LineWidth', 1.2);
plot([nu_underline, nu_underline], [0, tanh(nu_underline)], '--k', 'LineWidth', 1.2);

% Fill the sector bound region separately on positive and negative sides
fill([nu_positive, fliplr(nu_positive)], [line_bar_positive, fliplr(nu_positive)], 'y', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([nu_negative, fliplr(nu_negative)], [line_underline_negative, fliplr(nu_negative)], 'y', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

% Axes limits
xlim([-3 3]);
ylim([-1.2 1.2]);

% Draw x and y axes
plot([-3, 3], [0, 0], 'k', 'LineWidth', 1.5); % X-axis
plot([0, 0], [-1.2, 1.2], 'k', 'LineWidth', 1.5); % Y-axis

% Add small triangle arrowheads at the ends of axes
fill([2.9, 3, 2.9], [-0.05, 0, 0.05], 'k', 'EdgeColor', 'k'); % X-axis arrow
fill([-0.05, 0, 0.05], [1.1, 1.2, 1.1], 'k', 'EdgeColor', 'k'); % Y-axis arrow

ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
ax.Box = 'off';
ax.XColor = 'k';
ax.YColor = 'k';
ax.TickLength = [0 0]; % Remove ticks
ax.XTickLabel = []; % Remove X-axis numbers
ax.YTickLabel = []; % Remove Y-axis numbers
ax.LineWidth = 1.2;
ax.TickDir = 'both';

% Label \bar{\nu} and \underline{\nu} correctly in LaTeX format
text(nu_bar, -0.08, '$\bar{\nu}$', 'FontSize', 17, 'HorizontalAlignment', 'center', 'Interpreter', 'latex');
text(nu_underline, 0.08, '$\underline{\nu}$', 'FontSize', 17, 'HorizontalAlignment', 'center', 'Interpreter', 'latex');

% Axes labels and grid
xlabel('$\nu$', 'FontSize', 17, 'Interpreter', 'latex');
ylabel('$\tanh(\nu)$', 'FontSize', 17, 'Interpreter', 'latex');
% title('Unstable Node', 'FontSize', 14);
grid on;
legend('$\tanh(\nu)$', '$\beta_2 \nu$', '$\beta_1 \nu$', '$\alpha_2 \nu$', '$\alpha_1 \nu$', 'Location', 'southeast', ...
    'Interpreter', 'latex', 'Fontsize', 17);
hold off;
fig_name = strcat('unstablenode');
print(fig_name,'-dpng')
print(fig_name,'-depsc2')