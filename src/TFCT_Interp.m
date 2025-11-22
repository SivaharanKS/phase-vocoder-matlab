function y = TFCT_Interp(X,t,Nov)

% y = TFCT_Interp(X, t, hop)   
% Interpolation du vecteur issu de la TFCT
%
% X : matrice issue de la TFCT
% t : vecteur des temps (valeurs réelles) sur lesquels on interpole
% Pour chaque valeur de t (et chaque colonne), on interpole le module du spectre 
% et on détermine la différence de phase entre 2 colonnes successives de X
% 
% y : la sortie est une matrice où chaque colonne correspond à l'interpolation de la colonne correspondante de X
% en préservant le saut de phase d'une colonne à l'autre
%
% programme largement inspiré d'un programme fait à l'université de Columbia


[nl,nc] = size(X);

% calcul de N = Nfft
N = 2*(nl-1);

% if nargin <3
%   % default value
%   Nov = N/2;
% end

% Initialisations
%-------------------
% Le spectre interpolé
y = zeros(nl, length(t));

% Phase initiale
ph = angle(X(:,1)); 

% Déphasage entre chaque échantillon de la TF
dphi = zeros(nl,1);
dphi(2:nl) = (2*pi*Nov)./(N./(1:(N/2)));

% Premier indice de la colonne interpolée à calculer 
% (première colonne de Y). Cet indice sera incrémenté
% dans la boucle
ind_col = 1;

% On ajoute à X une colonne de zéros pour éviter le problème de 
% X(col+1) en fin de boucle
X = [X,zeros(nl,1)];


% Boucle pour l'interpolation
%----------------------------
%Pour chaque valeur de t, on calcul la nouvelle colonne de Y à partir de 2
%colonnes successives de X

%% Votre programme commence ici

for n = 1:length(t)
    % Déterminer les indices des 2 colonnes de X à utiliser
    % col est la partie entière de t(n)
    col = floor(t(n));
    
    % Vérifier qu'on ne dépasse pas les limites
    if col < 1
        col = 1;
    end
    if col >= nc
        col = nc - 1;
    end
    
    % Calculer les coefficients d'interpolation
    % beta est la partie décimale de t(n)
    beta = t(n) - col;
    alpha = 1 - beta;
    
    % Interpolation du module
    Mag_interp = alpha * abs(X(:, col)) + beta * abs(X(:, col+1));
    
    % Calcul de la variation de phase
    % Différence de phase entre les deux colonnes
    dphi_mes = angle(X(:, col+1)) - angle(X(:, col)) - dphi;
    
    % Ramener dphi_mes dans l'intervalle [-pi, pi]
    dphi_mes = dphi_mes - 2*pi*round(dphi_mes/(2*pi));
    
    % Mise à jour de la phase
    ph = ph + dphi_mes + dphi;
    
    % Construction de la colonne de Y
    y(:, ind_col) = Mag_interp .* exp(1j * ph);
    
    % Incrémenter l'indice de colonne
    ind_col = ind_col + 1;
end

end