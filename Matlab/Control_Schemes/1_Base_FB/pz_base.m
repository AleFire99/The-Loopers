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
Gp = Gp(1);% + Gp(2)
sysest_ct = sysestc;

feature = 1;

poles = pole(Gp)
zeros = zero(Gp)
num = Gp.Numerator{:};
den = Gp.Denominator{:};
syst = tf(num,den);

figure
rlocus(num,den)
% 
% Cancel = (s-poles(3))*(s-poles(2));      %Compensator scheme
% Cancel = Cancel*((1)/((s+wn*2)*(s+wn*3)));
% cancelled = syst*Cancel;

Cancel = s*(s-poles(2))*(s-poles(3));      %Compensator scheme
Cancel = Cancel*((1)/((s+wn*2)*(s+wn*3)));
cancelled = syst*Cancel;


figure
rlocus(cancelled)
axis([-1e2 1e2 -30 30]) 
sgrid (zeta,wn)

pi = (s+3.2)/s;
pic = pi*cancelled;
[kd,poles] = rlocfind(pic)
CL_TF = feedback(kd*pic,1,-1);

bode(pic)
margin(pic)

figure

step(CL_TF/dcgain(CL_TF))
figure 
bode(CL_TF)
margin(CL_TF)

controller_base = pi*Cancel;
dccl_base = dcgain(CL_TF);
kd_base = kd;
save('FB_controller_base','controller_base', "kd_base",'dccl_base')

