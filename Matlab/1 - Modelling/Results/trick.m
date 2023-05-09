clc 
close all
clear 

load("sysest09a_lowfreq.mat")
s1 = sysest;
load("sysest09b_highfreq.mat")
s2 = sysest;

sysest.A = (s1.A + s2.A)/2;
sysest.B = (s1.B + s2.B)/2;
sysest.C = (s1.C + s2.C)/2;


save("sysest09c_trick.mat","sysest")
