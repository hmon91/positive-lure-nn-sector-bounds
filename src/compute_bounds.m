function [L, U] = compute_bounds(W, x_min, x_max)
%COMPUTE_BOUNDS  Elementwise interval bounds of the linear map W*x.
%
%   [L, U] = COMPUTE_BOUNDS(W, x_min, x_max) returns the tightest elementwise
%   lower (L) and upper (U) bounds of W*x given that each component satisfies
%   x_i in [x_min(i), x_max(i)]. This is the standard interval-arithmetic
%   propagation used to obtain the pre-activation logit intervals in
%   Eqs. (18)-(23) of the paper.
%
%   For each entry w_ji of W:
%       - if w_ji >= 0 : contributes w_ji*x_min(i) to L, w_ji*x_max(i) to U
%       - if w_ji <  0 : contributes w_ji*x_max(i) to L, w_ji*x_min(i) to U
%
%   Inputs
%       W      : m-by-n weight matrix
%       x_min  : n-by-1 (or scalar) lower bounds of x
%       x_max  : n-by-1 (or scalar) upper bounds of x
%
%   Outputs
%       L, U   : m-by-1 elementwise lower/upper bounds of W*x
%
%   See also LOCAL_SECTOR_BOUND, TANH_SECTOR_SLOPES.

    x_min = x_min(:);
    x_max = x_max(:);

    Wpos = (W >= 0);
    Wneg = (W <  0);

    minMatrix = Wpos .* (W .* x_min') + Wneg .* (W .* x_max');
    L = sum(minMatrix, 2);

    maxMatrix = Wpos .* (W .* x_max') + Wneg .* (W .* x_min');
    U = sum(maxMatrix, 2);
end
