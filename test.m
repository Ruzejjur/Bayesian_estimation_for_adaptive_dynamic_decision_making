function test(impression_price, num_of_auctions, seed)
% TEST launches the main function with desired parameters and
%      state space S, action space A, defined by the user
%   INPUT:
%       impresion_price = price of one ad impression
%       num_of_auctions = number of auctions taking place
%       seed = seed for RNG, to recreate results
% 
%   OUTPUT:
%       none
%
%   Used functions: 
%       main()
%
% created: JR, 2021
%
% related to project "Bayesian estimation for adaptive dynamic decision making", BP J.Ružejnikov

    S = [45000, 40000, 35000, 30000, 25000, 20000, 15000, 10000, 7000, 5000, 0]; %state space, individual values are number of ad views
    A = [500, 400, 300, 200, 100, 70, 50 ,30, 20, 10, 5]; %action space, individual values are amounts in CZK
    
    main(S, A, impression_price, num_of_auctions ,seed);
    
end