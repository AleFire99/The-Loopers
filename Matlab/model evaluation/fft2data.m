function [fs,Pxs] = fft2data(data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
data = data;
%data=data(:,500*8:end) ;
%data = data(:,1:500*0.5);
Ts_002 = 0.002;
downsample_factor   =   1;
Ts                  =   Ts_002*downsample_factor;
Uvec                =   data(2,1:downsample_factor:end);
Time_vec            =   data(1,1:downsample_factor:end);
N                   =   length(Time_vec);                               % Total number of data points

%% Use noise-corrupted values
conv2angle = (2*pi)/4096;
theta           =  -data(3,1:downsample_factor:end)*conv2angle;               % Measured sideslip angle
alfa            =  data(4,1:downsample_factor:end)*conv2angle;                % Measured yaw rate

%calculate these using forward difference method
thetadot = zeros(1,length(theta));
alfadot = zeros(1,length(theta));
thetadot(2:end) = 1*imgaussfilt([theta(2:end)- theta(1:end-1)]/Ts,0.99); 
alfadot(2:end)  = 1*imgaussfilt([alfa(2:end)- alfa(1:end-1)]/Ts,0.99);


fs = [];
Pxs = [];

[fs(1,:), Pxs(1,:)]= applyfft(Uvec ,theta,Ts);
[fs(2,:), Pxs(2,:)]= applyfft(Uvec,thetadot,Ts);
[fs(3,:), Pxs(3,:)]= applyfft(Uvec,alfa,Ts);
[fs(4,:), Pxs(4,:)]= applyfft(Uvec,alfadot,Ts);


end

