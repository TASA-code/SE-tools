function [delta_v, delta_v_i, m_prop] = delta_v_calculation(h, di, m_init, Isp, option)

    R_E = 6378.137;
    g = 9.81;
    mu = 398600.4417;

    [h_init, h_final]  = deal(h(1), h(2));

    
    ri = h_init + R_E;
    rf = h_final + R_E;

    a = (ri+rf)/2;

    v_c1 = sqrt(mu/ri);
    v_t1 = sqrt(mu * (2/ri - 1/a));

    v_t2 = sqrt(mu * (2/rf - 1/a));
    v_c2 = sqrt(mu/rf);

    delta_v_h = (abs(v_t1 - v_c1) + abs(v_c2 - v_t2)) * 1000;
    

    if v_c1 > v_c2
        delta_v_i = 2*v_c2*sind(di/2)*1000;
    else
        delta_v_i = 2*v_c1*sind(di/2)*1000;
    end

    delta_v = delta_v_h + delta_v_i;



    m_prop = m_init * (1 - exp(-delta_v / (Isp*g)));

    if option == 1
        fprintf('-------------------------------------------\n')
        fprintf('| altitude ΔV       (m/s): %.4f\n', delta_v_h);
        fprintf('| inclination ΔV    (m/s): %.4f\n', delta_v_i);
        fprintf('| propellant mass    (kg): %.4f\n', m_prop);
        fprintf('-------------------------------------------\n')
    end


end
