function dx = flexArm2(x, Jeq, JL, Beq, BL, Kt, Kg, Ks, Km, ng, nm, Rm, V)

x1 = x(1); %theta
x2 = x(2); %thetadot
x3 = x(3); %alpha
x4 = x(4); %alphadot

%% 
tau = ng*nm*Kt*Kg*(V-Km*Kg*x2)/Rm;

dx(1,1) = x2;
dx(2,1) = (tau - Beq*x2 + BL*x4 + Ks*x3)/Jeq;
dx(3,1) = x4;
dx(4,1) = -tau/Jeq - ((Jeq+JL)/(JL*Jeq))*BL*x4 + Beq/Jeq*x2 - ((Jeq+JL)/(JL*Jeq))*Ks*x3;