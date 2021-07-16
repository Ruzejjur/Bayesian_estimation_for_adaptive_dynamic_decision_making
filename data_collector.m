function model = data_collector(ns, na, states, actions)
% DATA_COLLECTOR collects data from data vector data_vec and creates a model
% based on it
%   INPUT:
%       ns = number of system states
%       na = number of actions
%       states = vector of states that occurred in time step t
%       actions = vector of actions that occurred in time step t
% 
%   OUTPUT:
%       model = system transition model p(s_{t}|a_{t},s_{t-1})
% 
%
% created: JR, 2021
%
% related to project "Bayesian estimation for adaptive dynamic decision making", J.Ružejnikov

%% Intialisation
    num_of_auctions = size(actions, 2);
    model_table = ones(ns, na, ns, 2);
    model_table(:,:,:, 2) = ns;
    %initialising 3D model matrix, 4th dimension is for storing values:
    %[number of occurrences of triplets (s_{t},a_{t},s_{t-1}), number of occurrences of pairs (a_{t},s_{t-1})]
    final_model = zeros(ns, na, ns); %initialising 3D matrix for storing resulting propabilities
    
%% Calculating propabilities
    for i = 1:num_of_auctions %browsing through data vector and storing number of occurrences into model_table
        s_t1 = states(i); %fetching index of s_{t-1}
        a_t = actions(i); %fetching index of a_{t}
        s_t = states(i+1); %fetching index of s_{t}
        
        model_table(s_t,a_t,s_t1,1) = model_table(s_t,a_t,s_t1,1) + 1; %adding one to occurrences of triplet (s_{t},a_{t},s_{t-1})
        model_table(:,a_t,s_t1,2) = model_table(:,a_t,s_t1,2) + 1; %adding one to all occurrences of pair (a_{t},s_{t-1}) simultaneously
    end
    
    for i = 1:ns %calculating the values of probabilities for triplets (s_{t},a_{t},s_{t-1}) by dividing:
                 %number of occurrences of triplet (s_{t},a_{t},s_{t-1})/number of occurrences of pair (a_{t},s_{t-1})
        for j = 1:na
            for k = 1:ns
                num_of_pairs_st_at1 = model_table(i,j,k,2);
                final_model(i, j ,k) = model_table(i ,j ,k, 1)/num_of_pairs_st_at1; 
            end
        end    
    end
    model = final_model; %assigning result as output of the function
end