function [K_lqrFF_x, K_lqrFF_eta] = Fire_LQRFF(sysest_ct, tau)

Q_lqr = diag([10 1 1000 1 1000]);     %initial values
R_lqr = 1;

A_tilde = [sysest_ct.A,zeros(4,1);
           -1 0 -1 0 0];

A_tilde = A_tilde + tau*eye(5);
         
B_tilde = [sysest_ct.B;
           0];
         
K_lqrFF = lqr(A_tilde, B_tilde,Q_lqr,R_lqr);

K_lqrFF_x = K_lqrFF(:, 1:4);
K_lqrFF_eta = K_lqrFF(:, 5);

end

