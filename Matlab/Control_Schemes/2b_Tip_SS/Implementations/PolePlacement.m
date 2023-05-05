function [sys_controlled_pp, Kpp,K_p] = PolePlacement(sysest_ct_tip,new_pole)

Kpp = place(sysest_ct_tip.A, sysest_ct_tip.B, new_pole);      
sys_controlled_pp = ss(sysest_ct_tip.A - sysest_ct_tip.B * Kpp,sysest_ct_tip.B,sysest_ct_tip.C,sysest_ct_tip.D);
K_dc = dcgain(sys_controlled_pp);
K_p = 1/K_dc(1);

end

