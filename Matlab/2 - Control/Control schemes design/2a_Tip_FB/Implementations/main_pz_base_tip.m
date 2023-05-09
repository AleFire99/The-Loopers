%% root locus
close all
clear all
clc
s = tf('s');

load('sysest09c_trick.mat')   
wn=24.1651;
wn = 20;
zeta= 0.7; % overshhot less than 4.5%
%sysestc = d2c(sysest);
%Gp_all = tf(sysestc);
%Gp = sumtf(Gp_all(1), Gp_all(2));
sysestc = d2c(sysest);
sys1 = ss(sysestc)
sys1.C(2,1) = 1;
sys1.C(1,3) = 1;

Gp = tf(sys1)
Gp = Gp(1)
feature = 2;

poles = pole(Gp)
zeros = zero(Gp)
num = Gp.Numerator{:};
den = Gp.Denominator{:};
syst = tf(num,den);

figure
rlocus(num,den)
Cancel = (s-poles(2))*(s-poles(3))%*(s-poles(4))*(s-poles(5));      %Compensator scheme
Cancel = Cancel*(1)/((s+wn*10)*(s+wn*10))%/((s+wn*2)*(s+wn*3)));
cancelled = syst*Cancel;

bode(cancelled)
margin(cancelled)

figure
rlocus(cancelled)
axis([-1e2 1e2 -30 30]) 
sgrid (zeta,wn)

pi = (s+1)/s;
pic = pi*cancelled;
[kd,poles] = rlocfind(pic, -wn*0.7)
CL_TF =feedback(kd*pic,1,-1)
figure
bode(kd*pic)
margin(kd*pic)
figure
step(CL_TF/(dcgain(CL_TF)))
kd

controller_tip = pi*Cancel;
dccl_tip = dcgain(CL_TF);
kd_tip = kd;
save('FB_controller_tip','controller_tip', "kd_tip",'dccl_tip')


