function u = nn_forward(W, y)
%NN_FORWARD  Forward pass of a bias-free feedforward tanh network.
%
%   u = NN_FORWARD(W, y) evaluates the network
%
%       w0      = y
%       v_i     = W{i} * w_{i-1}      (pre-activation of layer i)
%       w_i     = tanh(v_i)           for i = 1 .. L-1  (hidden layers)
%       u       = W{L} * w_{L-1}      (linear output layer, no activation)
%
%   corresponding to Eq. (16) of the paper. The network has no biases and a
%   linear output layer, exactly as used for the NN controller Phi(y) = NN(y).
%
%   Inputs
%       W : 1-by-L cell array of weight matrices {W1, ..., WL}
%       y : n0-by-1 input vector (the plant output y = C*x). y may also be a
%           1-by-N row of scalar inputs when the network is single-input, in
%           which case u is returned as a 1-by-N row (batched evaluation).
%
%   Output
%       u : network output (control input). m-by-1, or m-by-N when batched.
%
%   Example
%       W  = load_weights('../weights');
%       u  = nn_forward(W, [1;1]*2);
%
%   See also LOCAL_SECTOR_BOUND.

    w = y;
    for i = 1:numel(W)-1
        w = tanh(W{i} * w);
    end
    u = W{end} * w;
end
