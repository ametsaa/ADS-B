%% Grijol Guillaume    Franchi loic
clear all;close all; clc;

%% Initialisation des variables
Ts= 10^(-6);
Ds=1/Ts;
fe=20*10^6;
Te=1/fe;
Ns=1000;
Nfft=512;  
Fse=Ts/Te;

%messafe envoyé de Ns bits
b = randi([0,1],1,Ns);
% onde biphase
p=[-0.5*ones(1,Fse/2) 0.5*ones(1,Fse/2)];
time_axis_sl=0:Te:(25*Ts-Te);

% on passe le bloc association bit/symboles
a= -2*b + 1;
% On reechantillonne a au temps Te.
ss = upsample(a,Fse);
sl = conv(ss,p) + 0.5;

%% DSP
 window = 512; 
 [px_sl,fsl]= pwelch(sl,window,0,Nfft,fe,'centered');
% figure,
% semilogy(fsl,px_sl);


% axe des frequence
f=-fe/2:fe/(Nfft):fe/2 -1/Nfft;

DSP_t= 0.25*Ts*((sinc(f*Ts/2).*sin(pi*f*Ts/2)).^2);
% On ajoute le dirac
DSP_t(length(f)/2+1) = DSP_t(length(f)/2+1) + 0.25;



% Calcul de la DSP de facon experimentale
window=512;
% la fenetre est deplacé K fois
K = length(sl)/window;
DSP_moy=zeros(1,Nfft);

for i=1:K
    tmp_sl_window= sl((i-1)*window+1:i*window);
    tmp_dsp=abs(fftshift(fft(tmp_sl_window,Nfft).^2));
    DSP_moy = DSP_moy + tmp_dsp;
end
DSP_moy = DSP_moy/(K);
% normalisation
DSP_moy = DSP_moy/(Ns*fe/2);


%% Figure de resultats

figure('units','normalized','position',[0 0 1 1]);
% sl pour les 25 premier bits
plot(time_axis_sl,sl(1:Fse*25),'LineWidth',3);
title('25 premier bits de sl(t)');
xlabel('temps (us)');
ylabel('amplitude');

figure,
semilogy(f,DSP_t);
title('DSP de s_l(t) theorique')
xlabel('fréquence (Hz)');
ylabel('amplitude');

figure,
semilogy(f,DSP_moy);
title('DSP de s_l(t) experimentale')
xlabel('fréquence (Hz)');
ylabel('amplitude');

% sur meme figure
figure,
semilogy(f,DSP_t);

hold on
semilogy(f,DSP_moy);
title('DSP de s_l(t)')
xlabel('fréquence (Hz)');
ylabel('amplitude');
legend('Theorique','Experiementale');

