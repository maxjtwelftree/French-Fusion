% TOGGLEDOTS: Function to toggle the display of dots on the loading label
        % animating the loading screen
        function toggleDots(app)
            % Define an array of dots to cycle through
            dots = {'.', '..', '...'};
            % Update the loading label with the appropriate number of dots
            app.LoadingLabel.Text = ['Loading', dots{app.LoadingAnimationStep+1}];
            % Update the animation step, looping back to 0 after reacting 2
            app.LoadingAnimationStep = mod(app.LoadingAnimationStep + 1, 3); 
        end
