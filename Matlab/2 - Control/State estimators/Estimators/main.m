
%% Observer implementation  

%obs_poles = 10*pp_poles;            %Arco
obs_poles = 2*pp_poles;            %Jc

L_obs = StateObserver(sysest_ct,obs_poles);

%% Kalman Filter

Q_KF = eye(4);     %Arco
R_KF = eye(1);

%Q_KF = eye(4);     %Alp
%R_KF = eye(1)*10;


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


