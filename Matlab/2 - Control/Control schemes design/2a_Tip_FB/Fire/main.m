%Fire's tip FB control
close all
clear all
clc
s = tf('s');

load('sysest09c_trick.mat')   

v_a_max = 13;

wn=24.1651;
wn = 20;
zeta= 0.7;

sysest_ct = d2c(sysest);
sys1 = ss(sysest_ct);
sys1.C(2,1) = 1;
sys1.C(1,3) = 1;

Gp = tf(sys1);
Gp = Gp(1);

poles = pole(Gp)
zeros = zero(Gp)

figure(1)
margin(Gp);

figure(2)
pzmap(Gp);


controller  = (s-poles(2))*(s-poles(3))*(s+6)^2/(s*(s+200)^3);      %Compensator scheme


%% Find gain
L_1 = Gp*controller;

controller = controller/dcgain(s^2*L_1);

L_2 = Gp*controller;

dcgain(s^2*L_2);

k = 32;

%% Overall controller

controller = controller*k

L = Gp*controller;

figure(3)
margin(L);

figure(4)
pzmap(L);

CL = L/(1+L);

figure(5)
step(CL)



