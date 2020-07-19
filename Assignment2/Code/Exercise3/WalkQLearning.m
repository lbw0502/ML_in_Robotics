function WalkQLearning(s)

% initialization
Q = zeros(16,4);
policy = zeros(16,1);
episilon = 0.2;
alpha = 0.33;
gama = 0.8;
T = 500;

state1 = s;
state = state1;

for i = 1:T
    
    if rand(1) > episilon
        [~, policy(state)] = max(Q(state,:));
    else
        policy(state) = ceil(rand(1)*4);
    end

    [newstate, reward] = SimulateRobot(state, policy(state));

    Q(state,policy(state)) = Q(state,policy(state)) + alpha * (reward + gama * max(Q(newstate,:)) - Q(state,policy(state)));

    state = newstate;
    
end

% compute the policy
[~,policy] = max(Q,[],2);

% the walking sequence simulation
sequence = zeros(1,16);
sequence(1) = state1;

for i = 2:16
    [sequence(i), ~] = SimulateRobot(sequence(i-1),policy(sequence(i-1)));
end

walkshow(sequence)

end