function Mission_display(h_err, MISSION_PROFILE)

    % Initialize an empty string
    mission_display = '';
    mission_display = [mission_display, sprintf('%d(%s)', MISSION_PROFILE{1}.h+h_err, 'Insert')];
    mission_display = [mission_display, ' -> '];

    % Loop through each mission phase to create the formatted string
    for k = 1:length(MISSION_PROFILE)

        % Append the current phase's altitude and life to the string
        mission_display = [mission_display, sprintf('%d(%.1f)', MISSION_PROFILE{k}.h, MISSION_PROFILE{k}.life)];
        
        % Add an arrow if this is not the last phase

        if k < length(MISSION_PROFILE)
            mission_display = [mission_display, ' -> '];
        end
    end

    disp('-------------------------')
    disp(mission_display);
    disp('-------------------------')
end

