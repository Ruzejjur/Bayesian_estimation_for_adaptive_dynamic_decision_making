function [states_opt_gen, states_opt_pred, states_rand, states_const, opt_strat_gen, opt_strat_pred, rand_strat, const_strat, V_k_gen, V_k_pred, impression_price_vec] = main_loop(S, A, impression_price, generated_model, num_of_auctions, seed, random_impress_price_bool, rand_steps)
% MAIN_LOOP calculates optimal using generated model, optimal using predicted model, random, constant (always chooses biggest)
% action) strategy with constant and random impression price and generates corresponding states to each
%   INPUT:
%       S = state space, individual values are number of ad impressions
%       A = action space, individual values are amounts in CZK 
%       impression_price = price of one ad impressions
%       generated_model = model for generating data
%       num_of_auctions = number of auctions taking place
%       seed = seed for random number generator to use in construction of
%              generated_model and in generating states in main_loop
%       random_impress_price_bool = if 1: than parametr impression_price is ignored
%                                   and  random seeded impression
%                                   price generated from normal distribution normrnd(0.035,0.005) is used,
%                                   if 0:
%                                   uses impression_price
%       rand_steps = number of steps that are going to be used before
%       optimal strategy with predicted model kicks in
% 
%   OUTPUT:
%       states_opt_gen = states generated for optimal strategy using generated model
%       states_opt_pred = states generated for optimal strategy using predicted model
%       states_rand = states generated for random strategy using generated model
%       states_cons = states generated for constant strategy using generated model
%       opt_strat_gen = optimal strategy using generated model
%       opt_strat_pred = optimal strategy using predicted model
%       rand_strat = random strategy
%       const_strat = constant strategy
%       V_k_gen = values of states corresponding to optimal strategy using
%       generated model
%       V_k_gen = values of states corresponding to optimal strategy using
%       predicted model
%       impression_price_vec = returns array of impression prices in each
%       time step t
%
%   Used functions: 
%       state_gen()
%      
%
% created: JR, 2021
%
% related to project "Bayesian estimation for adaptive dynamic decision making", J.Ružejnikov

%% Initialisation
    ns = size(S, 2); %number of states
    na = size(A, 2); %number of actions
    s_1 = 1; %state initialisation value - e.g. auction lost (zero views)
%   s_1 = randi(sn) %can be random 
    impression_price_vec = zeros(1,num_of_auctions); %array for storing impression price in each time step t
    V_k_gen = zeros(1,ns); %initialising values of states in each time step t to zeros for generated model
    V_k_pred = zeros(1,ns); %initialising values of states in each time step t to zeros for predicted model
    table_of_triplets = ones(ns,na,ns);%number of occurrences of triplets (s_{t},a_{t},s_{t-1})
    table_of_pairs = ones(ns,na,ns)*ns; %number of occurrences of pairs (a_{t},s_{t-1})
    predicted_model = ones(ns,na,ns)*(1/ns); %initialising 3D matrix for storing resulting propabilities calculated as 
                                       %[table_of_triplets/table_of_pairs]
    
    states_opt_gen= zeros(1,num_of_auctions+1); %initialising array for states generated using optimal strategy for generated mode
    states_opt_pred = zeros(1,num_of_auctions+1); %initialising array for states generated using optimal strategy for predicted model
    states_rand = zeros(1,num_of_auctions+1);%initialising array for states generated using random strategy
    states_const = zeros(1,num_of_auctions+1);%initialising array for states generated using constant strategy
    
    opt_strat_gen = zeros(1, num_of_auctions); %initialising array for actions (calculated using value iteration) for generated mode
    opt_strat_pred = zeros(1, num_of_auctions); %initialising array for actions (calculated using value iteration) for predicted model
    rand_strat = zeros(1, num_of_auctions); %initialising array for actions (chosen randomly in each time step t)
    const_strat = zeros(1, num_of_auctions); %initialising array for actions (chooses always biggest actions)
    
    %assigning initialisation value to each data vector
    states_opt_gen(1) = s_1;
    states_opt_pred(1) = s_1; 
    states_rand(1) = s_1; 
    states_const(1) = s_1; 
%% Generating data
    for i=1:num_of_auctions
        seed = seed + 1;
        rng(seed); %using seed for RNG
        
        %choosing state in time step t-1 for each data vector
        s_t1_opt_gen = states_opt_gen(i);
        s_t1_opt_pred = states_opt_pred(i);
        s_t1_rand = states_rand(i);
        s_t1_const = states_const(i);
        
        rand_strat(i) = randi(na); %generating random action a_{t}_rand and assigning to rand_strat
        const_strat(i) = na; %choosing biggest action a_{t}_const and assigning to const_strat
        
        % Value iteration: calculating optimal action for state s_{t-1}_opt_gen using generated model
        if random_impress_price_bool == 1
                    impression_price = normrnd(0.035,0.005);
        end
        impression_price_vec(i) = impression_price;
        state_val_for_a_in_s_gen = zeros(1, na); %array for finding biggest value of state s_{t-1}_opt_gen using action a_{t}_opt_gen
        for j =1:na %index representing actions a_{t}_opt_gen
            Sum = 0; %dummy sum for evaluation of value of state s_{t-1}_opt_gen using action a_{t}_opt_gen
            for k=1:ns %index representing states s_{t}
                r = reward_gen(S(k),A(j),impression_price); %computing reward for state S(k) and action A(j)
                Sum = Sum + generated_model(k,j,s_t1_opt_gen)*r; %bellman equation for evaluation of state value s_{t-1}_opt_gen using action a_{t}_opt_gen
            end
            state_val_for_a_in_s_gen(j) = Sum; %assigning value of s_{t-1}_opt_gen saved in Sum to value array V_k_gen
        end
        [max_value_gen, index_max_value_gen] = max(state_val_for_a_in_s_gen); %selecting the action with highest value
        V_k_gen(i) = max_value_gen; %assigning highest value of s_{t-1}_opt_gen using action a_{t}_opt_gen to V_k
        opt_strat_gen(i) = index_max_value_gen;
        
        % Value iteration: calculating optimal action for state s_{t-1}_opt_pred using predicted model

        state_val_for_a_in_s_pred = zeros(1, na); %array for finding biggest value of state s_{t-1}_opt_pred using action a_{t}_opt_pred
        for j =1:na %index representing actions a_{t}_opt_pred
            Sum = 0; %dummy sum for evaluation of value of state s_{t-1}_opt_pred using action a_{t}_opt_pred
            for k=1:ns %index representing states s_{t}
                r = reward_gen(S(k),A(j),impression_price); %computing reward for state S(k) and action A(j)
                Sum = Sum + predicted_model(k,j,s_t1_opt_pred)*r; %bellman equation for evaluation of state value s_{t-1}_opt_pred using action a_{t}_opt_pred
            end
            state_val_for_a_in_s_pred(j) = Sum; %assigning value of s_{t-1}_opt_pred saved in Sum to value array V_k_pred
        end
        
        [max_value_pred, index_max_value_pred] = max(state_val_for_a_in_s_pred); %selecting the action with highest value
        V_k_pred(i) = max_value_pred; %assigning highest value of s_{t-1}_opt_pred using action a_{t}_opt_pred to V_k_pred
        
        %chosing random strategy while using predicted model for steps
        %outlined in rand_steps
        if i < rand_steps            
            opt_strat_pred(i) = rand_strat(i);
        else 
            opt_strat_pred(i) = index_max_value_pred;
        end
        
        a_t_opt_gen = opt_strat_gen(i);
        a_t_opt_pred = opt_strat_pred(i);
        a_t_rand = rand_strat(i);
        a_t_const = const_strat(i);
        
        
        %generating state in time step t for each data vector: 
        s_t_opt_gen = state_gen(generated_model(:,a_t_opt_gen, s_t1_opt_gen)', seed);
        s_t_opt_pred = state_gen(generated_model(:,a_t_opt_pred, s_t1_opt_pred)', seed); 
        s_t_rand = state_gen(generated_model(:,a_t_rand, s_t1_rand)', seed);
        s_t_const = state_gen(generated_model(:,a_t_const, s_t1_const)', seed);
        
        %assigning newly generated states to respective data vectors
        states_opt_gen(i+1) = s_t_opt_gen;
        states_opt_pred(i+1) = s_t_opt_pred; 
        states_rand(i+1) = s_t_rand;
        states_const(i+1) = s_t_const;
        
        %recalculating predicted model based on new triplet (s_{t}_opt_pred, a_{t}_opt_pred, s_{t-1}_opt_pred)
        table_of_triplets(s_t_opt_pred, a_t_opt_pred, s_t1_opt_pred) = table_of_triplets(s_t_opt_pred, a_t_opt_pred, s_t1_opt_pred) + 1; %adding one to occurrences of triplet (s_{t}_opt_pred, a_{t}_opt_pred, s_{t-1}_opt_pred)
        table_of_pairs(:,a_t_opt_pred, s_t1_opt_pred) = table_of_pairs(:,a_t_opt_pred, s_t1_opt_pred) + 1; %adding one to all occurrences of pair (a_{t}_opt_pred, s_{t-1}_opt_pred) simultaneously
        
        
        
        for j = 1:ns %calculating the values of predicted_model for triplets (s_{t},a_{t},s_{t-1}) by dividing:
            predicted_model(j, a_t_opt_pred, s_t1_opt_pred) = table_of_triplets(j,a_t_opt_pred, s_t1_opt_pred)/table_of_pairs(j,a_t_opt_pred, s_t1_opt_pred); 
        end
    end
end