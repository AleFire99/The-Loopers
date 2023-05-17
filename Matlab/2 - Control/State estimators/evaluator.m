function [groudtruth, Xest, me] = evaluator(data)
time = data(1,:);
x1 = data(3,:);
x2 = data(4,:);
x3 = data(5,:);
x4 = data(6,:);
y1 = data(7,:);
y2 = data(8,:);
dt = 0.002;



thetadot = [0  (y1(2:end)-y1(1:end-1))/dt];
alfadot =  [0  (y2(2:end)-y2(1:end-1))/dt];

groudtruth = [y1; thetadot; y2; alfadot];
simulation = [x1;x2;x3;x4];

error = abs(groudtruth-simulation);
[row col] = size(error);
me = sum(sum(error))/(row*col);
Xest = [x1;x2;x3;x4];
end