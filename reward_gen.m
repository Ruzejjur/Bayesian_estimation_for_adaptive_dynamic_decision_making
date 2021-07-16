function R = reward_gen(s, a, impresion_price)
%RANDOM_GEN calculates immediate reward for choosing action a and reaching
%state s
%   INPUT:
%       ns = number of system states
%       na = number of actions
%       impression_price = price of one ad impressions
%   
%   OUTPUT:
%       R = immediate reward
%
%created: JR, 2021
%
%related to project "Bayesian estimation for adaptive dynamic decision making", J.Ružejnikov
%% Generating reward 
    if s == 0 %if s = "auction lost", you only lose money
        R = -a;
    elseif a == 0 %represents not partaking in auction
        R = 0;    
    else 
        R = s*impresion_price - a;
    end
end