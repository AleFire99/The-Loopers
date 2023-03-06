function dx = flexArm2(x,Jeq, JL, Beq, BL, Kt, Kg, Ks, Km, ng, nm, Rm, V)

x1 = x(1); %theta
x2 = x(2); %thetadot
x3 = x(3); %alpha
x4 = x(4); %alphadot

%% 
tao = ng*nm*Kt*(V-Km*x2/Kt)/Rm;

dx(1,1) = x2;
dx(2,1) = (tao - Beq*x2 + BL*x4 + Ks*x3)/Jeq;
dx(3,1) = x4;
dx(4,1) = -tao/Jeq - ((Jeq+JL)/(JL*Jeq))*BL*x4 + Beq/Jeq*x2 - ((Jeq+JL)/(JL*Jeq))*Ks*x3;