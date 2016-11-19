function [ registre ] = bit2registre(registre, message,REF_LON, REF_LAT)

    
    assert(length(message)==112);

    %% controle du CRC
    hDet= crc.detector([1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1]);
    [~,error] = detect(hDet, message');

    %% Mise a jour du registre
    if (error==0)

        DF=bi2de(fliplr(message(1:5)));
        if DF~=17
            disp('error : not ADSB')
            return;
        end

        AA=dec2hex(bi2de(fliplr(message(9:32))));

        ADSB=message(33:88);

        Code_FTC=bi2de(fliplr( ADSB(1:5) ));

        if (Code_FTC>=9) && (Code_FTC<=22) && (Code_FTC ~= 19)


            ra=[ADSB(9:15) ADSB(17:20)];

            altitude=bi2de(fliplr(ra))*25-1000;
            UTC=ADSB(21);

            CPR=ADSB(22);

            rlat=ADSB(23:39);
            lat=latitude(rlat,CPR,REF_LAT);

            rlon=ADSB(40:56);
            lon=longitude(rlon,CPR,lat,REF_LON);


            registre.adresse=AA;
            registre.format=DF;
            registre.type=Code_FTC;
            registre.altitude=altitude;
            registre.timeFlag=UTC;
            registre.cprFlag=CPR;
            registre.latitude=lat;
            registre.longitude=lon;
            tmp_traj = [lon; lat; altitude];
            registre.trajectoire=[tmp_traj registre.trajectoire];



        elseif (Code_FTC>=1) && (Code_FTC<=4)
            caract=bit2car(ADSB(9:56));
            registre.adresse=AA;
            registre.format=DF;
            registre.type=Code_FTC;
            registre.nom=caract;


        else 
            return
        end


    end
end

