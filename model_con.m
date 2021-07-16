function generated_model = model_con(ns,na, seed)
% MODEL_CON constructs a randomly generated model that simulates an online
% auction
%   INPUT:
%       ns = number of system states
%       na = number of actions
%       seed = seed for RNG, to recreate results
% 
%   OUTPUT:
%       generated_model = system transition model p(s_{t}|a_{t},s_{t-1})
% 
%
% created: JR 2021
%
% related to project "Bayesian estimation for adaptive dynamic decision making", BP J.Ruzheinikau

%% Initialisation
format long
generated_model = zeros(ns,na,ns); % initialising matrix for transition from s_{t-1},a_{t} -> s_{t}
                                   % read: zeros(s_{t},a_{t},s_{t-1})
sd = RandStream('dsfmt19937','Seed',seed); %using seed for RNG

%% System model
    if na <= ns % if number of actions is less than equal then fill the each matrix by column
        for s=1:ns %for each matrix
            counter1 = 1; %auxiliary variable for counting of sweeps through columns of each matrix
            for a=1:na %for each column of selected matrix
                %for each column fill the column with numbers such as the resulting matrix has ns on diagonal
                % for e.g.: ns=4, na = 4 
                %[4 3 2 1]
                %[3 4 3 2]
                %[2 3 4 3]
                %[1 2 3 4]
                counter2 = ns-counter1; %counter for moving diagonal at correct position after each sweep of a column
                for s1=1:counter1 %increase numbers until reaching diagonal
                    counter2 = counter2 + 1;
                    generated_model(s1,a,s) = counter2;
                end
                for s1=(counter1+1):ns %afterwards decrease numbers until the end of a column
                    counter2 = counter2 - 1;
                    generated_model(s1,a,s) = counter2;
                end
                generated_model(:,a,s) = generated_model(:,a,s)/sum(generated_model(:,a,s)); %normalizing the whole matrix so sum of each row is 1
                %e.g.:  
                %[0,4 0,3 0,2 0,1]
                %[0,3 0,4 0,3 0,2]
                %[0,2 0,3 0,4 0,3]
                %[0,1 0,2 0,3 0,4]
                counter1 = counter1 + 1; %increasing counter of sweeps through 
            end
            
        end
        
    else % if na > ns the process is identical with only difference being that the sweep are done through rows of each matrix
        % destinction of cases na <= ns and na > ns is required, because
        % sweaping through higher dimension of a matrix ensures it to be
        % filled the desired way (e.g. above)
        for s=1:ns
            counter1 = 1;
            for s1=1:ns %for each row of selected matrix
                counter2 = na-counter1;
                for a=1:counter1
                    counter2 = counter2 + 1;
                    generated_model(s1,a,s) = counter2;
                end
                for a=(counter1+1):na
                    counter2 = counter2 - 1;
                    generated_model(s1,a,s) = counter2;
                end
                counter1 = counter1 + 1;
            end
            for a=1:na
                generated_model(:,a,s) = generated_model(:,a,s)/sum(generated_model(:,a,s));
            end
        end
    end
    
    %adding a randomly generated real number from uniform distribution in range (-rand_range,rand_range)
    %to each element of each matrix to create a matrix of random elements with highest 
    %propability on diagonal, d is the lowest number of matrix for each s_{t-1}, this is
    %done to keep the patern of matrix described above
    rand_range = generated_model(ns-1,1,1); %choosing lowest number in the matrix
    d = (-rand_range + (rand_range+rand_range)*rand(sd,ns,na,ns)); %generating random matrix in range (-rand_range,rand_range)
    generated_model = abs(generated_model + d);
    for s=1:ns
        for a=1:na
            generated_model(:,a,s) = generated_model(:,a,s)/sum(generated_model(:,a,s)); %renormalizing so the element in each column sum to 1
        end
    end
    
%% Propability sum to one test

    for i=1:ns
        for j=1:na
            Sum = 0;
            for k=1:ns
                Sum = Sum + generated_model(k,j,i);
            end
            if Sum > 1 + 0.00000000001 || Sum < 1 - 0.00000000001
                s = Sum - eps;
                error("Values of propability distribution p(s_{t}|a_{t},s_{t-1}) does not sum to 1!")
            end
        end
    end
end