[data_struct, N_data_struct] = load_mat;            %loads all tests in ./Sine_tests

%% Fourier Transform Computations Linear Model

data = data_struct(1).data;

for i = 2:N_data_struct
    
    data = [data data_struct(i).data];
    
end