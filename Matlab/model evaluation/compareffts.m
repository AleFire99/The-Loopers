function [error] = compareffts(Px1,Px2)
%COMPAREFFTS Summary of this function goes here
%   Detailed explanation goes here

diff = abs(Px1(1,:)-Px2(1,:));
%error = norm(diff);
error = sum(sum(abs(diff)));
%error = sum(sum(diff./Px1))/length(diff)/4;

end

