%% Play/Pause function
        % PLAYPAUSEBUTTONPUSHED: Toggles the audio playback between play and pause.
        function playPauseButtonPushed(app, playPauseButton)
            try
                % Check if the audioPlayer is not initialized.
                if isempty(app.audioPlayer)
                    % Load the audio data and adjust its volume.
                    [audioData, fs] = audioread('said.wav');
                    audioData = app.VolumeSlider.Value * audioData;
                    app.audioPlayer = audioplayer(audioData, fs);
                end
                
                % Check if audio is currently playing.
                if app.isPlayingAudio
                    pause(app.audioPlayer);
                    app.isPlayingAudio = false;
                    stop(app.AudioTimer); % Stop the audio timer.
                else
                    play(app.audioPlayer);
                    app.isPlayingAudio = true;
                    start(app.AudioTimer); % Start the audio timer.
                end
    
                % Refresh runtime label and update button label.
                app.refreshRuntimeLabel();
                app.updatePlayPauseButtonLabel(playPauseButton);
            catch exception
                disp('Error reading audio file:');
                disp(exception.message);
            end
        end