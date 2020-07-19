function Exercise3_nubs(gesture_l,gesture_o,gesture_x,k)
cluster_l = nubs(gesture_l,k);
cluster_o = nubs(gesture_o,k);
cluster_x = nubs(gesture_x,k);

cluster_l_re = relabel(gesture_l, cluster_l);
cluster_o_re = relabel(gesture_o, cluster_o);
cluster_x_re = relabel(gesture_x, cluster_x);

cluster_plot(cluster_l,'gesture l,nubs')
cluster_plot(cluster_o,'gesture o,nubs')
cluster_plot(cluster_x,'gesture x,nubs')


cluster_plot(cluster_l_re,'gesture l(relabel),nubs')
cluster_plot(cluster_o_re,'gesture o(relabel),nubs')
cluster_plot(cluster_x_re,'gesture x(relabel),nubs')


end