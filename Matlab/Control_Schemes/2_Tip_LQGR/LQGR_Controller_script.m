sysest_dt = load("sysest.mat").sysest;
sysest_ct = d2c(sysest_dt);              % Implementation provided in Continuous time

% Model Parameters coming from resonance measurements

f=3.846;
wn = 2*pi*f;
zeta= 0.7;
v_a_max = 15;
Vd = [0.0001, 0, 0.0001, 0];

%% Continous Time

p_ol_ct = pole(sysest_ct);

A_ct = sysest_ct.A;
B_ct = sysest_ct.B;
C_ct = sysest_ct.C;
D_ct = sysest_ct.D;

% Enlarge the system considering the integral actions
        
Q_lq = diag([100, 10, 100, 10]);
R_lq = [1];

% We can do so using the |lqr| command:

K_lq = lqr(A_ct, B_ct, Q_lq, R_lq);

% Addition noises on the states and on the output

Q_kf = diag([0.1, 1, 0.1, 1]);  % The models of state 1 (z) and state 3 (theta) are the most reliable
R_kf = diag([0.1, 0.1]);                     % We trust the measurements more than the linearized model

% Implementation of the Kalman Filter 

L_kf = lqr(A_ct.', C_ct.', Q_kf, R_kf).';


%% Discrete Time

p_ol_dt = pole(sysest_dt);

A_dt = sysest_dt.A;
B_dt = sysest_dt.B;
C_dt = sysest_dt.C;
D_dt = sysest_dt.D;










