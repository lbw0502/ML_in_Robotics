function cluster = nubs(gesture, k)

% reshape the motion data to the size 600*30
gesture = reshape(gesture,[600,3]);

% initialization
v = [0.08, 0.05, 0.02];
center(1,:) = mean(gesture);
cluster = cell(1,1);
cluster{1} = gesture;
K=1;
condition = true;

while(condition)
    
    % compute the distortion for all clusters
    for j = 1:K
        temp = cluster{j} - center(j,:);
        distortion(j) = sum(sqrt(sum(temp.^2,2)));
    end
    
    % choose the cluster with the largest distortion
    [~,cluster_number] = max(distortion);
    
    % split the cluster into two subclusters by usting vi
    % compute new center
    center_new1 = center(cluster_number,:) + v;
    center_new2 = center(cluster_number,:) - v;
    
    % split the cluster
    dist_to_new1 = sqrt(sum((cluster{cluster_number} - center_new1).^2,2));
    dist_to_new2 = sqrt(sum((cluster{cluster_number} - center_new2).^2,2));
    
    mask = dist_to_new1 >= dist_to_new2;
    cluster_new = cluster;
    cluster_new{K+1} = cluster{cluster_number}(mask,:);
    cluster_new{cluster_number}(mask,:) = [];
    cluster = cluster_new;
    
    % update the center data
    center = zeros(K+1,3);
    for i = 1: K+1
        center(i,:) = mean(cluster{i});
    end
    
    % if the threshold is fulfilled, stop the iteration
    if K+1 == k
        condition = false;
    else K = K+1;
    end
    
end
end