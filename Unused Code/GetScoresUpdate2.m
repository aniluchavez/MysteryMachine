function [Button_Scores, change_log] = GetScoresUpdate2(N_Arms, Change_Rng, Initialize)
    persistent means new_means prs_change_log

    if ~exist("Initialize", "var"); Initialize = false; end

    if Initialize || isempty(means) || isempty(prs_change_log)
        % Initialize means ensuring they stay within [1, 100]
        means = [randi([40, 70], 1, N_Arms - 1), randi([80, 100], 1, 1)];
        
        % Generate new means from normal distributions
        new_means = zeros(1, N_Arms);
        for arm = 1:N_Arms
            if arm == N_Arms
                new_means(arm) = floor(normrnd(means(arm), 7.5));
                while new_means(arm) < 75 || new_means(arm) > 100
                    new_means(arm) = floor(normrnd(means(arm), 7.5));
                end
            else
                new_means(arm) = floor(normrnd(means(arm), 30));
                while new_means(arm) < 1 || new_means(arm) > 100
                    new_means(arm) = floor(normrnd(means(arm), 30));
                end
            end
        end

        prs_change_log = false(N_Arms, 1); % Initialize change log as false
    else
        change_log_entry = false(N_Arms, 1);
        % Update the means of the arms based on the given probability
        for arm = 1:N_Arms
            if rand() < Change_Rng / 100
                % Redraw the means within specified ranges
                means(arm) = floor(means(arm)); % Keep the current mean as a baseline
                
                if arm == N_Arms
                    new_means(arm) = floor(normrnd(means(arm), 7.5));
                    while new_means(arm) < 75 || new_means(arm) > 100
                        new_means(arm) = floor(normrnd(means(arm), 7.5));
                    end
                else
                    new_means(arm) = floor(normrnd(means(arm), 30));
                    while new_means(arm) < 1 || new_means(arm) > 100
                        new_means(arm) = floor(normrnd(means(arm), 30));
                    end
                end
                
                change_log_entry(arm) = true;
            end
        end
        prs_change_log = [prs_change_log, change_log_entry];
    end

    % Set Button Scores
    Button_Scores = new_means;

    % Introduce more variance by adding random noise to the scores
    noise = randi([-10, 10], 1, N_Arms); % You can adjust the range [-10, 10] as needed for more or less variance
    Button_Scores = Button_Scores + noise;
    
    % Ensure scores stay within the range of 1 to 100
    Button_Scores = max(min(Button_Scores, 100), 1);

    % Swap the third and fourth indices
    if N_Arms >= 4
        Button_Scores([3, 4]) = Button_Scores([4, 3]);
    end

    % Return the change log
    change_log = prs_change_log;
end
