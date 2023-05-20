%riccati
A = sysest.A;
B = sysest.B;
Ac = sysest_ct.A;
Bc = sysest_ct.B;
Q = diag([100 1 1000 1]);     %initial values
R = [1];

flag = 1;
counts=0;
P = [p1 p2 p3 p4;
     p2 p5 p6 p7;
     p3 p6 p8 p9;
     p4 p7 p9 p10];X
P1c =Q;
while(flag)
    P2c = (P1c*Ac + Ac'*P1c + Q - P1c*Bc*inv(R)*Bc'*P1c);
    
    if issymmetric(P1c)
        flag=0;
        Psol = P1c;
    end
    P1c = P2c;
    counts= counts+1;
end


flag = 1;
counts=0;
P1 =ones(4,4)*0;
while(flag)
    P2 = A'*P1*A+Q-A'*P1*B*inv(R+B'*P1*B)*B'*P1*A;
    
  
    if (P1*1.00001 >= P2) == (P2 >= P1*0.99999)
        flag=0;
    end
    P1 = P2;
    counts= counts+1;
end

K_riccati_d =inv(R+B'*P1*B)*B'*P1*A
K_riccati_c =inv(R)*Bc'*P1c

%%
n=size(A,1);
G=Bc*inv(R)*Bc';
Z=[Ac -G
    -Q -Ac'];
[U1,S1]=schur(Z);
[U,S]=ordschur(U1,S1,'lhp');
X=U(n+1:end,1:n)*U(1:n,1:n)^-1;
inv(R)*Bc'*X

