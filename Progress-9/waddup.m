%% Start of the application
classdef waddup < matlab.apps.AppBase
    %% Public properties utilised within the application
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
        ChallengeUI        matlab.ui.Figure
        Story1UI           matlab.ui.Figure
        Story2UI           matlab.ui.Figure
        Story3UI           matlab.ui.Figure
        StorySelectUI      matlab.ui.Figure
    end
 
    properties (Access = private)
        LoadingAnimationTimer
        LoadingAnimationStep = 0
        StartTime
        RuntimeLabel
        AudioTimer
        VolumeSlider
        InitialVolume = 0.5;  
        LightBackgroundColor = [1 1 1];
        isPlayingAudio = false; 
        LightFontColor = [0 0 0];
        DarkBackgroundColor = [0.2 0.2 0.2];
        DarkFontColor = [1 1 1];
        HomeUIBackgroundColor
        darkModeColors = struct('bg', [0.15 0.15 0.15], 'text', [1 1 1]);
        lightModeColors = struct('bg', [1 1 1], 'text', [0 0 0]);
        currentColors % Added this property for current UI colors
        isDarkMode = false; % default to light mode
        MusicPanel
        ChallengeScore = 0;
        ChallengeScoreLabel
        ChallengeLevel = 1;
        ScoreLabel
        sumbitTranslation
        FirstExit = true;
        streak = 0; 
        Score
        CurrentLevel = 1; 
    end

    % Methods utilised within the applications functionality 
    methods (Access = private)

        function startupFcn(app)
            app.Data = app.readDictionaryFile('dictionary.txt'); % reading the dictionary.txt file utilised for translation
            createLoadingPage(app);
            app.isDarkMode = false; 
            app.StartTime = tic();
            app.Score = 0; 
            if app.isDarkMode
                app.currentColors = app.darkModeColors;
            else
                app.currentColors = app.lightModeColors;
            end
            app.AudioTimer = timer(...
                'ExecutionMode', 'fixedRate', ...
                'Period', 1, ... 
                'TimerFcn', @(~,~) app.refreshRuntimeLabel() ...
            );
            start(app.AudioTimer); 
        end


        function createLoadingPage(app)
            app.UIFigure = uifigure('Visible', 'on'); %
            app.UIFigure.Position = [100, 100, 600, 400]; %
            app.UIFigure.Name = 'Loading'; 
            app.UIFigure.Color = [1 1 1]; 
            
            app.LoadingLabel = uilabel(app.UIFigure); % Loading... label
            app.LoadingLabel.Text = 'Loading'; % Loading text for the label
            app.LoadingLabel.FontSize = 20;
            app.LoadingLabel.FontWeight = 'bold';
            app.LoadingLabel.FontColor = [239, 65, 53] / 255;  
            app.LoadingLabel.Position = [150, 180, 300, 30];
            app.LoadingLabel.HorizontalAlignment = 'center'; 

            app.StartButton = uibutton(app.UIFigure, 'push'); 
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @startButtonPushed, true); % Callback used for the buttons execution
            app.StartButton.Position = [250, 150, 100, 30];
            app.StartButton.Text = 'Start'; % Start text for the label
            app.StartButton.FontSize = 14;
            app.StartButton.BackgroundColor = [0.3, 0.6, 1]; 
            app.StartButton.FontColor = [1, 1, 1]; 
            

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
            createHomeScreen(app); 
        end

    methods (Access = public)
        function app = waddup
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
