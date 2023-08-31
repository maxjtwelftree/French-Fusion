%% Start of the application
classdef myApp < matlab.apps.AppBase
    %% Public properties utilised within the application
    properties (Access = public)
        UIFigure           matlab.ui.Figure
        HomeUI             matlab.ui.Figure
        LoadingLabel       matlab.ui.control.Label
        StartButton        matlab.ui.control.Button
        SubmitButton       matlab.ui.control.Button
        sumbitTranslation  matlab.ui.control.Button
        EditText           matlab.ui.control.EditField
        TranslationLabel   matlab.ui.control.Label
        Data               struct
        audioPlayer        audioplayer  
        StoryUI            matlab.ui.Figure
        ChallengeUI        matlab.ui.Figure
        Story1UI           matlab.ui.Figure
        Story2UI           matlab.ui.Figure
        Story3UI           matlab.ui.Figure
        StorySelectUI      matlab.ui.Figure
        FirstStoryExit = true 
    end

    %% Private properites utilised within 
    properties (Access = private)
        LoadingAnimationTimer
        LoadingAnimationStep = 0
        StartTime
        RuntimeLabel
        AudioTimer
        VolumeSlider
        InitialVolume = 0.5;  
        isPlayingAudio = false; 
        HomeUIBackgroundColor
        MusicPanel
        ChallengeScore = 0;
        ChallengeScoreLabel
        ChallengeLevel = 1;
        ScoreLabel
        FirstExit = true;
        streak = 0; 
        Score
        CurrentLevel = 1; 
        storyIndex
    end

    % Methods utilised within the applications functionality 
    methods (Access = private)
        % Startup page, reads the dictionary utilised, loads the time and
        % updates the score
        function startupFcn(app)
            app.Data = app.readDictionaryFile('dictionary.txt'); % reading the dictionary.txt file utilised for translation
            createLoadingPage(app);
            app.StartTime = tic();
            % Audio timer for the study music implemented tracked
            app.AudioTimer = timer(...
                'ExecutionMode', 'fixedRate', ...
                'Period', 1, ... 
                'TimerFcn', @(~,~) app.refreshRuntimeLabel() ...
            );
            start(app.AudioTimer); 
        end

        %% Loading page created
        function createLoadingPage(app)
            app.UIFigure = uifigure('Visible', 'on'); % The loading page UI figure
            app.UIFigure.Position = [100, 100, 600, 400]; % Position of the GUI, maintained by other pages
            app.UIFigure.Name = 'Loading'; % Title of the GUI for context
            app.UIFigure.Color = [1 1 1];  % White background colour as followed by other pages within the application
            
            app.LoadingLabel = uilabel(app.UIFigure); % Loading... label
            app.LoadingLabel.Text = 'Loading'; % Loading text for the label
            app.LoadingLabel.FontSize = 20;
            app.LoadingLabel.FontWeight = 'bold';
            app.LoadingLabel.FontColor = [239, 65, 53] / 255;  
            app.LoadingLabel.Position = [150, 180, 300, 30];
            app.LoadingLabel.HorizontalAlignment = 'center'; % Aligned in the centre for aesthetic

            app.StartButton = uibutton(app.UIFigure, 'push'); % Button functionality utilised to start the game
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @startButtonPushed, true); % Callback used for the buttons execution
            app.StartButton.Position = [250, 150, 100, 30];
            app.StartButton.Text = 'Start'; % Start text for the label
            app.StartButton.FontSize = 14;
            app.StartButton.BackgroundColor = [0.3, 0.6, 1]; % Different colours used as followed through the remainder of the app to match french colours
            app.StartButton.FontColor = [1, 1, 1]; % White colouring used as followed by the other buttons within the app
            
            % ... animation created and utilised for appearance within the
            % loading table
            app.LoadingAnimationTimer = timer(...
                'ExecutionMode', 'fixedRate', ...
                'Period', 0.5, ...
                'TimerFcn', @(~,~) toggleDots(app) ...
            );
            start(app.LoadingAnimationTimer);
        end
        
        % function utilised for the animation
        function toggleDots(app)
            dots = {'.', '..', '...'};
            app.LoadingLabel.Text = ['Loading', dots{app.LoadingAnimationStep+1}];
            app.LoadingAnimationStep = mod(app.LoadingAnimationStep + 1, 3); % Animation being executed 
        end

        function startButtonPushed(app, ~)
            app.LoadingLabel.Visible = 'off';
            app.StartButton.Visible = 'off';
            createHomeScreen(app); % Home screen is created once the start button is pushed 
        end

        %% Home screen development with buttons, colour and text for the appdesigner GUI
        function createHomeScreen(app)
            % screen UI titled Home Screen
            if isempty(app.HomeUI) || ~isvalid(app.HomeUI)
                app.HomeUI = uifigure('Visible', 'off');
                app.HomeUI.Position = [100, 100, 600, 400];
                app.HomeUI.Name = 'Home Screen';
                app.HomeUI.Color = [1 1 1]; 
                app.HomeUIBackgroundColor = app.HomeUI.Color; 
            end

            titleLabel = uilabel(app.HomeUI);
            titleLabel.Text = 'French Fusion'; % Application title
            titleLabel.FontSize = 28;
            titleLabel.FontWeight = 'bold'; % Bold text for all sub headings and headings
            titleLabel.FontColor = [0 85/255 164/255]; % Following the colour theme 
            titleLabel.Position = [150, 320, 300, 40];  
            titleLabel.HorizontalAlignment = 'center';
        
            welcomeLabel = uilabel(app.HomeUI);
            welcomeLabel.Text = 'Bienvenue!'; % Welcome title 
            welcomeLabel.FontSize = 32;
            welcomeLabel.FontWeight = 'bold'; % Bold text for all sub headings and headings
            welcomeLabel.FontColor = [239, 65, 53] / 255; 
            welcomeLabel.Position = [150, 280, 300, 40]; 
            welcomeLabel.HorizontalAlignment = 'center';

            exitButton = uibutton(app.HomeUI, 'push'); % Push button for exiting the app
            exitButton.ButtonPushedFcn = @(~,~) app.exitButtonPushed(); % Executing and responding the the function supplied for the exit button (ie: leaving the application)
            exitButton.Position = [10, app.HomeUI.Position(4) - 40, 70, 30]; % Positioning in the top corner to allow less overflow of UI and design
            exitButton.FontColor = [1, 1, 1]; % White colour given and used with all buttons to correspond to the colours utilised throughout the applications entirety 
            exitButton.BackgroundColor = [0.3, 0.6, 1];
            exitButton.Text = 'Exit';
                
            buttonWidth = 120; % Button positioning 
            buttonHeight = 40;
            buttonSpacing = 20;
            
            startX = (app.HomeUI.Position(3) - (3 * buttonWidth + 2 * buttonSpacing)) / 2; % Allows for buttons to cohesively appear next to one another limiting cluster
            buttonY = (app.HomeUI.Position(4) - buttonHeight) / 2; 
            
            storyButton = uibutton(app.HomeUI, 'push'); 
            storyButton.ButtonPushedFcn = @(~,~) app.storyButtonPressed(); % Responding to the storyButtonPressed function to give the button action
            storyButton.Position = [startX, buttonY, buttonWidth, buttonHeight]; % Positioning the button with the above positioning
            storyButton.BackgroundColor = [0.3, 0.6, 1]; % Background colour as followed for all buttons 
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
            
            developedByLabel = uilabel(app.HomeUI);
            developedByLabel.Text = 'Developed By Max Twelftree';
            developedByLabel.FontSize = 10;
            developedByLabel.FontColor = [0.5 0.5 0.5]; 
            developedByLabel.Position = [150, 240, 300, 40];
            developedByLabel.HorizontalAlignment = 'center';

            musicPanel = uipanel(app.HomeUI);
            musicPanel.Position = [200, 20, 200, 100];
            musicPanel.BorderType = 'none';
            musicPanel.BackgroundColor = [1, 1, 1];
            
            % Define the Music Label
            musicLabel = uilabel(musicPanel);
            musicLabel.Text = 'Study Music';
            musicLabel.FontSize = 14;
            musicLabel.FontWeight = 'bold';
            musicLabel.FontColor = [0 85/255 164/255]; % Set the original font color
            musicLabel.BackgroundColor = [1 1 1]; % Set the original background color
            musicLabel.Position = [50, 80, 100, 20];
            musicLabel.HorizontalAlignment = 'center';
                        
            app.MusicPanel = musicPanel;  

            playPauseButton = uibutton(musicPanel, 'push');
            playPauseButton.Position = [45, 20, 50, 30];
            playPauseButton.Text = '▶️';
            playPauseButton.ButtonPushedFcn = @(~,~) app.playPauseButtonPushed(playPauseButton);
            
            pauseButton = uibutton(musicPanel, 'push');
            pauseButton.Position = [105, 20, 50, 30];
            pauseButton.Text = '⏸️';
            pauseButton.ButtonPushedFcn = @(~,~) app.pauseButtonPushed();

            app.RuntimeLabel = uilabel(app.HomeUI);
            app.RuntimeLabel.Position = [250, 75, 100, 20]; 
            app.RuntimeLabel.FontSize = 12;
            app.RuntimeLabel.Text = '🎶: 0 seconds';
            app.RuntimeLabel.HorizontalAlignment = 'center';
            
            app.StartTime = tic();
                        
            app.refreshRuntimeLabel(); 
            
            app.VolumeSlider = uislider(app.MusicPanel);
            app.VolumeSlider.Position = [20, 10, 160, 3];
            app.VolumeSlider.Value = app.InitialVolume;
            app.VolumeSlider.Limits = [0, 1]; 
            app.VolumeSlider.MajorTicks = [0, 0.5, 1];
            app.VolumeSlider.MajorTickLabels = {'0', '0.5', '1'};
            app.VolumeSlider.ValueChangedFcn = @(~,~) volumeSliderChanged(app);

            app.HomeUI.Visible = 'on'; % Reassuring the home UI is visible and users can view
        end

        %% Translator page being created as another function for users to utilise 
        function createTranslator(app)
            app.UIFigure = uifigure('Visible', 'on');
            app.UIFigure.Position = [100, 100, 600, 400];
            app.UIFigure.Name = 'French Translator';
            app.UIFigure.Color = [1 1 1]; 
            
            app.SubmitButton = uibutton(app.UIFigure, 'push');
            app.SubmitButton.ButtonPushedFcn = @app.submitTranslation; 
            app.SubmitButton.Position = [250, 10, 100, 30];
            app.SubmitButton.Text = 'Translate';
            app.SubmitButton.FontSize = 14;
            app.SubmitButton.BackgroundColor = [0.3, 0.6, 1];
            app.SubmitButton.FontColor = [1, 1, 1];
            
            app.EditText = uieditfield(app.UIFigure, 'text');
            app.EditText.ValueChangedFcn = createCallbackFcn(app, @EditTextValueChanged, true);
            app.EditText.Position = [150, 60, 300, 30];
            app.EditText.FontSize = 14;
            app.EditText.BackgroundColor = [1, 1, 1]; 
            
            app.TranslationLabel = uilabel(app.UIFigure);
            app.TranslationLabel.Position = [150, 150, 300, 200];
            app.TranslationLabel.FontSize = 14;
            app.TranslationLabel.FontWeight = 'bold';
            app.TranslationLabel.HorizontalAlignment = 'center';
            app.TranslationLabel.BackgroundColor = [1, 1, 1];  
            app.TranslationLabel.VerticalAlignment = 'top';
            app.TranslationLabel.WordWrap = 'on';
            app.TranslationLabel.Text = '';

            exitButton = uibutton(app.UIFigure, 'push');
            exitButton.ButtonPushedFcn = createCallbackFcn(app, @exitButtonPushed, true);
            exitButton.Position = [app.UIFigure.Position(3) - 100, app.UIFigure.Position(4) - 40, 70, 30];  
            exitButton.FontColor = [1, 1, 1];
            exitButton.BackgroundColor = [0.3, 0.6, 1];
            exitButton.Text = 'Exit';

            function exitButtonPushed(app, ~)
                delete(app.UIFigure);  
                createHomeScreen(app); 
            end
        end

        function storyButtonPressed(app)
            app.StoryUI = uifigure('Visible', 'on');
            app.StoryUI.Position = [100, 100, 600, 400];
            app.StoryUI.Name = 'Select a Story';
            app.StoryUI.Color = [1 1 1];

            selectLabel = uilabel(app.StoryUI);
            selectLabel.Text = 'Select your story 📖';
            selectLabel.FontSize = 16;
            selectLabel.FontWeight = 'bold';
            selectLabel.Position = [150, 350, 300, 30]; 
            selectLabel.HorizontalAlignment = 'center';
            selectLabel.FontColor = [0 85/255 164/255];

            exitButton = uibutton(app.StoryUI, 'push');
            exitButton.ButtonPushedFcn = @(~,~) app.exitButtonPushedStory();
            exitButton.Position = [app.StoryUI.Position(3) - 100, app.StoryUI.Position(4) - 40, 70, 30];  
            exitButton.FontColor = [1, 1, 1];
            exitButton.BackgroundColor = [0.3, 0.6, 1];
            exitButton.Text = 'Exit';

            app.UIFigure.Visible = 'off'; 
            
            story1Button = uibutton(app.StoryUI, 'push');
            story1Button.ButtonPushedFcn = @(~,~) app.displayStory(1);
            story1Button.Position = [150, 300, 300, 30];
            story1Button.BackgroundColor = [0.3, 0.6, 1];
            story1Button.FontColor = [1, 1, 1];
            story1Button.Text = 'Sherlock Holmes';
            
            story2Button = uibutton(app.StoryUI, 'push');
            story2Button.ButtonPushedFcn = @(~,~) app.displayStory(2); 
            story2Button.Position = [150, 250, 300, 30];
            story2Button.BackgroundColor = [0.3, 0.6, 1];
            story2Button.FontColor = [1, 1, 1];
            story2Button.Text = 'Baskerville Hall';
            
            story3Button = uibutton(app.StoryUI, 'push');
            story3Button.ButtonPushedFcn = @(~,~) app.displayStory(3); 
            story3Button.Position = [150, 200, 300, 30];
            story3Button.BackgroundColor = [0.3, 0.6, 1];
            story3Button.FontColor = [1, 1, 1];
            story3Button.Text = 'Fixing the Nets';
        end

        function displayStory(app, storyIndex)
            if storyIndex == 1
                app.createStoryUI('Sherlock Holmes', 'sherlock_holmes.txt');
            elseif storyIndex == 2
                app.createStoryUI('Baskerville Hall', 'baskerville_hall.txt');
            elseif storyIndex == 3
                app.createStoryUI('Fixing the Nets', 'fixing_the_nets.txt');
            end
        end

        function createStoryUI(app, storyTitle, storyFileName)
            if isempty(app.Story1UI) || ~isvalid(app.Story1UI)
                app.Story1UI = uifigure('Visible', 'off');
                app.Story1UI.Position = [100, 100, 600, 400];
                app.Story1UI.Name = storyTitle;
                app.Story1UI.Color = [1 1 1]; 
        
                storyPanel = uipanel(app.Story1UI);
                storyPanel.Position = [20, 20, 560, 360];  
                storyPanel.BackgroundColor = [1, 1, 1];  
                storyPanel.Scrollable = 'on';  
        
                storyTextArea = uitextarea(storyPanel);
                storyTextArea.Position = [10, 10, 540, 340];
                storyTextArea.FontSize = 14;
                storyTextArea.Value = fileread(storyFileName);  

                exitButton = uibutton(app.Story1UI, 'push');
                exitButton.ButtonPushedFcn = createCallbackFcn(app, @exitButtonPushedStoryUI, true);
                exitButton.Position = [app.Story1UI.Position(3) - 100, app.Story1UI.Position(4) - 40, 70, 30];  
                exitButton.FontColor = [1, 1, 1];
                exitButton.BackgroundColor = [0.3, 0.6, 1];
                exitButton.Text = 'Exit';

                app.Story1UI.Visible = 'on';
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

        function updateTranslationLabel(app)
            dictionary = app.Data.dictionary;
            userGuess = app.EditText.Value;
            
            if isKey(dictionary, userGuess)
                translations = dictionary(userGuess);
                
                if ~isempty(translations)
                    translationStr = sprintf('English translation for "%s":\n', userGuess);
                    for i = 1:numel(translations)
                        translationStr = sprintf('%s%s\n', translationStr, translations{i});
                    end
                    app.TranslationLabel.Text = translationStr;
                else
                    app.TranslationLabel.Text = 'No translation found';
                end
            else
                app.TranslationLabel.Text = 'Word not found in dictionary. Try another word.';
            end
        end

        function EditTextValueChanged(app, ~)
            updateTranslationLabel(app);
        end

        function volumeSliderChanged(app)
            if ~isempty(app.audioPlayer)
                if isplaying(app.audioPlayer)
                    pause(app.audioPlayer); 
                    
                    [audioData, fs] = audioread('said.wav');
                    
                    newAudioData = app.VolumeSlider.Value * audioData;
                    app.audioPlayer = audioplayer(newAudioData, fs);
                    
                    play(app.audioPlayer); 
                else
                    app.audioPlayer = audioplayer([], []);
                    app.audioPlayer.Volume = app.VolumeSlider.Value; 
                end
            end
        end

        function playPauseButtonPushed(app, playPauseButton)
            try
                if isempty(app.audioPlayer)
                    [audioData, fs] = audioread('said.wav');
                    audioData = app.VolumeSlider.Value * audioData; 
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
        
                app.refreshRuntimeLabel();
                app.updatePlayPauseButtonLabel(playPauseButton);
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
                app.updatePlayPauseButtonLabel(); 
            end
        end
        
        function updatePlayPauseButtonLabel(app, playPauseButton)
            if app.isPlayingAudio
                playPauseButton.Text = '⏸️';
            else
                playPauseButton.Text = '▶️';
            end
        end

        function translatorButtonPushed(app, ~)
            delete(app.HomeUI);
            createTranslator(app);
        end

        function exitButtonPushed(app, ~)
            close(app.HomeUI);
        end
        
        function exitButtonPushedStory(app, ~)
            app.StoryUI.Visible = 'off';  % Hide the StoryUI
            createHomeScreen(app); 
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

        function challengeButtonPushed(app, ~)    
            delete(app.HomeUI);
            createChallenge(app);
        end

        function createChallenge(app)        
            app.ChallengeUI = uifigure('Visible', 'on');
            app.ChallengeUI.Position = [100, 100, 600, 400];
            app.ChallengeUI.Name = 'Challenge';
            app.ChallengeUI.Color = [1 1 1];

            app.UIFigure.Visible = 'off';

            selectLabel = uilabel(app.ChallengeUI);
            selectLabel.Text = 'Select a level ⚡';
            selectLabel.FontSize = 16;
            selectLabel.FontWeight = 'bold';
            selectLabel.Position = [150, 350, 300, 30];
            selectLabel.HorizontalAlignment = 'center';
            selectLabel.FontColor = [0 85/255 164/255];
        
            exitButtonChallenge = uibutton(app.ChallengeUI, 'push');
            exitButtonChallenge.ButtonPushedFcn = @(~,~) app.exitChallenge();
            exitButtonChallenge.Position = [30, 30, 100, 30];
            exitButtonChallenge.FontColor = [1, 1, 1];
            exitButtonChallenge.BackgroundColor = [0.3, 0.6, 1];
            exitButtonChallenge.Text = 'Exit';
        
            level1Button = uibutton(app.ChallengeUI, 'push');
            level1Button.ButtonPushedFcn = @(~,~) app.startChallenge(1);
            level1Button.Position = [150, 300, 300, 30];
            level1Button.BackgroundColor = [0.3, 0.6, 1];
            level1Button.FontColor = [1, 1, 1];
            level1Button.Text = 'Level 1';
        
            level2Button = uibutton(app.ChallengeUI, 'push');
            level2Button.ButtonPushedFcn = @(~,~) app.startChallenge(2);
            level2Button.Position = [150, 250, 300, 30];
            level2Button.BackgroundColor = [0.3, 0.6, 1];
            level2Button.FontColor = [1, 1, 1];
            level2Button.Text = 'Level 2';
        
            level3Button = uibutton(app.ChallengeUI, 'push');
            level3Button.ButtonPushedFcn = @(~,~) app.startChallenge(3);
            level3Button.Position = [150, 200, 300, 30];
            level3Button.BackgroundColor = [0.3, 0.6, 1];
            level3Button.FontColor = [1, 1, 1];
            level3Button.Text = 'Level 3';
        end

        function startChallenge(app, selectedLevel)        
            % Create the challenge UI
            app.ChallengeUI = uifigure('Visible', 'on');
            app.ChallengeUI.Position = [100, 100, 600, 400];
            app.ChallengeUI.Name = 'Challenge';
            app.ChallengeUI.Color = [1 1 1];

            exitButtonLevel = uibutton(app.ChallengeUI, 'push');
            exitButtonLevel.ButtonPushedFcn = @(~,~) app.exitChallenge();
            exitButtonLevel.Position = [30, 30, 100, 30];
            exitButtonLevel.FontColor = [1, 1, 1];
            exitButtonLevel.BackgroundColor = [0.3, 0.6, 1];
            exitButtonLevel.Text = 'Exit'

            app.UIFigure.Visible = 'off';

            % Determine the file name based on the selected level
            switch selectedLevel
                case 1
                    levelFile = 'level1.txt';
                case 2
                    levelFile = 'level2.txt';
                case 3
                    levelFile = 'level3.txt';
                otherwise
                    % Default to level 1 if an invalid level is selected
                    levelFile = 'level1.txt';
            end
        
            % Load the challenge content from the corresponding level's file
            challengeContent = fileread(levelFile);
        
            % Split the content into lines
            lines = strsplit(challengeContent, '\n');
        
            % Initialize variables to store French words and English translations
            frenchWords = {};
            englishTranslations = {};
        
            % Parse the lines to extract French words and English translations
            for i = 1:length(lines)
                line = lines{i};
                parts = strsplit(line, ';');
                
                % Check if the line has the expected number of parts
                if numel(parts) >= 4
                    frenchWords{end+1} = parts{1};
                    englishTranslations{end+1} = parts{4};
                else
                    % Print a warning or handle missing translations as needed
                    fprintf('Warning: Line %d does not have the expected format\n', i);
                end
            end

            % Choose a random word from the challenge content
            randomIndex = randi(length(frenchWords));
            frenchWord = frenchWords{randomIndex};
            correctTranslation = englishTranslations{randomIndex};

            translateLabel = uilabel(app.ChallengeUI);
            translateLabel.Text = 'Translate the French word to English. 5 in a row allows you to level up!';
            translateLabel.HorizontalAlignment = 'center';
            translateLabel.FontSize = 16;
            translateLabel.FontWeight = 'bold';
            translateLabel.FontColor = [0 85/255 164/255];
            translateLabel.Position = [150, 350, 300, 30];
        
            % Create UI components
            frenchWordLabel = uilabel(app.ChallengeUI);
            frenchWordLabel.Text = frenchWord;
            frenchWordLabel.FontSize = 16;
            frenchWordLabel.HorizontalAlignment = 'center'; % Center the text
            frenchWordLabel.Position = [150, 300, 300, 30]; % Adjust the position
            
            guessEditField = uieditfield(app.ChallengeUI, 'text');
            guessEditField.Position = [200, 250, 200, 30]; % Adjust the position
            
            submitButton = uibutton(app.ChallengeUI, 'push');
            submitButton.Text = 'Submit';
            submitButton.Position = [250, 200, 100, 30];
            submitButton.FontWeight = 'bold';
            submitButton.FontSize = 14;
            submitButton.BackgroundColor = [0.3, 0.6, 1];
            submitButton.FontColor = [1, 1, 1];
            submitButton.ButtonPushedFcn = @(~,~) checkGuess(app, guessEditField.Value, correctTranslation);

            function checkGuess(app, guess, correctTranslation, frenchWords, englishTranslations, frenchWordLabel, guessEditField, submitButton)
                % Compare the guess to the correct translation
                if strcmp(guess, correctTranslation)
                    % Increment the streak
                    app.streak = app.streak + 1;
                
                    % Display a message indicating correctness and streak
                    message = uilabel(app.ChallengeUI);
                    message.Text = sprintf('Correct 🔥 Streak: %d', app.streak);
                    message.FontSize = 16;
                    message.FontColor = [0 85/255 164/255];
                    message.Position = [200, 150, 200, 30];
                    message.HorizontalAlignment = 'center'; % Center the text

                    % Check if the streak reaches 10
                    if app.streak >= 5 && selectedLevel < 3
                        % Suggest to go to the next level
                        nextLevelButton = uibutton(app.ChallengeUI, 'push');
                        nextLevelButton.Position = [250, 100, 100, 30];
                        nextLevelButton.Text = 'Next Level';
                        nextLevelButton.FontWeight = 'bold';
                        nextLevelButton.FontSize = 12;
                        nextLevelButton.BackgroundColor = [0.3, 0.6, 1];
                        nextLevelButton.FontColor = [1, 1, 1];
                        nextLevelButton.ButtonPushedFcn = @(~,~) app.startChallenge(selectedLevel + 1); % Move to the next level
                    end
                    
                    % Wait for a moment to show the correct message
                    pause(1);
                    
                    % Delete the message
                    delete(message);
                    
                    % Choose a new random word from the same level
                    randomIndex = randi(length(frenchWords));
                    frenchWord = frenchWords{randomIndex};
                    correctTranslation = englishTranslations{randomIndex};
                    
                    % Update UI components with the new word
                    frenchWordLabel.Text = frenchWord;
                    guessEditField.Value = '';
                    
                else
                    % Display a message indicating incorrectness
                    app.streak = 0;
                    message = uilabel(app.ChallengeUI);
                    message.Text = 'Incorrect ❌';
                    message.FontSize = 16;
                    message.Position = [230, 150, 140, 30];
                    message.FontColor = [0 85/255 164/255];
                    message.HorizontalAlignment = 'center'; % Center the text
                    
                    % Wait for a moment to show the incorrect message
                    pause(1);
                    
                    % Delete the message
                    delete(message);
                end
            end
            submitButton.ButtonPushedFcn = @(~,~) checkGuess(app, guessEditField.Value, correctTranslation, frenchWords, englishTranslations, frenchWordLabel, guessEditField, submitButton);
        end
        
        function storyButtonPushed(app, ~)    
            delete(app.HomeUI);
            createStorySelect(app);
        end

        function exitButtonPushedStoryUI(app, ~)
            app.Story1UI.Visible = 'off';  % Hide the StoryUI
            createHomeScreen(app); 
        end

        function exitChallenge(app)
            app.ChallengeUI.Visible = 'off';
            
            if app.FirstExit % If it's the first exit
                app.FirstExit = false; % Update the flag
                app.createChallenge(); % Navigate back to the challenge selection screen
            else
                app.createHomeScreen(); % Navigate to the home screen
            end
        end
    end

    methods (Access = public)
        function app = myApp
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [1 1 1];  
            
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