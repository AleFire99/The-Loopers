function [controller_tip, Kd, K_comp] = Alp02_rootlocus(sysest_ct, wn, zeta)

s = tf('s');

sys1 = ss(sysest_ct);
sys1.C(2,1) = 1;
sys1.C(1,3) = 1;

Gp = tf(sys1);
Gp = Gp(1);

poles_tip = pole(Gp);
zeros_tip = zero(Gp);
num = Gp.Numerator{:};
den = Gp.Denominator{:};
syst = tf(num,den);

figure
rlocus(num,den)
Cancel = (s-poles_tip(2))*(s-poles_tip(3))%*(s-poles(4))*(s-poles(5));      %Compensator scheme
Cancel = Cancel*(1)/((s+wn*10)*(s+wn*10))%/((s+wn*2)*(s+wn*3)));
cancelled = syst*Cancel;

bode(cancelled)
margin(cancelled)

figure
rlocus(cancelled)
axis([-1e2 1e2 -30 30]) 
sgrid (zeta,wn)

pi = (s+1)/s;
pic = pi*cancelled;
[Kd,poles_tip] = rlocfind(pic, -wn*0.7);
CL_TF =feedback(Kd*pic,1,-1);

controller_tip = pi*Cancel;
K_comp = 1/dcgain(CL_TF);


end

