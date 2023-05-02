function [controller] = Fires_desiged(sysest_ct)

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

%phase_in_w_c = rad2deg(-2*pi+atan(w_c/eigs(4))-2*atan(w_c/real(theta_zeros(2)))-3*atan(w_c/w_p))
%pm = 180-phase_in_w_c
%pm_des = 60;
%w_z = w_c/tan((pm-pm_des)/2)
w_z = 3;

C_desired = (s-eigs(3))*(s-eigs(2))*(s+w_z)^2/(s*(s+w_p)^2*(s+150));      %Compensator scheme

%Manually adjust K
K = 150;

controller = C_desired*K

L_Fire = controller*G_theta_cont;

figure
bode(L_Fire);
margin(L_Fire);

figure
pzmap(L_Fire);

CL = L_Fire/(1+L_Fire);

figure
step(CL);

L_poles = pole(CL);
L_zeros = zero(CL);

end

