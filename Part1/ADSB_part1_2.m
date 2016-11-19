%% Grijol Guillaume    Franchi loic
clear all;close all; clc;

%% Initialisation des variables
Ts= 10^(-6);
Ds=1/Ts;
fe=20*10^6;
Te=1/fe;
Ns=112;
Fse=Ts/Te;

% onde biphase
p=[-0.5*ones(1,Fse/2) 0.5*ones(1,Fse/2)];
pa= fliplr(p);
% Energie de l'onde biphase
Ep=sum(p.^2);

TEB=zeros(1,11);

% Rapport signal a bruit
Eb_N0_dB=0:1:10;
Eb_N0=(10.^( Eb_N0_dB /10));

% calcul du TEB pour chaque valeur du RSB
for i=1:length(Eb_N0);
    nb_error=0;
    nb_paquets=0;
    
    % on veut au minimum 100 erreur sur 600 messages envoyés
    while (nb_error<1000 && nb_paquets<6000)
        
        b = randi([0,1],1,Ns);
        %% Emmetteur
        % on passe le bloc association bit/symboles
        a= -2*b + 1;
        % On reechantillonne a au temps Te.
        ss = upsample(a,Fse);
        sl = conv(ss,p) + 0.5;
       
        
        %% Canal
        % calcul de sigma pour le bruit
        sigma_a_2=var(a);
        sigma_2 = (sigma_a_2*Ep/2)*((Eb_N0(i)).^(-1));

        noise = sqrt(sigma_2)*randn(1,length(sl));
        yl=noise+sl;
        %yl = abs(yl).^2;
        %% Reception
        rl=conv(yl,pa); 
        % reechantillonage
        rln=rl(Fse:Fse:Ns*Fse); 
        
        % dans ce cas la comparer les symboles ou les bits revient au meme
        % pour le calcul du TEB
        An=decision(rln);

        nb_error=nb_error+sum(a~=An);
        nb_paquets=nb_paquets+1;


    end
    TEB(i)=nb_error/(length(a)*nb_paquets);
end
%% Figure de resultats
close all
%Pb=qfunc(sqrt(2*Eb_N0));
Pb=1/2.*erfc(sqrt(Eb_N0));
figure('units','normalized','position',[0 0 1 1])
semilogy(Eb_N0_dB,Pb);

hold on
semilogy(Eb_N0_dB, TEB,'r');

title('Probabilite d erreur binaire')
xlabel('Eb/No en dB')
ylabel('Pb');
legend('theorique','experimentale');