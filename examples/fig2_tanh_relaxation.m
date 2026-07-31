% FIG2_TANH_RELAXATION
% Reproduces Fig. 2: linear relaxation of phi = tanh(nu) over a pre-activation
% interval [nu_lo, nu_up] for the three cases used in Theorem 4:
%   (a) positive interval, (b) negative interval, (c) sign-changing interval.
% The shaded band is the sector used by the sector-bound propagation. For the
% sign-changing case the origin-anchored slope of 1 gives the envelope
% -|nu| <= tanh(nu) <= |nu|  (Eqs. (28)-(29)); the other two cases give
% beta*nu <= tanh(nu) <= alpha*nu produced by TANH_SECTOR_SLOPES.
%
% Requires: ../src on the path (tanh_sector_slopes).

clear; clc; close all;
addpath('../src');

cases = {
    'positive',       0.8,  1.5;
    'negative',      -1.5, -0.8;
    'sign-changing', -1.2,  1.8
};

nu = linspace(-3, 3, 500);

for c = 1:size(cases, 1)
    name  = cases{c, 1};
    nu_lo = cases{c, 2};
    nu_up = cases{c, 3};

    [Alpha, Beta, flag] = tanh_sector_slopes(nu_lo, nu_up);
    a = Alpha(1, 1);   % upper slope
    b = Beta(1, 1);    % lower slope

    if flag                          % (c) sign-changing: envelope -|nu| .. |nu|
        upper =  a * abs(nu);
        lower = -a * abs(nu);
        up_lbl = '$|\alpha|\,|\nu|$'; lo_lbl = '$-|\alpha|\,|\nu|$';
    else                             % (a)/(b): alpha*nu .. beta*nu
        upper = a * nu;
        lower = b * nu;
        up_lbl = '$\alpha\nu$'; lo_lbl = '$\beta\nu$';
    end

    figure('Color', 'w'); hold on; grid on;
    nf  = linspace(nu_lo, nu_up, 200);
    if flag
        fill([nf, fliplr(nf)], [a*abs(nf), fliplr(-a*abs(nf))], 'y', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    else
        fill([nf, fliplr(nf)], [b*nf, fliplr(a*nf)], 'y', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    end
    plot(nu, tanh(nu), 'b',   'LineWidth', 2);
    plot(nu, upper,    'r--', 'LineWidth', 1.5);
    plot(nu, lower,    'g--', 'LineWidth', 1.5);
    plot([nu_lo nu_lo], [0, tanh(nu_lo)], '--k', 'LineWidth', 1.0);
    plot([nu_up nu_up], [0, tanh(nu_up)], '--k', 'LineWidth', 1.0);

    xlim([-3 3]); ylim([-1.2 1.2]);
    ax = gca; ax.XAxisLocation = 'origin'; ax.YAxisLocation = 'origin'; ax.Box = 'off';
    xlabel('$\nu$', 'Interpreter', 'latex', 'FontSize', 16);
    ylabel('$\tanh(\nu)$', 'Interpreter', 'latex', 'FontSize', 16);
    title(sprintf('%s interval', name), 'Interpreter', 'latex');
    legend({'sector', '$\tanh(\nu)$', up_lbl, lo_lbl}, ...
           'Interpreter', 'latex', 'Location', 'southeast', 'FontSize', 14);
end
