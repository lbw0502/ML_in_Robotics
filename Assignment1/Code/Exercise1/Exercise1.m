function par = Exercise1(k)

par = cell(1,3);
load('Data.mat');
N = size(Input,2);
N_train = N/k*(k-1);
N_val = N/k;

best_position_error = inf;

% the order of polynomial
for p1 = 1:6
    
    % accumulated position error initialization
    position_error = 0;
    
    % cross validation
    for K = 1:k        
        
        % split the dataset as training data and validation data
        Input_val = Input(:,1+(K-1)*N/k : K*N/k);
        Output_val = Output(:,1+(K-1)*N/k : K*N/k);

        Input_train = Input;
        Input_train(:,1+(K-1)*N/k : K*N/k) = [];
        Output_train = Output;
        Output_train(:,1+(K-1)*N/k : K*N/k) = [];

        % extract the specific data information from training set and
        %   validation set
        v_train = Input_train(1,:);
        w_train = Input_train(2,:);  
        x_train_label = Output_train(1,:);
        y_train_label = Output_train(2,:);
        theta_train_label = Output_train(3,:);

        v_val = Input_val(1,:);
        w_val = Input_val(2,:);
        x_val_label = Output_val(1,:);
        y_val_label = Output_val(2,:);
        theta_val_label = Output_val(3,:);

        % preparation for construction of datamatrix
        vw_tain = v_train.*w_train;
        v_w_vw_train = [v_train;w_train;vw_tain];
        vw_val = v_val.*w_val;
        v_w_vw_val = [v_val;w_val;vw_val];
  
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %data matrix construction
        X_train_xy = matrix_construction(v_w_vw_train,p1);
        X_val_xy = matrix_construction(v_w_vw_val,p1);
        
        % use pseudo inverse to compute the Least Square Estimator
        t_x = pinv(X_train_xy')*x_train_label';
        t_y = pinv(X_train_xy')*y_train_label';
        
        % use the learned Estimator to compute the predicted value
        x_pred = X_val_xy' * t_x;
        y_pred = X_val_xy' * t_y;
        
        % accumulate the position error after each validation
        position_error =  position_error + sum(sqrt((x_pred-x_val_label').^2+(y_pred-y_val_label').^2))/N_val;
    end
    
    % find the lowest position error, store the corresponding p1 as p1_best
    if position_error < best_position_error
        best_position_error = position_error;
        p1_best = p1;
    end
end

% use the whole data set to estimate t_x and t_y with the learned p1
v = Input(1,:);
w = Input(2,:);  
x_label = Output(1,:);
y_label = Output(2,:);
vw = v.*w;
v_w_vw = [v;w;vw];
data = matrix_construction(v_w_vw,p1_best);
t_x = pinv(data')*x_label';
t_y = pinv(data')*y_label';
par{1} = t_x;
par{2} = t_y;


best_orientation_error = inf;
for p2 =1:6
    % accumulated orientation error initialization
    orientation_error = 0;
    
    % cross validaiton
    for K = 1:k        
        
        % split the dataset as training data and validation data
        Input_val = Input(:,1+(K-1)*N/k : K*N/k);
        Output_val = Output(:,1+(K-1)*N/k : K*N/k);

        Input_train = Input;
        Input_train(:,1+(K-1)*N/k : K*N/k) = [];
        Output_train = Output;
        Output_train(:,1+(K-1)*N/k : K*N/k) = [];

        % the number of training set and validation set
        N_train = size(Input_train,2);
        N_val = size(Input_val,2);

        % extract the specific data informatino from training set and
        % validation set
        v_train = Input_train(1,:);
        w_train = Input_train(2,:);  
        x_train_label = Output_train(1,:);
        y_train_label = Output_train(2,:);
        theta_train_label = Output_train(3,:);

        v_val = Input_val(1,:);
        w_val = Input_val(2,:);
        x_val_label = Output_val(1,:);
        y_val_label = Output_val(2,:);
        theta_val_label = Output_val(3,:);

        % preparation for construction of datamatrix
        vw_tain = v_train.*w_train;
        v_w_vw_train = [v_train;w_train;vw_tain];
        vw_val = v_val.*w_val;
        v_w_vw_val = [v_val;w_val;vw_val];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %data matrix construction
        X_train_theta = matrix_construction(v_w_vw_train,p2);
        X_val_theta = matrix_construction(v_w_vw_val,p2);

        % use pseudo inverse to compute the Least Square Estimator
        t_theta = pinv(X_train_theta')*theta_train_label';
        
        % use the learned Estimator to compute the predicted value
        theta_pred = X_val_theta'*t_theta;
        
        % accumulate the position error after each validation
        orientation_error = orientation_error + sum(abs(theta_pred-theta_val_label'))/N_val;
    end
   
    % find the lowest position error, store the corresponding p2 as p2_best
    if orientation_error < best_orientation_error
        best_orientation_error = orientation_error;
        p2_best = p2;
    end
 
end

% use the whole data set to estimate t_theta with the learned p2
v = Input(1,:);
w = Input(2,:);  
theta_label = Output(3,:);
vw = v.*w;
v_w_vw = [v;w;vw];
data = matrix_construction(v_w_vw,p2_best);
t_theta = pinv(data')*theta_label';
par{3} = t_theta;

end