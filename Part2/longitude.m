function [ lon ] = longitude( rlon, CPR,lat)
% Calcul la longitude d'un avion ? partir d'une longitude de r?ference, d'une latitude et un
% morceaux de trame ADS-B.

%% Initialisation des variable

i=CPR;
Nb=17;
lon_ref=-0.60552610000002; % selon google map pour l'Enseirb
LON=floor(bi2de(fliplr(rlon)));

%% 1)
tmp=cprNL(lat)-i;
if (tmp>0)
    D_loni=360/tmp;
else
    D_loni=360;
end

%% 2)
m= floor(lon_ref/D_loni) + floor( 1/2 + ...
    (lon_ref-D_loni*floor(lon_ref/D_loni))/D_loni - LON/(2^Nb));

%% 3)
lon=D_loni*(m+LON/(2^Nb));

end

