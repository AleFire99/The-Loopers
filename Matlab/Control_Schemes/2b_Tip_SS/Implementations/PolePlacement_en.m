function [sys_controlled_pp_enla,K_x,K_eta] = PolePlacement_en(sysest_ct_tip,poles_en)

A_en = [sysest_ct_tip.A, zeros(4,1);
       -sysest_ct_tip.C(1, :), 0];

B_en = [sysest_ct_tip.B;
            0];
        
C_en = [sysest_cont.C, zeros(2,1)];

D_en = [0;0];

K_en = place(A_en, B_en, poles_en);

K_x = K_en(1:4);
K_eta = K_en(5);

sys_controlled_pp_enla = ss(A_en-B_en*K_en, B_en, C_en, D_en);

end

