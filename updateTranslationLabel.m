%% Translation label
        % UPDATETRANSLATIONLABEL: Updates the translation label based on the user's input in the edittext field
        function updateTranslationLabel(app)
            dictionary = app.Data.dictionary;
            % Get the user's guess/input from the EditText field
            userGuess = app.EditText.Value;
    
            % Check if the user's input exists in the dictionary
            if isKey(dictionary, userGuess)
                translations = dictionary(userGuess);
                
                % If translations are found, display them
                if ~isempty(translations)
                    translationStr = sprintf('English translation for "%s":\n', userGuess);
                    for i = 1:numel(translations)
                        translationStr = sprintf('%s%s\n', translationStr, translations{i});
                    end
                    app.TranslationLabel.Text = translationStr;
                else
                    app.TranslationLabel.Text = 'No translation found';
                end
            else
                app.TranslationLabel.Text = 'Word not found in dictionary. Try another word.';
            end
        end