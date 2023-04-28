function [Cancel,K_comp,kd] = pzcancellation(sysest_ct, zeta, wn)

Gp = tf(sysest_ct);
s = tf('s');

poles = pole(Gp(1))
zeros = zero(Gp(1))
num = Gp(1).Numerator{:};
den = Gp(1).Denominator{:};
syst = tf(num,den);

figure
rlocus(num,den)

Cancel = s*(s-poles(3))*(s-poles(2));      %Compensator scheme
Cancel = Cancel*((1)/((s+25)*(s+10)*(s+20)));
cancelled = syst*Cancel;

figure
rlocus(cancelled)
axis([-1e2 1e2 -30 30]) 
sgrid (zeta,wn)
[kd,poles] = rlocfind(cancelled)
[numc,denc]=cloop(kd*cancelled,-1)

figure
tfc = tf(numc,denc)
K_comp = 1/dcgain(tfc);
step(tfc*K_comp)
kd

end

