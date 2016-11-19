clear all;close all; clc;

%% Initialisation des variables

registre = struct ('adresse', [],'format',[],'type',[],'nom',[]...
                  ,'altitude',[],'timeFlag',[],'cprFlag',[]...
                  ,'latitude',[],'longitude',[],'trajectoire',[]);
              
%%

load('trames_20141120.mat');
A=trames_20141120(:,1)';

%% La fonction bit2registre convertie une trame binaire en registre.
for i=1:21
    registre=bit2registre(registre,trames_20141120(:,i)')
end

%% La fonction plot_google_map affiche des longitudes/lattitudes en degr? d?cimaux,
MER_LON = -0.710648; % Longitude de l'a?roport de M?rignac
MER_LAT = 44.836316; % Latitude de l'a?roport de M?rignac

figure(1);
plot(MER_LON,MER_LAT,'.r','MarkerSize',20);% On affiche l'aeroport de Merignac sur la carte
text(MER_LON+0.05,MER_LAT,'Merignac airport','color','r')

title('Trajectoire de l avion');
xlabel('Longitude en degre');
ylabel('Lattitude en degre');

hold on;

%% Affichage d'un avion
PLANE_LON = registre.trajectoire(:,2); % Longitude de l'avion
PLANE_LAT = registre.trajectoire(:,1); % Latitude de l'avion

Id_airplane='AF-1214'; % Nom de l'avion
plot(PLANE_LON,PLANE_LAT,'r','MarkerSize',8);
plot(PLANE_LON(1),PLANE_LAT(1),'r','MarkerSize',8);
text(PLANE_LON(1)+0.005,PLANE_LAT(1),Id_airplane,'color','b');

%% Affichage de la carte
plot_google_map('MapType','terrain','ShowLabels',0) % On affiche une carte sans le nom des villes
