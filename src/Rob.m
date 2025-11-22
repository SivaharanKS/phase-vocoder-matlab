function yrob = Rob(y, fc, Fs)
% Rob : Robotisation de la voix par modulation de bande latérale
%
% y : signal d'entrée
% fc : fréquence de la porteuse (Hz)
% Fs : fréquence d'échantillonnage (Hz)
%
% yrob : signal robotisé

%% Mettez votre code ici

% vecteur temps
N = length(y);
t = (0:N-1)/Fs;

% porteuse complexe
c = exp(1i*2*pi*fc*t);

% modulation simple
y_complex = y(:).' .* c;

% partie réelle : robotisation
yrob = real(y_complex)';

% normalisation
yrob = yrob / max(abs(yrob)+1e-12);

end
