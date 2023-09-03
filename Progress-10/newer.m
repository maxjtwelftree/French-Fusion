classdef newer < matlab.apps.AppBase

    properties (Access = public)
        UIFigure           matlab.ui.Figure
        HomeUI             matlab.ui.Figure
        LoadingLabel       matlab.ui.control.Label
        StartButton        matlab.ui.control.Button
        SubmitButton       matlab.ui.control.Button
        EditText           matlab.ui.control.EditField
        TranslationLabel   matlab.ui.control.Label
        Data               struct
    end

    properties (Access = private)
        LoadingAnimationTimer
        LoadingAnimationStep = 0
    end

    properties (Access = private)
        animationTimer
        animationStep = 0
    end

    methods (Access = private)

        function startupFcn(app)
            app.Data = app.readDictionaryFile('dictionary.txt');
            createLoadingPage(app);
        end

        function createLoadingPage(app)
            app.UIFigure = uifigure('Visible', 'on');
            app.UIFigure.Position = [100, 100, 600, 400];
            app.UIFigure.Name = 'French Translator';
            app.UIFigure.Color = [1 1 1];  
            
            app.LoadingLabel = uilabel(app.UIFigure);
            app.LoadingLabel.Text = 'Loading';
            app.LoadingLabel.FontSize = 20;
            app.LoadingLabel.FontWeight = 'bold';
            app.LoadingLabel.FontColor = [239, 65, 53] / 255;  
            app.LoadingLabel.Position = [150, 180, 300, 30];
            app.LoadingLabel.HorizontalAlignment = 'center';
            
            app.StartButton = uibutton(app.UIFigure, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @startButtonPushed, true);
            app.StartButton.Position = [250, 150, 100, 30];
            app.StartButton.Text = 'Start';
            app.StartButton.FontSize = 14;
            app.StartButton.BackgroundColor = [0.3, 0.6, 1];
            app.StartButton.FontColor = [1, 1, 1];
            
            app.LoadingAnimationTimer = timer(...
                'ExecutionMode', 'fixedRate', ...
                'Period', 0.5, ...
                'TimerFcn', @(~,~) toggleDots(app) ...
            );
            start(app.LoadingAnimationTimer);
        end
        
        function toggleDots(app)
            dots = {'.', '..', '...'};
            app.LoadingLabel.Text = ['Loading', dots{app.LoadingAnimationStep+1}];
            app.LoadingAnimationStep = mod(app.LoadingAnimationStep + 1, 3);
        end

        function startButtonPushed(app, ~)
            app.LoadingLabel.Visible = 'off';
            app.StartButton.Visible = 'off';
            createHomeScreen(app); 
        end

        function createTranslator(app)
            app.UIFigure = uifigure('Visible', 'on');
            app.UIFigure.Position = [100, 100, 600, 400];
            app.UIFigure.Name = 'French Translator';
            app.UIFigure.Color = [1 1 1]; 
            
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
            app.EditText.BackgroundColor = [1, 1, 1];  
            
            app.TranslationLabel = uilabel(app.UIFigure);
            app.TranslationLabel.Position = [150, 150, 300, 200];
            app.TranslationLabel.FontSize = 14;
            app.TranslationLabel.FontWeight = 'bold';
            app.TranslationLabel.HorizontalAlignment = 'center';
            app.TranslationLabel.BackgroundColor = [1, 1, 1];  
            app.TranslationLabel.VerticalAlignment = 'top';
            app.TranslationLabel.WordWrap = 'on';
            app.TranslationLabel.Text = '';
            
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

        function createHomeScreen(app)
            app.HomeUI = uifigure('Visible', 'off');
            app.HomeUI.Position = [100, 100, 600, 400];
            app.HomeUI.Name = 'Home Screen';
            app.HomeUI.Color = [1 1 1];  % Light gray background color
            
            % Title Label
            titleLabel = uilabel(app.HomeUI);
            titleLabel.Text = 'Francais Fusion';
            titleLabel.FontSize = 28;
            titleLabel.FontWeight = 'bold';
            titleLabel.FontColor = [0 85/255 164/255];  % Dark blue font color
            titleLabel.Position = [150, 320, 300, 40];  % Above the name label
            titleLabel.HorizontalAlignment = 'center';
        
            % Welcome Label
            welcomeLabel = uilabel(app.HomeUI);
            welcomeLabel.Text = 'Bienvenue!';
            welcomeLabel.FontSize = 32;
            welcomeLabel.FontWeight = 'bold';
            welcomeLabel.FontColor = [239, 65, 53] / 255; % French red font color
            welcomeLabel.Position = [150, 280, 300, 40]; % Adjusted position
            welcomeLabel.HorizontalAlignment = 'center';
        
            % Buttons
            buttonWidth = 120;
            buttonHeight = 40;
            buttonSpacing = 20;
            
            startX = (app.HomeUI.Position(3) - (3 * buttonWidth + 2 * buttonSpacing)) / 2;
            buttonY = (app.HomeUI.Position(4) - buttonHeight) / 2; % Adjusted position
            
            exitButton = uibutton(app.HomeUI, 'push');
            exitButton.ButtonPushedFcn = createCallbackFcn(app, @exitButtonPushed, true);
            exitButton.Position = [startX, buttonY, buttonWidth, buttonHeight];
            exitButton.Text = 'Exit';
            
            translatorButton = uibutton(app.HomeUI, 'push');
            translatorButton.ButtonPushedFcn = createCallbackFcn(app, @translatorButtonPushed, true);
            translatorButton.Position = [startX + buttonWidth + buttonSpacing, buttonY, buttonWidth, buttonHeight];
            translatorButton.Text = 'Translator';
            
            challengeButton = uibutton(app.HomeUI, 'push');
            challengeButton.ButtonPushedFcn = createCallbackFcn(app, @challengeButtonPushed, true);
            challengeButton.Position = [startX + 2 * (buttonWidth + buttonSpacing), buttonY, buttonWidth, buttonHeight];
            challengeButton.Text = 'Challenge';         
            
            developedByLabel = uilabel(app.HomeUI);
            developedByLabel.Text = 'Developed By Max Twelftree';
            developedByLabel.FontSize = 10;
            developedByLabel.FontColor = [0.5 0.5 0.5];  
            developedByLabel.Position = [150, 240, 300, 40];
            developedByLabel.HorizontalAlignment = 'center';
            
            app.HomeUI.Visible = 'on';
        end

        function translatorButtonPushed(app, ~)
            delete(app.HomeUI);
        
            createTranslator(app);
        end

        function exitButtonPushed(app, ~)
            close(app.HomeUI);
        end

        function createRandomChallenge(app)
            englishWords = keys(app.Data.dictionary); 
            randomIndex = randi(length(englishWords)); 
            randomEnglishWord = englishWords{randomIndex}; 
            
            app.UIFigure = uifigure('Visible', 'on');
            app.UIFigure.Position = [100, 100, 600, 400];
            app.UIFigure.Name = 'Challenge';
            app.UIFigure.Color = [1 1 1];  
            
            app.EditText = uieditfield(app.UIFigure, 'text');
            app.EditText.ValueChangedFcn = createCallbackFcn(app, @EditTextValueChanged, true);
            app.EditText.Position = [150, 60, 300, 30];
            app.EditText.FontSize = 14;
            app.EditText.BackgroundColor = [1, 1, 1];  
            
            app.TranslationLabel = uilabel(app.UIFigure);
            app.TranslationLabel.Position = [150, 150, 300, 200];
            app.TranslationLabel.FontSize = 14;
            app.TranslationLabel.FontWeight = 'bold';
            app.TranslationLabel.HorizontalAlignment = 'center';
            app.TranslationLabel.BackgroundColor = [1, 1, 1];  
            app.TranslationLabel.VerticalAlignment = 'top';
            app.TranslationLabel.WordWrap = 'on';
            app.TranslationLabel.Text = sprintf('Translate the English word "%s" to French:', randomEnglishWord);
            
            app.SubmitButton = uibutton(app.UIFigure, 'push');
            app.SubmitButton.ButtonPushedFcn = createCallbackFcn(app, @SubmitButtonPushed, true);
            app.SubmitButton.Position = [250, 10, 100, 30];
            app.SubmitButton.Text = 'Submit';
            app.SubmitButton.FontSize = 14;
            app.SubmitButton.BackgroundColor = [0.3, 0.6, 1];
            app.SubmitButton.FontColor = [1, 1, 1];
        end
        
        function challengeButtonPushed(app, ~)
            delete(app.HomeUI);
            createChallenge(app);        
        end
        
    end

    methods (Access = public)
        function app = newer
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [1 1 1];  
            
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