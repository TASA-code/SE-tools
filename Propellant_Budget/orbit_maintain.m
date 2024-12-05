function [delta_v, m_prop, i_final] = orbit_maintain(MISSION, SC, dL)

    % atmospheric model (rho = rho0*EXP(-(h_ellp-h0)/H)
    R_E = 6378.137;
    mu_E = 398600.4417;
    i_sun = 23.44;      % deg


    atm = readtable('atmosphere.xlsx', 'VariableNamingRule','preserve');
    lower_bounds = atm.base_altitude;
    upper_bounds = atm.altitude_max;
    density = atm.density;
    baseheight = atm.base_altitude;
    scaleH = atm.scale_height;

    for i = 1:length(lower_bounds)
        if (lower_bounds(i) < MISSION.h && upper_bounds(i) > MISSION.h) || ...
           (lower_bounds(i) == MISSION.h && upper_bounds(i) > MISSION.h)
            rho0 = density(i);
            h0 = baseheight(i);
            H = scaleH(i);
            break; % Stop after finding the first matching range
        end
    end
    
    
    h_ellp = MISSION.h;
    a = R_E+h_ellp;
    rho = rho0 * exp(-(h_ellp - h0)/H);
    BC = SC.mass/(SC.area*SC.CD);
     
    
    % theory
    dadt = -sqrt(mu_E*a) * (rho/BC) * 86400 * 1000;
    da = sqrt(-(2*a*dadt*dL)/(3*pi*R_E));
    maintain_freq = sqrt(-(8/3)*(a/(pi*R_E))*(dL/dadt));
    maintain_time = 365*MISSION.life/maintain_freq;


    n = rad2deg(sqrt(mu_E/(R_E+MISSION.h)^3))*86400;
    LTDN = deg2rad(SC.LTDN*15);
    didt = (3/16)*(0.9856^2/n)*sind(MISSION.i)*(1+cosd(i_sun))^2*sin(2.*LTDN)*365*MISSION.life;
    i_final = MISSION.i + didt;


    dv = delta_v_calculation([MISSION.h-da, MISSION.h+da],0, SC.mass, SC.Isp, 0);
    
    delta_v = dv*maintain_time;
    m_prop = SC.mass * (1 - exp(-delta_v / (SC.Isp*9.81)));
    

end