%% Story reading screen 
        % CREATESTORYUI: Cronstructs the user interface for displaying a story
        function createStoryUI(app, storyTitle, storyFileName)
            % Check if the story UI exists and is still valid.
            if isempty(app.Story1UI) || ~isvalid(app.Story1UI)
                % Initialize the main story window with specified properties
                app.Story1UI = uifigure('Visible', 'off');
                app.Story1UI.Position = [100, 100, 600, 400];
                app.Story1UI.Name = storyTitle; % The title of the story to be displayed
                app.Story1UI.Color = [1 1 1]; 
        
                % Create a scrosllable panel to contain the story text
                storyPanel = uipanel(app.Story1UI);
                storyPanel.Position = [20, 20, 560, 360];  
                storyPanel.BackgroundColor = [1, 1, 1];  
                storyPanel.Scrollable = 'on';  
        
                % Create a text area inside the panel to display the story
                storyTextArea = uitextarea(storyPanel);
                storyTextArea.Position = [10, 10, 540, 340];
                storyTextArea.FontSize = 14;
                storyTextArea.Value = fileread(storyFileName);  
        
                % Add an exit button to close the story UI
                exitButton = uibutton(app.Story1UI, 'push');
                exitButton.ButtonPushedFcn = createCallbackFcn(app, @exitButtonPushedStoryUI, true);
                exitButton.Position = [app.Story1UI.Position(3) - 100, app.Story1UI.Position(4) - 40, 70, 30];  
                exitButton.FontColor = [1, 1, 1];
                exitButton.BackgroundColor = [0.3, 0.6, 1];
                exitButton.Text = 'Exit';
    
                % Display the story UI
                app.Story1UI.Visible = 'on';
            end
        end