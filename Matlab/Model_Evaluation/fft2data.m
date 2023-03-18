function [fs,Pxs] = fft2data(data,Uvec )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
data = data;
%data=data(:,500*8:end) ;
%data = data(:,1:500*0.5);
Ts_002 = 0.002;
downsample_factor   =   1;
Ts                  =   Ts_002*downsample_factor;

%% Use noise-corrupted values
theta           = -data(1,1:downsample_factor:end);               % Measured sideslip angle
alfa            = data(2,1:downsample_factor:end);                % Measured yaw rate
thetadot        = data(3,1:downsample_factor:end);
alfadot         = data(4,1:downsample_factor:end);

fs = [];
Pxs = [];

[fs(1,:), Pxs(1,:)]= applyfft(Uvec ,theta,Ts);
[fs(2,:), Pxs(2,:)]= applyfft(Uvec,thetadot,Ts);
[fs(3,:), Pxs(3,:)]= applyfft(Uvec,alfa,Ts);
[fs(4,:), Pxs(4,:)]= applyfft(Uvec,alfadot,Ts);


end

