function Exercise3_kmeans(gesture_l,gesture_o,gesture_x,init_cluster_l,init_cluster_o,init_cluster_x,k)
cluster_l = kmeans(gesture_l,init_cluster_l,k);
cluster_o = kmeans(gesture_o,init_cluster_o,k);
cluster_x = kmeans(gesture_x,init_cluster_x,k);

cluster_plot(cluster_l,'gesture l,kmeans')
cluster_plot(cluster_o,'gesture o,kmeans')
cluster_plot(cluster_x,'gesture x,kmeans')

end