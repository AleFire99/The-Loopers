function [controller] = Fires_desiged(sysest_ct)

G_sysest_cont = tf(sysest_ct);
G_theta_cont = G_sysest_cont(1)
G_alpha_cont = G_sysest_cont(1);
eigs = pole(G_sysest_cont(1))
theta_zeros = zero(G_theta_cont)

s = tf('s');

%%
%Fire's design

DC_gain_theta = dcgain(s*G_theta_cont);


%adding a zero in 0.7 to boost the phase
%added integral action to guarantee zero steady state error due to the
%friction

C_desired = (s-eigs(3))*(s-eigs(2))*(s+0.7)/(s*(s+25)*(s+30));      %Compensator scheme
DC_C_des = dcgain(s*C_desired); 

t_set = 1.5;       %Good trade-off between speed and robustness
tau = t_set/5;
BW = 1/(tau*DC_C_des*DC_gain_theta);

controller = C_desired*BW

L_Fire = controller*G_theta_cont;

figure
bode(L_Fire);
margin(L_Fire);

figure
pzmap(L_Fire);



end

