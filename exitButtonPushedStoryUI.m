% EXITBUTTONPUSHEDSTORYUI: executed when the exit button in the StoryUI is pushed
        function exitButtonPushedStoryUI(app, ~)
            delete(app.Story1UI);  % Remove the story UI.
            createHomeScreen(app); % Return to the home screen
        end