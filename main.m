function main(S, A, impression_price, num_of_auctions, seed)
% MAIN calculates optimal strategy, outputs graph of of comparison between strategies
% optimal,random with several different settings
%   INPUT:
%       S = state space, individual values are number of ad impressions
%       A = action space, individual values are amounts in CZK
%       impression_price = price of ad view
%       num_of_auctions = number of auctions taking place
%       seed = seed for random number generator to use in construction of
%              generated_model and in generating states in main_loop
% 
%   OUTPUT:
%       None
%
%   Used functions: 
%       model_con(), main_loop(), strat_eval()
%      
%
% created: JR, 2021
%
% related to project "Bayesian estimation for adaptive dynamic decision making", BP J.Ružejnikov
%% Intialisation
    close all
    format long
    ns = size(S,2); %number of states
    na = size(A,2); %number of actions
    S = sort(S);
    A = sort(A);
    %sorting arrays S,A from lowest to highest, so indexes of these arrays
    %can be used as a "pointer" to real values of S and A
    
    generated_model = model_con(ns,na, seed); %randomly generated discreet propabilities p(s_{t}|a_{t},s_{t-1})
    
%% Generating optimal strategy, random and const strategy + corresponding states generated in time step t
%    With fixed impression_price and with uniform initialized model for prediction
     [states_opt_gen, states_opt_pred, states_rand, states_const, opt_strat_gen, opt_strat_pred, rand_strat, const_strat, V_k_gen, V_k_pred, impress_price_vec_const] = main_loop(S, A, impression_price, generated_model, num_of_auctions, seed, 0, 0);
%    With fixed impression_price and with 200 steps exploration
     [states_opt_gen_200, states_opt_pred_200, states_rand_200, states_const_200, opt_strat_gen_200, opt_strat_pred_200, rand_strat_200, const_strat_200, V_k_gen_200, V_k_pred_200, ~] = main_loop(S, A, impression_price, generated_model, num_of_auctions, seed, 0, 200);
%    With random seeded impression price and with uniform initialized model for prediction    
     [states_opt_gen_rp, states_opt_pred_rp, states_rand_rp, states_const_rp, opt_strat_gen_rp, opt_strat_pred_rp, rand_strat_rp, const_strat_rp, V_k_gen_rp, V_k_pred_rp, impress_price_vec_rand] = main_loop(S, A, impression_price, generated_model, num_of_auctions, seed, 1, 0);
%    With random seeded impression price and with 200 steps exploration      
     [states_opt_gen_200_rp, states_opt_pred_200_rp, states_rand_200_rp, states_const_200_rp, opt_strat_gen_200_rp, opt_strat_pred_200_rp, rand_strat_200_rp, const_strat_200_rp, V_k_gen_200_rp, V_k_pred_200_rp, ~] = main_loop(S, A, impression_price, generated_model, num_of_auctions, seed, 1, 200);
%% Evaluating optimal strategy
%    Calculating immediate and overall reward for each strategy and
%    corresponding states
     
%    With fixed impression_price and with uniform initialized model for prediction 
     [immediate_reward_opt_gen, accum_reward_opt_gen] = strat_eval(S, A, impress_price_vec_const, states_opt_gen, opt_strat_gen);
     [immediate_reward_opt_pred, accum_reward_opt_pred] = strat_eval(S, A, impress_price_vec_const, states_opt_pred, opt_strat_pred); 
     [immediate_reward_rand, accum_reward_rand] = strat_eval(S, A, impress_price_vec_const,  states_rand, rand_strat); 
      predicted_model = data_collector(ns,na,states_rand,rand_strat); %calculating the model from the data are truly without generated model to check if the data are truly generated from generated_model
     [immediate_reward_const, accum_reward_const] = strat_eval(S, A, impress_price_vec_const, states_const, const_strat);
     
%     With fixed impression_price and with 200 steps exploration
     [immediate_reward_opt_gen_200, accum_reward_opt_gen_200] = strat_eval(S, A, impress_price_vec_const, states_opt_gen_200, opt_strat_gen_200);
     [immediate_reward_opt_pred_200, accum_reward_opt_pred_200] = strat_eval(S, A, impress_price_vec_const, states_opt_pred_200, opt_strat_pred_200); 
     [immediate_reward_rand_200, accum_reward_rand_200] = strat_eval(S, A, impress_price_vec_const,  states_rand_200, rand_strat_200); 
      predicted_model = data_collector(ns,na,states_rand_200_rp,rand_strat_200_rp); %calculating the model from the data are truly without generated model to check if the data are truly generated from generated_model
     [immediate_reward_const_200, accum_reward_const_200] = strat_eval(S, A, impress_price_vec_const, states_const_200, const_strat_200);
     
     
%    With random seeded impression price and with uniform initialized model for prediction
     [immediate_reward_opt_gen_rp, accum_reward_opt_gen_rp] = strat_eval(S, A, impress_price_vec_rand, states_opt_gen_rp, opt_strat_gen_rp);
     [immediate_reward_opt_pred_rp, accum_reward_opt_pred_rp] = strat_eval(S, A, impress_price_vec_rand, states_opt_pred_rp, opt_strat_pred_rp); 
     [immediate_reward_rand_rp, accum_reward_rand_rp] = strat_eval(S, A, impress_price_vec_rand,  states_rand_rp, rand_strat_rp); 
%      predicted_model = data_collector(ns,na,states_rand_rp, rand_strat_rp); %calculating the model from the data are truly without generated model to check if the data are truly generated from generated_model
     [immediate_reward_const_rp, accum_reward_const_rp] = strat_eval(S, A, impress_price_vec_rand, states_const_rp, const_strat_rp);
     
%    With random seeded impression price and with uniform initialized model for prediction
     [immediate_reward_opt_gen_200_rp, accum_reward_opt_gen_200_rp] = strat_eval(S, A, impress_price_vec_rand, states_opt_gen_200_rp, opt_strat_gen_200_rp);
     [immediate_reward_opt_pred_200_rp, accum_reward_opt_pred_200_rp] = strat_eval(S, A, impress_price_vec_rand, states_opt_pred_200_rp, opt_strat_pred_200_rp); 
     [immediate_reward_rand_200_rp, accum_reward_rand_200_rp] = strat_eval(S, A, impress_price_vec_rand,  states_rand_200_rp, rand_strat_200_rp); 
%      predicted_model = data_collector(ns,na,states_rand_200_rp,rand_strat_200_rp); %calculating the model from the data are truly without generated model to check if the data are truly generated from generated_model
     [immediate_reward_const_200_rp, accum_reward_const_200_rp] = strat_eval(S, A, impress_price_vec_rand, states_const_200_rp, const_strat_200_rp);
     
%% Debug info 1: for large number_of_auctions: uncomment at your own discretion
%       fprintf("State values: \n")
%       display(V_k)
%       fprintf("Náhodná strategie: \n")
%       disp(rand_strat)
%       fprintf("Optimal strategy: \n")
%       disp(opt_strat)
%       fprintf("Constant strategy: \n")
%       disp(const_strat);
    
% Debug info 2:
    formatspec1 = "Accumulated reward with optimal strategy and generated model:%5i \n";
    fprintf(formatspec1,accum_reward_opt_gen(num_of_auctions))
    
    formatspec1 = "Accumulated reward with optimal strategy and predicted model:%5i \n";
    fprintf(formatspec1,accum_reward_opt_pred(num_of_auctions))
    
    formatspec1 = "Accumulated reward with random strategy:%5i \n";
    fprintf(formatspec1,accum_reward_rand(num_of_auctions))
    
    formatspec1 = "Accumulated reward with constant strategy:%5i \n";
    fprintf(formatspec1,accum_reward_const(num_of_auctions))
    %
    formatspec1 = "Accumulated reward with optimal strategy and generated model with 200 steps exploration: %5i \n";
    fprintf(formatspec1,accum_reward_opt_gen_200(num_of_auctions))
    
    formatspec1 = "Accumulated reward with optimal strategy and predicted model with 200 steps exploration: %5i \n";
    fprintf(formatspec1,accum_reward_opt_pred_200(num_of_auctions))
    
    formatspec1 = "Accumulated reward with random strategy and random with 200 steps exploration : %5i \n";
    fprintf(formatspec1,accum_reward_rand_200(num_of_auctions))
    
    formatspec1 = "Accumulated reward with constant strategy and random with 200 steps exploration: %5i \n";
    fprintf(formatspec1,accum_reward_const_200(num_of_auctions))
    
    %
    formatspec1 = "Accumulated reward with optimal strategy and generated model and random impression price: %5i \n";
    fprintf(formatspec1,accum_reward_opt_gen_rp(num_of_auctions))
    
    formatspec1 = "Accumulated reward with optimal strategy and predicted model and random impression price: %5i \n";
    fprintf(formatspec1,accum_reward_opt_pred_rp(num_of_auctions))
    
    fprintf(formatspec1,accum_reward_rand_rp(num_of_auctions))
    formatspec1 = "Accumulated reward with random strategy and random impression price: %5i \n";
    
    formatspec1 = "Accumulated reward with constant strategy and random impression price: %5i \n";
    fprintf(formatspec1,accum_reward_const_rp(num_of_auctions))
    
        %
    formatspec1 = "Accumulated reward with optimal strategy and generated model with 200 steps exploration and random impression price: %5i \n";
    fprintf(formatspec1,accum_reward_opt_gen_200_rp(num_of_auctions))
    
    formatspec1 = "Accumulated reward with optimal strategy and predicted model with 200 steps exploration and random impression price: %5i \n";
    fprintf(formatspec1,accum_reward_opt_pred_200_rp(num_of_auctions))
    
    formatspec1 = "Accumulated reward with random strategy and random with 200 steps exploration and random impression price: %5i \n";
    fprintf(formatspec1,accum_reward_rand_200_rp(num_of_auctions))
    
    formatspec1 = "Accumulated reward with constant strategy and random with 200 steps exploration and random impression price: %5i \n";
    fprintf(formatspec1,accum_reward_const_200_rp(num_of_auctions))
    
%% Graphs
    %Optimal strategy vs. random strategy vs. constant strategy on generated data
    for i=1:(num_of_auctions+1)
        states_opt_gen(i) = S(states_opt_gen(i));
        states_opt_pred(i) = S(states_opt_pred(i));
        states_rand(i) = S(states_rand(i));
        states_const(i) = S(states_const(i));
        
        states_opt_gen_rp(i) = S(states_opt_gen_rp(i));
        states_opt_pred_rp(i) = S(states_opt_pred_rp(i));
        states_rand_rp(i) = S(states_rand_rp(i));
        states_const_rp(i) = S(states_const_rp(i));
        
        states_opt_gen_200(i) = S(states_opt_gen_200(i));
        states_opt_pred_200(i) = S(states_opt_pred_200(i));
        states_rand_200(i) = S(states_rand_200(i));
        states_const_200(i) = S(states_const_200(i));
        
        states_opt_gen_200_rp(i) = S(states_opt_gen_200_rp(i));
        states_opt_pred_200_rp(i) = S(states_opt_pred_200_rp(i));
        states_rand_200_rp(i) = S(states_rand_200_rp(i));
        states_const_200_rp(i) = S(states_const_200_rp(i));
        
    end
    for i=1:num_of_auctions
        opt_strat_gen(i) = A(opt_strat_gen(i));
        opt_strat_pred(i) = A(opt_strat_pred(i));
        rand_strat(i) = A(rand_strat(i));
        const_strat(i) = A(const_strat(i));
        
        opt_strat_gen_rp(i) = A(opt_strat_gen_rp(i));
        opt_strat_pred_rp(i) = A(opt_strat_pred_rp(i));
        rand_strat_rp(i) = A(rand_strat_rp(i));
        const_strat_rp(i) = A(const_strat_rp(i));
        
        opt_strat_gen_200(i) = A(opt_strat_gen_200(i));
        opt_strat_pred_200(i) = A(opt_strat_pred_200(i));
        rand_strat_200(i) = A(rand_strat_200(i));
        const_strat_200(i) = A(const_strat_200(i));
        
        opt_strat_gen_200_rp(i) = A(opt_strat_gen_200_rp(i));
        opt_strat_pred_200_rp(i) = A(opt_strat_pred_200_rp(i));
        rand_strat_200_rp(i) = A(rand_strat_200_rp(i));
        const_strat_200_rp(i) = A(const_strat_200_rp(i));
    end
    
    time1 = [1:num_of_auctions];
    time2 = [1:num_of_auctions+1];
    
    set(0,'units','pixels'); 
    Pix_SS = get(0,'screensize');
    monitor_x_size = Pix_SS(3);
    monitor_y_size = Pix_SS(4);
    fig_size_x = 900;
    fig_size_y = 800;
    x_lim = [0 600];
    
    f1 = figure(1);
    f1.Position = [monitor_x_size - fig_size_x 50 fig_size_x fig_size_y];
    
        subplot(3,3,[1,3])
        plot(time1, accum_reward_opt_gen, 'b',time1, accum_reward_opt_pred, 'g', time1, accum_reward_rand, 'r')
        str = sprintf("Akumulovaná odmìna");
        title(str)
        xlabel("Èas t")
        ylabel("Akumulovaná odmìna")
        legend("Opt strat s perfektním modelem","Opt strat s odhadnutým modelem","Náhodná strategie",'Location','northwest')
        grid on
        
        subplot(3,3,[4,6])
        plot(time1, accum_reward_opt_gen, 'b',time1, accum_reward_opt_pred, 'g', time1, accum_reward_rand, 'r')
        str = sprintf("Akumulovaná odmìna: prvních 600 krokù");
        title(str)
        xlabel("Èas t")
        ylabel("Akumulovaná odmìna")
        legend("Opt strat s perfektním modelem","Opt strat s odhadnutým modelem","Náhodná strategie",'Location','northwest')
        xlim(x_lim)
        grid on

        subplot(3,3,[7,9])
        plot(time1, immediate_reward_opt_gen, 'bo', time1, immediate_reward_opt_pred, 'go', time1, immediate_reward_rand, 'ro')
        str = sprintf("Okamžitá odmìna");
        title(str)
        xlabel("Èas t")
        ylabel("Okamžitá odmìna")
        legend("Opt strat s perfektním modelem","Opt strat s odhadnutým modelem","Náhodná strategie",'Location','best','Orientation','horizontal')
        xlim(x_lim)
        grid on

        
         str = sprintf('Result for impression price: %.3f',impression_price);
         sgtitle(str);
         pause 
         
         
    f2 = figure(2);
    f2.Position = [monitor_x_size - fig_size_x 50 fig_size_x fig_size_y];
    
        subplot(2,3,[1,3])
        plot(time2, states_opt_gen, 'bo', time2, states_opt_pred, 'go', time2, states_rand, 'ro')
        str = sprintf("Stavy");
        title(str)
        xlabel("Èas t")
        ylabel("Stav")
        xlim(x_lim)
        legend("Opt strat s perfektním modelem","Opt strat s odhadnutým modelem","Náhodná strategie",'Location','northwest','Orientation','horizontal')
        grid on

        subplot(2,3,4)
        plot(time1, opt_strat_gen,'b*')
        title('Opt strat s perfektním modelem')
        xlabel("Èas t")
        ylabel("Akce")
        xlim(x_lim)
        grid on

        subplot(2,3,5)
        plot(time1, opt_strat_pred,'g*')
        title('Opt strat s odhadnutým modelem')
        xlabel("Èas t")
        ylabel("")
        xlim(x_lim)
        grid on

        subplot(2,3,6)
        plot(time1, rand_strat,'r*')
        title('Náhodná strategie')
        xlabel("Èas t")
        ylabel("")
        xlim(x_lim)
        grid on
    
        str = sprintf('Result for impression price: %.3f',impression_price);
        sgtitle(str);
        pause 
        
        
    f3 = figure(3);
    f3.Position = [monitor_x_size - fig_size_x 50 fig_size_x fig_size_y];
    
        subplot(3,3,[1,3])
        plot(time1, accum_reward_opt_gen_rp, 'b',time1, accum_reward_opt_pred_rp, 'g', time1, accum_reward_rand_rp, 'r')
        str = sprintf("Akumulovaná odmìna");
        title(str)
        xlabel("Èas t")
        ylabel("Akumulovaná odmìna")
        legend("Opt strat s perfektním modelem","Opt strat s odhadnutým modelem","Náhodná strategie",'Location','northwest')
        grid on
        
        subplot(3,3,[4,6])
        plot(time1, accum_reward_opt_gen_rp, 'b',time1, accum_reward_opt_pred_rp, 'g', time1, accum_reward_rand_rp, 'r')
        str = sprintf("Akumulovaná odmìna");
        title(str)
        xlabel("Èas t")
        ylabel("Akumulovaná odmìna")
        legend("Opt strat s perfektním modelem","Opt strat s odhadnutým modelem","Náhodná strategie",'Location','northwest')
        xlim(x_lim)
        grid on


        subplot(3,3,[7,9])
        plot(time1, immediate_reward_opt_gen_rp, 'bo', time1, immediate_reward_opt_pred_rp, 'go', time1, immediate_reward_rand_rp, 'ro')
        str = sprintf("Okamžitá odmìna");
        title(str)
        xlabel("Èas t")
        ylabel("Okamžitá odmìna")
        legend("Opt strat s perfektním modelem","Opt strat s odhadnutým modelem","Náhodná strategie",'Location','best','Orientation','horizontal')
        xlim(x_lim)
        grid on
     
        str = sprintf('Result for random seeded impression price. Seed: %u ', seed);
        sgtitle(str);
         
        pause
        
    f4 = figure(4);
    f4.Position = [monitor_x_size - fig_size_x 50 fig_size_x fig_size_y];
    
        subplot(2,3,[1,3])
        plot(time2, states_opt_gen_rp, 'bo', time2, states_opt_pred_rp, 'go', time2, states_rand_rp, 'ro')
        str = sprintf("Stavy v èase t");
        title(str)
        xlabel("Èas t")
        ylabel("Stav")
        legend("Opt strat s perfektním modelem","Opt strat s odhadnutým modelem","Náhodná strategie",'Location','best','Orientation','horizontal')
        xlim(x_lim)
        grid on

        subplot(2,3,4)
        plot(time1, opt_strat_gen_rp,'b*')
        title('Opt strat s perfektním modelem')
        xlabel("Èas t")
        ylabel("Akce")
        xlim(x_lim)
        grid on

        subplot(2,3,5)
        plot(time1, opt_strat_pred_rp,'g*')
        title('Opt strat s odhadnutým modelem')
        xlabel("Èas t")
        ylabel("")
        xlim(x_lim)
        grid on

        subplot(2,3,6)
        plot(time1, rand_strat_rp,'r*')
        title('Náhodná strategie')
        xlabel("Èas t")
        ylabel("")
        xlim(x_lim)
        grid on
        
        str = sprintf('Result for random seeded impression price. Seed: %u ', seed);
        sgtitle(str);

        pause 

    f5 = figure(5);
    f5.Position = [monitor_x_size - fig_size_x 50 fig_size_x fig_size_y];
    
        subplot(3,3,[1,3])
        plot(time1, accum_reward_opt_gen_200, 'b',time1, accum_reward_opt_pred_200, 'g', time1, accum_reward_rand_200, 'r')
        str = sprintf("Akumulovaná odmìna");
        title(str)
        xlabel("Èas t")
        ylabel("Akumulovaná odmìna")
        legend("Opt strat s perfektním modelem","Opt strat s odhadnutým modelem","Náhodná strategie",'Location','northwest')
        grid on
        
        subplot(3,3,[4,6])
        plot(time1, accum_reward_opt_gen_200, 'b',time1, accum_reward_opt_pred_200, 'g', time1, accum_reward_rand_200, 'r')
        str = sprintf("Akumulovaná odmìna: prvních 600 krokù");
        title(str)
        xlabel("Èas t")
        ylabel("Akumulovaná odmìna")
        legend("Opt strat s perfektním modelem","Opt strat s odhadnutým modelem","Náhodná strategie",'Location','northwest')
        xlim(x_lim)
        grid on

        subplot(3,3,[7,9])
        plot(time1, immediate_reward_opt_gen_200, 'bo', time1, immediate_reward_opt_pred_200, 'go', time1, immediate_reward_rand_200, 'ro')
        str = sprintf("Okamžitá odmìna");
        title(str)
        xlabel("Èas t")
        ylabel("Okamžitá odmìna")
        legend("Opt strat s perfektním modelem","Opt strat s odhadnutým modelem","Náhodná strategie",'Location','best','Orientation','horizontal')
        xlim(x_lim)
        grid on

        
        str = sprintf('Result for impression price: %.3f and 200 steps exploration',impression_price);
        sgtitle(str)

        pause
        
    f6 = figure(6);
    f6.Position = [monitor_x_size - fig_size_x 50 fig_size_x fig_size_y];
    
        subplot(2,3,[1,3])
        plot(time2, states_opt_gen_200, 'bo', time2, states_opt_pred_200, 'go', time2, states_rand_200, 'ro')
        str = sprintf("Stavy v èase t");
        title(str)
        xlabel("Èas t")
        ylabel("Stav")
        legend("Opt strat s perfektním modelem","Opt strat s odhadnutým modelem","Náhodná strategie",'Location','best','Orientation','horizontal')
        xlim(x_lim)
        grid on

        subplot(2,3,4)
        plot(time1, opt_strat_gen_200,'b*')
        title('Opt strat s perfektním modelem')
        xlabel("Èas t")
        ylabel("Akce")
        xlim(x_lim)
        grid on

        subplot(2,3,5)
        plot(time1, opt_strat_pred_200,'g*')
        title('Opt strat s odhadnutým modelem')
        xlabel("Èas t")
        ylabel("")
        xlim(x_lim)
        grid on

        subplot(2,3,6)
        plot(time1, rand_strat_200,'r*')
        title('Náhodná strategie')
        xlabel("Èas t")
        ylabel("")
        xlim(x_lim)
        grid on
        
        str = sprintf('Result for impression price: %.3f and 200 steps exploration',impression_price);
        sgtitle(str)   

        pause
        
    f7 = figure(7);
    f7.Position = [monitor_x_size - fig_size_x 50 fig_size_x fig_size_y];
    
        subplot(3,3,[1,3])
        plot(time1, accum_reward_opt_gen_200_rp, 'b',time1, accum_reward_opt_pred_200_rp, 'g', time1, accum_reward_rand_200_rp, 'r')
        str = sprintf("Akumulovaná odmìna");
        title(str)
        xlabel("Èas t")
        ylabel("Akumulovaná odmìna")
        legend("Opt strat s perfektním modelem","Opt strat s odhadnutým modelem","Náhodná strategie",'Location','northwest')
        grid on
        
        subplot(3,3,[4,6])
        plot(time1, accum_reward_opt_gen_200_rp, 'b',time1, accum_reward_opt_pred_200_rp, 'g', time1, accum_reward_rand_200_rp, 'r')
        str = sprintf("Akumulovaná odmìna: prvních 600 krokù");
        title(str)
        xlabel("Èas t")
        ylabel("Akumulovaná odmìna")
        legend("Opt strat s perfektním modelem","Opt strat s odhadnutým modelem","Náhodná strategie",'Location','northwest')
        xlim(x_lim)
        grid on

        subplot(3,3,[7,9])
        plot(time1, immediate_reward_opt_gen_200_rp, 'bo', time1, immediate_reward_opt_pred_200_rp, 'go', time1, immediate_reward_rand_200_rp, 'ro')
        str = sprintf("Okamžitá odmìna");
        title(str)
        xlabel("Èas t")
        ylabel("Okamžitá odmìna")
        legend("Opt strat s perfektním modelem","Opt strat s odhadnutým modelem","Náhodná strategie",'Location','best','Orientation','horizontal')
        xlim(x_lim)
        grid on

        
        str = sprintf('Result for random seeded impression price Seed: %u \n and 200 steps exploration.', seed);
        sgtitle(str);  

        pause
        
    f8 = figure(8);
    f8.Position = [monitor_x_size - fig_size_x 50 fig_size_x fig_size_y];
    
        subplot(2,3,[1,3])
        plot(time2, states_opt_gen_200_rp, 'bo', time2, states_opt_pred_200_rp, 'go', time2, states_rand_200_rp, 'ro')
        str = sprintf("Stavy v èase t");
        title(str)
        xlabel("Èas t")
        ylabel("Stav")
        legend("Opt strat s perfektním modelem","Opt strat s odhadnutým modelem","Náhodná strategie",'Location','best','Orientation','horizontal')
        xlim(x_lim)
        grid on

        subplot(2,3,4)
        plot(time1, opt_strat_gen_200_rp,'b*')
        title('Opt strat s perfektním modelem')
        xlabel("Èas t")
        ylabel("Akce")
        xlim(x_lim)
        grid on

        subplot(2,3,5)
        plot(time1, opt_strat_pred_200_rp,'g*')
        title('Opt strat s odhadnutým modelem')
        xlabel("Èas t")
        ylabel("")
        xlim(x_lim)
        grid on

        subplot(2,3,6)
        plot(time1, rand_strat_200_rp,'r*')
        title('Náhodná strategie')
        xlabel("Èas t")
        ylabel("")
        xlim(x_lim)
        grid on
        
        str = sprintf('Result for random seeded impression price Seed: %u and 200 steps exploration.', seed);
        sgtitle(str);  

        pause        
%     str = sprintf('Result for impression price: %.3f, number of auctions: %u, seed: %u \n Optimal strategy',impression_price, num_of_auctions, seed);
%     sgtitle(str);
    

%% Saving graphs
%     str = sprintf('graphs/%.3f_%u_%u_accum_immed_reward.png',impression_price, num_of_auctions, seed);
%     saveas(f1,str)
%     str = sprintf('graphs/%.3f_%u_%u_states_acts.png',impression_price, num_of_auctions, seed);
%     saveas(f2,str)
%     str = sprintf('graphs/%.3f_%u_%u_accum_immed_reward_rp.png',impression_price, num_of_auctions, seed);
%     saveas(f3,str)
%     str = sprintf('graphs/%.3f_%u_%u_states_acts_rp.png',impression_price, num_of_auctions, seed);
%     saveas(f4,str)
%     str = sprintf('graphs/%.3f_%u_%u_accum_immed_reward_200.png',impression_price, num_of_auctions, seed);
%     saveas(f5,str)
%     str = sprintf('graphs/%.3f_%u_%u_states_acts_200.png',impression_price, num_of_auctions, seed);
%     saveas(f6,str)
%     str = sprintf('graphs/%.3f_%u_%u_accum_immed_reward_200_rp.png',impression_price, num_of_auctions, seed);
%     saveas(f7,str)
%     str = sprintf('graphs/%.3f_%u_%u_acts_200_rp.png',impression_price, num_of_auctions, seed);
%     saveas(f8,str)

    
    
end
