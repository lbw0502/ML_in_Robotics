function cluster_new = relabel(gesture, cluster)
gesture = reshape(gesture,[600,3]);
cluster_new = cell(1,7);
center = zeros(7,3);

for i = 1:7
    center(i,:) = mean(cluster{i});

end


for i = 1:600
     
    temp = gesture(i,:) - center;
    distortion = sqrt(sum(temp.^2,2));
    [~, cluster_num] = min(distortion);
    cluster_new{cluster_num} = [cluster_new{cluster_num}; gesture(i,:)];
end


end