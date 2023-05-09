omega_n_1 = sqrt(sysest.A(2,3)/sysest.Ts)
xi_1 = sysest.A(2,4)/(sysest.Ts*2*omega_n_1)
omega_n_2 = sqrt(-sysest.A(4,3)/sysest.Ts)
xi_2 = -(sysest.A(4,4)-1)/(sysest.Ts*2*omega_n_2)
