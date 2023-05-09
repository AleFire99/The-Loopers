function [controller] = JCs_design(sysest_ct)

G_sysest_cont = tf(sysest_ct);
G_theta_cont = G_sysest_cont(1)
G_alpha_cont = G_sysest_cont(1);
eigs = pole(G_sysest_cont(1))
theta_zeros = zero(G_theta_cont)

s = tf('s');

%JC's design

controller =2.6464+1.1/s;%((s-eigs(2))*(s-eigs(3)))/((s+20)*s)     %Poles come from the pid action

num =controller.Numerator{:};
dem = controller.Denominator{:};

L_JC = controller*G_theta_cont;

figure
bode(L_JC);
margin(L_JC);

figure
pzmap(L_JC);


end

