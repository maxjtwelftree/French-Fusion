classdef needswork < matlab.apps.AppBase

    properties (Access = public)
        UIFigure           matlab.ui.Figure
        LoadingLabel       matlab.ui.control.Label
        StartButton        matlab.ui.control.Button
        SubmitButton       matlab.ui.control.Button
        EditText           matlab.ui.control.EditField
        TranslationLabel   matlab.ui.control.Label
        Data               struct
    end

    methods (Access = private)

        function startupFcn(app)
            createLoadingPage(app);
        end

        function createLoadingPage(app)
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100, 100, 600, 400];
            app.UIFigure.Name = 'French Translator';
            app.UIFigure.Color = [1 1 1];  % White background color
            
            app.LoadingLabel = uilabel(app.UIFigure);
            app.LoadingLabel.Text = 'Loading...';
            app.LoadingLabel.FontSize = 20;
            app.LoadingLabel.FontWeight = 'bold';
            app.LoadingLabel.FontColor = [0.2 0.2 0.7];  % Dark blue font color
            app.LoadingLabel.Position = [150, 180, 300, 30];
            app.LoadingLabel.HorizontalAlignment = 'center';
            
            app.StartButton = uibutton(app.UIFigure, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @startButtonPushed, true);
            app.StartButton.Position = [250, 150, 100, 30];
            app.StartButton.Text = 'Start';
            app.StartButton.FontSize = 14;
            app.StartButton.BackgroundColor = [0.3, 0.6, 1];
            app.StartButton.FontColor = [1, 1, 1];
        end
        
        function startButtonPushed(app, ~)
            delete(app.LoadingLabel);
            delete(app.StartButton);
            createTranslator(app);
        end

        function createTranslator(app)
            app.UIFigure.Visible = 'on';
            app.UIFigure.Position = [100, 100, 600, 400];
            app.UIFigure.Name = 'French Translator';
            app.UIFigure.Color = [0.9 0.9 0.95];  % Light gray background color
            
            developedByLabel = uilabel(app.UIFigure);
            developedByLabel.Text = 'Developed By Max Twelftree';
            developedByLabel.FontSize = 10;
            developedByLabel.FontColor = [0.5 0.5 0.5];  % Gray font color
            developedByLabel.Position = [150, 330, 300, 20];  % Centered above the translation box
            developedByLabel.HorizontalAlignment = 'center';

            titleLabel = uilabel(app.UIFigure);
            titleLabel.Text = 'Francais Fusion';
            titleLabel.FontSize = 20;
            titleLabel.FontWeight = 'bold';
            titleLabel.FontColor = [0.2 0.2 0.7];  % Dark blue font color
            titleLabel.Position = [150, 300, 300, 30];  % Above the name label
            titleLabel.HorizontalAlignment = 'center';  % Center the text
            
            app.SubmitButton = uibutton(app.UIFigure, 'push');
            app.SubmitButton.ButtonPushedFcn = createCallbackFcn(app, @SubmitButtonPushed, true);
            app.SubmitButton.Position = [250, 10, 100, 30];
            app.SubmitButton.Text = 'Translate';
            app.SubmitButton.FontSize = 14;
            app.SubmitButton.BackgroundColor = [0.3, 0.6, 1];
            app.SubmitButton.FontColor = [1, 1, 1];
            
            app.EditText = uieditfield(app.UIFigure, 'text');
            app.EditText.ValueChangedFcn = createCallbackFcn(app, @EditTextValueChanged, true);
            app.EditText.Position = [150, 60, 300, 30];
            app.EditText.FontSize = 14;
            app.EditText.BackgroundColor = [1, 1, 1];  % White background color
            
            app.TranslationLabel = uilabel(app.UIFigure);
            app.TranslationLabel.Position = [150, 150, 300, 200];
            app.TranslationLabel.FontSize = 14;
            app.TranslationLabel.FontWeight = 'bold';
            app.TranslationLabel.HorizontalAlignment = 'center';
            app.TranslationLabel.BackgroundColor = [1, 1, 1];  % White background color
            app.TranslationLabel.VerticalAlignment = 'top';
            app.TranslationLabel.WordWrap = 'on';
            app.TranslationLabel.Text = '';
            
            app.Data = app.readDictionaryFile('dictionary.txt');
        end

        function data = readDictionaryFile(~, filename)
            fid = fopen(filename, 'r');
            C = textscan(fid, '%s %s %s %s', 'Delimiter', ';');
            fclose(fid);

            frenchWords = C{1};
            englishTranslations = C{4};

            dictionary = containers.Map('KeyType', 'char', 'ValueType', 'any');
            for i = 1:numel(frenchWords)
                word = frenchWords{i};
                translation = englishTranslations{i};
                if isKey(dictionary, word)
                    translations = dictionary(word);
                    translations{end+1} = translation;
                else
                    translations = {translation};
                end
                dictionary(word) = translations;
            end

            data.dictionary = dictionary;
        end

        function EditTextValueChanged(app, ~)
            updateTranslationLabel(app);
        end

        function SubmitButtonPushed(app, ~)
            updateTranslationLabel(app);
        end

        function updateTranslationLabel(app)
            dictionary = app.Data.dictionary;
            userGuess = app.EditText.Value;
            translations = dictionary(userGuess);

            if ~isempty(translations)
                translationStr = sprintf('English translation for "%s":\n', userGuess);
                for i = 1:numel(translations)
                    translationStr = sprintf('%s%s\n', translationStr, translations{i});
                end
                app.TranslationLabel.Text = translationStr;
            else
                app.TranslationLabel.Text = 'Translation not found';
            end
        end
    end

    methods (Access = public)
        function app = needswork
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [1 1 1];  % White background color
            
            startupFcn(app);
            registerApp(app, app.UIFigure);
            app.UIFigure.Visible = 'on';
            
            if nargout == 0
                clear app
            end
        end
        
        function refresh(app)
            updateTranslationLabel(app);
        end
    end
end
