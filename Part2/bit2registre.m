function [ registre ] = bit2registre(registre, message)
% La fonction bit2registre convertie une trame binaire en registre.
% Cette fonction se veux intuitive et simple a comprendre elle n'est pas
% optimis?. 

assert(length(message)==112);

%% controle du CRC
hDet= crc.detector([1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1]);
[~,error] = detect(hDet, message');

%% Mise a jour du registre
if (error==0)
    disp('Pas d erreurs')
    
%Format de voie descendante (DF)
    DF=bi2de(fliplr(message(1:5)));
    if DF~=17 %message de type ADSB seulement
        disp('error : not ADSB')
        return;
    end
    
% Capacit? : non trait?

% Adresse OACI (AA)
    AA=dec2hex(bi2de(fliplr(message(9:32))));
    
% ADS_B (cas vol)
    ADSB=message(33:88);
    
    Code_FTC=bi2de(fliplr( ADSB(1:5) ));  % D?termine le registre ? utiliser 
    
    % compris entre 9 et 22 pour le vol
    if (Code_FTC>=9) && (Code_FTC<=22) && (Code_FTC~=19)
     

        ra=[ADSB(9:15) ADSB(17:20)];
        %ra=[ADSB(9:12) ADSB(14:20)];
        altitude=bi2de(fliplr(ra))*25-1000; % en pied

        UTC=ADSB(21);

        CPR=ADSB(22);

        rlat=ADSB(23:39);
        lat=latitude(rlat,CPR);

        rlon=ADSB(40:56);
        lon=longitude(rlon,CPR,lat);
        
        % mise a jour du registre "vol"
        registre.adresse=AA;
        registre.format=DF;
        registre.type=Code_FTC;
        registre.altitude=altitude;
        registre.timeFlag=UTC;
        registre.cprFlag=CPR;
        registre.latitude=lat;
        registre.longitude=lon;
        registre.trajectoire=[lat lon altitude; registre.trajectoire];
        disp('------------------------------------')
        disp(registre)
        disp('------------------------------------')
        
    % compris entre 1 et 4 pour l'identification
    elseif (Code_FTC>=1) && (Code_FTC<=4)
        caract=bit2car(ADSB(9:56));
        registre.adresse=AA;
        registre.format=DF;
        registre.type=Code_FTC;
        registre.nom=caract;
        
        disp('------------------------------------')
        disp(registre)
        disp('------------------------------------')
        
    % exit sinon (cas sol ou autre...)
    else 
        return
    end
   

else
    % disp('Erreur Crc')
    
end
end

