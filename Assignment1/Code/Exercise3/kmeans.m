function cluster = k_means(gesture,init_cluster,k)

% reshape the data into the shape 600*3
x = gesture(:,:,1);
y = gesture(:,:,2);
z = gesture(:,:,3);

x = x(:);
y = y(:);
z = z(:);

dataset = [x,y,z];

% initialization
cluster_center = init_cluster;
distortion = zeros(k,1);
cluster = cell(k,1);
distortion_old = inf;
step = 0;
condition = true;

% keep iterating until the condition becomes 'false'
while(condition)
    
    % E step
    % compuete euclidean distance between each data point and k different
    %   representative point
    
    % determine the smallest distance and move this data to the
    %   corresponding cluster_cell
    for i = 1:size(dataset,1)
        temp = dataset(i,:) - cluster_center;
        dist = sqrt(sum(temp.^2,2));

        [~,cluster_number] = min(dist);
        cluster{cluster_number} = [cluster{cluster_number};dataset(i,:)];
    end
    
    % M step
    % update the new respresentative point
    for K = 1:k
        cluster_center(K,:) = mean(cluster{K});
    end
    
    % distortion computation
    % Calculate the total distortion, the sum of the distance between each data point
    %   and its closest cluster mean.

    for K = 1:k
        temp = cluster{K} - cluster_center(K,:);
        dist = sqrt(sum(temp.^2,2));   
        distortion(K) = sum(dist);
    end
    distortion_new = sum(distortion);
    
    % if the threshold is fulfilled, stop the iteration
    % if not, update the distortion and reset cluster cell
    if ((distortion_old - distortion_new) < 10e-6)
        condition = false;
    else
        distortion_old = distortion_new; 
        step =step+1;   
        cluster = cell(k,1);
    end
        
end

end