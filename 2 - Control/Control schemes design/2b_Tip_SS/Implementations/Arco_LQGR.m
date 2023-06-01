function [K_lqgr, L_lqgr] = Arco_LQGR(sysest_ct_tip)

% Enlarge the system considering the integral actions
        
Q_lqgr = diag([100, 10, 100, 10]);
R_lqgr = [1];

% We can do so using the |lqr| command:

K_lqgr = lqr(sysest_ct_tip.A, sysest_ct_tip.B, Q_lqgr, R_lqgr);

% Addition noises on the states and on the output

Q_kf = diag([0.1, 1, 0.1, 1]);  % The models of state 1 (z) and state 3 (theta) are the most reliable
R_kf = diag([0.1, 0.1]);                     % We trust the measurements more than the linearized model

% Implementation of the Kalman Filter 

L_lqgr = lqr(A_ct.', C_ct.', Q_kf, R_kf).';


end

