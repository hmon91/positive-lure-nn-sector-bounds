function [Alpha, Beta, flag] = tanh_sector_slopes(v_lo, v_up)
%TANH_SECTOR_SLOPES  Linear sector slopes for tanh over a pre-activation box.
%
%   [Alpha, Beta, flag] = TANH_SECTOR_SLOPES(v_lo, v_up) returns, for each
%   neuron whose pre-activation lies in [v_lo(i), v_up(i)], the upper- and
%   lower-bounding slopes of a linear relaxation of tanh through the origin:
%
%       Beta(i,i) * v  <=  tanh(v)  <=  Alpha(i,i) * v      (see Eq. (26), Fig. 2)
%
%   Three cases are distinguished, following Fig. 2:
%     (a) Positive interval  (v_lo >= 0, v_up > 0):
%             upper slope Alpha = 1                 (tangent at the origin)
%             lower slope Beta  = tanh(v_up)/v_up   (chord to the far end)
%     (b) Negative interval  (v_lo < 0, v_up <= 0):
%             upper slope Alpha = tanh(v_lo)/v_lo
%             lower slope Beta  = 1
%     (c) Sign-changing interval (v_lo < 0 < v_up):
%             Alpha = Beta = 1 and flag(i) = true. The origin-fixed slope of 1
%             is applied to |v| in LOCAL_SECTOR_BOUND (Eqs. (28)-(29)).
%
%   Fixing the upper slope at the origin (design choice (iii) in Sec. V) rather
%   than at the interval boundary keeps fidelity near the equilibrium and
%   avoids per-boundary derivative evaluations.
%
%   Inputs
%       v_lo, v_up : n-by-1 lower/upper pre-activation bounds
%
%   Outputs
%       Alpha, Beta : n-by-n diagonal matrices of upper/lower slopes
%       flag        : n-by-1 logical, true for sign-changing neurons
%
%   See also COMPUTE_BOUNDS, LOCAL_SECTOR_BOUND.

    v_lo = v_lo(:);
    v_up = v_up(:);
    n = numel(v_lo);

    a    = zeros(n, 1);   % upper slope
    b    = zeros(n, 1);   % lower slope
    flag = false(n, 1);

    for i = 1:n
        if v_lo(i) * v_up(i) < 0            % (c) interval crosses zero
            a(i) = 1;
            b(i) = 1;
            flag(i) = true;
        elseif v_up(i) > 0                  % (a) nonnegative interval
            a(i) = 1;
            b(i) = tanh(v_up(i)) / v_up(i);
        elseif v_lo(i) < 0                  % (b) nonpositive interval
            a(i) = tanh(v_lo(i)) / v_lo(i);
            b(i) = 1;
        else                               % degenerate interval [0,0]
            a(i) = 1;
            b(i) = 1;
        end
    end

    Alpha = diag(a);
    Beta  = diag(b);
end
