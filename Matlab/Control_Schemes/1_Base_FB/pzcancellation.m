%% root locus
close all
clear all
clc
s = tf('s');

load('sysest09c_trick.mat')   
wn=24.1651;
zeta= 0.7; % overshhot less than 4.5%
sysestc = d2c(sysest);
Gp = tf(sysestc);


poles = pole(Gp(1))
zeros = zero(Gp(1))
num = Gp(1).Numerator{:};
den = Gp(1).Denominator{:};
syst = tf(num,den);

figure
rlocus(num,den)

Cancel = s*(s-poles(3))*(s-poles(2));      %Compensator scheme
Cancel = Cancel*((1)/((s+25)*(s+10)*(s+20)));
cancelled = syst*Cancel;

figure
rlocus(cancelled)
axis([-1e2 1e2 -30 30]) 
sgrid (zeta,wn)
[kd,poles] = rlocfind(cancelled)
[numc,denc]=cloop(kd*cancelled,-1)

figure
tfc = tf(numc,denc)
step(tfc/dcgain(tfc))
kd
