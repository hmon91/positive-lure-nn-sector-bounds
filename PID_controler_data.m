clc
clear
close all

% A = [-5 10;6 2];
A = [-7 5; 6 1];
B = [1;2];
C = [1 1];
tspan = [0 10];

Xc = [0;0];
Uc = 0;
Yc = 0;

for i = 1:10

% Define the center point
center = [2;2];

% Generate random points using normal distribution
random_points = 0.1*randn(2, 1);

% Shift points to be around the center [2; 2]
shifted_points = random_points + center;

x0 = shifted_points;
% x0 = center;

output = sim('simul');
sizeu = size(output.Uc,1);
plot(output.Yc,output.Uc)
hold on
Uc = [Uc;output.Uc];
Yc = [Yc;output.Yc];
end


dlmwrite('K_x.txt', Yc);
dlmwrite('K_u.txt', Uc);
