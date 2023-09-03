%% Start the challenge
        % STARTCHALLENGE:starts the challenge with an extensive amount of
        % functionality allowing for user's to gain streaks and increase
        % levels
        function startChallenge(app, selectedLevel)        
            app.ChallengeUI = uifigure('Visible', 'on');
            app.ChallengeUI.Position = [100, 100, 600, 400];
            app.ChallengeUI.Name = 'Challenge';
            app.ChallengeUI.Color = [1 1 1];

            % Exit button to allow users to go back to the main page 
            exitButtonLevel = uibutton(app.ChallengeUI, 'push');
            exitButtonLevel.ButtonPushedFcn = @(~,~) app.exitChallenge();
            exitButtonLevel.Position = [30, 30, 100, 30];
            exitButtonLevel.FontColor = [1, 1, 1];
            exitButtonLevel.BackgroundColor = [0.3, 0.6, 1];
            exitButtonLevel.Text = 'Exit'

            app.UIFigure.Visible = 'off';
    
            % a switch statement to determine the appropriate level file based on the selected level.
            switch selectedLevel
                case 1
                    % If the selected level is 1, set the level file to level1.txt
                    levelFile = 'level1.txt';
                case 2
                    % If the selected level is 2, set the level file to level2.txt
                    levelFile = 'level2.txt';
                case 3
                    % If the selected level is 3, set the level file to level3.txt
                    levelFile = 'level3.txt';
                otherwise
                    % Foer any other value of selected level, default to level1.txt
                    levelFile = 'level1.txt';
            end
        
            % load the challenge content from the corresponding level's file
            challengeContent = fileread(levelFile);
        
            % Spldit the content into lines
            lines = strsplit(challengeContent, '\n');
        
            % Initialize variables to store French words and English translations
            frenchWords = {};
            englishTranslations = {};
        
            % parse the lines to extract French words and English translations
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

            % Cereate a label to display instructions for the challenge
            translateLabel = uilabel(app.ChallengeUI);
            translateLabel.Text = 'Translate the French word to English. 5 in a row allows you to level up!';
            translateLabel.HorizontalAlignment = 'center'; % Center the text within the label
            translateLabel.FontSize = 16;
            translateLabel.FontWeight = 'bold';
            translateLabel.FontColor = [0 85/255 164/255];
            translateLabel.Position = [150, 350, 300, 30];
            
            % Create a label to display the French word that needs translation
            frenchWordLabel = uilabel(app.ChallengeUI);
            frenchWordLabel.Text = frenchWord;
            frenchWordLabel.FontSize = 16;
            frenchWordLabel.HorizontalAlignment = 'center'; % Center the French word text within the label
            frenchWordLabel.Position = [150, 300, 300, 30]; % set position for the French word label
            
            % Create an edit field where users can input their English translation guess
            guessEditField = uieditfield(app.ChallengeUI, 'text');
            guessEditField.Position = [200, 250, 200, 30]; % Set the position for the edit field
            
            % Create a "Submit" button for users to submit their translation guess
            submitButton = uibutton(app.ChallengeUI, 'push');
            submitButton.Text = 'Submit';
            submitButton.Position = [250, 200, 100, 30];
            submitButton.FontWeight = 'bold';
            submitButton.FontSize = 14;
            submitButton.BackgroundColor = [0.3, 0.6, 1];
            submitButton.FontColor = [1, 1, 1];
            submitButton.ButtonPushedFcn = @(~,~) checkGuess(app, guessEditField.Value, correctTranslation); % Setr the callback function to check the guess when the button is pressed
              