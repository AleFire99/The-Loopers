function [error] = compareffts(Px1,Px2)
%COMPAREFFTS compares two matrix with amplitudes
%   Detailed explanation goes here

diff = abs(Px1(:,:)-Px2(:,:));


%error = norm(diff);
error = sum(sum(abs(diff)));
%error = sum(sum(diff./Px1))/length(diff)/4;

end

