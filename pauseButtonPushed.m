% PAUSEBUTTONPUSHED: Pauses the audio playback
        function pauseButtonPushed(app, ~)
            if ~isempty(app.audioPlayer) && isplaying(app.audioPlayer)
                pause(app.audioPlayer);
                app.isPlayingAudio = false;
                app.updatePlayPauseButtonLabel();
            end
        end