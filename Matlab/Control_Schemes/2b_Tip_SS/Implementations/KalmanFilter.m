function [L_KF] = KalmanFilter(sysest_ct_tip)

Q_KF = eye(4);     %initial values
R_KF = eye(1);

L_KF = lqr(sysest_ct_tip.A.', sysest_ct_tip.C.', Q_KF, R_KF).';

end

