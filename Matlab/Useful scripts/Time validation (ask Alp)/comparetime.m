function [error] = comparetime(state1,state2)

    diff = abs(state1-state2);
    error = sum(sum(diff));

end

