function [error] = comparetime(state1,state2)
%Detailed explanation goes here

    diff = abs(state1-state2);

    error = sum(sum(diff));

end

