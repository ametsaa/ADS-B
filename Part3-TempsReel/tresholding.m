function [ index ] = tresholding( vl,treshold,Fse )
%% pr?ambule
up=ones(1,Fse/2);
down=zeros(1,Fse/2);
Sp=[up down up down down down down up down up down down down down down down];
%% Calcul de la composante de normalisation de Sp
Sp_norm = sqrt(sum(abs(Sp).^2));
delta_t2 = length(vl);
nb_pts_Tp = Fse*8;



%% code en commentaitre fonctionnel mais plus long
% 
% index=[];
% 
% for j=0:delta_t2-nb_pts_Tp
%     intercorr = sum(vl(1+j:j+nb_pts_Tp).*Sp);
%     vl_norm = sqrt(sum(abs(vl(1+j:j+nb_pts_Tp)).^2));
%     intercorr_norma = intercorr / (Sp_norm*vl_norm);
%     if (intercorr_norma>treshold)
%         index = [index j+nb_pts_Tp];
%     end
% end

% sync rapide
   intercorr = conv(vl, fliplr(Sp));
   intercorr_norma = Sp_norm*sqrt(conv(abs(vl).^2, ones(1, floor(nb_pts_Tp))));
   rho = intercorr./intercorr_norma;
   [~, index] = findpeaks(rho, 'MINPEAKHEIGHT', treshold);

end

