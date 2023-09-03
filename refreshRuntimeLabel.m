% REFRESHRUNTIMELABEL: Updates the audio runtime label
        function refreshRuntimeLabel(app)
            if ~isempty(app.audioPlayer) && isplaying(app.audioPlayer)
                elapsedTime = toc(app.StartTime);
                app.RuntimeLabel.Text = sprintf('🎶: %d seconds', round(elapsedTime));
            end
        end