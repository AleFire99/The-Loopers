function [L_obs] = StateObserver_JC(sysest_ct_tip,obs_poles)

L_obs = place(sysest_ct_tip.A',sysest_ct_tip.C', obs_poles)'; 

end

