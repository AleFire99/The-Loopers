%% Parameters
% Signals are 3 Steps, 3 Ramps, 35 Sinusoids

tip_max_steps = [20 45 90];
tip_max_ramps = [20 45 90];
frequencies_rads = 0.1*[ 010 030 050 070 090 100 110 120 130 140 150 160 170 180 185 190 193 195 197 200 205 210 220 230 240 250 260 270 280 290 300 340 370 400 450 500 ];
power_max = 200;

%% Vectors initializations

n_steps = length(tip_max_steps);
n_ramps = length(tip_max_ramps);
n_sinewaves = length(frequencies_rads);
n_signals = n_steps + n_ramps + n_sinewaves;

Delta_t_per_signal = 20;
sampling_time = 0.002;
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

    slope = tip_max_ramps(k+1)/Delta_t_per_signal;

    for i = 1:Delta_t_per_signal/sampling_time+1    
        vett_ref(initial_time_signal+i) = sampling_time*(i-1)*slope;    
    end
end

%% Sinevawes
previus_reference_signals = n_steps + n_ramps;

for k = 0:n_sinewaves-1
    initial_time_signal = (k+previus_reference_signals)*Delta_t_per_signal/sampling_time;
    vett_ref(initial_time_signal+1) = 0;
    Amplitude = sqrt(power_max/frequencies_rads(k+1));
    
    for i = 2:(Delta_t_per_signal*3)/(4*sampling_time)
        vett_ref(initial_time_signal+i) = Amplitude*sin(frequencies_rads(k+1)*sampling_time*(i-1));  
    end
    
    for i = (Delta_t_per_signal*3)/(4*sampling_time)+1:Delta_t_per_signal/sampling_time    
        vett_ref(initial_time_signal+i) = 0;    
    end
end 

%% Plotting

figure
plot(vett_t,vett_ref);grid;
xlabel('Time [s]');
legend('reference');

%% Creation of The Time serie

reference_simulink(:,1) = vett_t';
reference_simulink(:,2) = vett_ref';

