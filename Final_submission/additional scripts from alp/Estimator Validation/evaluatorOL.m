function [groudtruth, Xest, me] = evaluatorOL(data)
time = data(1,:);
x1 = data(8,:);
x2 = data(9,:);
x3 = data(10,:);
x4 = data(11,:);
y1 = data(3,:);
y2 = data(4,:);

dt = 0.002;



%thetadot = [0  (y1(2:end)-y1(1:end-1))/dt];
%alfadot =  [0  (y2(2:end)-y2(1:end-1))/dt];
thetadot = [(y1(2)-y1(1))/dt (y1(3:end)-y1(1:end-2))/(2*dt) (y1(end)-y1(end-1))/dt];
alfadot =  [(y2(2)-y2(1))/dt (y2(3:end)-y2(1:end-2))/(2*dt) (y2(end)-y2(end-1))/dt];
thetadot = imgaussfilt(thetadot,3);
alfadot=imgaussfilt(alfadot,3);

groudtruth = [y1; thetadot; y2; alfadot]*180/pi;
simulation = [x1;x2;x3;x4]*180/pi;

error = abs(groudtruth-simulation);
[row col] = size(error);
me = sum(sum(error))/(row*col);
Xest = simulation;
end