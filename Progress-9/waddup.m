%% Start of the application
classdef waddup < matlab.apps.AppBase
    %% Public properties utilised within the application
    properties (Access = public)
        UIFigure           matlab.ui.Figure
        HomeUI             matlab.ui.Figure
        LoadingLabel       matlab.ui.control.Label
    end
 
    properties (Access = private)
        LoadingAnimationTimer
        LoadingAnimationStep = 0
        StartTime
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
