classdef heapsadded < matlab.apps.AppBase

    properties (Access = public)
        UIFigure           matlab.ui.Figure
        HomeUI             matlab.ui.Figure
        LoadingLabel       matlab.ui.control.Label
        StartButton        matlab.ui.control.Button
        SubmitButton       matlab.ui.control.Button
        EditText           matlab.ui.control.EditField
        TranslationLabel   matlab.ui.control.Label
        Data               struct
        audioPlayer        audioplayer  
        StoryUI            matlab.ui.Figure
    end

    properties (Access = private)
        LoadingAnimationTimer
        LoadingAnimationStep = 0
        StartTime           % Add this line
        RuntimeLabel        % Add this line
        AudioTimer % Add this line
        VolumeSlider
        InitialVolume = 0.5;  % You can set the initial value as needed
        LightBackgroundColor = [1 1 1];
        isPlayingAudio = false; % Add this line
        LightFontColor = [0 0 0];
        DarkBackgroundColor = [0.2 0.2 0.2];
        DarkFontColor = [1 1 1];
        HomeUIBackgroundColor % Add this line
        MusicPanel % Add this line
    end

    methods (Access = private)
        function startupFcn(app)
            app.Data = app.readDictionaryFile('dictionary.txt');
            createLoadingPage(app);
            % Initialize the start time for runtime calculation
            app.StartTime = tic();
            
            app.AudioTimer = timer(...
                'ExecutionMode', 'fixedRate', ...
                'Period', 1, ... % Update every 1 second (adjust as needed)
                'TimerFcn', @(~,~) app.refreshRuntimeLabel() ...
            );
            start(app.AudioTimer);
        end

        function createLoadingPage(app)
            app.UIFigure = uifigure('Visible', 'on');
            app.UIFigure.Position = [100, 100, 600, 400];
            app.UIFigure.Name = 'French Translator';
            app.UIFigure.Color = [1 1 1];  
            
            app.LoadingLabel = uilabel(app.UIFigure);
            app.LoadingLabel.Text = 'Loading';
            app.LoadingLabel.FontSize = 20;
            app.LoadingLabel.FontWeight = 'bold';
            app.LoadingLabel.FontColor = [239, 65, 53] / 255;  % Dark blue font color
            app.LoadingLabel.Position = [150, 180, 300, 30];
            app.LoadingLabel.HorizontalAlignment = 'center';
            
            app.StartButton = uibutton(app.UIFigure, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @startButtonPushed, true);
            app.StartButton.Position = [250, 150, 100, 30];
            app.StartButton.Text = 'Start';
            app.StartButton.FontSize = 14;
            app.StartButton.BackgroundColor = [0.3, 0.6, 1];
            app.StartButton.FontColor = [1, 1, 1];
            
            % Start the loading animation
            app.LoadingAnimationTimer = timer(...
                'ExecutionMode', 'fixedRate', ...
                'Period', 0.5, ...
                'TimerFcn', @(~,~) toggleDots(app) ...
            );
            start(app.LoadingAnimationTimer);
        end
        
        function toggleDots(app)
            dots = {'.', '..', '...'};
            app.LoadingLabel.Text = ['Loading', dots{app.LoadingAnimationStep+1}];
            app.LoadingAnimationStep = mod(app.LoadingAnimationStep + 1, 3);
        end

        function startButtonPushed(app, ~)
            app.LoadingLabel.Visible = 'off';
            app.StartButton.Visible = 'off';
            createHomeScreen(app); % Display the home screen immediately
        end

        function createHomeScreen(app)
            if isempty(app.HomeUI) || ~isvalid(app.HomeUI)
                app.HomeUI = uifigure('Visible', 'off');
                app.HomeUI.Position = [100, 100, 600, 400];
                app.HomeUI.Name = 'Home Screen';
                app.HomeUI.Color = [1 1 1];  % Light gray background color
                app.HomeUIBackgroundColor = app.HomeUI.Color; % Store the initial background color
            end

            % Title Label
            titleLabel = uilabel(app.HomeUI);
            titleLabel.Text = 'Francais Fusion';
            titleLabel.FontSize = 28;
            titleLabel.FontWeight = 'bold';
            titleLabel.FontColor = [0 85/255 164/255];  % Dark blue font color
            titleLabel.Position = [150, 320, 300, 40];  % Above the name label
            titleLabel.HorizontalAlignment = 'center';
        
            % Welcome Label
            welcomeLabel = uilabel(app.HomeUI);
            welcomeLabel.Text = 'Bienvenue!';
            welcomeLabel.FontSize = 32;
            welcomeLabel.FontWeight = 'bold';
            welcomeLabel.FontColor = [239, 65, 53] / 255; % French red font color
            welcomeLabel.Position = [150, 280, 300, 40]; % Adjusted position
            welcomeLabel.HorizontalAlignment = 'center';

            exitButton = uibutton(app.HomeUI, 'push');
            exitButton.ButtonPushedFcn = @(~,~) app.exitButtonPushed();
            exitButton.Position = [10, app.HomeUI.Position(4) - 40, 70, 30]; % Top left corner
            exitButton.FontColor = [1, 1, 1];
            exitButton.BackgroundColor = [0.3, 0.6, 1];
            exitButton.Text = 'Exit';
                
            % Buttons
            buttonWidth = 120;
            buttonHeight = 40;
            buttonSpacing = 20;
            
            startX = (app.HomeUI.Position(3) - (3 * buttonWidth + 2 * buttonSpacing)) / 2;
            buttonY = (app.HomeUI.Position(4) - buttonHeight) / 2; % Adjusted position
            
            storyButton = uibutton(app.HomeUI, 'push');
            storyButton.ButtonPushedFcn = @(~,~) app.storyButtonPushed();  % Connect to the storyButtonPushed method
            storyButton.Position = [startX, buttonY, buttonWidth, buttonHeight];
            storyButton.BackgroundColor = [0.3, 0.6, 1];
            storyButton.FontColor = [1, 1, 1];
            storyButton.Text = 'Story';
            
            translatorButton = uibutton(app.HomeUI, 'push');
            translatorButton.ButtonPushedFcn = createCallbackFcn(app, @translatorButtonPushed, true);
            translatorButton.Position = [startX + buttonWidth + buttonSpacing, buttonY, buttonWidth, buttonHeight];
            translatorButton.BackgroundColor = [0.3, 0.6, 1];
            translatorButton.FontColor = [1, 1, 1];
            translatorButton.Text = 'Translator';
            
            challengeButton = uibutton(app.HomeUI, 'push');
            challengeButton.ButtonPushedFcn = createCallbackFcn(app, @challengeButtonPushed, true);
            challengeButton.Position = [startX + 2 * (buttonWidth + buttonSpacing), buttonY, buttonWidth, buttonHeight];
            challengeButton.BackgroundColor = [0.3, 0.6, 1];
            challengeButton.FontColor = [1, 1, 1];
            challengeButton.Text = 'Challenge';         
            
            % Developed By Label
            developedByLabel = uilabel(app.HomeUI);
            developedByLabel.Text = 'Developed By Max Twelftree';
            developedByLabel.FontSize = 10;
            developedByLabel.FontColor = [0.5 0.5 0.5];  % Gray font color
            developedByLabel.Position = [150, 240, 300, 40];
            developedByLabel.HorizontalAlignment = 'center';

            musicPanel = uipanel(app.HomeUI);
            musicPanel.Position = [200, 20, 200, 100];
            musicPanel.BorderType = 'none';
            musicPanel.BackgroundColor = [1 1 1];  % Set the background color to match the UIFigure
            
            musicLabel = uilabel(musicPanel);
            musicLabel.Text = 'Study Music';
            musicLabel.FontSize = 14;
            musicLabel.FontWeight = 'bold';
            musicLabel.FontColor = [0 85/255 164/255];
            musicLabel.Position = [50, 80, 100, 20];
            musicLabel.HorizontalAlignment = 'center';
            app.MusicPanel = musicPanel; % Store the music panel handle

            playPauseButton = uibutton(musicPanel, 'push');
            playPauseButton.Position = [45, 20, 50, 30];
            playPauseButton.Text = '▶️';
            playPauseButton.ButtonPushedFcn = @(~,~) app.playPauseButtonPushed(playPauseButton);
            
            pauseButton = uibutton(musicPanel, 'push');
            pauseButton.Position = [105, 20, 50, 30];
            pauseButton.Text = '⏸️';
            pauseButton.ButtonPushedFcn = @(~,~) app.pauseButtonPushed();

            app.RuntimeLabel = uilabel(app.HomeUI);
            app.RuntimeLabel.Position = [250, 75, 100, 20]; % Adjusted position
            app.RuntimeLabel.FontSize = 12;
            app.RuntimeLabel.Text = '🎶: 0 seconds';
            app.RuntimeLabel.HorizontalAlignment = 'center';
            
            app.StartTime = tic(); % Start the timer
                        
            % Inside the Timer function for updating the runtime label
            app.refreshRuntimeLabel(); % Refresh the runtime label
            
            app.VolumeSlider = uislider(app.MusicPanel);
            app.VolumeSlider.Position = [20, 10, 160, 3];
            app.VolumeSlider.Value = app.InitialVolume;
            app.VolumeSlider.Limits = [0, 1];  % Volume ranges from 0 to 1
            app.VolumeSlider.MajorTicks = [0, 0.5, 1];
            app.VolumeSlider.MajorTickLabels = {'0', '0.5', '1'};
            app.VolumeSlider.ValueChangedFcn = @(~,~) volumeSliderChanged(app);

            app.HomeUI.Visible = 'on';
        end

        function createTranslator(app)
            app.UIFigure = uifigure('Visible', 'on');
            app.UIFigure.Position = [100, 100, 600, 400];
            app.UIFigure.Name = 'French Translator';
            app.UIFigure.Color = [1 1 1];  % Light gray background color
            
            app.SubmitButton = uibutton(app.UIFigure, 'push');
            app.SubmitButton.ButtonPushedFcn = createCallbackFcn(app, @SubmitButtonPushed, true);
            app.SubmitButton.Position = [250, 10, 100, 30];
            app.SubmitButton.Text = 'Translate';
            app.SubmitButton.FontSize = 14;
            app.SubmitButton.BackgroundColor = [0.3, 0.6, 1];
            app.SubmitButton.FontColor = [1, 1, 1];
            
            app.EditText = uieditfield(app.UIFigure, 'text');
            app.EditText.ValueChangedFcn = createCallbackFcn(app, @EditTextValueChanged, true);
            app.EditText.Position = [150, 60, 300, 30];
            app.EditText.FontSize = 14;
            app.EditText.BackgroundColor = [1, 1, 1];  % White background color
            
            app.TranslationLabel = uilabel(app.UIFigure);
            app.TranslationLabel.Position = [150, 150, 300, 200];
            app.TranslationLabel.FontSize = 14;
            app.TranslationLabel.FontWeight = 'bold';
            app.TranslationLabel.HorizontalAlignment = 'center';
            app.TranslationLabel.BackgroundColor = [1, 1, 1];  % White background color
            app.TranslationLabel.VerticalAlignment = 'top';
            app.TranslationLabel.WordWrap = 'on';
            app.TranslationLabel.Text = '';

            exitButton = uibutton(app.UIFigure, 'push');
            exitButton.ButtonPushedFcn = createCallbackFcn(app, @exitButtonPushed, true);
            exitButton.Position = [app.UIFigure.Position(3) - 100, app.UIFigure.Position(4) - 40, 70, 30]; % Top right corner
            exitButton.FontColor = [1, 1, 1];
            exitButton.BackgroundColor = [0.3, 0.6, 1];
            exitButton.Text = 'Exit';

            function exitButtonPushed(app, ~)
                delete(app.UIFigure);  % Delete the current UI figure
                createHomeScreen(app); % Recreate the home screen
            end
        end
        
        function data = readDictionaryFile(~, filename)
            fid = fopen(filename, 'r');
            C = textscan(fid, '%s %s %s %s', 'Delimiter', ';');
            fclose(fid);

            frenchWords = C{1};
            englishTranslations = C{4};

            dictionary = containers.Map('KeyType', 'char', 'ValueType', 'any');
            for i = 1:numel(frenchWords)
                word = frenchWords{i};
                translation = englishTranslations{i};
                if isKey(dictionary, word)
                    translations = dictionary(word);
                    translations{end+1} = translation;
                else
                    translations = {translation};
                end
                dictionary(word) = translations;
            end

            data.dictionary = dictionary;
        end

        function EditTextValueChanged(app, ~)
            updateTranslationLabel(app);
        end

        function SubmitButtonPushed(app, ~)
            updateTranslationLabel(app);
        end

        function updateTranslationLabel(app)
            dictionary = app.Data.dictionary;
            userGuess = app.EditText.Value;
            translations = dictionary(userGuess);

            if ~isempty(translations)
                translationStr = sprintf('English translation for "%s":\n', userGuess);
                for i = 1:numel(translations)
                    translationStr = sprintf('%s%s\n', translationStr, translations{i});
                end
                app.TranslationLabel.Text = translationStr;
            else
                app.TranslationLabel.Text = 'Translation not found';
            end
        end
    end

    methods (Access = private)
        function playPauseButtonPushed(app, playPauseButton)
            try
                if isempty(app.audioPlayer)
                    [audioData, fs] = audioread('said.wav');
                    audioData = app.VolumeSlider.Value * audioData; % Apply volume adjustment
                    app.audioPlayer = audioplayer(audioData, fs);
                end
        
                if app.isPlayingAudio
                    pause(app.audioPlayer);
                    app.isPlayingAudio = false;
                    stop(app.AudioTimer);
                else
                    play(app.audioPlayer);
                    app.isPlayingAudio = true;
                    start(app.AudioTimer);
                end
        
                app.refreshRuntimeLabel(); % Update runtime label
                app.updatePlayPauseButtonLabel(playPauseButton); % Update button label
            catch exception
                disp('Error reading audio file:');
                disp(exception.message);
            end
        end

        function refreshRuntimeLabel(app)
            if ~isempty(app.audioPlayer) && isplaying(app.audioPlayer)
                elapsedTime = toc(app.StartTime);
                app.RuntimeLabel.Text = sprintf('🎶: %d seconds', round(elapsedTime));
            end
        end
        
        function pauseButtonPushed(app, ~)
            if ~isempty(app.audioPlayer) && isplaying(app.audioPlayer)
                pause(app.audioPlayer);
                app.isPlayingAudio = false;
                app.updatePlayPauseButtonLabel(); % Update button label
            end
        end
        
        function updatePlayPauseButtonLabel(app, playPauseButton)
            if app.isPlayingAudio
                playPauseButton.Text = '⏸️';
            else
                playPauseButton.Text = '▶️';
            end
        end
        
        function volumeSliderChanged(app)
            if ~isempty(app.audioPlayer)
                if isplaying(app.audioPlayer)
                    pause(app.audioPlayer); % Pause the player
                    
                    % Get the original audio data
                    [audioData, fs] = audioread('said.wav');
                    
                    % Adjust the volume and create a new audioplayer object
                    newAudioData = app.VolumeSlider.Value * audioData;
                    app.audioPlayer = audioplayer(newAudioData, fs);
                    
                    play(app.audioPlayer); % Resume playing with the new volume
                else
                    % If the audio was paused, just update the volume for the next play
                    app.audioPlayer = audioplayer([], []);
                    app.audioPlayer.Volume = app.VolumeSlider.Value; % Update the volume
                end
            end
        end

        function translatorButtonPushed(app, ~)
            delete(app.HomeUI);
            createTranslator(app);
        end

        function exitButtonPushed(app, ~)
            close(app.HomeUI);
        end

        function challengeButtonPushed(app, ~)
            delete(app.HomeUI);
            createRandomChallenge(app); % Use the createRandomChallenge function
        end

        function createRandomChallenge(app)
            englishWords = keys(app.Data.dictionary); % Get all English words from the dictionary
            randomIndex = randi(length(englishWords)); % Generate a random index
            randomEnglishWord = englishWords{randomIndex}; % Get the random English word
            
            app.UIFigure = uifigure('Visible', 'on');
            app.UIFigure.Position = [100, 100, 600, 400];
            app.UIFigure.Name = 'Challenge';
            app.UIFigure.Color = [1 1 1];  % Light gray background color
            
            app.EditText = uieditfield(app.UIFigure, 'text');
            app.EditText.ValueChangedFcn = createCallbackFcn(app, @EditTextValueChanged, true);
            app.EditText.Position = [150, 60, 300, 30];
            app.EditText.FontSize = 14;
            app.EditText.BackgroundColor = [1, 1, 1];  % White background color
            
            app.TranslationLabel = uilabel(app.UIFigure);
            app.TranslationLabel.Position = [150, 150, 300, 200];
            app.TranslationLabel.FontSize = 14;
            app.TranslationLabel.FontWeight = 'bold';
            app.TranslationLabel.HorizontalAlignment = 'center';
            app.TranslationLabel.BackgroundColor = [1, 1, 1];  % White background color
            app.TranslationLabel.VerticalAlignment = 'top';
            app.TranslationLabel.WordWrap = 'on';
            app.TranslationLabel.Text = sprintf('Translate the English word "%s" to French:', randomEnglishWord);
            
            app.SubmitButton = uibutton(app.UIFigure, 'push');
            app.SubmitButton.ButtonPushedFcn = createCallbackFcn(app, @SubmitButtonPushed, true);
            app.SubmitButton.Position = [250, 10, 100, 30];
            app.SubmitButton.Text = 'Submit';
            app.SubmitButton.FontSize = 14;
            app.SubmitButton.BackgroundColor = [0.3, 0.6, 1];
            app.SubmitButton.FontColor = [1, 1, 1];

            exitButton = uibutton(app.UIFigure, 'push');
            exitButton.ButtonPushedFcn = createCallbackFcn(app, @exitButtonPushed, true);
            exitButton.Position = [app.UIFigure.Position(3) - 100, app.UIFigure.Position(4) - 40, 70, 30]; % Top right corner
            exitButton.FontColor = [1, 1, 1];
            exitButton.BackgroundColor = [0.3, 0.6, 1];
            exitButton.Text = 'Exit';

            function exitButtonPushed(app, ~)
                delete(app.UIFigure);  % Delete the current UI figure
                createHomeScreen(app); % Recreate the home screen
            end
        end

        function closeApp(app)
            if ~isempty(app.audioPlayer) && isplaying(app.audioPlayer)
                stop(app.audioPlayer);
            end
            
            if ~isempty(app.AudioTimer) && isvalid(app.AudioTimer)
                stop(app.AudioTimer);
                delete(app.AudioTimer);
            end
            
            delete(app.UIFigure);
        end

        function storyButtonPushed(app)
            if isempty(app.StoryUI) || ~isvalid(app.StoryUI)
                app.StoryUI = uifigure('Visible', 'off');
                app.StoryUI.Position = [100, 100, 600, 400];
                app.StoryUI.Name = 'Graded Reader';
                app.StoryUI.Color = [1 1 1];  % Light gray background color
        
                storyPanel = uipanel(app.StoryUI);
                storyPanel.Position = [20, 20, 560, 360];  % Adjust the position and size
                storyPanel.BackgroundColor = [1, 1, 1];  % White background color
                storyPanel.Scrollable = 'on';  % Enable scrolling
        
                storyTextArea = uitextarea(storyPanel);
                storyTextArea.Position = [10, 10, 540, 340];  % Adjust the position and size
                storyTextArea.FontSize = 14;
                storyTextArea.Value = fileread('graded_reader.txt');  % Read the content of the file
        
                exitButton = uibutton(app.StoryUI, 'push');
                exitButton.ButtonPushedFcn = @(~,~) app.exitStoryButtonPushed();
                exitButton.Position = [app.StoryUI.Position(3) - 100, app.StoryUI.Position(4) - 40, 70, 30]; % Top right corner
                exitButton.FontColor = [1, 1, 1];
                exitButton.BackgroundColor = [0.3, 0.6, 1];
                exitButton.Text = 'Exit';
        
                app.StoryUI.Visible = 'on';
            end
        end

        function exitStoryButtonPushed(app)
            app.StoryUI.Visible = 'off';
        end

    end

    methods (Access = public)
        function app = heapsadded
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [1 1 1];  % White background color
            
            startupFcn(app);
            registerApp(app, app.UIFigure);
            app.UIFigure.Visible = 'on';
            app.UIFigure.CloseRequestFcn = @(~,~) app.closeApp();

            if nargout == 0
                clear app
            end
        end
        
        function refresh(app)
            updateTranslationLabel(app);
        end
    end
end