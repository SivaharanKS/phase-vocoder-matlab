function Vocodeur_App
% Interface graphique pour tester les effets du vocodeur

%% -----------------------------------------------------------
% VARIABLES INTERNES
%% -----------------------------------------------------------
Fs = []; 
y = []; 
y_orig = []; 
filename = '';

speed_on = false;
pitch_on = false;
robot_on = false;
echo_on = false;
reverse_on = false;

speed_val = 1.0;     % 0.5 -> 2
pitch_val = 1.0;     % 0.5 -> 2
Fc = 500;            % valeur par défaut

% chemins des fichiers audio
path_extrait = 'Extrait.wav';
path_diner   = 'Diner.wav';
path_halle   = 'Halleluia.wav';

%% -----------------------------------------------------------
% CREATION DE LA FENETRE PRINCIPALE
%% -----------------------------------------------------------
h.fig = figure('Name','Interface Vocodeur',...
    'NumberTitle','off','MenuBar','none','ToolBar','none',...
    'Position',[200 200 900 520]);

%% -----------------------------------------------------------
% PANEL GAUCHE : CHOIX DU SON
%% -----------------------------------------------------------
uipanel('Title','Choix du son','FontSize',10,'Position',[0.01 0.55 0.28 0.44]);

uicontrol('Style','pushbutton','String','Charger Extrait.wav',...
    'Units','normalized','Position',[0.02 0.75 0.26 0.06],...
    'Callback',@cbLoadExtrait);

uicontrol('Style','pushbutton','String','Charger Diner.wav',...
    'Units','normalized','Position',[0.02 0.68 0.26 0.06],...
    'Callback',@cbLoadDiner);

uicontrol('Style','pushbutton','String','Charger Halleluia.wav',...
    'Units','normalized','Position',[0.02 0.61 0.26 0.06],...
    'Callback',@cbLoadHalle);

uicontrol('Style','pushbutton','String','Importer fichier...',...
    'Units','normalized','Position',[0.02 0.54 0.26 0.06],...
    'Callback',@cbImport);

h.txtFile = uicontrol('Style','text','String','Aucun fichier chargé',...
    'Units','normalized','Position',[0.02 0.50 0.26 0.03],...
    'HorizontalAlignment','left');

%% -----------------------------------------------------------
% PANEL MILIEU : SELECTION DES EFFETS
%% -----------------------------------------------------------
uipanel('Title','Effets','FontSize',10,'Position',[0.30 0.55 0.34 0.44]);

h.chkSpeed = uicontrol('Style','checkbox','String','Vitesse',...
    'Units','normalized','Position',[0.31 0.83 0.20 0.06],...
    'Callback',@cbToggleSpeed);

h.chkPitch = uicontrol('Style','checkbox','String','Pitch',...
    'Units','normalized','Position',[0.47 0.83 0.20 0.06],...
    'Callback',@cbTogglePitch);

h.chkRobot = uicontrol('Style','checkbox','String','Robotisation',...
    'Units','normalized','Position',[0.31 0.75 0.20 0.06],...
    'Callback',@cbToggleRobot);

h.chkEcho = uicontrol('Style','checkbox','String','Echo',...
    'Units','normalized','Position',[0.47 0.75 0.20 0.06],...
    'Callback',@cbToggleEcho);

h.chkReverse = uicontrol('Style','checkbox','String','Reverse',...
    'Units','normalized','Position',[0.31 0.67 0.20 0.06],...
    'Callback',@cbToggleReverse);

% Slider vitesse
uicontrol('Style','text','String','Vitesse (0.5 à 2)',...
    'Units','normalized','Position',[0.30 0.60 0.18 0.04],...
    'HorizontalAlignment','left');

h.sldSpeed = uicontrol('Style','slider','Min',0.5,'Max',2,'Value',1,...
    'Units','normalized','Position',[0.30 0.56 0.32 0.035],...
    'Callback',@cbSpeedSlider);

h.txtSpeedVal = uicontrol('Style','text','String','1.00',...
    'Units','normalized','Position',[0.63 0.56 0.05 0.035]);

% Slider pitch
uicontrol('Style','text','String','Pitch (0.5 à 2)',...
    'Units','normalized','Position',[0.30 0.50 0.18 0.04],...
    'HorizontalAlignment','left');

h.sldPitch = uicontrol('Style','slider','Min',0.5,'Max',2,'Value',1,...
    'Units','normalized','Position',[0.30 0.46 0.32 0.035],...
    'Callback',@cbPitchSlider);

h.txtPitchVal = uicontrol('Style','text','String','1.00',...
    'Units','normalized','Position',[0.63 0.46 0.05 0.035]);

%% -----------------------------------------------------------
% PANEL DROITE : ROBOTISATION + BOUTON RUN
%% -----------------------------------------------------------
uipanel('Title','Robotisation / Simulation','FontSize',10,'Position',[0.65 0.55 0.34 0.44]);

uicontrol('Style','text','String','Fréquence porteuse Fc (Hz)',...
    'Units','normalized','Position',[0.66 0.88 0.30 0.04],...
    'HorizontalAlignment','left');

h.btnFc200 = uicontrol('Style','togglebutton','String','200',...
    'Units','normalized','Position',[0.67 0.83 0.10 0.05],...
    'Callback',@cbSetFc200);

h.btnFc500 = uicontrol('Style','togglebutton','String','500',...
    'Units','normalized','Position',[0.78 0.83 0.10 0.05],...
    'Callback',@cbSetFc500);

h.btnFc1000 = uicontrol('Style','togglebutton','String','1000',...
    'Units','normalized','Position',[0.67 0.77 0.10 0.05],...
    'Callback',@cbSetFc1000);

h.btnFc2000 = uicontrol('Style','togglebutton','String','2000',...
    'Units','normalized','Position',[0.78 0.77 0.10 0.05],...
    'Callback',@cbSetFc2000);

h.btnRun = uicontrol('Style','pushbutton','String','Lancer la simulation',...
    'Units','normalized','Position',[0.70 0.66 0.24 0.08],...
    'BackgroundColor',[0.2 0.8 0.2],'Callback',@cbRun);

h.btnPlayOriginal = uicontrol('Style','pushbutton','String','Jouer original',...
    'Units','normalized','Position',[0.67 0.56 0.12 0.05],...
    'Callback',@cbPlayOriginal);

h.btnPlayProcessed = uicontrol('Style','pushbutton','String','Jouer traité',...
    'Units','normalized','Position',[0.80 0.56 0.12 0.05],...
    'Callback',@cbPlayProcessed);

h.txtStatus = uicontrol('Style','text','String','Statut : prêt',...
    'Units','normalized','Position',[0.66 0.48 0.32 0.04],...
    'HorizontalAlignment','left');

guidata(h.fig,h);

%% =======================================================================
% CALLBACKS : CHARGEMENT DES SONS
%% =======================================================================

function cbLoadExtrait(src,~)
    h = guidata(src);
    [y, Fs] = audioread('Extrait.wav');
    h.y = y; h.y_orig = y; h.Fs = Fs; h.filename = 'Extrait.wav';
    set(h.txtFile,'String','Extrait.wav chargé');
    guidata(src,h);
end

function cbLoadDiner(src,~)
    h = guidata(src);
    [y, Fs] = audioread('Diner.wav');
    h.y = y; h.y_orig = y; h.Fs = Fs; h.filename = 'Diner.wav';
    set(h.txtFile,'String','Diner.wav chargé');
    guidata(src,h);
end

function cbLoadHalle(src,~)
    h = guidata(src);
    [y, Fs] = audioread('Halleluia.wav');
    h.y = y; h.y_orig = y; h.Fs = Fs; h.filename = 'Halleluia.wav';
    set(h.txtFile,'String','Halleluia.wav chargé');
    guidata(src,h);
end

function cbImport(src,~)
    h = guidata(src);
    [file, path] = uigetfile({'*.wav'},'Importer un fichier audio');
    if file == 0, return; end
    [y, Fs] = audioread(fullfile(path,file));
    h.y = y; h.y_orig = y; h.Fs = Fs; h.filename = file;
    set(h.txtFile,'String',[file ' chargé']);
    guidata(src,h);
end


%% =======================================================================
% CALLBACKS : ACTIVATION DES EFFETS
%% =======================================================================

function cbToggleSpeed(src,~)
    h = guidata(src);
    h.speed_on = get(src,'Value');
    guidata(src,h);
end

function cbTogglePitch(src,~)
    h = guidata(src);
    h.pitch_on = get(src,'Value');
    guidata(src,h);
end

function cbToggleRobot(src,~)
    h = guidata(src);
    h.robot_on = get(src,'Value');
    guidata(src,h);
end

function cbToggleEcho(src,~)
    h = guidata(src);
    h.echo_on = get(src,'Value');
    guidata(src,h);
end

function cbToggleReverse(src,~)
    h = guidata(src);
    h.reverse_on = get(src,'Value');
    guidata(src,h);
end


%% =======================================================================
% CALLBACKS : SLIDERS
%% =======================================================================

function cbSpeedSlider(src,~)
    h = guidata(src);
    val = get(src,'Value');
    h.speed_val = val;
    set(h.txtSpeedVal,'String',sprintf('%.2f',val));
    guidata(src,h);
end

function cbPitchSlider(src,~)
    h = guidata(src);
    val = get(src,'Value');
    h.pitch_val = val;
    set(h.txtPitchVal,'String',sprintf('%.2f',val));
    guidata(src,h);
end


%% =======================================================================
% CALLBACKS : BOUTONS Fc
%% =======================================================================

function resetFcButtons(h)
    set(h.btnFc200,'Value',0);
    set(h.btnFc500,'Value',0);
    set(h.btnFc1000,'Value',0);
    set(h.btnFc2000,'Value',0);
end

function cbSetFc200(src,~)
    h = guidata(src);
    resetFcButtons(h);
    set(src,'Value',1);
    h.Fc = 200;
    guidata(src,h);
end

function cbSetFc500(src,~)
    h = guidata(src);
    resetFcButtons(h);
    set(src,'Value',1);
    h.Fc = 500;
    guidata(src,h);
end

function cbSetFc1000(src,~)
    h = guidata(src);
    resetFcButtons(h);
    set(src,'Value',1);
    h.Fc = 1000;
    guidata(src,h);
end

function cbSetFc2000(src,~)
    h = guidata(src);
    resetFcButtons(h);
    set(src,'Value',1);
    h.Fc = 2000;
    guidata(src,h);
end


%% =======================================================================
% CALLBACK : LECTURE AUDIO
%% =======================================================================

function cbPlayOriginal(src,~)
    h = guidata(src);
    if isempty(h.y_orig), return; end
    sound(h.y_orig, h.Fs);
end

function cbPlayProcessed(src,~)
    h = guidata(src);
    if isempty(h.y), return; end
    sound(h.y, h.Fs);
end


%% =======================================================================
% CALLBACK : RUN / SIMULATION
%% =======================================================================

function cbRun(src,~)
    h = guidata(src);
    if isempty(h.y)
        set(h.txtStatus,'String','Aucun son chargé !');
        return;
    end

    y = h.y_orig;  % point de départ

    % --- Vitesse ---
    if h.speed_on
        y = TimeStretch(y, h.speed_val); % fonction à créer
    end

    % --- Pitch ---
    if h.pitch_on
        y = PitchShift(y, h.pitch_val); % fonction à créer
    end

    % --- Robotisation ---
    if h.robot_on
        y = Rob(y, h.Fc, h.Fs);
    end

    % --- Echo ---
    if h.echo_on
        y = effet_echo(y, h.Fs, 250, 0.6);
    end

    % --- Reverse ---
    if h.reverse_on
        y = flipud(y);
    end

    h.y = y;
    set(h.txtStatus,'String','Traitement terminé');
    guidata(src,h);

    plotResults(h.y_orig, y, h.Fs);
end


%% =======================================================================
% FONCTIONS : EFFETS TEMPS / PITCH (à compléter par toi)
%% =======================================================================

function y2 = TimeStretch(y, alpha)
    % Vitesse = interpolation simple
    L = length(y);
    t_old = (1:L);
    t_new = linspace(1, L, round(L/alpha));
    y2 = interp1(t_old, y, t_new,'linear')';
end

function y2 = PitchShift(y, alpha)
    % Pitch = resampling simple
    y2 = resample(y, alpha*1000, 1000);
end

%% =======================================================================
% AFFICHAGE DES RÉSULTATS DANS UNE FENÊTRE SÉPARÉE
%% =======================================================================

function plotResults(y_orig, y_proc, Fs)

    figure('Name','Analyse du signal','NumberTitle','off');

    % Domaine temporel
    subplot(3,1,1);
    t1 = (0:length(y_orig)-1)/Fs;
    t2 = (0:length(y_proc)-1)/Fs;
    plot(t1, y_orig, 'b'); hold on;
    plot(t2, y_proc, 'r');
    title('Signal temporel : original vs traité');
    xlabel('Temps (s)');
    ylabel('Amplitude');
    legend('Original','Traité');

    % Spectre
    subplot(3,1,2);
    Y1 = abs(fftshift(fft(y_orig)));
    Y2 = abs(fftshift(fft(y_proc)));
    f1 = linspace(-Fs/2, Fs/2, length(Y1));
    f2 = linspace(-Fs/2, Fs/2, length(Y2));
    plot(f1, Y1/max(Y1), 'b'); hold on;
    plot(f2, Y2/max(Y2), 'r');
    title('Spectre amplitude normalisé');
    xlabel('Fréquence (Hz)');
    ylabel('Amplitude');
    legend('Original','Traité');

    % Spectrogramme
    subplot(3,1,3);
    spectrogram(y_proc, 128, 120, 128, Fs, 'yaxis');
    title('Spectrogramme du signal traité');

end

end  % <== FIN FONCTION PRINCIPALE Vocodeur_App
