function [d_best, error_best, confMat] = Exercise2(d_max)
% load training and testing data
image_train = loadMNISTImages('train-images.idx3-ubyte');
label_train = loadMNISTLabels('train-labels.idx1-ubyte');
image_test = loadMNISTImages('t10k-images.idx3-ubyte');
label_test = loadMNISTLabels('t10k-labels.idx1-ubyte');

% some initializaiton
N_train = size(image_train,2);
N_test = size(image_test,2);
image_train_cell = cell(1,10);
mu_train = cell(1,10);
var_train = cell(1,10);
label_test_pred = zeros(N_test,1);
error = zeros(d_max,1);
confMat_cell = cell(d_max, 1);

% dimention reduction by PCA
% data centering
image_mean = mean(image_train,2);
image_train_centered = image_train - image_mean;

% computer the covariance matrix of centered data
image_train_cov = cov(image_train_centered');

% compute the eigenvalues of covariance matrix
[V,~] = eig(image_train_cov);

% the default order eigenvalues is ascendant
%   so we need sort them into descending order
V = fliplr(V);

for d = 1:d_max
    
    % choose the first d eigenvalues as projection matrix
    W = V(:,1:d);
    
    % reduced training data
    image_train_reduced = W'*image_train_centered;

    % classify the training data with its labels
    % the digit 'i' is stored in image_train_cell{i+1}
    % the corresponding mu and variance for each digit are stored in mu_train and var_train
    % mu and variance will be used for likelihood value computation
    for i =1:10
        image_train_cell{i} = image_train_reduced(:,label_train == i-1);
        mu_train{i} = mean(image_train_cell{i},2);
        var_train{i} = cov(image_train_cell{i}');
    end

    % use the mean of training data to center the testing data
    image_test_centered = image_test - image_mean;
    
    % project the centered testing data onto new subspace
    image_test_reduced = W'*image_test_centered;

    % initialize the likelihood value for the whole testing data
    likelihood_value = zeros(10,N_test);

    for i = 1:10
        % each testing data produces a likelihood value with respect to the
        %   learned mu and variance of each digit
        
        % the size of likelihood_value matrix is 10*10000
        % each column represents a test image
        % each row represents the "probability", showing how likely the
        %   image can be assigned to each class
        likelihood_value(i,:) = mvnpdf(image_test_reduced',mu_train{i}',var_train{i});
    end
    
    % extract the index for each testing data, who produces the lagrest
    %   likelihood value
    [~,label_test_pred] = max(likelihood_value);
    label_test_pred = label_test_pred - 1;
    
    % compute the misclassification error, store the error with respect to
    %   different eigenvector number
    error(d) = sum(label_test_pred' ~= label_test);
    
    % store the confusion matrix in confMat
    confMat_cell{d} = confusionmat(label_test,label_test_pred);
   
end

% show the error in percent form
error = error/N_test*100;

% find the lowest error and the corresponding eigenvector number
[error_best, d_best] = min(error);

% dispaly the result
disp('---------------------------')
disp(['optiaml parameter : d = ', num2str(d_best)])
disp(['lowest classification error is ', num2str(error_best), '%'])

% choose the corresponding confusion matrix
confMat = confMat_cell{d_best};

% show the confusion matrix
% helperDisplayConfusionMatrix(confMat)
helperDisplayConfusionMatrix(confMat)

% plot error
figure('name','error plot')
plot(error)
xlabel('number of eigenvectors')
ylabel('prediction error')
print('error plot','-dpng')

end