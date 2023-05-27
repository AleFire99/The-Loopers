function [K_lqr_x, K_lqr_eta] = Arco_LQRegulator(sysest_ct_tip, tau, Q_lqr)

%Q_lqr = diag([1 1 1000 1 100]);     %initial values
R_lqr = diag([1000]);

A_tilde = [sysest_ct_tip.A,zeros(4,1);
           -sysest_ct_tip.C(1, :), 0];
         
B_tilde = [sysest_ct_tip.B;
           0];
         
[K_lqr] = lqr(A_tilde + tau*eye(4+1), B_tilde,Q_lqr,R_lqr);

K_lqr_x = K_lqr(:, 1:4);
K_lqr_eta = K_lqr(:, 5);

end

