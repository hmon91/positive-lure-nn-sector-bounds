function W = load_weights(folder)
%LOAD_WEIGHTS  Load the trained NN controller weights W1, W2, W3.
%
%   W = LOAD_WEIGHTS(folder) reads W1.csv, W2.csv, W3.csv from the given folder
%   and returns them as the cell array W = {W1, W2, W3} expected by
%   NN_FORWARD and LOCAL_SECTOR_BOUND. If FOLDER is omitted, 'weights' relative
%   to the current directory is used.
%
%   The shipped weights define the 1-10-10-1 tanh controller from the paper's
%   numerical example (single input y = C*x, scalar output u).
%
%   Example
%       W = load_weights('../weights');
%
%   See also NN_FORWARD, LOCAL_SECTOR_BOUND.

    if nargin < 1 || isempty(folder)
        folder = 'weights';
    end

    W1 = load(fullfile(folder, 'W1.csv'));   % 10 x 1
    W2 = load(fullfile(folder, 'W2.csv'));   % 10 x 10
    W3 = load(fullfile(folder, 'W3.csv'));   % 1  x 10

    % load() returns a column for a single-row/column csv; make orientation explicit
    if isvector(W1); W1 = W1(:);   end   % 10 x 1  (input dimension 1)
    if isvector(W3); W3 = W3(:).'; end   % 1  x 10 (output dimension 1)

    W = {W1, W2, W3};
end
