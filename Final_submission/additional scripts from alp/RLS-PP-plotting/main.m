%this files is to:
%1. load square wave experiment on adaptive control
%2. split squares and calculate individual overshoots
%3. also time constant and settling time are calculated
%4. plot the overshoots 
load("RLSPPsteps.mat")
plot(data(1,:),data(2,:),"r",data(1,:),data(3,:)+data(4,:),"b")
xlabel("time [s]")
ylabel("angle [deg]")
grid on
legend(["reference", "tip"])

tip = data(3,:)+data(4,:);
tip = tip(:,500:28000-1);
reps = reshape(tip, 500*5,11 );

%% split inpto individiual steps 
figure
plot(reps(:,10))

%% calculate overshoots 
reference = 45;
mxs = max(reps) +22.5; %
mns = min(reps) -22.5;

overshoots = [];
for i=1:length(mxs)
overshoots(2*i-1) = mxs(i)/reference;
overshoots(2*i) = -mns(i)/reference;
end
overshoots = (overshoots)*100-100
figure(1)
plot(overshoots,"bx:")
xlabel("number of controller updates")
ylabel("overshoot [%]")
grid on
ylim([0 12])
saveas(figure(1), "osRLS.png")

%%
behaviour = [];
for i = 1:21
behaviour(:,i) = Test_Analysis(all(:,(i*1250:(i+1)*1250)));
pause(0.1)
end
figure(2)
plot(behaviour(2,:),"bx:")
xlabel("number of controller updates")
ylabel("settling time [s]")
grid on
ylim([0 1])
saveas(figure(2), "stRLS.png")
