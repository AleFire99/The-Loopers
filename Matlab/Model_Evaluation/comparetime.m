function [error] = comparetime(state1,state2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
diff = abs(state1-state2);

error = sum(sum(diff));

end

