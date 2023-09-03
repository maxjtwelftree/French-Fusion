        % CHALLENGEBUTTONPUSHED: switches to the challenge screen
        function challengeButtonPushed(app, ~)    
            delete(app.HomeUI);   % Remove the home UI
            createChallenge(app); % Creates the challenge UI.
        end