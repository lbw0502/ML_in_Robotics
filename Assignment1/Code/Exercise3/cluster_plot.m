function cluster_plot(cluster,name)
color = ['b','k','r','g','m','y','c'];
figure('name',name)
hold on
for i = 1:7
    plot3(cluster{i}(:,1),cluster{i}(:,2),cluster{i}(:,3),'x','color',color(i)) 
end

title(name)
print(name,'-dpng')

end
