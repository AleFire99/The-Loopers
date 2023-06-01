function  plotter(time,GND,Xest,type)
figure(1)
subplot(4,1,1)
states = ["theta" ,"thetadot","alfa","alfadot"];

for i=1:4
    subplot(4,1,i)
    plot(time,GND(i,:),"k",time,Xest(i,:),"b")
    if mod(i,2)
        unit = "[rad]";
    else
        unit ="[rad/s]";
    end
    ylabel([states(i)+unit])
    xlabel("time [s]")
    
end
sgtitle([type+' vs Ground Truth'])
saveas(figure(1),[type+".png"])
end

