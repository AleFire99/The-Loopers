Main.m file:

%% This code does following: 
% Frequency based controller Base and Tip, Pole placement for Tip, LQR for Tip
%1-load sinusoid tests on real system (requires .mat)
%2-calculate fourier transforms from sine tests
%3-load controllers and system model (requires .mat)
%4-plot bode for real system in Closed loop and design in closed loop
%5-plot step responses from real data and simulation
%6-save images to folder

Load_mat.m
reads the several sinusoid files from folder.

Fourier.m
custom founction to calculate fourier transform