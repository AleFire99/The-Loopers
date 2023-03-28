%% Load of Datas
close all
clear all

[data_struct, N_data_struct] = load_mat;        %loads all tests in ./Sine_tests
data = data_struct(1).data;
for i = 2:N_data_struct
    
    data = [data, data_struct(i).data];
    
end

Numb_freq = length(data);
time = 0:0.002:(Numb_freq*0.002);       
time = time(1:end-1);
input = data(2,:);  

figure;
plot(time,input);


