function [l1_norm] = compareffts(Px1,Px2)

diff = [0,0];
    for i=1:2
        
        
        diff(i) = mean(abs(Px1(i,:) - Px2(i,:)));
        
        %error = norm(diff);
        %diff(i) = sum(sum(abs(diff(i))))
        %error = sum(sum(diff./Px1))/length(diff)/4;
    end
    
    l1_norm = mean(diff);

end

