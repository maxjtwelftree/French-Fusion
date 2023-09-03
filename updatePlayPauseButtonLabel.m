% UPDATEPLAYPAUSEBUTTONLABEL: Updates the play/pause button label based on the audio playback state
        function updatePlayPauseButtonLabel(app, playPauseButton)
            if app.isPlayingAudio
                playPauseButton.Text = '⏸️';
            else
                playPauseButton.Text = '▶️';
            end
        end