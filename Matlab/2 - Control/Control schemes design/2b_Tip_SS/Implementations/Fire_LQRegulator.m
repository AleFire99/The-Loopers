function [K_lqr] = Fire_LQRegulator(sysest_ct)

Q_lqr = diag([200 1 1000 1]);     %initial values
R_lqr = 1;

K_lqr = lqr(sysest_ct.A, sysest_ct.B, Q_lqr,R_lqr);
end

