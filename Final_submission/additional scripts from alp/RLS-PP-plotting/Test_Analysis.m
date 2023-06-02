function [result] = Test_Analysis(data)
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

time = data(1,:);
reference = data(2,:);
rev = 1;
if reference(end) == -22.5
rev = -1;
end
reference = rev*data(2,:)+22.5;

theta = rev*data(3,:)+22.5;
alpha = rev*data(4,:);
tip = theta+alpha;

%% Plot of the Signals

figure(1)
subplot 411;plot(time,reference);grid;
title('Reference Signal');
xlabel('Time [s]');

subplot 412;plot(time,theta);grid
title('Theta Output');
xlabel('Time [s]');

subplot 413;plot(time,alpha);grid
title('Alpha Output');
xlabel('Time [s]');

subplot 414;plot(time,tip);grid
title('Tip Position (Alpha + Theta)');
xlabel('Time [s]');



%% Finding overshoot
steady_state = reference(end);
%base_overshoot = max(theta-steady_state)
%tip_overshoot = max(abs(alpha))

total_overshoot = max(tip-steady_state)/45*100;

%% Finding settling time

slope = diff(theta)./diff(time);
points = find(slope == max(slope),1); %find the highest slope
time_constant = steady_state/slope(points);
settling_time = 5*time_constant;

%% %Finding rising time
low_out = find(tip>0.1*steady_state,1);
high_out = find(tip>0.9*steady_state,1);
rising_time = time(high_out)-time(low_out);


result = [total_overshoot;settling_time;rising_time];
end