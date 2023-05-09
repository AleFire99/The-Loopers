%% Parameters
% Signals are 36 Sinusoids
% to add/remove/modify any signal modify the element in one of the vectors
frequencies_rads = 0.1*[ 010 030 050 070 090 100 110 120 130 140 150 160 170 180 185 190 193 195 197 200 205 210 220 230 240 250 260 270 280 290 300 340 370 400 450 500 ];
power_max = 2025;

Delta_t_per_signal = 30;
sampling_time = 0.002;

plot_flag = 0;

%% Vectors initializations

n_sinewaves = length(frequencies_rads);
n_signals = n_sinewaves;

vett_ref = zeros(1,(Delta_t_per_signal * n_signals)/sampling_time+1);
vett_t = 0:sampling_time:Delta_t_per_signal * n_signals;
simulation_time = vett_t(end);


%% Sinevawes
previus_reference_signals = 0;

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

if plot_flag == 1
    
    figure
    plot(vett_t,vett_ref);grid;
    xlabel('Time [s]');
    legend('reference');
    
end

%% Creation of The Time serie

reference_simulink(:,1) = vett_t';
reference_simulink(:,2) = vett_ref';

