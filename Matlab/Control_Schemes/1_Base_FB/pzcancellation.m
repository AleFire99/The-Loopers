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
Gp = sumtf(Gp(1), Gp(2));
sysest_ct = sysestc;

feature = 2;
poles = pole(Gp)
zeros = zero(Gp)
num = Gp.Numerator{:};
den = Gp.Denominator{:};
syst = tf(num,den);

figure
rlocus(num,den) 
% Cancel = (s-poles(3))*(s-poles(2));      %Compensator scheme
% Cancel = Cancel*((1)/((s+wn*2)*(s+wn*3)));
% cancelled = syst*Cancel;

Cancel = (s-poles(2))*(s-poles(3))*(s-poles(4))*(s-poles(5));      %Compensator scheme
Cancel = Cancel*((1)/((s+wn*2)*(s+wn*3))/((s+wn*2)*(s+wn*3)));
cancelled = syst*Cancel;

figure
rlocus(cancelled)
axis([-1e2 1e2 -30 30]) 
sgrid (zeta,wn)

pi = 1;
pic = pi*cancelled;
[kd,poles] = rlocfind(pic)
[numc,denc]=feedback(kd*pic,1,-1)

bode(pic)
margin(pic)

figure
tfc = tf(numc,denc)
step(tfc)
kd
