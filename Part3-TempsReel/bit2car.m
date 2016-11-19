function [ caract ] = bit2car( vect )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
array=[ 'A','B','C','D','E','F',...
            'G','H','I','J','K','L','M','N',...
            'O','P','Q','R','S','T','U','V','W','X','Y','Z'];
caract='';
for i=0:7
    vect_6=bi2de(fliplr(vect(1+6*i:6*(i+1)))); 
    if (vect_6<=26) % lettre
        tmp=array(vect_6);
    elseif (vect_6==32)
        tmp=' ';
    elseif (vect_6>=48) && (vect_6<=57) % chiffre
        tmp=int2str(vect_6-48);
    end
    caract=strcat(caract,tmp);
end
end

