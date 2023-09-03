%% Story Select screen
        % STORYSELECT: Initializes the story selection interface where users can choose 
        % a story to display.
        function storySelect(app)
            % STORYUI: Represents the main story selection interface
            app.StoryUI = uifigure('Visible', 'on');
            app.StoryUI.Position = [100, 100, 600, 400];
            app.StoryUI.Name = 'Select a Story';
            app.StoryUI.Color = [1 1 1];
    
            % SELECTLABEL: Informs users about the purpose of the interface
            selectLabel = uilabel(app.StoryUI);
            selectLabel.Text = 'Select your story 📖';
            selectLabel.FontSize = 16;
            selectLabel.FontWeight = 'bold';
            selectLabel.Position = [150, 350, 300, 30]; 
            selectLabel.HorizontalAlignment = 'center';
            selectLabel.FontColor = [0 85/255 164/255];
    
            % EXITBUTTON: Lets users close the story selection interface
            exitButton = uibutton(app.StoryUI, 'push');
            exitButton.ButtonPushedFcn = @(~,~) app.exitButtonPushedStory();
            exitButton.Position = [app.StoryUI.Position(3) - 100, app.StoryUI.Position(4) - 40, 70, 30];  
            exitButton.FontColor = [1, 1, 1];
            exitButton.BackgroundColor = [0.3, 0.6, 1];
            exitButton.Text = 'Exit';
    
            % Hiding the main application window duriEng story selection
            app.UIFigure.Visible = 'off'; 
            
            % STORY''BUTTON: involve buttons for seperate stories
            % Each button corresponds to a different story. When a button is pressed, 
            % it triggers the respective story to be displayed.
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