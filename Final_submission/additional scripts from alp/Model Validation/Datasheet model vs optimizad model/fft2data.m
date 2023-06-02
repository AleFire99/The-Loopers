function [Pxs] = fft2data(data,Uvec)

%data=data(:,500*8:end) ;
%data = data(:,1:500*0.5);

theta           = data(1,:);               
alfa            = data(3,:);     

Pxs = [];

Pxs(1,:)= applyfft(Uvec,theta);
Pxs(2,:)= applyfft(Uvec,alfa);


end

