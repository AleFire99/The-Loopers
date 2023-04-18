%% root locus
close all
clear all
clc
load('sysest.mat')   
wn=24.1651;
zeta= 0.7; % overshhot less than 4.5%
sysestc = d2c(sysest);
Gp = tf(sysestc);
eigs = pole(Gp(1));
s = tf('s');
figure
rlocus(Gp(1).Numerator{:}, Gp(1).Denominator{:})
axis([-25 5 -25 25]) 
sgrid(zeta,wn)
[kd,poles] = rlocfind(Gp(1).Numerator{:}, Gp(1).Denominator{:})
[numCL, denCL] = cloop(kd*Gp(1).Numerator{:}, Gp(1).Denominator{:})
figure
step(numCL,denCL)
%% root locus comp
close all
num = Gp(1).Numerator{:};
den = Gp(1).Denominator{:};
figure
step(num,den)
figure
rlocus(num,den);
figure
numcf=[1 5];
dencf=[1 0];
numf=conv(numcf,num);
denf=conv(dencf,den);
rlocus(numf,denf)
sgrid(zeta,wn)
%zzeros = roots(num);
%rlC = (1)*((s-zzeros(1))*(s-zzeros(2))*(s-zzeros(3)))/((s-eigs(1))*(s-eigs(4))*(s-eigs(2))*(s-eigs(3)))
% rlocus(real(rlC.Numerator{:}), real(rlC.Denominator{:}))
axis([-30 5 -30 30]) 
[kd,poles] = rlocfind(numf,denf)
[numc,denc]=cloop(kd*numf,denf,-1)
% [kd,poles] = rlocfind(real(rlC.Numerator{:}), real(rlC.Denominator{:}))
% [numCL, denCL] = cloop(kd*real(rlC.Numerator{:}), real(rlC.Denominator{:}),-1)
figure
step(numc,denc)

%% PI
sys = tf(num, den);
rlocus(sys);
%sisotool(sys); %apply a tuning PI
Kp = 2.6464;
Ti = 1.1;
controller = Kp * tf([1 Ti], [1 0]);
sys_cl = feedback(controller * sys, 1);
figure
step(sys_cl)