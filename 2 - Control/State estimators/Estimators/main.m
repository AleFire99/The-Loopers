%% Creation of the Estimated system in State Space

A_sysest_dt = [     1,      0.002,      0,          0;
                    0,      0.928,      1.162,      0.0017;
                    0,      0,          1,          0.002;
                    0,      0.0716,     -1.930,     0.9971];
                
B_sysest_dt = [     0;
                    0.10661;
                    0;
                    -0.1066];
                
C_sysest_dt = [     1,      0,          0,          0;
                    0,      0,          1,          0];
                
D_sysest_dt = [     0;
                    0];
                
Ts = 0.002;

sysest = ss(A_sysest_dt, B_sysest_dt, C_sysest_dt, D_sysest_dt, Ts);

%% Extraction of Matrices  in continuos time

sysest_ct = d2c(sysest);              % Implementation provided in Continuous time

%% Modification of the C matrix to have the tip position

sysest_ct_tip = ss(sysest_ct.A,sysest_ct.B,[1 0 1 0; 0 0 1 0],sysest_ct.D);

G_tip_cont = tf(sysest_ct_tip(1));

%% Model Parameters coming from resonance measurements

v_a_max = 13;

%% Observer implementation  


obs_poles = 10*pp_poles;            %Arco

L_obs = place(sysest_ct_tip.A',sysest_ct_tip.C', obs_poles)'; 

%% Kalman Filter

Q_KF = 2.25*e-6*eye(4);     %Alp/Arco

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


