clear all;close all; clc;
%test
Ts= 10^(-6);
Ds=1/Ts;
%REF_LAT = 44.80704679999999; 
%REF_LON = -0.60552610000002;
REF_LAT = 44.8291; 
REF_LON = -0.702779;

load('abs_cplxBuffer.mat');


listeRegistresOut  = [];

%%
for i=1:1
    listeRegistresOut = FRANCHI(listeRegistresOut,abs_cplxBuffer,Fe,Ds,REF_LON,REF_LAT);
end