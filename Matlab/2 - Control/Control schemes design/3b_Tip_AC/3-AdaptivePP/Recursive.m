close all
clear all
clc

%%
%Loading model
load("sysest09c_trick.mat");
load("Trans.mat");
sysest_cont = d2c(sysest);              % Implementation provided in Continuous time
sysest_ct = sysest_cont;
f=3.846;
wn = 2*pi*f;
zeta= 0.7;
v_a_max = 5;

% Pole placement param

new_pole = [-23; -25; -27; -29];          %Definition of the new poles

% Pole placement implementation

k = place(sysest_cont.A, sysest_cont.B, new_pole);      
syspp = ss(sysest_cont.A-sysest_cont.B*k,sysest_cont.B,sysest_cont.C,sysest_cont.D);
p_cl = pole(syspp);
Kdc = dcgain(syspp);
Kr = 1/Kdc(1);

%Observer implementation  

L_obs = place(sysest_cont.A',sysest_cont.C',1.5*new_pole)'; 

% LQR
Q = diag([1000 1 100 1]);     %initial values
R = [1];
K_lqr = lqr(sysest_cont,Q,R);

%% Recursive part
% before run simulink
disc=tf(sysest);
param = [disc(1).Numerator{:}(3:end) -disc(1).Denominator{:}(2:end)];
param2 = [disc(2).Numerator{:}(3:end) -disc(2).Denominator{:}(2:end)];

%% after run simulink
tic
obtained = out.Parameters.Data(end,:);
obtained2 = out.Parameters2.Data(end,:);
% disc=tf(sysest);
% theta_d = disc(1)
% alpha_d = disc(2);
% discfake=tf(sysfake);
%theta_dfake = discfake(1)
tfobtained1 = tf([obtained(1:3)],[1 -obtained(4:end)],0.002)
tfobtained2 = tf([obtained2(1:2)],[1 -obtained2(3:end)],0.002)
%
close all;
figure
bode(sysest(1),sysfake(1),tfobtained1)

legend(["Model discrete","Model fake","Recursive Estimation"  ])

% Transform matrix
Co1 = ctrb(sysest);
tfrls = [tfobtained1;tfobtained2]
sysest2 = ss(balred(tfrls,4));
%  sysest2 = canon(sysest2, 'modal');
%  sysest2.D = sysest.D;
Co2 = ctrb(sysest2);
%Trans = Co1*inv(Co2);

new_A = Trans*sysest2.A*inv(Trans);
new_B = Trans*sysest2.B;
new_C = sysest2.C*inv(Trans);
new_sys= ss(new_A,new_B,new_C,sysest2.D,0.002)
toc