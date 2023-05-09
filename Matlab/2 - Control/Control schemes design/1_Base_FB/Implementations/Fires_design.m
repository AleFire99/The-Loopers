function [controller] = Fires_design(sysest_ct)

G_sysest_cont = tf(sysest_ct);
G_theta_cont = G_sysest_cont(1);
G_alpha_cont = G_sysest_cont(1);
eigs = pole(G_sysest_cont(1));
theta_zeros = zero(G_theta_cont);

s = tf('s');

%%
%Fire's design

w_c = 15;
w_p = 22;

w_z = 3;

C_desired = (s-eigs(3))*(s-eigs(2))*(s+w_z)^2/(s*(s+w_p)^2*(s+150));      %Compensator scheme

%Manually adjust K
K = 150;

controller = C_desired*K

end

