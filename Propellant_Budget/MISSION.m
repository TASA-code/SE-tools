clear; close all; clc;


% Spacecraft parameters
SC.LTDN = 10.25;  % in hours (10:15)
SC.mass = 400;
SC.Isp = 160;
SC.area = 4.65;
SC.CD = 2.0;

INSERT.h_err = 10;
INSERT.i_err = 0.1;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define MISSION

MISSION_PROFILE = {
    struct('life', 0, 'h', 500)
    struct('life', 3, 'h', 460) 
};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Mission_display(INSERT.h_err, MISSION_PROFILE);
[delta_v, m_prop] = Mission_Analysis(INSERT, MISSION_PROFILE, SC)