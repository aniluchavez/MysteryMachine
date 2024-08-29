function [Button_Scores, change_log] = GetScoresUpdateA(N_Arms, Change_Rng, Initialize)
    new_points = zeros(1, N_Arms);
    persistent means so_means prs_change_log 
    
    if ~exist("Initialize", "var"); Initialize = false; end
    
    if Initialize || isempty(means) || isempty(so_means) || isempty(prs_change_log)
        means = [randi([1, 100], 1, N_Arms - 1), randi([75, 100], 1, 1)];
        so_means = sort(means, 'ascend');  

        % Generate initial points from specified distributions
        for arm = 1:N_Arms
            if arm <= N_Arms - 2
                new_points(arm) = floor(normrnd(so_means(arm), 30));
            elseif arm == N_Arms - 1
                mu_right = log(so_means(end - 1) - 1);
                new_points(arm) = floor(lognrnd(mu_right, 0.5));
            else
                mu_left = log(so_means(end) - 1);
                new_points(arm) = floor(so_means(end) - lognrnd(mu_left, 0.15) * 5);
            end
        end     
        prs_change_log = false(N_Arms, 1); 
    else
        change_log_entry = false(N_Arms, 1); 
        for arm = 1:N_Arms
            if rand() < Change_Rng / 100
                means = [randi([1, 100], 1, N_Arms - 1), randi([75, 100], 1, 1)];
                so_means=sort(means,'ascend');% Redraw for all arms
                if arm <= N_Arms - 2
                    new_points(arm) = floor(normrnd(so_means(arm), 30));
                elseif arm == N_Arms - 1
                    mu_right = log(so_means(arm) - 1);
                    new_points(arm) = floor(lognrnd(mu_right, 0.5));
                else
                    mu_left = log(so_means(arm) - 1);
                    new_points(arm) = floor(so_means(arm) - lognrnd(mu_left, 0.15) * 5);
                end

                change_log_entry(arm) = true;  % Mark change
            end
        end
        
        % Adjust bounds again
     

        prs_change_log = [prs_change_log, change_log_entry];
    end

    Button_Scores = new_points;
   % Button_Scores([3, 4]) = Button_Scores([4, 3]);

    change_log = prs_change_log;
end
