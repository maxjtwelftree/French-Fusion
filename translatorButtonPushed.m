% TRANSLATORBUTTONPUSHED: Switches the interface to the translator screen
        function translatorButtonPushed(app, ~)
            delete(app.HomeUI);   % Remove the home UI
            createTranslator(app); % Create the translator UI
        end