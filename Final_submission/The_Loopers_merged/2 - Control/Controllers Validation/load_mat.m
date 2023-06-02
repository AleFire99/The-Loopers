function [data, N_data] = load_mat(foldername)
matfiles = dir('./'+foldername+'/*.mat') ;   % get all dat files in the folder 
    N = length(matfiles) ;      % total number of files 
    for i = 1:N  % loop for each file 
        data(i) = load("./"+foldername+"/"+matfiles(i).name);
        N_data = length(data);
    end
end