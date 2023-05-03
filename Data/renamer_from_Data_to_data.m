close all
clear all

filename = 'dataFBbaseFire_control_Sine_500.mat';

load(filename);
data = Data;
save(filename, 'data')