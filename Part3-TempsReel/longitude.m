function [ lon ] = longitude( rlon, CPR,lat, REF_LON)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

%% Initialisation des variable

i=CPR;
Nb=17;

LON=bi2de(fliplr(rlon));

%% 1)
tmp=cprNL(lat)-i;
if (tmp>0)
    D_loni=360/tmp;
elseif tmp==0
    D_loni=360;
end

%% 2)
m= floor(REF_LON/D_loni) + floor( 1/2 + mod(REF_LON, D_loni)/D_loni - LON/(2^Nb));
  %(REF_LON-D_loni*floor(REF_LON/D_loni))/D_loni - LON/(2^Nb));
%% 3)
lon=D_loni*(m+LON/(2^Nb));

end

