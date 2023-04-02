sysest = load("sysest.mat").sysest;
sysest_cont = d2c(sysest);              % Implementation provided in Continuous time

% Model Parameters coming from resonance measurements

f=3.846;
wn = 2*pi*f;
zeta= 0.7;

%% Control with a Compensator

G_sysest_cont = tf(sysest_cont);
G_theta_cont = G_sysest_cont(1);
G_alpha_cont = G_sysest_cont(1);
eigs = pole(G_sysest_cont(1));

s = tf('s');

syscomp =((s-eigs(3))*(s-eigs(4)))/((s+22)*(s+wn*zeta));     %Poles come from the pid action

num =syscomp.Numerator{:};
dem = syscomp.Denominator{:};
disp(num) %compensator
disp(dem) %compensator

%plant

G_sysest_cont(1).Numerator{:}
G_sysest_cont(1).Denominator{:}
%% PI: Ziegler-Nichols step response method

% im using a closed loop because open loop the system is unstable

H = feedback(G_sysest_cont(1),1); 
[ys,tts] = step(H);

% Plot the Tangent in the maximum slope point

slope = diff(ys)./diff(tts);
points = find(slope == max(slope)); %find the hightest slope
yTangent = (tts - tts(points))*slope(points)+ys(points); %tangent

%No delaty so t0 = 0

% Research of t1
indext1 = find(yTangent<=0.002);
indext1 = find(yTangent(indext1) >= -0.002);

indext2 = find(yTangent<=1.0025);
indext2 = find(yTangent(indext2) >= 0.9975);

% Plot of the Step Responce of the System and the tangent curve at the
% maximum slope

figure

plot(tts,ys);
xlim([0 3])
ylim([0 1.2])

hold on

plot(tts, yTangent);
scatter(tts(points),yTangent(points));
hold off

% Parameters of the PID using the Ziegler-Nichols Rules

Kpid = 1/1;                             %Amplitudes of Output over Input
Lpid = tts(indext1) - 0;                %Value of t1-t0
Tpid = tts(indext2) - tts(indext1);     %Value of t2-t1


%Implementation of a PI 

Kp = 0.9*Tpid/(Kpid*Lpid);
Ti = 3*Lpid;
