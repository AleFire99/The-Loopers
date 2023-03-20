sysestc = d2c(sysest);
eigs = eig(sysestc.A);

tau_1 = 24;
tau_2 = 25;

s = tf("s");
C = (s+eigs(3))*(s+eigs(4))/((1+s*tau_1)*(1+s*tau_2))