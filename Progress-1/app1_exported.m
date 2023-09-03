classdef app1_exported < matlab.apps.AppBase

    properties (Access = public)
        UIFigure              matlab.ui.Figure
        TitleLabel            matlab.ui.control.Label
        SubtitleLabel         matlab.ui.control.Label
        RulesTextArea         matlab.ui.control.Label 
        StartQuestButton      matlab.ui.control.Button
    end

    methods (Access = private)
        function createComponents(app)
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'LexiLearn Game';
            app.UIFigure.Color = [0.2, 0.2, 0.2];
            
            app.StartQuestButton = uibutton(app.UIFigure, 'push');
            app.StartQuestButton.ButtonPushedFcn = createCallbackFcn(app, @StartQuestButtonPushed, true);
            buttonWidth = 200; % Adjusted width
            buttonHeight = 60; % Adjusted height
            buttonX = (app.UIFigure.Position(3) - buttonWidth) / 2; % Centered horizontally
            buttonY = (app.UIFigure.Position(4) - buttonHeight) / 2; % Centered vertically
            app.StartQuestButton.Position = [buttonX, buttonY, buttonWidth, buttonHeight];
            app.StartQuestButton.Text = 'Start Your Quest';
            app.StartQuestButton.FontSize = 16;
            app.StartQuestButton.FontColor = [1, 1, 1];
            app.StartQuestButton.BackgroundColor = [1, 0, 0];
            
            app.UIFigure.Visible = 'on';
        end
        
        function displayTitleAndRules(app)
            app.StartQuestButton.Visible = 'off'; % Hide the button after clicking
            
            % Display the title and subtitle
            titleY = 380; % Y position for the title
            subtitleY = titleY - 25; % Y position for the subtitle
            app.TitleLabel = uilabel(app.UIFigure);
            app.TitleLabel.FontSize = 36;
            app.TitleLabel.Position = [30 titleY 200 50];
            app.TitleLabel.Text = 'Lexi Learn';
            app.TitleLabel.FontColor = [1, 1, 1];

            app.SubtitleLabel = uilabel(app.UIFigure);
            app.SubtitleLabel.FontSize = 14;
            app.SubtitleLabel.Position = [30 subtitleY 200 20];
            app.SubtitleLabel.Text = 'Developed by Max Twelftree';
            app.SubtitleLabel.FontColor = [1, 1, 1];

            app.RulesTextArea = uilabel(app.UIFigure);
            app.RulesTextArea.FontSize = 14;
            app.RulesTextArea.Position = [30 subtitleY 200 0];
            app.RulesTextArea.Text = [
            'Here are the rules of the game:'; ...
                "1. It's a single player game"; ...
                "2. Starts with asking what house you wish to be apart of"; ...
                "3. Asks for a username (must be 8 characters)"; ...
                "4. Pushes to the word Arena (Round play)"; ...
                "5. The game is simple, try to add the correct letters to words and score Xp"; ...
                "6. You have 3 lives"; ...
                "7. A streak of 5 correct words gives you a wand (extra Xp)"; ...
                "8. Upgrading a wand costs you Xp"; ...
                "9. Skipping a move costs you an extra 40 Xp"; ...
                "10. To get the damage details, press d in Enter Your Attack"; ...
            ];
            app.RulesTextArea.FontColor = [1, 1, 1];


            app.UIFigure.Visible = 'on';
        end
    end
    
    methods (Access = private)
        % Button pushed function: StartQuestButton
        function StartQuestButtonPushed(app, event)
            displayTitleAndRules(app);
        end
    end

    methods (Access = public)
        function app = app1_exported
            createComponents(app);
            registerApp(app, app.UIFigure);

            if nargout == 0
                clear app
            end
        end

        function delete(app)
            delete(app.UIFigure);
        end
    end
end
