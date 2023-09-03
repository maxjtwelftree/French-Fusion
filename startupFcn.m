% Startup page, reads the dictionary utilised, loads the time and
        % updates the score
        function startupFcn(app)
            app.Data = app.readDictionaryFile('dictionary.txt'); % reading the dictionary.txt file utilised for translation
            createLoadingPage(app);
            app.StartTime = tic();
            % Audio timer for the study music implemented tracked
            app.AudioTimer = timer(...
                'ExecutionMode', 'fixedRate', ...
                'Period', 1, ... 
                'TimerFcn', @(~,~) app.refreshRuntimeLabel() ...
            );
            start(app.AudioTimer); 
        end