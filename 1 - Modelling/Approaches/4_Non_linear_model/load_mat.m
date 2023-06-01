function [data, N_data] = load_mat()
matfiles = dir('./Sine_tests/*.mat') ;   % get all dat files in the folder 
    N = length(matfiles) ;      % total number of files 
    for i = 1:N  % loop for each file 
        %data(i) = load("./Sine_tests/"+matfiles(i).name);           %Used to load a folder of sine tests
        N_data = length(data);
    end
end