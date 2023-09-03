% STARTBUTTONPUSHED: Function to execute when the Start button is pushed
        function startButtonPushed(app, ~)
            % Make the loading label invisible
            app.LoadingLabel.Visible = 'off';
            % Make the start button invisible
            app.StartButton.Visible = 'off';
            % Call another function to create the home screen
            createHomeScreen(app); 
        end