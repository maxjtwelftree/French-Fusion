% CHECKGUESS: Compare the guess to the correct translation
            function checkGuess(app, guess, correctTranslation, frenchWords, englishTranslations, frenchWordLabel, guessEditField, submitButton)
                if strcmp(guess, correctTranslation)
                    % Increment the streak by one
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
                        % suggest to go to the next level due to the high
                        % streak
                        nextLevelButton = uibutton(app.ChallengeUI, 'push');
                        nextLevelButton.Position = [250, 100, 100, 30];
                        nextLevelButton.Text = 'Next Level';
                        nextLevelButton.FontWeight = 'bold';
                        nextLevelButton.FontSize = 12;
                        nextLevelButton.BackgroundColor = [0.3, 0.6, 1];
                        nextLevelButton.FontColor = [1, 1, 1];
                        nextLevelButton.ButtonPushedFcn = @(~,~) app.startChallenge(selectedLevel + 1); % Move to the next level
                    end
                    
                    % wait for a moment to show the correct message
                    pause(1);
                    
                    % delete the message
                    delete(message);
                    
                    % Chooese another new random word from the same level
                    randomIndex = randi(length(frenchWords));
                    frenchWord = frenchWords{randomIndex};
                    correctTranslation = englishTranslations{randomIndex};
                    
                    % Update UI components with the new word
                    frenchWordLabel.Text = frenchWord;
                    guessEditField.Value = '';
                    
                else
                    % display a message indicating incorrectness
                    app.streak = 0;
                    message = uilabel(app.ChallengeUI);
                    message.Text = 'Incorrect ❌';
                    message.FontSize = 16;
                    message.Position = [230, 150, 140, 30];
                    message.FontColor = [0 85/255 164/255];
                    message.HorizontalAlignment = 'center'; % Center the text
                    
                    % Wait for a moment to show the incorrect message
                    pause(1);
                    
                    % delete the message
                    delete(message);
                end
            end
            % Adjust the submit button's callback function to check the user's translation guess
            submitButton.ButtonPushedFcn = @(~,~) checkGuess(app, guessEditField.Value, correctTranslation, frenchWords, englishTranslations, frenchWordLabel, guessEditField, submitButton);
        end