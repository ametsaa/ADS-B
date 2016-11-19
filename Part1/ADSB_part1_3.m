%% Grijol Guillaume    Franchi loic
clear all;close all; clc;

%% Initialisation des variables
Ts= 10^(-6);
Ds=1/Ts;
fe=20*10^6;
Te=1/fe;
Nb=300;
Ns=112;
Fse=Ts/Te;

% onde biphase
p=[-0.5*ones(1,Fse/2) 0.5*ones(1,Fse/2)];
pa= fliplr(p);
% Energie de l'onde biphase
Ep=sum(abs(p).^2);


TEB=zeros(1,11);

% Rapport signal a bruit
Eb_N0_dB=0:1:10;
Eb_N0=(10.^( Eb_N0_dB /10));

% mise en place de sp
Tp = 8*10^-6;
up=ones(1,Fse/2);
down=zeros(1,Fse/2);
sp=[up down up down down down down up down up down down down down down down];
% Calcul de la composante de normalisation de Sp
sp_norm = sqrt(sum(sp.^2));
%time_axis_sp=0:Te:(Fse*Te*8 - Te);
%plot(time_axis_sp, sp);



for i=1:length(Eb_N0);
    nb_error_tot=0;
    Nb_message=0;
    
    while (nb_error_tot<1000 && Nb_message<6000)
        
        b = randi([0,1],1,Ns);
        % on passe le bloc association bit/symboles
        a= -2*b + 1;
        % On reechantillonne a au temps Te.
        ss = upsample(a,Fse);
        sl = conv(ss,p) + 0.5;
      
        % Prise en compte du préambule
        sl = [sp sl];
        % Prise en compte du delai de propagation delata_t
        % En Te nous avons un point, prenons un delai de propagation entre 0 et
        % 100Te soit un nombre de point entre 0 et 100
        nb_pts_delta_t = randi(101) -1;
        delta_t = zeros(1,nb_pts_delta_t);
        % delais de propagation pour sl
        sl = [ delta_t sl ];

        % calcul de sigma pour le bruit
        %sigma_a_2=var(a);
        sigma_a_2 = var(a);
        sigma_2= (sigma_a_2*Ep/2)*((Eb_N0(i)).^(-1));
        noise = sqrt(sigma_2)*randn(1,length(sl));
        
        %Prise en compte du decalage en frequence
        delta_f = randi(2001) -1 -1000;
        t=(0:Te:(length(sl)-1)*Te)*Ds;
        
        sl=sl.*exp(-1i*2*pi*delta_f*t);
        yl=noise+sl;
        vl = abs(yl).^2;
        %vl =yl;
        % algorithme de synchronisation
        delta_t2 = length(vl);
        nb_pts_Tp = Fse*8; % car time_Tp = Fse*8*Ts
        index=0;
        max=0;
        for j=0:delta_t2-nb_pts_Tp
            intercorr = sum(vl(1+j:j+nb_pts_Tp).*sp);
            vl_norm = sqrt(sum(vl(1+j:j+nb_pts_Tp).^2));
            intercorr_norma = intercorr / (sp_norm*vl_norm);
            if (max < intercorr_norma)
                max = intercorr_norma;
                % on ne prends pas en compte le préambule
                index = j + nb_pts_Tp;
            end
        end
        
        %% Reception
        
        rl=conv(vl,pa);
        
        rln=rl(index+Fse:Fse:length(rl));  
        An=decision(rln);
        % la taille de An n'est pas toujours identique a celle de a
        % on calcule le nombre d'erreur en conséquence
        N2=length(An);
        if(length(a) < N2)
            nb_error_tot=nb_error_tot+sum(a~=An(1:Ns));
        else
           nb_error_tot=nb_error_tot+sum(a(1:N2)~=An);  
        end

        Nb_message=Nb_message+1;


    end
    TEB(i)=nb_error_tot/(length(a)*Nb_message);
end

%% Figure de resultats
close all

Pb=qfunc(sqrt(2*Eb_N0));

figure('units','normalized','position',[0 0 1 1])
semilogy(Eb_N0_dB,Pb);

hold on
semilogy(Eb_N0_dB, TEB,'r');

title('Probabilite d erreur binaire avec erreur de synchronisation')
xlabel('Eb/No en dB')
ylabel('Pb');
legend('theorique','experimentale');