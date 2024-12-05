function [delta_v, m_prop] = Mission_Analysis(INSERT, mission, SC)


    R_E  = 6378.137;

    % Calculate inclination for each mission phase and store it
    for k = 1:length(mission)
        mission{k}.i = rad2deg(acos(-0.098922 * (1 + (mission{k}.h / R_E))^(7/2)));
    end

    
    % Error and target parameters
    h_insert = mission{1}.h + INSERT.h_err;
    i_insert = mission{1}.i + INSERT.i_err;

    % Initialize delta-v and propellant mass storage
    delta_v = struct();
    m_prop = struct();

    if mission{1}.life == 0
        di_target = abs(i_insert - mission{2}.i);
        [delta_v.insert, ~, m_prop.insert] = delta_v_calculation([h_insert, mission{2}.h], di_target, SC.mass, SC.Isp, 0);
    else
        % Adjust insertion error
        di_target = abs(i_insert - mission{1}.i);
        [delta_v.insert, ~, m_prop.insert] = delta_v_calculation([h_insert, mission{1}.h], di_target, SC.mass, SC.Isp, 0);
    end

    % Process each mission phase
    for k = 1:length(mission)
        if k == 1
            % Initial maintenance for the first mission phase
            [delta_v.(['maintain' num2str(k)]), m_prop.(['maintain' num2str(k)]), i_final] = orbit_maintain(mission{k}, SC, 100);
        else
            % Transfer between the previous and current mission phases
            if mission{1}.life ~= 0
                di = abs(mission{k}.i - i_final);
                [delta_v.(['transfer' num2str(k-1)]), ~, m_prop.(['transfer' num2str(k-1)])] = delta_v_calculation([mission{k-1}.h, mission{k}.h], di, SC.mass, SC.Isp, 0);
            end
            % Maintenance at the current mission phase
            [delta_v.(['maintain' num2str(k)]), m_prop.(['maintain' num2str(k)])] = orbit_maintain(mission{k}, SC, 100);
        end
    end
    
    % Total delta-v and propellant mass calculations
    delta_v.TOTAL = sum(cell2mat(struct2cell(delta_v)));
    disp(['Total Delta V: ', num2str(delta_v.TOTAL), ' m/s']);
    
    m_prop.TOTAL = sum(cell2mat(struct2cell(m_prop)));
    disp(['Total Propellant Mass: ', num2str(m_prop.TOTAL), ' kg']);

end