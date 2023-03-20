%% continous
sysestc = d2c(sysest);
zeta = 0.8;
wn = 24.1651;
new_pole = [-wn*zeta ; -21; -23; -25];
k = place(sysestc.A, sysestc.B, new_pole);
syspp = ss(sysestc.A-sysestc.B*k,sysestc.B,sysestc.C,sysestc.D);
p_cl = pole(syspp);
step(syspp)
Kdc = dcgain(syspp);
Kr = 1/Kdc;
L = place(sysestc.A',sysestc.C', 10*new_pole)';
%% discrete
new_pole2 = [0.95 + 0.0i, 0.98 + 0.0i, 0.96 + 0.0i, 0.993 - 0.0i];
k2 = place(sysest.A, sysest.B, new_pole2);
syspp2 = ss(sysest.A-sysest.B*k2,sysest.B,sysest.C,sysest.D, 0.002);
p_cl2 = pole(syspp2);
step(syspp2)
Kdc2 = dcgain(syspp2);
Kr2 = 1/Kdc2;
L22 = place(sysest.A',sysest.C', new_pole2/0.99)';