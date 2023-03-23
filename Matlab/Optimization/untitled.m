% Definir las variables simbólicas
syms ntot Kg Kt Ks Rm Beq BL Jeq JL
% Define matrix A
%i will consider ng*nm together as ntot
TaoCons = ntot*Kt*Kg/Rm;
 A = [0 1 0 0;
     0 (-TaoCons*Km*Kg-Beq)/Jeq Ks/Jeq BL/Jeq;
     0 0 0 1;
     0 (TaoCons*Km*Kg+Beq)/Jeq -Ks*((Jeq+JL)/(JL*Jeq)) -BL*((Jeq+JL)/(JL*Jeq))];

% Sampling time
dt = 0.002;

% Tustin's Method
Ad = simplify((eye(4) + dt/2*A)\(eye(4) - dt/2*A));
%%
Delta = 0.002;

A_dt = [1,                 Delta,                              0,                      0;
     0,                 1-Delta*(ng*nm*Kt*Km*Kg^2+Beq*Rm)/(Jeq*Rm),     Delta*Ks/Jeq,                 Delta*BL/Jeq;
     0,                 0,                              1,                      Delta;
     0,                 Delta*(ng*nm*Kt*Km*Kg^2+Beq*Rm)/(Jeq*Rm),      -Delta*Ks*(Jeq+JL)/(Jeq*JL),  1-Delta*BL*(Jeq+JL)/(Jeq*JL)];
B_dt = [0;                 ng*nm*Kt*Kg/(Jeq*Rm);                              0;   -ng*nm*Kt*Kg/(Jeq*Rm)];
C_dt = [1,                 0,                              0,                      0;
     0,                 0,                              1,                      0];
D_dt = [0;                 0];

sys_dt = ss(A_dt,B_dt,C_dt,D_dt)