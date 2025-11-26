function InterfaceVocodeur
    % =====================================================================
    % INTERFACE GRAPHIQUE - PROJET VOCODEUR (Version Finale - Boutons Pitch)
    % =====================================================================

    % --- 1. Création de la fenêtre principale ---
    fig = uifigure('Name', 'Vocodeur de Phase - Studio', ...
        'Position', [100 100 750 480], ... 
        'Color', [0.94 0.94 0.94]);        

    % Données partagées
    appData = struct();
    appData.y = [];
    appData.fs = 0;
    appData.name = '';

    % =====================================================================
    % COLONNE DE GAUCHE : SÉLECTIONS
    % =====================================================================
    
    % --- PANNEAU 1 : CHOIX DE L'AUDIO ---
    pnlSource = uipanel(fig, 'Position', [20 300 300 150], ...
        'Title', 'Choix de l''audio', 'FontWeight', 'bold', ...
        'BackgroundColor', 'white', 'FontSize', 12);

    % Grille de boutons
    uibutton(pnlSource, 'Position', [15 90 125 30], 'Text', 'Diner.wav', ...
        'ButtonPushedFcn', @(btn,e) loadSpecificFile('Diner.wav'));
    
    uibutton(pnlSource, 'Position', [150 90 125 30], 'Text', 'Extrait.wav', ...
        'ButtonPushedFcn', @(btn,e) loadSpecificFile('Extrait.wav'));
    
    uibutton(pnlSource, 'Position', [15 50 125 30], 'Text', 'Halleluia.wav', ...
        'ButtonPushedFcn', @(btn,e) loadSpecificFile('Halleluia.wav'));
    
    uibutton(pnlSource, 'Position', [150 50 125 30], 'Text', 'Parcourir...', ...
        'BackgroundColor', [0.9 0.9 0.9], ...
        'ButtonPushedFcn', @(btn,e) browseFile());

    % Indicateur de fichier
    lblStatus = uilabel(pnlSource, 'Position', [15 15 270 25], ...
        'Text', 'Aucun fichier sélectionné', ...
        'FontColor', [0.6 0.6 0.6], 'HorizontalAlignment', 'center', ...
        'FontAngle', 'italic');


    % --- PANNEAU 2 : CHOIX DE L'EFFET ---
    bgEffet = uibuttongroup(fig, 'Position', [20 20 300 260], ...
        'Title', 'Choix de l''effet', 'FontWeight', 'bold', ...
        'BackgroundColor', 'white', 'FontSize', 12, ...
        'SelectionChangedFcn', @updatePanelVisibility);

    % Boutons radio
    startY = 210; gap = 40;
    uiradiobutton(bgEffet, 'Position', [30 startY 200 22], 'Text', 'Vitesse (Time Stretch)', 'Tag', 'vitesse', 'FontSize', 11);
    uiradiobutton(bgEffet, 'Position', [30 startY-gap 200 22], 'Text', 'Pitch (Hauteur)', 'Tag', 'pitch', 'FontSize', 11);
    uiradiobutton(bgEffet, 'Position', [30 startY-2*gap 200 22], 'Text', 'Robotisation', 'Tag', 'robot', 'FontSize', 11);
    uiradiobutton(bgEffet, 'Position', [30 startY-3*gap 200 22], 'Text', 'Echo', 'Tag', 'echo', 'FontSize', 11);
    uiradiobutton(bgEffet, 'Position', [30 startY-4*gap 200 22], 'Text', 'Reverse', 'Tag', 'reverse', 'FontSize', 11);

    % =====================================================================
    % COLONNE DE DROITE : RÉGLAGES & ACTION
    % =====================================================================

    % --- PANNEAU 3 : PARAMÈTRES ---
    pnlSettingsContainer = uipanel(fig, 'Position', [340 120 390 330], ...
        'Title', 'Paramètre de l''effet', 'FontWeight', 'bold', ...
        'BackgroundColor', 'white', 'FontSize', 12);

    % -- SOUS-PANNEAU VITESSE --
    pnlVitesse = uipanel(pnlSettingsContainer, 'Position', [10 10 370 290], ...
        'BorderType', 'none', 'BackgroundColor', 'white', 'Visible', 'on');
    
    uilabel(pnlVitesse, 'Position', [0 220 370 22], 'Text', 'Ajuster la vitesse de lecture :', ...
        'HorizontalAlignment', 'center', 'FontSize', 11);
    
    lblValVitesse = uilabel(pnlVitesse, 'Position', [135 170 100 30], ...
        'Text', 'x 1.0', 'FontSize', 16, 'FontWeight', 'bold', ...
        'HorizontalAlignment', 'center', 'FontColor', [0 0.45 0.74]);
    
    % Label Gauche
    uilabel(pnlVitesse, 'Position', [10 112 60 22], ...
        'Text', 'Lent (0.5)', 'FontColor', [0.5 0.5 0.5], ...
        'HorizontalAlignment', 'right', 'FontSize', 10);
    
    % Slider Vitesse
    sldVitesse = uislider(pnlVitesse, 'Position', [80 120 210 3], ...
        'Limits', [0.5 2.0], 'Value', 1.0, ...
        'ValueChangedFcn', @(sld,e) updateLabel(sld, lblValVitesse, 'x '));
    
    % Label Droite
    uilabel(pnlVitesse, 'Position', [300 112 70 22], ...
        'Text', 'Rapide (2.0)', 'FontColor', [0.5 0.5 0.5], ...
        'HorizontalAlignment', 'left', 'FontSize', 10);


    % -- SOUS-PANNEAU PITCH (MODIFIÉ AVEC BOUTONS) --
    pnlPitch = uipanel(pnlSettingsContainer, 'Position', [10 10 370 290], ...
        'BorderType', 'none', 'BackgroundColor', 'white', 'Visible', 'off');
    
    uilabel(pnlPitch, 'Position', [0 220 370 22], 'Text', 'Choisir la modification de hauteur :', ...
        'HorizontalAlignment', 'center', 'FontSize', 11);
    
    % Groupe de boutons pour le choix Grave/Aigu
    bgPitchChoix = uibuttongroup(pnlPitch, 'Position', [60 80 250 120], ...
        'BorderType', 'none', 'BackgroundColor', 'white');
        
    % Bouton Aigu (Augmentation)
    uiradiobutton(bgPitchChoix, 'Position', [75 80 150 30], ...
        'Text', 'Aigu (Plus haut)', 'FontSize', 14, 'FontWeight', 'bold', ...
        'Tag', 'aigu');
        
    % Bouton Grave (Diminution)
    uiradiobutton(bgPitchChoix, 'Position', [75 30 150 30], ...
        'Text', 'Grave (Plus bas)', 'FontSize', 14, 'FontWeight', 'bold', ...
        'Tag', 'grave');


    % -- SOUS-PANNEAU ROBOTISATION --
    pnlRobot = uipanel(pnlSettingsContainer, 'Position', [10 10 370 290], ...
        'BorderType', 'none', 'BackgroundColor', 'white', 'Visible', 'off');
    
    uilabel(pnlRobot, 'Position', [0 220 370 22], 'Text', 'Fréquence de modulation (Hz) :', ...
        'HorizontalAlignment', 'center', 'FontSize', 11);
    
    bgRobotFreq = uibuttongroup(pnlRobot, 'Position', [60 80 250 100], ...
        'BorderType', 'none', 'BackgroundColor', 'white');
    
    uiradiobutton(bgRobotFreq, 'Position', [10 60 100 22], 'Text', '200 Hz', 'UserData', 200, 'FontWeight', 'bold');
    uiradiobutton(bgRobotFreq, 'Position', [10 20 100 22], 'Text', '500 Hz', 'UserData', 500, 'FontWeight', 'bold');
    uiradiobutton(bgRobotFreq, 'Position', [140 60 100 22], 'Text', '1000 Hz', 'UserData', 1000, 'FontWeight', 'bold');
    uiradiobutton(bgRobotFreq, 'Position', [140 20 100 22], 'Text', '2000 Hz', 'UserData', 2000, 'FontWeight', 'bold');


    % -- SOUS-PANNEAU INFO (Vide) --
    pnlInfo = uipanel(pnlSettingsContainer, 'Position', [10 10 370 290], ...
        'BorderType', 'none', 'BackgroundColor', 'white', 'Visible', 'off');
    
    uilabel(pnlInfo, 'Position', [35 140 300 40], ...
        'Text', {'Cet effet est automatique.', 'Aucun réglage nécessaire.'}, ...
        'HorizontalAlignment', 'center', 'FontColor', [0.5 0.5 0.5]);


    % --- BOUTON D'ACTION PRINCIPAL ---
    btnRun = uibutton(fig, 'Position', [340 20 390 80], ...
        'Text', 'LANCER LE TRAITEMENT', ...
        'FontSize', 14, 'FontWeight', 'bold', ...
        'BackgroundColor', [0.2 0.6 0.3], ... 
        'FontColor', 'white', ...
        'ButtonPushedFcn', @runSimulation);


    % =====================================================================
    % FONCTIONS LOGIQUES (CALLBACKS)
    % =====================================================================

    function loadSpecificFile(filename)
        if exist(filename, 'file')
            [y, fs] = audioread(filename);
            if size(y, 2) > 1, y = y(:,1); end 
            appData.y = y;
            appData.fs = fs;
            appData.name = filename;
            
            lblStatus.Text = ['Fichier prêt : ' filename];
            lblStatus.FontColor = [0 0.5 0]; 
            lblStatus.FontWeight = 'bold';
        else
            uialert(fig, ['Fichier introuvable : ' filename], 'Erreur');
        end
    end

    function browseFile()
        [file, path] = uigetfile({'*.wav;*.mp3', 'Audio'});
        if isequal(file, 0), return; end
        loadSpecificFile(fullfile(path, file));
    end

    function updateLabel(sld, lbl, prefix)
        lbl.Text = [prefix num2str(sld.Value, '%.2f')];
    end

    function updatePanelVisibility(~, event)
        pnlVitesse.Visible = 'off';
        pnlPitch.Visible = 'off';
        pnlRobot.Visible = 'off';
        pnlInfo.Visible = 'off';
        
        switch event.NewValue.Tag
            case 'vitesse', pnlVitesse.Visible = 'on';
            case 'pitch',   pnlPitch.Visible = 'on';
            case 'robot',   pnlRobot.Visible = 'on';
            otherwise,      pnlInfo.Visible = 'on';
        end
    end

    function runSimulation(~, ~)
        if isempty(appData.y)
            uialert(fig, 'Merci de choisir un son (à gauche) avant de lancer.', 'Attention');
            return;
        end
        
        y = appData.y;
        fs = appData.fs;
        effet = bgEffet.SelectedObject.Tag;
        y_out = [];
        
        fig.Pointer = 'watch'; drawnow;
        
        try
            switch effet
                % ---------------------------------------------------------
                % 1. VITESSE
                % ---------------------------------------------------------
                case 'vitesse'
                    rapp = sldVitesse.Value;
                    % Nfft et Nwind fixés à 1024 comme dans Vocodeur.m
                    y_out = PVoc(y, rapp, 1024, 1024);
                    
                % ---------------------------------------------------------
                % 2. PITCH (GRAVE / AIGU) - LOGIQUE VOCODEUR.M
                % ---------------------------------------------------------
                case 'pitch'
                    choix_pitch = bgPitchChoix.SelectedObject.Tag;
                    
                    % Paramètres issus de Vocodeur.m
                    Nfft = 256; 
                    Nwind = 256;
                    
                    if strcmp(choix_pitch, 'aigu')
                        % --- AUGMENTATION (AIGU) ---
                        % Dans Vocodeur.m : a = 2, b = 3
                        a = 2; 
                        b = 3;
                    else
                        % --- DIMINUTION (GRAVE) ---
                        % Dans Vocodeur.m : a = 3, b = 2
                        a = 3; 
                        b = 2;
                    end
                    
                    % 1. Étirement via PVoc
                    y_voc = PVoc(y, a/b, Nfft, Nwind);
                    
                    % 2. Ré-échantillonnage pour restaurer la vitesse
                    % et changer la hauteur
                    y_out = resample(y_voc, a, b);
                    
                % ---------------------------------------------------------
                % 3. ROBOTISATION
                % ---------------------------------------------------------
                case 'robot'
                    fc = bgRobotFreq.SelectedObject.UserData;
                    y_out = Rob(y, fc, fs);
                    
                % ---------------------------------------------------------
                % 4. ECHO
                % ---------------------------------------------------------
                case 'echo'
                    y_out = effet_echo(y, fs, 250, 0.6);
                    
                % ---------------------------------------------------------
                % 5. REVERSE
                % ---------------------------------------------------------
                case 'reverse'
                    y_out = effet_reverse(y);
            end
            
            % Appel de la fonction d'affichage complète
            afficherResultats(y, y_out, fs, effet);
            
            soundsc(y_out, fs);
            
        catch ME
            uialert(fig, ['Erreur Code : ' ME.message], 'Erreur');
        end
        fig.Pointer = 'arrow';
    end

    % --- AFFICHAGE COMPLET (TEMPOREL + SPECTRE + SPECTROGRAMME) ---
    function afficherResultats(y_in, y_out, fs, titre)
        % Création d'une nouvelle figure large
        figure('Name', ['Résultats : ' titre], 'NumberTitle', 'off', 'Color', 'white', ...
               'Position', [150 150 800 600]);
        
        % --- 1. Comparaison Temporelle ---
        subplot(3,1,1);
        t_in = (0:length(y_in)-1)/fs;
        t_out = (0:length(y_out)-1)/fs;
        
        plot(t_in, y_in, 'Color', [0.7 0.7 0.7], 'LineWidth', 1); hold on;
        plot(t_out, y_out, 'Color', [0 0.45 0.74], 'LineWidth', 1);
        
        title(['1. Signal Temporel (' titre ')']);
        xlabel('Temps (s)'); ylabel('Amplitude');
        legend('Original', 'Modifié'); grid on; axis tight;
        
        % --- 2. Comparaison Spectrale (FFT) ---
        subplot(3,1,2);
        
        % FFT Original
        N1 = length(y_in);
        f1 = (-N1/2:N1/2-1)*fs/N1;
        Y1 = fftshift(abs(fft(y_in)));
        
        % FFT Modifié
        N2 = length(y_out);
        f2 = (-N2/2:N2/2-1)*fs/N2;
        Y2 = fftshift(abs(fft(y_out)));
        
        plot(f1, Y1/max(Y1), 'Color', [0.7 0.7 0.7], 'LineWidth', 1); hold on;
        plot(f2, Y2/max(Y2), 'Color', [0.85 0.33 0.1], 'LineWidth', 1);
        
        title('2. Spectre d''amplitude comparé');
        xlabel('Fréquence (Hz)'); ylabel('Amp. Norm.');
        legend('Original', 'Modifié'); grid on; 
        xlim([-fs/2 fs/2]);
        
        % --- 3. Spectrogramme du résultat ---
        subplot(3,1,3);
        spectrogram(y_out, 128, 120, 128, fs, 'yaxis');
        title('3. Spectrogramme (Signal Modifié)');
    end
end