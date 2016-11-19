function [ registre  ] = update( new_registre, registre )
Code_FTC=new_registre.type;
if (Code_FTC>=9) && (Code_FTC<=22)
    % mise a jour du registre "vol"
         registre.adresse=new_registre.adresse;
         registre.format=new_registre.format;
         registre.type=new_registre.type;
         registre.altitude=new_registre.altitude;
         registre.timeFlag=new_registre.timeFlag;
         registre.cprFlag=new_registre.cprFlag;
         registre.latitude=new_registre.latitude;
         registre.longitude=new_registre.longitude;
        registre.trajectoire=[registre.trajectoire new_registre.trajectoire];
      
elseif (Code_FTC>=1) && (Code_FTC<=4)
        registre.adresse=new_registre.adresse;
        registre.format=new_registre.format;
        registre.type=new_registre.type;
        registre.nom=new_registre.nom;
        
   
end


end

