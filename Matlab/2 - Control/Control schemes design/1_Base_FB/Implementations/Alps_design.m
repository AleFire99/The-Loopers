function [controller,K_comp] = Alps_design(sysest_ct, zeta, wn)

Gp = tf(sysest_ct);
s = tf('s');

poles = pole(Gp(1))
zeros = zero(Gp(1))
num = Gp(1).Numerator{:};
den = Gp(1).Denominator{:};
syst = tf(num,den);

figure
rlocus(num,den)

Cancel = (s-poles(2))*(s-poles(3));      %Compensator scheme
Cancel = Cancel*((1)/((s+wn*2)*(s+wn*3)));
cancelled = syst*Cancel;

figure
rlocus(cancelled)
axis([-1e2 1e2 -30 30]) 
sgrid (zeta,wn)

pi = (s+1)/s;
pic = pi*cancelled;
[Kd_base,poles] = rlocfind(pic);
CL_TF = feedback(Kd_base*pic,1,-1);

figure
step(CL_TF/dcgain(CL_TF))

controller = pi*Cancel*Kd_base;
K_comp = 1/dcgain(CL_TF);

end

