%% Parameters
% Signals are 3 Steps, 3 Ramps, 35 Sinusoids
% to add/remove/modify any signal modify the element in one of the vectors
tip_max_steps = [20 45 90];
tip_max_ramps = [90];

Delta_t_per_signal = 30;
sampling_time = 0.002;

plot_flag = 0;

%% Vectors initializations

n_steps = length(tip_max_steps);
n_ramps = length(tip_max_ramps);
n_signals = n_steps + n_ramps;

vett_ref = zeros(1,(Delta_t_per_signal * n_signals)/sampling_time+1);
vett_t = 0:sampling_time:Delta_t_per_signal * n_signals;
simulation_time = vett_t(end);

%% Steps
% Remember to modify the number of signals if you want to add others 
previus_reference_signals = 0;

for k = 0:n_steps-1
    initial_time_signal = (k+previus_reference_signals)*Delta_t_per_signal/sampling_time;
    vett_ref(initial_time_signal+1) = 0;
    for i = 2:Delta_t_per_signal/(2*sampling_time)
        vett_ref(initial_time_signal+i) = tip_max_steps(k+1);  
    end
    
    for i = Delta_t_per_signal/(2*sampling_time)+1:Delta_t_per_signal/sampling_time    
        vett_ref(initial_time_signal+i) = 0;    
    end
    
end

%% Ramps
% Remember to modify the number of signals if you want to add others 
previus_reference_signals = n_steps;

for k = 0:n_ramps-1
    initial_time_signal = (k+previus_reference_signals)*Delta_t_per_signal/sampling_time;

    vett_ref(initial_time_signal+1) = 0;
    slope = tip_max_ramps(k+1)/(Delta_t_per_signal*(3/4));
    
    for i = 2:(Delta_t_per_signal*3)/(4*sampling_time)
        vett_ref(initial_time_signal+i) = sampling_time*(i-1)*slope;  
    end
    
    for i = (Delta_t_per_signal*3)/(4*sampling_time)+1:Delta_t_per_signal/sampling_time    
        vett_ref(initial_time_signal+i) = 0;    
    end

end



%% Plotting

if plot_flag == 1
    
    figure
    plot(vett_t,vett_ref);grid;
    xlabel('Time [s]');
    legend('reference');
    
end

%% Creation of The Time serie

reference_simulink(:,1) = vett_t';
reference_simulink(:,2) = vett_ref';

