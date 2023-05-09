clear all
close all

%% Parameters
% Signals are 3 Steps, 3 Ramps, 35 Sinusoids
% to add/remove/modify any signal modify the element in one of the vectors
frequencies_rads = 0.1*[ 010 030 050 070 090 100 110 120 130 140 150 160 170 180 185 190 193 195 197 200 205 210 220 230 240 250 260 270 280 290 300 340 370 400 450 500 ];
power_max = 200;

dataset_loaded = "data";

load(dataset_loaded+".mat");

data_unsplitted = data';

Delta_t_per_signal = 20;
sampling_time = 0.002;

plot_flag = 0;

%% Vectors initializations

n_sinewaves = length(frequencies_rads);
n_signals = n_sinewaves;

data = zeros(7,(Delta_t_per_signal * n_signals)/sampling_time+1);

%% Sinevawes
previus_reference_signals = 0;

for k = 0:3
    initial_index_signal = ((k+previus_reference_signals)*Delta_t_per_signal/sampling_time)+1;
    end_index_signal =initial_index_signal + (Delta_t_per_signal)/(sampling_time);
    
    data = data_unsplitted(:, initial_index_signal:end_index_signal);
    if frequencies_rads(k+1)<10
        saved_file = "./Sine_Tests/"+ dataset_loaded +"0"+ frequencies_rads(k+1)*10 + ".mat";
    else
        saved_file = "./Sine_Tests/"+ dataset_loaded + frequencies_rads(k+1)*10 + ".mat";
    end
    
    save(saved_file ,'data');
    
end 
