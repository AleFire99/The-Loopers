function [controller_base, dccl_base] = Alp02_rootlocus(sysest_ct, wn, zeta)

s = tf('s');

Gp = tf(sysest_ct);
Gp = Gp(1);

poles = pole(Gp);
num = Gp.Numerator{:};
den = Gp.Denominator{:};
sysest_ct_tf = tf(num,den);

Cancel = (s-poles(2))*(s-poles(3));      %Compensator scheme
Cancel = Cancel*((1)/((s+wn*2)*(s+wn*3)));
cancelled = sysest_ct_tf*Cancel;

figure
rlocus(cancelled)
axis([-1e2 1e2 -30 30]) 
sgrid (zeta,wn)

pi = (s+2)/s;
pi_canceled = pi*cancelled;
[kd_base,poles_canceled] = rlocfind(pi_canceled);

controller_base = kd_base*pi*Cancel

CL_TF = feedback(kd_base*pi_canceled,1,-1);

dccl_base = dcgain(CL_TF);

end

