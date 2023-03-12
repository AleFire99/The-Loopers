close all
clear all

% syms m1;                                            %[Kg], Main arm mass
% syms m2;                                            %[Kg], Load arm mass
% syms L1;                                            %[m], Main arm length
% syms L2;                                            %[m], Load arm length
% syms d;                                             %[m], Arm anchor Point (1)

syms Kt;                                            %[N*m/A], Motor current-torque constant
syms Km;                                            %[V*s/rad], Motor back-emf constant                    
syms Kg;                                            %[], High-gear ratio
syms nm;                                            %[], Motor efficiency
syms ng;                                            %[], Gearbox efficiency
syms Rm;                                            %[ohm], Motor armature resistance

syms Jeq;                                           %[Kg*m^2], High gear moment of inertia no load
% syms JL = m1*L1*L1/3 + m2*L2*L2/12 + m2*d*d;        %[Kg*m^2], Load moment of inertia
syms JL;
syms BL;                                            %[N*m*s/rad], Load viscous coefficient (neglected)
syms Beq;                                           %[N*m*s/rad], Base viscous coefficient
syms Ks;
syms Delta;                                         %[s] Sampling Time

%Countinuos System

A_ct = [0,                 1,                              0,                      0;
     0,                 -(ng*nm*Kt*Km*Kg^2+Beq*Rm)/(Jeq*Rm),     Ks/Jeq,                 BL/Jeq;
     0,                 0,                              0,                      1;
     0,                 (ng*nm*Kt*Km*Kg^2+Beq*Rm)/(Jeq*Rm),      -Ks*(Jeq+JL)/(Jeq*JL),  -BL*(Jeq+JL)/(Jeq*JL)];
B_ct = [0;                 ng*nm*Kt*Kg/(Jeq*Rm);                              0;   -ng*nm*Kt*Kg/(Jeq*Rm)];
C_ct = [1,                 0,                              0,                      0;
     0,                 0,                              1,                      0];
D_ct = [0;                 0];



%Discrete System

A_dt = [1,                 Delta,                              0,                      0;
     0,                 1-Delta*(ng*nm*Kt*Km*Kg^2+Beq*Rm)/(Jeq*Rm),     Delta*Ks/Jeq,                 Delta*BL/Jeq;
     0,                 0,                              1,                      Delta;
     0,                 Delta*(ng*nm*Kt*Km*Kg^2+Beq*Rm)/(Jeq*Rm),      -Delta*Ks*(Jeq+JL)/(Jeq*JL),  1-Delta*BL*(Jeq+JL)/(Jeq*JL)];
B_dt = [0;                 Delta*ng*nm*Kt*Kg/(Jeq*Rm);                              0;   -Delta*ng*nm*Kt*Kg/(Jeq*Rm)];
C_dt = [1,                 0,                              0,                      0;
     0,                 0,                              1,                      0];
D_dt = [0;                 0];


syms a11 a12 a13 a14 a21 a22 a23 a24 a31 a32 a33 a34 a41 a42 a43 a44
A = [a11 a12 a13 a14; a21 a22 a23 a24; a31 a32 a33 a34; a41 a42 a43 a44]