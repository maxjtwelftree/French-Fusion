% EXITBUTTONPUSHEDSTORY: exits the story interface and returns to the home screen.
        function exitButtonPushedStory(app, ~)
            delete(app.StoryUI);  % Hide the StoryUI
            createHomeScreen(app); % create the home screen UI
        end