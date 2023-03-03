close all
clear all

%Simulation flexible arm
m1 = 0.064;
m2 = 0.03;
L1 = 29.8/100;
L2 = 15.6/100;
d = 21.5/100; %we have 3 d12

Kt = 0.00768;
Kg = 70; %high gear
Km = 0.00768;
nm = 0.69;
ng = 0.9;
Rm = 2.6;

Jeq = 0.002087; %High gear moment of inertia
JL = m1*L1*L1/3 + m2*L2*L2/12 + m2*d*d; %
BL = 0; %invented but i am neglecting the damping in the link
Beq = 0.015;
wn= 2*pi*3.846;

Ks = JL*wn*wn; %invented  

V = 0; %no input applied
ts = 0:0.1:5;

y0 = [1;1;2;-1];



% dx = flexArm(x,Jeq, JL, Beq, BL, N, Rm, Kt, Ks, V);
% ode is used to solve problems with mass like pendulum
%it integrates dx that is the derivative of the states 
[t, y] = ode45(@(t,y) FlexArm2(y,Jeq, JL, Beq, BL, Kt, Kg, Ks, Km, ng, nm, Rm, V),ts,y0);

figure
plot(t,y(:,1),'-o')
figure
plot(t,y(:,2),'-o')
figure
plot(t,y(:,3),'-o')
figure
plot(t,y(:,4),'-o')

%% State space
TaoCons = ng*Kg*nm*Kt;
A = [0 1 0 0;
    0 (-TaoCons*Kg*Km-Beq)/Jeq Ks/Jeq BL/Jeq;
    0 0 0 1;
    0 (TaoCons*Kg*Km+Beq)/Jeq -Ks*((Jeq+JL)/(JL*Jeq)) -BL*((Jeq+JL)/(JL*Jeq))];

B = [0;
    TaoCons/Jeq;
    0;
    -TaoCons/Jeq];
C = [1 0 0 0;
    0 0 1 0];
D=0;
disp('  Eigenvalues of A:');
eig(A)

disp(['  Rank of Controllability = ' num2str(rank(ctrb(A,B))) ]) %needs to be full rank to say that is controllable
sys = ss(A,B,C,D);
% Simulate step response of closed-loop system
t = 0:0.002:5;
u = ones(size(t));
[y, t] = lsim(sys, u, t);


%% pole placement
poles = [-5 -90 -10 -11];

% Compute state feedback gains
K = place(A, B, poles);

% Create closed-loop state space model
Ac = A - B*K;
Bc = B;
Cc = C;
Dc = D;
sys_cl = ss(Ac, Bc, Cc, Dc);

% Simulate step response of closed-loop system

[y2, t] = lsim(sys_cl, u, t);

% Plot step response
figure
plot(t, y(:,1),t, y2(:,1));
legend('theta OL','theta CL');

figure
plot(t, y(:,2),t, y2(:,2));
legend('alpha OL','alpha CL');