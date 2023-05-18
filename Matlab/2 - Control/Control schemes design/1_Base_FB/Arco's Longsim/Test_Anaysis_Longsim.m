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


ID = 7;

initial_time_signal = (ID)*Delta_t_per_signal/sampling_time

data = data';

time = data(1,initial_time_signal+1:initial_time_signal+Delta_t_per_signal/sampling_time);
reference = data(2,initial_time_signal+1:initial_time_signal+Delta_t_per_signal/sampling_time);
theta = data(3,initial_time_signal+1:initial_time_signal+Delta_t_per_signal/sampling_time);
alpha = data(4,initial_time_signal+1:initial_time_signal+Delta_t_per_signal/sampling_time);
tip = data(5,initial_time_signal+1:initial_time_signal+Delta_t_per_signal/sampling_time);
control_signal = data(6,initial_time_signal+1:initial_time_signal+Delta_t_per_signal/sampling_time);
integral_control_signal = data(7,initial_time_signal+1:initial_time_signal+Delta_t_per_signal/sampling_time);

%% Plot of the Signals

figure
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

