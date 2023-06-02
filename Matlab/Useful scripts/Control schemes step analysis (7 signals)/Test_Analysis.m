%% Loading data coming from The simulink in this Folder
% The data.mat file must be a struct with field data obtained as response of a step.
% Its structure is:
% - Time
% - Reference
% - Base values
% - Tip values
% - Base + tip values
% - Control signal
% - Integrated control signal

clc


time = data(1,:);
reference = data(2,:);
theta = data(3,:);
alpha = data(4,:);
tip = theta+alpha;
control_signal = data(5,:);
integral_control_signal = data(6,:);

%% Plot of the Signals

figure(1)
subplot 611;plot(time,reference);grid;
title('Reference Signal');
xlabel('Time [s]');

subplot 612;plot(time,theta);grid
title('Theta Output');
xlabel('Time [s]');

subplot 613;plot(time,alpha);grid
title('Alpha Output');
xlabel('Time [s]');

subplot 614;plot(time,tip);grid
title('Tip Position (Alpha + Theta)');
xlabel('Time [s]');

subplot 615;plot(time,control_signal);grid
title('Voltage Control Signal');
xlabel('Time [s]');

subplot 616;plot(time,integral_control_signal);grid
title('Integral of The Voltage');
xlabel('Time [s]');


%% Finding overshoot
steady_state = reference(end);
base_overshoot = max(abs(theta-steady_state))
alpha_overshoot = max(abs(alpha))
hit_time = find(tip == steady_state,1)
total_overshoot = max(abs(tip(hit_time:end)-steady_state))

%% Finding settling time

slope = diff(theta)./diff(time);
points = find(slope == max(slope),1); %find the highest slope
time_constant = steady_state/slope(points)
settling_time = 5*time_constant

%% %Finding rising time
low_out = find(tip>0.1*steady_state,1);
high_out = find(tip>0.9*steady_state,1);
rising_time = time(high_out)-time(low_out)

%% Finding dead time
start_of_output = find(abs(tip)>10e-5,1);
start_of_ref = find(reference>0.1,1);
dead_time = time(start_of_output)-time(start_of_ref)

%% Finding maximum control signal and total control signal 
max_control = max(control_signal)
total_control = integral_control_signal(end)        % continuos because in simulink