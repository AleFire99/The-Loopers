clear all
close all

sysest = load("sysest.mat").sysest;
sysestc = d2c(sysest);

%% tf compensator
Gp = tf(sysestc);
eigs = pole(Gp(1));
s = tf('s');
syscomp =((s-eigs(3))*(s-eigs(4)))/((s+22)*(s+wn*zeta))
num =syscomp.Numerator{:};
dem = syscomp.Denominator{:};
disp(num) %compensator
disp(dem) %compensator

%plant
%Gp(1).Numerator{:}

%Gp(1).Denominator{:}
%% PI: Ziegler-Nichols step response method
H = feedback(Gp(1),1); % im using a closed loop because open loop the system is unstable
[ys,tts] = step(H);
figure
plot(tts,ys);
xlim([0 3])
ylim([0 1.2])
hold on
slope = diff(ys)./diff(tts);
points = find(slope == max(slope)); %find the hightest slope
yTangent = (tts - tts(points))*slope(points)+ys(points); %tangent

indext1 = find(yTangent<=0.002);
indext1 = find(yTangent(indext1) >= -0.002);

indext2 = find(yTangent<=1.0025);
indext2 = find(yTangent(indext2) >= 0.9975);

plot(tts, yTangent);
scatter(tts(points),yTangent(points));
hold off

Kpid = 1/1;%gain of the response/unit input
Lpid = tts(indext1); %obtained from the graph
Taopid = tts(indext2) -tts(indext1); %obtained from the graph

%PI parameters
Kp = 0.9*Taopid/(Kpid*Lpid)
Ti = 3*Lpid