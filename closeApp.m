        % CLOSEAPP: safely closes the app, ensuring that the audio player and timer are properly stopped.
        function closeApp(app)
            if ~isempty(app.audioPlayer) && isplaying(app.audioPlayer)
                stop(app.audioPlayer);
            end
            
            if ~isempty(app.AudioTimer) && isvalid(app.AudioTimer)
                stop(app.AudioTimer);
                delete(app.AudioTimer);
            end
            delete(app.UIFigure);
        end