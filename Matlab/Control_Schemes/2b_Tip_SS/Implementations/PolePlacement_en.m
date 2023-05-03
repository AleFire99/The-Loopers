function [sys_controlled_pp_enla,K_x,K_eta] = PolePlacement_en(sysest_ct_tip,poles_en)

A_tilde =   [sysest_ct_tip.A, zeros(4,1);
             -sysest_ct_tip.C(1, :), 0];

B_tilde =   [sysest_ct_tip.B;
             0];
        
M_tilde =   [zeros(4,1);
             1];
        
C_en =      [1 0 0 0 0;
             0 0 1 0 0];
            
D_en =      [0 ];


K_en = place(A_tilde, B_tilde, poles_en);

K_x = K_en(1:4);
K_eta = K_en(5);

sys_controlled_pp_enla = ss(A_tilde-B_tilde*K_en, M_tilde, C_en, D_en);

end

