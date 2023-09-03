% STORYBUTTONPUSHED: executed when the story button is pushed
        function storyButtonPushed(app, ~)    
            delete(app.HomeUI); % Delete the home UI.
            createStorySelect(app); % Transition to the story selection interface.
        end