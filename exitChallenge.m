        % EXITCHALLENGE: executed when the exit button in the ChallengeUI is pushed
        function exitChallenge(app)
            delete(app.ChallengeUI);  % Remove the challenge UI
            createHomeScreen(app);    % Return to the home screen
        end