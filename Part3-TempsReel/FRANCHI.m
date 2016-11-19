function listeRegistresOut = FRANCHI(listeRegistresIn,cplxBuffer,Fe,Ds,REF_LON,REF_LAT)
% Veuillez garder ce nom de fonction et cet ordre dans les param?tres

    registre_vide = struct ('adresse', [],'format',[],'type',[],'nom',[]...
                  ,'altitude',[],'timeFlag',[],'cprFlag',[]...
                  ,'latitude',[],'longitude',[],'trajectoire',[]);
    
    % A choisir
    % test pour 1 seconde
    abs_cplxBuffer =cplxBuffer;
    % pour le temps réel
    %abs_cplxBuffer = abs(cplxBuffer).^2;
    N=112;
    Fse = Fe/Ds;

    p=[-0.5*ones(1,Fse/2) 0.5*ones(1,Fse/2)];
    pa= fliplr(p);
    
    %initialisation

    listeRegistresOut=listeRegistresIn;
    
    treshold=0.7;

    % Recuperer les indexes de debut de trame ADS_B:
    index=tresholding(abs_cplxBuffer, treshold, Fse);

    % Extraire chaques trames potentielles
    for k=1:length(index)
        % Extraction des trames Vl(t)
        % on ne prends que des trames completes
        if((index(k)+N*Fse-1) < length(abs_cplxBuffer))
            vl=abs_cplxBuffer(index(k)+1:index(k)+N*Fse);
        end
        % filtrage adapte
        rl=conv(vl,pa);
        % echantillonnage
        rm=rl(Fse:Fse:length(rl));
        % Decision
        bk=decision_bk(rm);
        
        registre_tmp=bit2registre(registre_vide,bk,REF_LON, REF_LAT);

        % Si pas d'erreurs de  de CRC (si c'est pas vide)
        if isempty(registre_tmp.format)==0

            flag=0;

            % Aucun registre cree precedement
            if isempty(listeRegistresOut)
                listeRegistresOut=registre_tmp;
            else
                n=length(listeRegistresOut);
                for i=1:n
                    % si on a deja le meme avion dans la liste de registre
                    % on met simplement le registre a jour
                    if  strcmp(listeRegistresOut(i).adresse,registre_tmp.adresse)
                        listeRegistresOut(i) = update_reg(registre_tmp,listeRegistresOut(i)); %mettre a jours
                        flag=1;
                    end
                end
                % s'il n'existe pas du tout on l'ajoute
                if flag==0
                    listeRegistresOut=[listeRegistresOut registre_tmp];
                end
            end
        end
    end
end