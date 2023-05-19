sysest = load("sysest09c_trick.mat").sysest;

sysest_ct = d2c(sysest);

v_a_max = 10;


%% Observer implementation  

obs_poles = 10*pp_poles;            %Arco

L_obs = place(sysest_ct_tip.A',sysest_ct_tip.C', obs_poles)'; 

%% Kalman Filter

Q_KF = diag([0.0015, 0.0653, 0.0002, 0.192]);     %Alp/Arco

R_KF = eye(1)*1e-8;


L_KF = KalmanFilter(sysest_ct, Q_KF, R_KF);

%% Comparison Part

comparison_flag = 1;

if comparison_flag == 1
  
    figure;
    sigma(sysest_ct_tip, 'b-x', sys_controlled_pp, 'r-o');
    legend;grid on;
    
%     figure
%     pzmap(L_Controlled);
%     
%     CL_Controlled = L_Controlled/(1+L_Controlled);
%     
%     figure; hold on;
%     step(CL);
%     step(CL_Controlled);
%     legend;
%     hold off;
%     grid;
%     
%     L_poles = pole(CL_Controlled);
%     L_zeros = zero(CL_Controlled);

end


