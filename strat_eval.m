
function [immediate_reward, accum_reward] = strat_eval(S, A, impression_price_vec, states, strat)
%STRAT_EVAL calculates immediate and accumulated reward in each time step t         
%   INPUT:
%       S = state space, individual values are number of ad impressions
%       A = action space, individual values are amounts in CZK
%       impression_price_vec = array of impression prices in each time step t
%       states = vector of states in time step t
%       strat = vector of actions in time step t
%       
%   OUTPUT:
%       immediate_reward = immediate reward for choosing action in time step t and reaching state t 
%       accum_reward = accumulated reward up to time 
%
%   Used functions: 
%       reward_gen()
%
%created: JR, 2021
%
%related to project "Bayesian estimation for adaptive dynamic decision making", BP J.Ružejnikov
%% Initialisation
    num_of_auctions = size(strat,2);
    current_accum_reward = 0; %initialisation value for total accumulated reward
    accum_reward = zeros(1, num_of_auctions); %initialising array for tracking accumulated reward
    immediate_reward = zeros(1, num_of_auctions); %initialising array for tracking immediate reward
%% Computing overall reward
    for i=1:num_of_auctions
        r = reward_gen(S(states(i+1)),A(strat(i)),impression_price_vec(i)); %calulating immediate reward
        current_accum_reward = current_accum_reward + r; %adding immediate reward to accumulated reward
            %addding rewards to total reward where a_{t} are choosen according to random strategy 
        accum_reward(i) = current_accum_reward;   %assigning accumulated reward up to time step t
        immediate_reward(i) =  r; %assigning immediate reward for reaching time step t
    end
end