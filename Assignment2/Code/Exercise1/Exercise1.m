load dataGMM.mat
k=4;

% 1. initialize mean and covariance of data and pi

% use k-means Toolbox to initialize the mean of data
[idx,mean] = kmeans(Data',k);               
mean = mean';
covariance = cell(1,k);
pi = zeros(1,4);

% compute the initial covariance and pi of data
for i = 1:k
    covariance{i} = cov(Data(1,idx==i),Data(2,idx==i));
    pi(i) = length(find(idx==i))/length(idx);
end

% some other initializations
log_likeli_pre = 0;
flag = true;
iteriation = 0;


% 2. E-step

% keep iteriating until the log-likelihood value converges
while(flag)
       
    % compute responsbilities
    responsbility = cell(1,4);
    n_k = zeros(1,4);
    denominator = 0;
    for i =1:k
        denominator = denominator + pi(i) * mvnpdf(Data',mean(:,i)',covariance{i});
    end

    for i = 1:k
        responsbility{i} = (pi(i) * mvnpdf(Data',mean(:,i)',covariance{i})) ./ denominator;
        n_k(i) = sum(responsbility{i});
    end

    % 3.M-step
    for i =1:k
        
        % compute new mean
        mean(:,i) = sum((responsbility{i}*ones(1,2)).*Data')/n_k(i);
        
        %compute new covariance
        Data_centered = Data - mean(:,i) * ones(1,length(idx));
        covariance{i} = ((responsbility{i}*ones(1,2))'.* Data_centered) * Data_centered' / n_k(i);
        
        % compute new pi
        pi(i) = n_k(i)/sum(n_k);
    end


    % 4. log-likelihood evaluation
    log_likeli = 0;
    for i = 1:k
        log_likeli = log(log_likeli + pi(i) * mvnpdf(Data',mean(:,i)',covariance{i}));
    end
    log_likeli = sum(log_likeli);
    
    % if log-likelihood value converges, stop the iteriation
    if log_likeli == log_likeli_pre
        flag = false;
    else
        log_likeli_pre = log_likeli;
        iteriation = iteriation + 1;
    end

end


% density plot
value = 0;
x = linspace(-0.1,0.1,100);
y = linspace(-0.1,0.1,100);
[X,Y] = meshgrid(x,y);

for i = 1:k
   value = value + pi(i) * mvnpdf([X(:),Y(:)],mean(:,i)',covariance{i});
end

VALUE = reshape(value,size(X));
surf(X,Y,VALUE)
colorbar
