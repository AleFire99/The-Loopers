clear data_modded
%run code in the folder "FBBase_Sine_tests_MOD"
load("FB_controller_base.mat")
discont = c2d(kd_base*controller_base,0.002);
matfiles = dir('./*.mat') ;   % get all dat files in the folder
N = length(matfiles) ;      % total number of files
for i = 1:N-1  % loop for each file
    data_modded(i) = load("./"+matfiles(i+1).name);
    temp = data_modded(i).data;
    data_modded(i).data(2,:) = (lsim(1/discont, (temp(2,:)))' + temp(3,:)*2*pi/4096); %conveted to degrees 
    N_data_modded = length(data_modded);
end

save("FB_Base_moddeddata", "data_modded", "N_data_modded")
%after you save the modded data move it to where main.m is. Otherwise code
%will break