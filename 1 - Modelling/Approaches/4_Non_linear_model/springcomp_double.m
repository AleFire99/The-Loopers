function [Mx_real, Mx_lin] = springcomp_double(alpha, Ks)

% Considering 2 Sprin, one per side

P0_A = [-3.2 3.5]/100;
P0_B = [+3.2 3.5]/100;

PP = [0 7.7]/100;
l = norm(PP);

%% Side A
theta0 = atan2(PP(2)-P0_A(2), PP(1)-P0_A(1));
Pinit = [PP(2)-P0_A(2), PP(1)-P0_A(1)];
xk = norm(Pinit);
pdiff = [l*sin(alpha) - P0_A(1);l*cos(alpha)- P0_A(2)];

theta = atan2(pdiff(2,:), pdiff(1,:));
norms = pdiff.*pdiff;
norms = sqrt(norms(1,:) + norms(2,:));

Fx_real_a = Ks*(norms-xk).*cos(theta+alpha);
%Fx_lin = (alfa+ norm(Pinit)).*taylorapp(theta0, alfa);%cosx = cos(x0) - sin(x0)*(x);
%Fx_lin = norm(Pinit)*cos(theta0) - norm(Pinit)*sin(theta0).*alfa + alfa*cos(theta0);
%Fx_lin_a = Ks*(norms-xk + alpha.*(norms-xk)).*(cos(theta0));
Fx_lin_a = Ks*(cos(theta0))*(norms-xk);
 
%% Side B

theta0 = atan2(PP(2)-P0_B(2), PP(1)-P0_B(1));
Pinit = [PP(2)-P0_B(2), PP(1)-P0_B(1)];
xk = norm(Pinit);
pdiff = [l*sin(alpha) - P0_B(1);l*cos(alpha)- P0_B(2)];

theta = atan2(pdiff(2,:), pdiff(1,:));
norms = pdiff.*pdiff;
norms = sqrt(norms(1,:) + norms(2,:));

Fx_real_b = Ks*(norms-xk).*cos(theta+alpha);
%Fx_lin = (alfa+ norm(Pinit)).*taylorapp(theta0, alfa);%cosx = cos(x0) - sin(x0)*(x);
%Fx_lin = norm(Pinit)*cos(theta0) - norm(Pinit)*sin(theta0).*alfa + alfa*cos(theta0);
%Fx_lin_b = Ks*(norms-xk + alpha.*(norms-xk)).*(cos(theta0));
Fx_lin_b = Ks*(cos(theta0))*(norms-xk);

Mx_real = (Fx_real_a + Fx_real_b)*l;
Mx_lin = (Fx_lin_a + Fx_lin_b)*l;


end

