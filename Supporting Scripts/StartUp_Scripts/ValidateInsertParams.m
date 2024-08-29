% Function called by: InsertParams.m
% Role of function is to validate to validate all inserted parameters by the user. 
% If values are invalid they are updated. More parameters are also added.
% Parameters: 
%   - in_pars (struct that contains all inserted parameters)
% Return Values: None
function ValidateInsertParams(in_pars)
    load('colors.mat','color_list');
    
    %in_pars.screen extra variables (dependent on user-defined variables)
    in_pars.screen.custom_screen_ = false;         % dependent on start_point, height and width
    in_pars.screen.window = -1;                    % will be used to hold the window (-1 is a placeholder)
    in_pars.screen.center = [0,0];                 % will be used to represent the center of the window
    in_pars.screen.screen_width = 0;               % the width of the screen in which the window will be housed 
    in_pars.screen.screen_height = 0;              % the height of the screen in which the window will be housed 
    in_pars.screen.window_dims = [0,0];            % the dimensions of the window (combines width and height)    

    % in_pars.screen - VALUE EVALUATION
    % Evaluating color
    if ~isrgba(in_pars.screen.color)
        disp("Inoperable value provided for in_pars.screen.color. Applying default...");
        in_pars.screen.color = color_list.grey;
    end
    
    % Evaluating screen (must be within the acceptable range of the available Screens
    if ~isnat(in_pars.screen.screen) || in_pars.screen.screen > max(Screen('Screens'))
        disp("Inoperable value provided for in_pars.screen.screen. Applying default...");
        in_pars.screen.screen = max(Screen('Screens'));
    end

    % change the value of screen_width and screen_height based on the screen
    [in_pars.screen.screen_width, in_pars.screen.screen_height] = Screen('WindowSize', in_pars.screen.screen);
    
    % change the value of custom_screen_ based on the value of start_point 
    dims = [in_pars.screen.screen_width, in_pars.screen.screen_height];
    if ~isloc(in_pars.screen.start_point, dims)
        disp("Inoperable value provided for in_pars.screen.start_point. Applying default...");
        in_pars.screen.start_point = [0, 0];
    end
    
    % change the value of custom_screen_ based on the value of height and width
    make_custom_screen = isnat(in_pars.screen.window_height) && ...        
        isnat(in_pars.screen.window_width) && ...
        in_pars.screen.window_height <= in_pars.screen.screen_height && ...
        in_pars.screen.window_width <= in_pars.screen.screen_width;
    if make_custom_screen   
        disp("Custom Valus provided for Width and Length. Abandoning FullScreen Mode...");
        in_pars.screen.custom_screen_ = true;
    else 
        disp("Assuming FullScreen Mode.");
        [in_pars.screen.window_width, in_pars.screen.window_height] = Screen('WindowSize', in_pars.screen.screen);
    end

    % change the value of in_pars.screen.center, based on screen width and height
    in_pars.screen.center = [in_pars.screen.window_width / 2, in_pars.screen.window_height / 2];

    % change the value of in_pars.screen.window_dims
    in_pars.screen.window_dims = [in_pars.screen.window_width, in_pars.screen.window_height];


    %in_pars.text- VALUE EVALUATION
    % Get all the size parameters
    all_sizes = fieldnames(in_pars.text.size);
    for size_idx = 1:length(all_sizes)
        if ~isnat(in_pars.text.size.(all_sizes{size_idx}))
            disp(sprinf("Inoperable value provided for in_pars.target.size.%s. Applying default...",all_sizes{size_idx}));
            in_pars.text.size.(all_sizes{size_idx}) = 40;
        end
    end

    %in_pars.trial - VALUE EVALUATION
    % Evaluating show_intro
    if ~isscalar(in_pars.trial.show_intro) || ~islogical(in_pars.trial.show_intro)
        disp("Inoperable value provided for in_pars.trial.show_intro. Applying default...");
        in_pars.trial.show_intro = 20;
    end

    % Evaluating duration_s
    % if ~isnat(in_pars.trial.duration_s)
    %     disp("Inoperable value provided for in_pars.trial.duration_s. Applying default...");
    %     in_pars.trial.duration_s = 20;
    % end

    % Evaluating cpu_wait_s
    if ~isnumlist(in_pars.trial.cpu_wait_s, "whole") || in_pars.trial.cpu_wait_s(1) > in_pars.trial.cpu_wait_s(2)
        disp("Inoperable value provided for in_pars.trial.cpu_wait_s. Applying default...");
        in_pars.trial.cpu_wait_s = [2,4];
    end

    % Evaluating num
    if ~isnat(in_pars.trial.num)
        disp("Inoperable value provided for in_pars.trial.num. Applying default...");
        in_pars.trial.num = 0;
    end

    %Evaluating photodiode_dur_s
    if ~isnum(in_pars.trial.photodiode_dur_s) && in_pars.trial.photodiode_dur_s < 0
        disp("Inoperable value provided for in_pars.trial.photodiode_dur_s. Applying default...");
        in_pars.trial.photodiode_dur_s = 0.5;
    end

    % Extra variables for in_pars.trial.cpu_wait_s
    in_pars.trial.cpu_wait_dur = in_pars.trial.cpu_wait_s(2) - in_pars.trial.cpu_wait_s(1);


    %in_pars.target - VALUE EVALUATION
    button_names = ['Y', 'B', 'A', 'X'];

    % Evaluating target.radius_percent
    if ~isnat(in_pars.target.radius_percent) || in_pars.target.radius_percent > 100
        disp("Inoperable value provided for in_pars.trial.cpu_wait_s. Applying default...")
        in_pars.target.radius_percent = 100;
    end
 

    %Evaluating target.colors
    tch = height(in_pars.target.colors);
    for idx = 1:tch
        if ~isrgba(in_pars.target.colors(idx, :)) || tch ~= 4
            disp("Inoperable value provided for in_pars.target.colors. Applying default...")
            in_pars.target.colors = [color_list.yellow * 0.8; color_list.red * 0.8;...
                                     color_list.green * 0.8; color_list.blue * 0.8];
            break;
        end
    end

    % Evaluating target.scores
    if ~iswhole(in_pars.target.score_change_rng) || in_pars.target.score_change_rng > 100
        disp("Inoperable value provided for in_pars.target.score_change_rng. Applying default...");
        in_pars.target.score_change_rng = 30;
    end   

    % extra variables for in_pars.target
    x = in_pars.screen.window_width;
    w_height = in_pars.screen.window_height;
    y = w_height - in_pars.text.size.turn_order - in_pars.text.size.score_mode - in_pars.text.size.score_totals - 10;
    y_upper_offset = in_pars.text.size.turn_order + in_pars.text.size.score_mode + 10;
    % y_lower_offset = in_pars.text.size.score_totals;
    shorter_dist = min([sqrt( (x/4)^2 + (y/4)^2 ), x/2, y/2]);
    center_dist = min(x/2, y*tand(60)/2);
    
    radius = max(20, (shorter_dist/2)*(in_pars.target.radius_percent/100));
    coords = [x/2,                 (y/4   + y_upper_offset); 
              x/2 + center_dist/2, (y/2   + y_upper_offset); 
              x/2,                 (3*y/4 + y_upper_offset); 
              x/2 - center_dist/2, (y/2   + y_upper_offset)];
    rects = zeros(4,4);
    for idx = 1:4
        rects(idx,:) = [coords(idx, 1)-radius, coords(idx, 2)-radius, coords(idx, 1)+radius, coords(idx, 2)+radius];
    end
    
    ring_rects = rects+ [-10, -10, 10, 10];

    in_pars.target.button_names = button_names;
    in_pars.target.coords = coords;
    in_pars.target.rects = rects;
    in_pars.target.radius = radius;
    in_pars.target.ring_rects = ring_rects;

    % CREATING in_pars.parameters.avatars
    % Generating preliminary stuff
        % avatar width = one 6th of screen width
        % avatat height = one 4th of remaining screen height after score mode is shown     
    avatar_width = in_pars.screen.window_width / 6;
    avatar_height = (in_pars.screen.window_height - in_pars.text.size.score_totals - 10) / 4;
    avatar_ystart = in_pars.text.size.score_mode + 10;
    left_avatar_xstart = in_pars.screen.window_width - avatar_width;
    avatar_name_ystart = avatar_height-(in_pars.text.size.title+10);

    % Determine the dimensions for the player avatar
    player_rect = [0, avatar_ystart, avatar_width, avatar_ystart + avatar_height];
    player_textbox_rect = [0, avatar_ystart + avatar_name_ystart, avatar_width, avatar_ystart + avatar_height];
    player_gray_rect = [0, avatar_ystart, avatar_width, avatar_ystart + avatar_name_ystart];
    
    % Determine the dimensions for the CPU
    cpu_rect = [left_avatar_xstart, avatar_ystart, in_pars.screen.window_width, avatar_ystart + avatar_height];
    cpu_textbox_rect = [left_avatar_xstart, avatar_ystart + avatar_name_ystart, in_pars.screen.window_width, avatar_ystart + avatar_height];
    cpu_gray_rect = [left_avatar_xstart, avatar_ystart, in_pars.screen.window_width, avatar_ystart + avatar_name_ystart];

    % storing the values in in_pars.avatars
    in_pars.avatars.player_rect = player_rect;
    in_pars.avatars.player_textbox_rect = player_textbox_rect;
    in_pars.avatars.player_gray_rect = player_gray_rect;
    in_pars.avatars.cpu_rect = cpu_rect;
    in_pars.avatars.cpu_textbox_rect = cpu_textbox_rect;
    in_pars.avatars.cpu_gray_rect = cpu_gray_rect;
    in_pars.avatars.avatar_height = avatar_height;
    in_pars.avatars.avatar_width = avatar_width;
    in_pars.avatars.left_avatar_xstart = left_avatar_xstart;

    % in_pars.disbtn (disable buttons) - VALUE EVALUATION
    % Evaluating disbtn.player
    dpl = length(in_pars.disbtn.player);
    change_pb = false;
    if ~ischar(in_pars.disbtn.player)
        if ~isstring(in_pars.disbtn.player); change_pb = true;
        else; in_pars.disbtn.player = char(upper(in_pars.disbtn.player));
        end
    else; in_pars.disbtn.player = upper(in_pars.disbtn.player);
    end
    for idx = 1:dpl
        if ~contains(lower(button_names), lower(in_pars.disbtn.player(idx)))
            change_pb = true;
            break;
        end
    end

    if change_pb
        disp("Inoperable value provided for in_pars.disbtn.player. Applying default...");
        in_pars.disbtn.player = 'A';
    elseif ~isvector(in_pars.disbtn.player)
        disp("WARNING: empty string provided for in_pars.disbtn.player. Assuming this is done on purpose.")
        in_pars.disbtn.player = '0';
    end

    % Evaluating disbtn.cpu
    dcl = length(in_pars.disbtn.cpu);
    change_cb = false;
    if ~ischar(in_pars.disbtn.cpu)
        if ~isstring(in_pars.disbtn.cpu); change_cb = true;
        else; in_pars.disbtn.cpu = char(upper(in_pars.disbtn.cpu));
        end
    else; in_pars.disbtn.cpu = upper(in_pars.disbtn.cpu);
    end
    for idx = 1:dcl
        if ~contains(lower(button_names), lower(in_pars.disbtn.cpu(idx)))
            change_cb = true;
            break;
        end
    end
    if change_cb
        disp("Inoperable value provided for in_pars.disbtn.cpu. Applying default...");
        in_pars.disbtn.cpu = 'Y';
    elseif ~isvector(in_pars.disbtn.cpu)
        disp("WARNING: empty string provided for in_pars.disbtn.cpu. Assuming this is done on purpose.")
        in_pars.disbtn.cpu = '0';
    end
end




% Custom functions to make the code above more readable
%Checks if a value is a single number
function result = isnum(input)
    result = isscalar(input) && isnumeric(input);
end


%Checks if a value is a whole number (including 0 and positive integers)
function result = iswhole(input)
    % I define naturals as any number equal to or above 0
    result = isnum(input) && input >= 0 && round(input) == input;
end


%Checks if a value is a natural number (integers > 0)
function result = isnat(input)
    %Check if this is a number above 0
    result = isnum(input) && input > 0 && round(input) == input;
end

% Check if a value is composed of numbers
function result = isnumlist(input, Option)
    check_option = exist("Option", "var");
    if check_option
        check_option = check_option && (...
                        strcmpi(char(Option), 'num') || ...
                        strcmpi(char(Option), 'whole') || ...
                        strcmpi(char(Option), 'nat'));
    end
    if ~check_option; Option = 'num'; end

    result = isvector(input);
    try
        for idx = 1:length(input)
            if strcmpi(Option, 'num')
                result = result && isnum(input(idx));
            elseif strcmpi(Option, 'nat')
                result = result && isnat(input(idx));
            elseif strcmpi(Option, 'whole')
                result = result && iswhole(input(idx));
            else
                result = false;
            end
        end
    catch
        result = false;
    end
end

% Checks if a value is a vector pretaining to a specific color
function result = isrgba(input)
    % RGBA values are represented as vectors of 4 elements (numbers)
    result = isvector(input) && numel(input) == 4 && isnumlist(input, 'whole');

    % If this is a vector, check if every element is a whole number no greater than 255 
    if result
        for idx = 1:numel(input)
            if input(idx) > 255; result = false; end
        end
    end
end


function result = isloc(input, Dimensions)
    % Locations are vectors of x and y axes
    result = isvector(input) && numel(input) == 2 && isnumlist(input, 'whole');

    %Check if the values of the x and y axis are within the acceptable value for our screen  
    % [screen_width, screen_height] = Screen('WindowSize', Screen_Number);
    if result
        result = input(1)<Dimensions(1) && input(2)<Dimensions(2);
    end
end