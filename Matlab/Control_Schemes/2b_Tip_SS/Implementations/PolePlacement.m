function [sys_controlled_pp, Kpp,K_p] = PolePlacement(sysest_ct,new_pole)

Kpp = place(sysest_ct.A, sysest_ct.B, new_pole);      
sys_controlled_pp = ss(sysest_ct.A - sysest_ct.B * Kpp,sysest_ct.B,sysest_ct.C,sysest_ct.D);
K_dc = dcgain(sys_controlled_pp);
K_p = 1/K_dc(1);

end

