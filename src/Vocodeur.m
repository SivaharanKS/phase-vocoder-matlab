%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VOCODEUR : Programme principal réalisant un vocodeur de phase 
% et permettant de :
%
% 1- modifier le tempo (la vitesse de "prononciation")
%   sans modifier le pitch (fréquence fondamentale de la parole)
%
% 2- modifier le pitch 
%   sans modifier la vitesse 
%
% 3- "robotiser" une voix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Récupération d'un signal audio
%--------------------------------

% [y,Fs]=audioread('Diner.wav');   %signal d'origine
 [y,Fs]=audioread('Extrait.wav');   %signal d'origine
% [y,Fs]=audioread('Halleluia.wav');   %signal d'origine

% Remarque : si le signal est en stéréo, ne traiter qu'une seule voie à la
% fois
y = y(:,1);

%% Courbes
%--------
N = length(y);
t = [0:N-1]/Fs;
f = [0:N-1]*Fs/N; f = f-Fs/2;

figure(1)
subplot(311),plot(t,y)
title('Signal original')
subplot(312),plot(f,abs(fftshift(fft(y))))
subplot(313),spectrogram(y,128,120,128,Fs,'yaxis')


%% Ecoute
%-------
disp('------------------------------------')
disp('SON ORIGINAL')
soundsc(y,Fs);

%-------------------------------
%% 1- MODIFICATION DE LA VITESSE
% (sans modification du pitch)
%-------------------------------
% PLUS LENT
rapp = 2/3;
ylent = PVoc(y,rapp,1024); 

% % % Ecoute
% % %-------
% disp('------------------------------------')
pause
disp('1- MODIFICATION DE LA VITESSE SANS MODIFIER LE PITCH')
% 
disp('Son en diminuant la vitesse sans modifier le pitch')
soundsc(ylent,Fs);

% Observation
%-------------
N = length(ylent);
t = [0:N-1]/Fs;
f = [0:N-1]*Fs/N; f = f-Fs/2;

figure(2)
subplot(311),plot(t,ylent)
title('Signal "plus lent"')
subplot(312),plot(f,abs(fftshift(fft(ylent))))
subplot(313),spectrogram(ylent,128,120,128,Fs,'yaxis')

% 
% % PLUS RAPIDE
rapp = 3/2;
yrapide = PVoc(y,rapp,1024); 


% Ecoute 
% %-------
pause
disp('Son en augmentant la vitesse sans modifier le pitch')
soundsc(yrapide,Fs);

% Observation
%-------------
N = length(yrapide);
t = [0:N-1]/Fs;
f = [0:N-1]*Fs/N; f = f-Fs/2;

figure(3)
subplot(311),plot(t,yrapide)
title('Signal "plus rapide"')
subplot(312),plot(f,abs(fftshift(fft(yrapide))))
subplot(313),spectrogram(yrapide,128,120,128,Fs,'yaxis')

%% === Comparaison des signaux (original / lent / rapide) ===

figure(4);

% Axe temporel pour chaque signal
t_orig   = (0:length(y)-1)/Fs;
t_lent   = (0:length(ylent)-1)/Fs;
t_rapide = (0:length(yrapide)-1)/Fs;

plot(t_orig, y, 'LineWidth', 1.2); hold on;
plot(t_lent, ylent, 'LineWidth', 1.2);
plot(t_rapide, yrapide, 'LineWidth', 1.2);

title('Comparaison signaux temporels : original / ralenti / accéléré');
xlabel('Temps (s)');
ylabel('Amplitude');
legend('Original', 'Plus lent', 'Plus rapide');
grid on;

%% === Spectre comparatif (original / lent / rapide) ===

figure(5);

% Calcul FFT et fréquence
N_orig = length(y);
N_lent = length(ylent);
N_rap  = length(yrapide);

f_orig = (-N_orig/2:N_orig/2-1)*Fs/N_orig;
f_lent = (-N_lent/2:N_lent/2-1)*Fs/N_lent;
f_rap  = (-N_rap/2:N_rap/2-1)*Fs/N_rap;

Y_orig = fftshift(abs(fft(y)));
Y_lent = fftshift(abs(fft(ylent)));
Y_rap  = fftshift(abs(fft(yrapide)));

plot(f_rap,  Y_rap /max(Y_rap),  'LineWidth', 1.2); hold on;
plot(f_lent, Y_lent/max(Y_lent), 'LineWidth', 1.2);
plot(f_orig, Y_orig/max(Y_orig), 'LineWidth', 1.2);

title('Spectre amplitude : original / lent / rapide');
xlabel('Fréquence (Hz)');
ylabel('Amplitude normalisée');
legend('Original', 'Plus lent', 'Plus rapide');
grid on;

%----------------------------------
%% 2- MODIFICATION DU PITCH
% (sans modification de vitesse)
%----------------------------------
% Paramètres généraux:
%---------------------
% Nombre de points pour la FFT/IFFT
Nfft = 256;

% Nombre de points (longueur) de la fenêtre de pondération 
% (par défaut fenêtre de Hanning)
Nwind = Nfft;

% 1.1- Augmentation 
%-------------------
a = 2;
b = 3;
yvoc = PVoc(y, a/b,Nfft,Nwind);

% Ré-échantillonnage du signal temporel afin de garder la même vitesse
ypitch1 = resample(yvoc,a,b);

%Somme de l'original et du signal modifié
%Attention : on doit prendre le même nombre d'échantillons
%Remarque : vous pouvez mettre un coefficient à ypitch pour qu'il
%intervienne + ou - dans la somme...
lmin = min(length(y),length(ypitch1));
ysomme = y(1:lmin)/max(abs(y(1:lmin))) + ypitch1(1:lmin)/max(abs(ypitch1(1:lmin)));

% % Ecoute
% %-------
% disp('------------------------------------')
pause
disp('2- MODIFICATION DU PITCH SANS MODIFIER LA VITESSE')
%  
disp('Son en augmentant le pitch sans modification de vitesse')
soundsc(ypitch1, Fs);
pause
disp('Somme du son original et du précédent')
soundsc(ysomme, Fs);

% Observation
%-------------
N = length(ypitch1);
t = [0:N-1]/Fs;
f = [0:N-1]*Fs/N; f = f-Fs/2;

figure(6)
subplot(311),plot(t,ypitch1)
title('Signal avec "pitch" augmenté')
subplot(312),plot(f,abs(fftshift(fft(ypitch1))))
subplot(313),spectrogram(ypitch1,128,120,128,Fs,'yaxis')

%% 1.2- Diminution 
%-----------------

a = 3;
b = 2;
yvoc = PVoc(y, a/b,Nfft,Nwind); 

% Ré-échantillonnage du signal temporel afin de garder la même vitesse
ypitch2 = resample(yvoc,a,b);  

%Somme de l'original et du signal modifié
%Attention : on doit prendre le même nombre d'échantillons
%Remarque : vous pouvez mettre un coefficient à ypitch pour qu'il
%intervienne + ou - dans la somme...
lmin = min(length(y),length(ypitch2));
ysomme = y(1:lmin)/max(abs(y(1:lmin))) + ypitch2(1:lmin)/max(abs(ypitch2(1:lmin)));

% Ecoute
%-------
 pause
 disp('Son en diminuant le pitch sans modification de vitesse')
 soundsc(ypitch2, Fs);
 pause
 disp('Somme du son original et du précédent')
 soundsc(ysomme, Fs);

% Observation
%-------------
N = length(ypitch2);
t = [0:N-1]/Fs;
f = [0:N-1]*Fs/N; f = f-Fs/2;

figure(7)
subplot(311),plot(t,ypitch2)
title('Signal avec "pitch" diminué')
subplot(312),plot(f,abs(fftshift(fft(ypitch2))))
subplot(313),spectrogram(ypitch2,128,120,128,Fs,'yaxis')

%% === Comparaison des signaux temporels (original / pitch augmenté / pitch diminué) ===

figure(8);

% Axe temporel pour chaque signal
t_orig   = (0:length(y)-1)/Fs;
t_p1     = (0:length(ypitch1)-1)/Fs;
t_p2     = (0:length(ypitch2)-1)/Fs;

plot(t_orig, y, 'LineWidth', 1.2); hold on;
plot(t_p1, ypitch1, 'LineWidth', 1.2);
plot(t_p2, ypitch2, 'LineWidth', 1.2);

title('Comparaison signaux temporels : original / pitch augmenté / pitch diminué');
xlabel('Temps (s)');
ylabel('Amplitude');
legend('Original', 'Pitch augmenté', 'Pitch diminué');
grid on;

%% === Spectre comparatif (original / pitch augmenté / pitch diminué) ===

figure(9);

% FFT
N_orig = length(y);
N_p1   = length(ypitch1);
N_p2   = length(ypitch2);

f_orig = (-N_orig/2:N_orig/2-1)*Fs/N_orig;
f_p1   = (-N_p1/2:N_p1/2-1)*Fs/N_p1;
f_p2   = (-N_p2/2:N_p2/2-1)*Fs/N_p2;

Y_orig = fftshift(abs(fft(y)));
Y_p1   = fftshift(abs(fft(ypitch1)));
Y_p2   = fftshift(abs(fft(ypitch2)));

% === ORDRE D’AFFICHAGE : du fond → avant-plan ===
plot(f_p1, Y_p1/max(Y_p1), 'LineWidth', 1.2); hold on;       
plot(f_p2, Y_p2/max(Y_p2), 'LineWidth', 1.2);                
plot(f_orig, Y_orig/max(Y_orig), 'LineWidth', 1.4);          

title('Spectre amplitude : original / pitch augmenté / pitch diminué');
xlabel('Fréquence (Hz)');
ylabel('Amplitude normalisée');
legend('Pitch augmenté', 'Pitch diminué', 'Original');
grid on;

%----------------------------
%% 3- ROBOTISATION DE LA VOIX
%-----------------------------
% Choix de la fréquence porteuse (2000, 1000, 500, 200)
Fc = 500; 

yrob = Rob(y,Fc,Fs);

% Ecoute
%-------
pause
disp('------------------------------------')
disp('3- SON "ROBOTISE"')
soundsc(yrob,Fs)

% Observation
%-------------
N = length(yrob);
t = [0:N-1]/Fs;
f = [0:N-1]*Fs/N; f = f-Fs/2;

figure(10)
subplot(311),plot(t,yrob)
title('Signal "robotisé"')
subplot(312),plot(f,abs(fftshift(fft(yrob))))
subplot(313),spectrogram(yrob,128,120,128,Fs,'yaxis')

%% === Comparaison des signaux temporels (original / robotisé) ===

figure(11);

% Axe temporel pour chaque signal
t_orig = (0:length(y)-1)/Fs;
t_rob  = (0:length(yrob)-1)/Fs;

plot(t_orig, y, 'LineWidth', 1.2); hold on;
plot(t_rob, yrob, 'LineWidth', 1.2);

title('Comparaison signaux temporels: original / robotisé');
xlabel('Temps (s)');
ylabel('Amplitude');
legend('Original', 'Robotisé');
grid on;

%% === Spectre comparatif (original / robotisé) ===

figure(12);

% FFT
N_orig = length(y);
N_rob  = length(yrob);

f_orig = (-N_orig/2:N_orig/2-1)*Fs/N_orig;
f_rob  = (-N_rob/2:N_rob/2-1)*Fs/N_rob;

Y_orig = fftshift(abs(fft(y)));
Y_rob  = fftshift(abs(fft(yrob)));

plot(f_orig, Y_orig/max(Y_orig), 'LineWidth', 1.2); hold on;
plot(f_rob,  Y_rob /max(Y_rob),  'LineWidth', 1.2);

title('Spectre amplitude : original / robotisé');
xlabel('Fréquence (Hz)');
ylabel('Amplitude normalisée');
legend('Original', 'Robotisé');
grid on;
