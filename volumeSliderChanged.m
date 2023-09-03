%% Volume Slider
        % VOLUMESLIDERCHANGED: Updates the volume of the audio player based on the slider's value
        function volumeSliderChanged(app)
            % Check if the audio player object is initialized and not empty
            if ~isempty(app.audioPlayer)
                % If the audio is currently playing, pause it and modify the volume
                if isplaying(app.audioPlayer)
                    pause(app.audioPlayer); 
                    
                    % Read the audio fidle
                    [audioData, fs] = audioread('said.wav');
                    
                    % Adjust the audio data based on the voelume slider value
                    newAudioData = app.VolumeSlider.Value * audioData;
                    app.audioPlayer = audioplayer(newAudioData, fs);
                    
                    % Resume playing the audio with the new voelume level
                    play(app.audioPlayer); 
                else
                    % If the audio is not playing, simply update the voelume property of the player
                    app.audioPlayer = audioplayer([], []);
                    app.audioPlayer.Volume = app.VolumeSlider.Value; 
                end
            end
        end