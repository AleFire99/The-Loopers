clc 
close all
clear 

load("Copy_of_sysest5.mat")
s1 = sysest;
load("Copy_of_sysest_matching.mat")
s2 = sysest;

A = (s1.A + s2.A)/2;
B = (s1.B + s2.B)/2;
C = (s1.C + s2.C)/2;

ss(A,B,C,[],0.002)
