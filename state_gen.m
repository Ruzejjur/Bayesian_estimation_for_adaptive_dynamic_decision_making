function s_t = state_gen(distribution, seed)
%STATE_GEN generates state in time step t using distribution
%   INPUT:
%       distribution = probabilities of reaching state s_t:  p(s_{t}|a_{t},s_{t-1})
%       seed = seed for RNG, to recreate results
%   OUTPUT:
%       s_t = generated state in time step t
%
%created: JR, 2021
%
%related to project "Bayesian estimation for adaptive dynamic decision making", BP J.Ruejnikov

    sd = RandStream('dsfmt19937','Seed', seed); %using seed for RNG
    
    cp = [0,cumsum(distribution)]; %computing cumulative sums of probabilities
    rand_num = rand(sd); %generating random number in range (0,1)
    for j=2:length(cp) 
    %choosing index of state according to which interval the random number landed 
    %starting from index 2 because rand_num is always > 0
        if rand_num<=cp(j)
            s_t = j-1;
            break;
        end
    end
end