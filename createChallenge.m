%% Challenge screen
        % CREATECHALLENGE: Constructs the challenge user interface within the main application.
        function createChallenge(app)        
            app.ChallengeUI = uifigure('Visible', 'on');
            app.ChallengeUI.Position = [100, 100, 600, 400];
            app.ChallengeUI.Name = 'Challenge';
            app.ChallengeUI.Color = [1 1 1];
        
            % Hide the main application's figure
            app.UIFigure.Visible = 'off';
        
            % Create a label prompting the user to select a challenge level
            selectLabel = uilabel(app.ChallengeUI);
            selectLabel.Text = 'Select a level ⚡';
            selectLabel.FontSize = 16;
            selectLabel.FontWeight = 'bold';
            selectLabel.Position = [150, 350, 300, 30];
            selectLabel.HorizontalAlignment = 'center';
            selectLabel.FontColor = [0 85/255 164/255];
            
            % Exit button to allow users to go back to the main page 
            exitButtonChallenge = uibutton(app.ChallengeUI, 'push');
            exitButtonChallenge.ButtonPushedFcn = @(~,~) app.exitChallenge();
            exitButtonChallenge.Position = [30, 30, 100, 30];
            exitButtonChallenge.FontColor = [1, 1, 1];
            exitButtonChallenge.BackgroundColor = [0.3, 0.6, 1];
            exitButtonChallenge.Text = 'Exit';
        
            % Button for starting Level 1 of the challenge
            level1Button = uibutton(app.ChallengeUI, 'push');
            level1Button.ButtonPushedFcn = @(~,~) app.startChallenge(1);
            level1Button.Position = [150, 300, 300, 30];
            level1Button.BackgroundColor = [0.3, 0.6, 1];
            level1Button.FontColor = [1, 1, 1];
            level1Button.Text = 'Level 1';
        
            % Button for starting Level 2 of the challenge
            level2Button = uibutton(app.ChallengeUI, 'push');
            level2Button.ButtonPushedFcn = @(~,~) app.startChallenge(2);
            level2Button.Position = [150, 250, 300, 30];
            level2Button.BackgroundColor = [0.3, 0.6, 1];
            level2Button.FontColor = [1, 1, 1];
            level2Button.Text = 'Level 2';
        
            % Button for starting Level 3 of the challenge
            level3Button = uibutton(app.ChallengeUI, 'push');
            level3Button.ButtonPushedFcn = @(~,~) app.startChallenge(3);
            level3Button.Position = [150, 200, 300, 30];
            level3Button.BackgroundColor = [0.3, 0.6, 1];
            level3Button.FontColor = [1, 1, 1];
            level3Button.Text = 'Level 3';
        end