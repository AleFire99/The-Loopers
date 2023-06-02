function [groudtruth] = stateestimation(data)
y1 = data(1,:);
y2 = data(2,:);

dt = 0.002;

%thetadot = [0  (y1(2:end)-y1(1:end-1))/dt];
%alfadot =  [0  (y2(2:end)-y2(1:end-1))/dt];
thetadot = [(y1(2)-y1(1))/dt (y1(3:end)-y1(1:end-2))/(2*dt) (y1(end)-y1(end-1))/dt];
alfadot =  [(y2(2)-y2(1))/dt (y2(3:end)-y2(1:end-2))/(2*dt) (y2(end)-y2(end-1))/dt];
thetadot = imgaussfilt(thetadot,3);
alfadot=imgaussfilt(alfadot,3);

groudtruth = [y1; thetadot; y2; alfadot];

end