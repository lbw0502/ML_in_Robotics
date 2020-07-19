% load the data 
file_Test = '.\Test.txt';
file_A = '.\A.txt';
file_B = '.\B.txt';
file_pi = '.\pi.txt';
Test = textread(file_Test);
A = textread(file_A);
B = textread(file_B);
pi = textread(file_pi);


gesture_num = size(Test,2);
gesture_label = zeros(gesture_num,1);
log_likeli = zeros(gesture_num, 1);

for i = 1:gesture_num
    sequence = Test(:,i);
    termination = forward_procedure(A,B,pi,sequence);
    log_likeli(i) = log(termination);
    
    if log_likeli(i) > -115
        gesture_label(i) = 1;
    else
        gesture_label(i) = 2;
    end
    
end





% use forward procedure to compute the terminatino value
function termination = forward_procedure(A,B,pi,sequence)

    % initialization of HMM model parameter
    state_num = length(pi);
    observation_num = size(B,1);
    sequence_length = length(sequence);

    % initialization of alpha matrix and first row of alpha matrix
    alpha = zeros(sequence_length,state_num);
    alpha(1,:) = pi .* B(sequence(1),:);
    
    % compute the whole alpha matrix
    for t = 2:sequence_length
        for i = 1:state_num
            alpha(t,i) = sum(alpha(t-1,:) .* A(:,i)') * B(sequence(t),i);
        end
    end
    
    % compute the final termination
    termination = sum(alpha(end,:));

end
    
    
