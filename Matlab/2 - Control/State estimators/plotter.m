function  plotter(time,GND,Xest)
figure
subplot(4,1,1)
for i=1:4
    subplot(4,1,i)
    plot(time,GND(i,:),"k",time,Xest(i,:),"b")

end
end

