clear
clc
close all
x0l = 0; x0u = 6;
x = linspace(x0l,x0u,100);
% xmax = max(x);
% xmin = min(x);
% plot(x,0,'.k')
% grid on

W1 = load('W1n.csv');
W2 = load('W2n.csv');
W3 = load('W3n.csv');
% W1=W1';
% W2=W2';
% W3=W3';

n0 = size(x0l,1);
n1 = size(W1,1);
n2 = size(W2,1);
n3 = size(W3,1);

% W1 = 4 * rand(size(W1)) - 2;
% W2 = 4 * rand(size(W2)) - 2;
% W3 = 4 * rand(size(W3)) - 2;
b1 = zeros(n1,1);
b2 = zeros(n2,1);
b3 = zeros(n3,1);

%% Nominal Path Output
v1 = W1*x;
w1 = tanh(v1);
v2 = W2*w1;
w2 = tanh(v2);
v3 = W3*w2;


minv2 = min(v2,[],2);
maxv2 = max(v2,[],2);
realrangev2 = [minv2,maxv2];

%% End Points
% v1end1 = W1*xmax;
% w1end1 = tanh(v1end1);
% v2end1 = (W2*w1end1)'
% (max(v2,[],2))'
% 
% 
% v1end2 = W1*xmin;
% w1end2 = tanh(v1end2);
% v2end2 = (W2*w1end2)'
% (min(v2,[],2))'

 %% finding the range of v1 by interval
% 
%  [v1l,v1u] = compute_bounds_bias(W1,b1,x0l,x0u);
% 
% w1l = tanh(v1l);
% w1u = tanh(v1u);
% 
% [v2l,v2u] = compute_bounds_bias(W2,b2,w1l,w1u);

%% Finding the Preactivation Bounds
[Lowerv1, Upperv1] = compute_bounds(W1,x0l,x0u);

Lowerw1 = tanh(Lowerv1);
Upperw1 = tanh(Upperv1);

[Lowerv2, Upperv2] = compute_bounds(W2,Lowerw1,Upperw1);

Lowerw2 = tanh(Lowerv2);
Upperw2 = tanh(Upperv2);

[Lowerv3, Upperv3] = compute_bounds(W3,Lowerw2,Upperw2);

%% Hamidreza's Local Sector Bound
v1lowerbound= W1*x;
v1upperbound = W1*x;


[Alpha1,Beta1,Flag1] = tanhbounds(Lowerv1,Upperv1);
upperbound1matrix = Alpha1*W1;
lowerbound1matrix = Beta1*W1;
upperbound1matrix = replace_rows_with_abs(Flag1,upperbound1matrix);
lowerbound1matrix = replace_rows_with_minus_abs(Flag1,lowerbound1matrix);
upperbound1 = upperbound1matrix * x;
lowerbound1 = lowerbound1matrix * x;


W2_plus  = max(W2, 0);
W2_minus = min(W2, 0);
upperbound2matrix = (W2_plus * Alpha1 * W1 + W2_minus * Beta1 * W1);
lowerbound2matrix = (W2_plus * Beta1 * W1 + W2_minus * Alpha1 * W1);
upperbound2 = upperbound2matrix * x;
lowerbound2 = lowerbound2matrix * x;


[Alpha2,Beta2,Flag2] = tanhbounds(Lowerv2,Upperv2);
upperbound3matrix = Alpha2 * (W2_plus * Alpha1 * W1 + W2_minus * Beta1 * W1);
lowerbound3matrix = Beta2 * (W2_plus * Beta1 * W1 + W2_minus * Alpha1 * W1);
upperbound3matrix = replace_rows_with_abs(Flag2,upperbound3matrix);
lowerbound3matrix = replace_rows_with_minus_abs(Flag2,lowerbound3matrix);
upperbound3 = upperbound3matrix * x;
lowerbound3 = lowerbound3matrix * x;


W3_plus  = max(W3, 0);
W3_minus = min(W3, 0);
upperbound4matrix = (W3_plus * upperbound3matrix + W3_minus * lowerbound3matrix);
lowerbound4matrix = (W3_plus * lowerbound3matrix + W3_minus * upperbound3matrix);

upperbound4 = upperbound4matrix * x;
lowerbound4 = lowerbound4matrix * x;

% globalupperbound=abs(W3)*abs(W2)*abs(W1)*x;
% globallowerbound=-abs(W3)*abs(W2)*abs(W1)*x;

localsec = [lowerbound4matrix,upperbound4matrix]
globalsec = [-abs(W3)*abs(W2)*abs(W1),abs(W3)*abs(W2)*abs(W1)];
%% Plots
for i = 1:n3
    figure
    hold on
    grid on
    plot(x,v3(i,:), 'k')
    plot(x,lowerbound4(i,:), 'b')
    plot(x,upperbound4(i,:), 'r')
    % plot(x,globallowerbound(i,:), 'g')
    % plot(x,globalupperbound(i,:), 'y')
    title(sprintf('The %dth entry of vector W3*tanh(W2*tanh(v1))', i))
    hold off
end
% %
% % grid on
% % for i = 1:n2
% %     figure
% %     hold on
% %     grid on
% %     plot(x,v2(i,:), 'k')
% %     plot(x,lowerbound2(i,:), 'b')
% %     plot(x,upperbound2(i,:), 'r')
% %     title(sprintf('The %dth entry of vector W2*tanh(v1)', i))
% %     hold off
% % end
% % 
% % % grid on
% % % for i = 1:n1
% % %     figure
% % %     hold on
% % %     grid on
% % %     plot(x,w1(i,:), 'k')
% % %     plot(x,lowerbound1(i,:), 'b')
% % %     plot(x,upperbound1(i,:), 'r')
% % %     title(sprintf('The %dth entry of vector tanh(v1)', i))
% % %     hold off
% % % end
% 

% figure
% title('v1 by interval')
% hold on
% grid on
% for i = 1:n1
%     plot(v1(i,:), i-1, '.k')
%     plot(v1l(i), i-1, 'b*')
%     plot(v1u(i), i-1, 'r*')
% end
% hold off

figure
title('\omega_1')
hold on
grid on
for i = 1:n1
    plot(v1(i,:), i-1, '.k')
    plot(tanh(Lowerv1(i)), i-1, 'b*')
    plot(tanh(Upperv1(i)), i-1, 'r*')
end

figure
title('v2 by W+ and W-')
hold on
grid on
for i = 1:n2
    plot(v2(i,:), i-1, '.k')
    plot(Lowerv2(i), i-1, 'b*')
    plot(Upperv2(i), i-1, 'r*')
    % plot(v2end1(i), i-1,'ob')
    % plot(v2end2(i), i-1,'or')
end
%%
function [L, U] = compute_bounds(W, x_min, x_max)
% COMPUTE_BOUNDS Compute the elementwise lower (L) and upper (U) bounds 
% of the vector W*x given that x_i in [x_min(i), x_max(i)].
%
%   Inputs:
%       W      - (m x n) matrix
%       x_min  - (n x 1) lower bounds for components of x
%       x_max  - (n x 1) upper bounds for components of x
%
%   Outputs:
%       L      - (m x 1) elementwise lower bound for W*x
%       U      - (m x 1) elementwise upper bound for W*x

    % Ensure x_min and x_max are column vectors
    x_min = x_min(:);
    x_max = x_max(:);
    
    % Dimensions of W
    [m, n] = size(W);
    
    % Logical masks for nonnegative vs negative entries in W
    Wpos = (W >= 0);
    Wneg = (W < 0);
    
    %----------------------------------------------------------------------
    % Lower bound: for each row j and column i,
    %   w_ji * x_i is minimized by:
    %       w_ji * x_min(i), if w_ji >= 0
    %       w_ji * x_max(i), if w_ji < 0
    %----------------------------------------------------------------------
    minMatrix = Wpos .* (W .* x_min') + Wneg .* (W .* x_max');
    L = sum(minMatrix, 2);
    
    %----------------------------------------------------------------------
    % Upper bound: for each row j and column i,
    %   w_ji * x_i is maximized by:
    %       w_ji * x_max(i), if w_ji >= 0
    %       w_ji * x_min(i), if w_ji < 0
    %----------------------------------------------------------------------
    maxMatrix = Wpos .* (W .* x_max') + Wneg .* (W .* x_min');
    U = sum(maxMatrix, 2);
end


function [VL,VU] = compute_bounds_bias(Weight,bias,xL,xU)
    xL = xL(:);
    xU = xU(:);

    c = 0.5*(xU+xL);
    r = 0.5*(xU-xL);

    VL = Weight*c+bias - abs(Weight) * abs(r);
    VU = Weight*c+bias + abs(Weight) * abs(r); 
end

function [ALPHA,BETA,flag] = tanhbounds(vlow,vup)

vlow = vlow(:);
vup = vup(:);
n = size(vlow,1);
alpha = zeros(n,1);
beta = zeros(n,1);
flag = zeros(n,1);
for i = 1:n
    if vlow(i)*vup(i) < 0
    alpha(i) = 1;
    beta(i) = 1;
    flag(i) = 1;

    elseif vup(i) > 0
    alpha(i) = 1;
    beta(i) = tanh(vup(i))/vup(i);

    elseif vlow(i) < 0
    alpha(i) = tanh(vlow(i))/vlow(i);
    beta(i) = 1;

    end
end

ALPHA = diag(alpha);
BETA = diag(beta);

end


function new_matrix = replace_rows_with_abs(flag, matrix)
    % Ensure flag is a column vector
    flag = flag(:);
    
    % Make a copy of the original matrix
    new_matrix = matrix;
    
    % Find the rows where flag is 1
    rows_to_replace = find(flag == 1);
    
    % Replace those rows with their absolute values
    new_matrix(rows_to_replace, :) = abs(matrix(rows_to_replace, :));
end

function new_matrix = replace_rows_with_minus_abs(flag, matrix)
    % Ensure flag is a column vector
    flag = flag(:);
    
    % Make a copy of the original matrix
    new_matrix = matrix;
    
    % Find the rows where flag is 1
    rows_to_replace = find(flag == 1);
    
    % Replace those rows with their absolute values
    new_matrix(rows_to_replace, :) = -abs(matrix(rows_to_replace, :));
end