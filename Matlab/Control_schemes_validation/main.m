clear all
close all
clc

%Loading data
Data = load("Data.mat").Data;
time = Data(1,:);
reference = Data(2,:);
base = Data(3,:);
tip = Data(4,:);
total = Data(5,:);
control_signal = Data(6,:);
integral_control_signal = Data(7,:);

%%
%Finding overshoot
steady_state = reference(end);
base_overshoot = max(base-steady_state)
tip_overshoot = max(tip-steady_state)
total_overshoot = max(total-steady_state)

%%
%Finding settling time
start_of_slope = find(total>0,1);
slope = (total(start_of_slope+2)-total(start_of_slope))/(time(start_of_slope+2)-time(start_of_slope));
time_constant = steady_state/slope;
settling_time = 5*time_constant

%%
%Finding rising time
low_out = find(total>0.1*steady_state);
high_out = find(total>0.9*steady_state);
rising_time = time(high_out)-time(low_out)

%%
%Finding maximum control signal and total control signal
max_control = max(control_signal)
total_control = integral_control_signal(end)