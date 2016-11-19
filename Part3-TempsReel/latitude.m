function [ lat ] = latitude( rlat,CPR, REF_LAT )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%% Initialisation des variable
Nz=15;
i=CPR;
Nb=17;
LAT=floor(bi2de(fliplr(rlat)));

%% 1)
D_lati=360/(4*Nz-i);
%% 2)
k = floor(REF_LAT/D_lati) +...
    floor( 1/2 + mod(REF_LAT, D_lati)/D_lati - LAT/(2^Nb));
    %floor( 1/2 + (REF_LAT-D_lati*floor(REF_LAT/D_lati))/D_lati - LAT/(2^Nb));
%% 3)
lat=D_lati*(k + LAT/(2^Nb));

end

