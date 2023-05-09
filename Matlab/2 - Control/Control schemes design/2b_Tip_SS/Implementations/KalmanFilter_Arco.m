function [L_KF] = KalmanFilter_Arco(sysest_ct_tip, Q_KF, R_KF)

L_KF = lqr(sysest_ct_tip.A.', sysest_ct_tip.C.', Q_KF, R_KF).';

end

