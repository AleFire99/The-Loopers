function simulateArm(theta,alfa,tpause)
%UNTITLED Summary of this function goes here
%   pace is to slow down the simulation, pace applies a pause between each sample 
ts = 0.002;
th1 = theta;
th2 = alfa;
L1 = 29.8/100;
d = 21.5/100/2; %we have 3 d12

L1aug = L1;

P1 = L1aug*[cos(th1) sin(th1)];
P2 = L1aug*[cos(th2+th1) sin(th2+th1)];
figure 
grid on

h1 = animatedline([0 P1(1,1)], [0 P1(1,2)],'Color','r','LineWidth',3,'MaximumNumPoints',2);
%h2 = animatedline([0 P2(1,1)], [0 P2(1,2)],'Color','r','LineWidth',3,'MaximumNumPoints',2);
marker = animatedline('Marker','o');
addpoints(marker, [0] , [0])

tip = animatedline('Marker','x','MaximumNumPoints',1 ,'LineWidth',3);
addpoints(tip,P2(1,1),P2(1,2))

%viscircles([0 0],d,'Color',"b", 'LineWidth',0.1);
%viscircles([0 0],L1aug,'Color',"k",'LineWidth',0.1);

axis(1.5*L1*[-1 1,-1,1])
numpoints = length(theta);
a = tic; % start timer

for k = 2:numpoints
    pause(tpause)
  
    b = toc(a); % check timer
    if b > (ts)
        addpoints(h1,[0 P1(k,1)], [0 P1(k,2)])
        %addpoints(h2,[0 P2(k,1)], [0 P2(k,2)])   
        addpoints(tip,P2(k,1),P2(k,2))

        drawnow % update screen every x seconds
        a = tic; % reset timer after updating
    end
end
drawnow % draw final frame
display(["simulation ended, time: " +  numpoints*ts + " seconds"])

end


