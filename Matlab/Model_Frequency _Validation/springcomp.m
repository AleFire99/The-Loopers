function [Mx_real, Mx_lin] = springcomp(alfa, Ks)

P0 = [-3.2 3.5]/100;
PP = [0 7.7]/100;
l = norm(PP);
theta0 = atan2(PP(2)-P0(2), PP(1)-P0(1));
Pinit = [PP(2)-P0(2), PP(1)-P0(1)];
xk = norm(Pinit);
pdiff = [l*sin(alfa) - P0(1);l*cos(alfa)- P0(2)];

theta = atan2(pdiff(2,:), pdiff(1,:));
norms = pdiff.*pdiff;
norms = sqrt(norms(1,:) + norms(2,:));
           

Mx_real = Ks*(norms-xk).*cos(theta+alfa)*l;
%Fx_lin = (alfa+ norm(Pinit)).*taylorapp(theta0, alfa);%cosx = cos(x0) - sin(x0)*(x);
%Fx_lin = norm(Pinit)*cos(theta0) - norm(Pinit)*sin(theta0).*alfa + alfa*cos(theta0);
Mx_lin = Ks*(norms-xk + alfa.*(norms-xk)).*(cos(theta0))*l;

end

