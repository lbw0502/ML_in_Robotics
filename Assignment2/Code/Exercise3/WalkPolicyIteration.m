function WalkPolicyIteration(s)

    % reward matrix
    rew = [0 0 0 0
        0 1 -1 -1
        0 -1 -1 -1
        0 0 0 0
        -1 -1 0 1
        0 0 0 0
        0 0 0 0
        -1 1 0 0 
        -1 -1 0 -1
        0 0 0 0
        0 0 0 0
        -1 0 0 0
        0 0 0 0
        0 0 -1 1
        0 -1 -1 1
        0 0 0 0];

    % state transition matrix
    state_trans = [2 4 5 13
        1 3 6 14
        4 2 7 15
        3 1 8 16
        6 8 1 9
        5 7 2 10
        8 6 3 11
        7 5 4 12
        10 12 13 5
        9 11 14 6
        12 10 15 7
        11 9 16 8
        14 16 9 1
        13 15 10 2
        16 14 11 3
        15 13 12 4];

    % some initialization
    V = zeros(16,1);
    policy = ceil(rand(16,1)*4);
    gama = 0.9;
    flag = true;
    iteration = 0;

    reward = zeros(16,1);
    theta = zeros(16,1);
    V_theta = zeros(16,1);
    policy_new = zeros(16,1);
    

    % policy iteration
    while(flag)
        iteration = iteration + 1;
        
        % (a) update state value
        for i = 1:16
            reward(i) = rew(i,policy(i));
            theta(i) = state_trans(i,policy(i));
            V_theta(i) = V(theta(i));
        end

        V_new = reward + gama * V_theta;       
        V = V_new;
        
        %(b) update policy
        Q = rew + gama * reshape(V(state_trans(:)),size(state_trans));
        [~,policy_new] = max(Q,[],2);
        
        % check the convergence of policy
        if policy_new == policy
            flag = false;
        else
            policy = policy_new;
        end

    end


    % the walking sequence simulation
    sequence = zeros(1,16);
    sequence(1) = s;
    for i = 2:16
        sequence(i) = state_trans(sequence(i-1),policy(sequence(i-1)));
    end

    walkshow(sequence)

end