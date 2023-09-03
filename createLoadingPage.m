%% Loading page created
        % CREATELOADINGPAGE: shows the loading animation with a start
        % button initialising the application.
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