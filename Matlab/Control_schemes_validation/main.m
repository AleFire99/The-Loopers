clear all
close all
clc

%Loading data
Data = load("Data.mat").Data;
time = Data(1,:);
reference = Data(2,:);
theta = Data(3,:);
alpha = Data(4,:);
tip = Data(5,:);
control_signal = Data(6,:);
integral_control_signal = Data(7,:);

%%
%Finding overshoot
steady_state = reference(end);
base_overshoot = max(theta-steady_state)
tip_overshoot = max(abs(alpha))
total_overshoot = max(tip-steady_state)

%%
%Finding settling time
start_of_slope = find(tip>0.01,1);
slope = (tip(start_of_slope+30)-tip(start_of_slope+20))/(time(start_of_slope+30)-time(start_of_slope+20));
time_constant = steady_state/slope
settling_time = 5*time_constant

%%
%Finding rising time
low_out = find(tip>0.1*steady_state,1);
high_out = find(tip>0.9*steady_state,1);
rising_time = time(high_out)-time(low_out)

%%
%Finding dead time
start_of_output = find(abs(tip)>10e-5,1);
start_of_ref = find(reference>0.1,1);
dead_time = time(start_of_output)-time(start_of_ref)

%%
%Finding maximum control signal and total control signal
max_control = max(control_signal)
total_control = integral_control_signal(end)