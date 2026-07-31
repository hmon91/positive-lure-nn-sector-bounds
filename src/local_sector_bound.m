function [gamma1, gamma2] = local_sector_bound(W, x_lo, x_hi)
%LOCAL_SECTOR_BOUND  Tight local sector bound of a tanh FFNN (Theorem 4).
%
%   [gamma1, gamma2] = LOCAL_SECTOR_BOUND(W, x_lo, x_hi) computes slope
%   matrices gamma1, gamma2 such that the network output is sector bounded,
%
%       gamma1 * y  <=  NN(y)  <=  gamma2 * y ,   for all y in [x_lo, x_hi],
%
%   with y restricted to the nonnegative orthant (positive-system setting).
%   This implements the layer-wise propagation of Section V (Eqs. (17)-(33)):
%   pre-activation intervals are obtained by interval arithmetic, each tanh is
%   relaxed by an origin-anchored linear sector, and the resulting slope
%   matrices are propagated through the weights using the (W+, W-) split.
%
%   The routine is written for a general L-layer bias-free network with tanh
%   hidden activations and a linear output layer (Eq. (16)); for the paper's
%   1-10-10-1 controller it returns the scalar bounds [gamma1, gamma2] with
%   gamma1 = L^{(q+1)} * prod_i D_low^{(i)} Lhat^{(i)} * W1 and gamma2 the
%   analogous product (Eq. (33)).
%
%   Inputs
%       W     : 1-by-L cell array {W1, ..., WL} of weight matrices
%       x_lo  : n0-by-1 lower bounds on the input y   (assumed >= 0)
%       x_hi  : n0-by-1 upper bounds on the input y   (assumed >= x_lo)
%
%   Outputs
%       gamma1, gamma2 : m-by-n0 lower / upper sector-slope matrices
%
%   Example
%       W = load_weights('../weights');
%       [g1, g2] = local_sector_bound(W, 0, 12.2);   % scalar input y in [0,12.2]
%
%   See also COMPUTE_BOUNDS, TANH_SECTOR_SLOPES, NN_FORWARD.

    % Layer-1 pre-activation v1 = W1*y is linear, hence trivially sector bounded
    % with lower = upper slope matrix equal to W1 (Eq. (17)).
    Lpre = W{1};
    Upre = W{1};
    [v_lo, v_hi] = compute_bounds(W{1}, x_lo, x_hi);

    for i = 1:numel(W) - 1
        % --- relax the tanh of the current hidden layer (Eqs. (26)-(31)) ---
        [Alpha, Beta, flag] = tanh_sector_slopes(v_lo, v_hi);

        Upost = Alpha * Upre;                 % upper post-activation slopes
        Lpost = Beta  * Lpre;                 % lower post-activation slopes
        Upost(flag, :) =  abs(Upost(flag, :)); % sign-changing rows -> |.| (Eq. 29)
        Lpost(flag, :) = -abs(Lpost(flag, :));

        % numeric post-activation range feeds the next interval computation
        w_lo = tanh(v_lo);
        w_hi = tanh(v_hi);

        % --- propagate slopes through the next weight matrix (Eq. (32)) ---
        Wnext = W{i + 1};
        Wp = max(Wnext, 0);
        Wm = min(Wnext, 0);
        Upre = Wp * Upost + Wm * Lpost;
        Lpre = Wp * Lpost + Wm * Upost;

        % next pre-activation interval
        [v_lo, v_hi] = compute_bounds(Wnext, w_lo, w_hi);
    end

    % Output layer is linear: its pre-activation slope matrices are the answer.
    gamma1 = Lpre;
    gamma2 = Upre;
end
