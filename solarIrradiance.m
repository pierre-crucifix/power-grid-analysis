% Cette onciotn n'est pas notre production. Elle à été développée par
% l'équipe de DiSC est est accessible via l'url suivante : http://kom.aau.dk/project/SmartGridControl/DiSC/index.html

classdef solarIrradiance < handle
    %solarIrradiance implements a solar irradiance model.
    %   The solar irradiance model can be used to investigate the behavior
    %   of e.g., photovoltaic systems. The model is based on the work by
    %   Heinriich Morf (1998-2013) and the book: "An Introduction to Solar
    %   Radiation", 1983.
    %   
    %
    %	R. Pedersen 11-6-2014, Aalborg University
    
    properties
        lat = 57;       % [degree], latitude of location (57 = Aalborg)
        t = 0.75;       % [-], Transmittance
        p = 100;        % [Kpa], Air pressure
        Ts = 60;        % [sec], sampling time
        
        % Parameters based on data and system identification
        a = 0.221;      % [-], Ångström-Prescott parameter
        b = 0.667;      % [-], Ångström-Prescott parameter
        tau = 0.25;     % [-], Transmission factor of irradiance through clouds 
        
        % For filters
        LPyOld = 0;     % [-], place holder for low-pass filter
        LPtau = 20;     % [sec], low-pass filter time constant
        WFyOld = 0;     % [-], place holder for window filter output
        WFT = 60;       % [sec], window filter window
        WFuOld          % [-], place holder for windoe filter input
    end
    
    methods
        % Constructor
        function obj = solarIrradiance(param)
            % Param format
            % - param.lat           [degree]. Latitudal coordinate of system
            % - param.t             [-]. Transmittance at location
            % - param.p             [kPa]. Pressure at the location  
            % - param.Ts            [s]. Sampling time
            
            % Set parameters
            obj.lat = param.lat;
            obj.t = param.t;
            obj.p = param.p;
            obj.Ts = param.Ts;

            % Setup window filter
            if obj.Ts>obj.WFT
                obj.WFuOld = 0;
            else
                obj.WFuOld = zeros(1,ceil(obj.WFT/obj.Ts));
            end
        end
        
        % Sample model
        function Go = sample(obj,k,day,cc)
            % Input:
            %   k [-], is the sample number. Used for zenit angle
            %   day [-], is the Julian day of the year (1-365)
            %   cc [-], is cloud cover (0-1);
            %
            % Output:
            %   Go [w/m^2], is the irradiance on a horizontal surface.
            
            % Global beam and difuse irradiance
            cosz = zenitAngle(obj.lat,k,obj.Ts,day);
            m = optAirmass(cosz,obj.p);
            Gb = beamIrradiance(cosz,obj.t,m);
            Gd = diffuseIrradiance(cosz,obj.t,m);

            % Stochastic insolation 
            SIF = stochInsolFun(cc);
            
            % Total solar irradiation
            G = Gb*SIF + (1-cc)*Gd + cc*obj.tau*(Gb+Gd);
            Go = LPFilter(obj,G);
            if obj.Ts<obj.WFT
                Go = WFilter(obj,Go);
            end
        end
          
        % Low pass filter function (Own LP filter implemented)
        function y = LPFilter(obj,u)
            y = u*(obj.Ts/(obj.LPtau+obj.Ts)) + obj.LPyOld*(obj.LPtau/(obj.LPtau+obj.Ts));
            obj.LPyOld = y;
        end
        
        % Window filter function
        function y = WFilter(obj,u)
            y = obj.Ts/obj.WFT*u + obj.WFyOld - obj.Ts/obj.WFT* obj.WFuOld(end);
            obj.WFyOld = y;
            obj.WFuOld(2:end) = obj.WFuOld(1:end-1);
            obj.WFuOld(1) = u;
        end
        
        %% Set/get functions
        % Set Ångström-Prescott parameters
        function setAaPParam(obj,a,b)
            obj.a = a;
            obj.b = b;
            obj.tau = a/(a+b);  
        end
        
    end
    
end

%% Internal Functions
% Declination angle
function Ang = declinationAngle(day)
    % Input
    %   - day, is the julian day of the year
    %
    % Output
    %   - Ang [rad], is the declination angle in radians.
    
    % Two different methods of approximating the declenation angle is
    % provided. The latter one being the most precise.

    % Equation (1.3.3) from book
    Ang = 23.45*sin((360/365)*(284+day)*pi/180)*pi/180;
end
% Angle hour
function Ha = angleHour(k,Ts)
    Ha = (12-k/(60*60/Ts))*15*pi/180; % pi/180 to get it in rad [rad]
end
% Solar Zenit angle
function cosz = zenitAngle(lat,k,Ts,day)
    dAng = declinationAngle(day);
    Ha = angleHour(k,Ts);
    cosz = sin(lat*pi/180)*sin(dAng)+cos(lat*pi/180)*cos(dAng)*cos(Ha);
end
% Optical airmass
function m = optAirmass(cosz,p)
    m = p/(101.3*cosz);
    if m < 0
        m = 0;
    end
end
% Beam irradiation
function Gb = beamIrradiance(cosz,t,m)
    S = 1353;   % Solar constant from NASA
    Gb = S*cosz*t^m;
    if Gb < 0
        Gb = 0;
    end
end
% Diffuse irradiance
function Gd = diffuseIrradiance(cosz,t,m)
    S = 1353;   % Solar constant from NASA
    Gd = 0.3*(1-t^m)*S*cosz;
end
% Stochastic insolation function (SIF)
function SIF = stochInsolFun(cc)
    % Simulates the irradic behavior of clouds on irradiance 
    % Input:
    %   cc [-], is the cloud cover (0-1)
    %
    % Output:
    %   SIF [-], is the state, either 0 or 1
    r = rand(1);
    if r<cc
        SIF = 0;
    else
        SIF = 1;
    end
end

