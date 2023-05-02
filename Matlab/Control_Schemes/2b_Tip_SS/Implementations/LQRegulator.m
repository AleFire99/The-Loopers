function [K_lqr] = LQRegulator(sysest_ct)

omega_c = 20;

Q = diag([1000 1 100 1]);     %initial values
R = [1];
K_lqr = lqr(sysest_ct.A + omega_c*eye,Q,R);
end

