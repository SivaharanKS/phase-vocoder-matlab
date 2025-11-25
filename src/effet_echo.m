function yecho = effet_echo(y, Fs, delay_ms, alpha)
% Effet echo basique : copie retardée et atténuée
% y : signal original
% Fs : fréquence d’échantillonnage
% delay_ms : retard en millisecondes
% alpha : coefficient d’atténuation

delay = round((delay_ms/1000) * Fs);
yecho = y;

if length(y) > delay
    yecho(delay+1:end) = yecho(delay+1:end) + alpha * y(1:end-delay);
end

% Normalisation
yecho = yecho / max(abs(yecho));
end
