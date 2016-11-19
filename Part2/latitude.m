function [ lat ] = latitude( rlat,CPR )
% Calcul la latitude d'un avion ? partir d'une latitude de r?ference et un
% fragment de trame ADS-B.

%% Initialisation des variable
Nz=15;
i=CPR;
Nb=17;
lat_ref=44.80704679999999; % selon google map pour l'Enseirb 
LAT=floor(bi2de(fliplr(rlat)));

%% 1)
D_lati=360/(4*Nz-i);
%% 2)
j = floor(lat_ref/D_lati) +...
    floor( 1/2 + (lat_ref-D_lati*floor(lat_ref/D_lati))/D_lati - LAT/(2^Nb));
%% 3)
lat=D_lati*(j + LAT/(2^Nb));

end

