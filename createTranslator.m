%% Translator page being created as another function for users to utilise 
        % CREATETRANSLATOR: initialises the translator page with a submit
        % button reading from the core translator loaded within the
        % startupFcn. Callbacks are utilised to display messages to the
        % user based on their input they feed to the translator.
        % Exit buttons are also used to allow the user to go back to the
        % home page and later access other modes
        function createTranslator(app)
            % UIFIGURE: Used for the UI of the translator (note: wasn't changed due to errors that came with a new UI 
            app.UIFigure = uifigure('Visible', 'on'); % Represents the main window for the translator
            app.UIFigure.Position = [100, 100, 600, 400]; % position and size
            app.UIFigure.Name = 'Translator'; % Provides a title 
            app.UIFigure.Color = [1 1 1]; %  the background color of the main window
    
            % SUBMITBUTTION: Represents the button users press to trigger the translation
            app.SubmitButton = uibutton(app.UIFigure, 'push'); 
            app.SubmitButton.ButtonPushedFcn = @app.submitTranslation; % Callback so once the submit button is pressed a message displaying the text's translations from the dictionary text file are processed 
            app.SubmitButton.Position = [250, 10, 100, 30]; % position and size
            app.SubmitButton.Text = 'Translate'; % Provides a title for the button
            app.SubmitButton.FontSize = 14; % font size used for the button 
            app.SubmitButton.BackgroundColor = [0.3, 0.6, 1]; % background colour as maintained by other buttons
            app.SubmitButton.FontColor = [1, 1, 1]; % font colour as maintained by other buttons 
    
            % EDITTEXT: Allows users to type in the text they want translated.
            app.EditText = uieditfield(app.UIFigure, 'text');
            app.EditText.ValueChangedFcn = createCallbackFcn(app, @EditTextValueChanged, true); % Callback used for the buttons functionality 
            app.EditText.Position = [150, 60, 300, 30]; % Sets the position and size of the input field
            app.EditText.FontSize = 14; % font size used 
            app.EditText.BackgroundColor = [1, 1, 1]; 
    
            % TRANSLATIONLABEL: Displays the resulting translation
            app.TranslationLabel = uilabel(app.UIFigure);
            app.TranslationLabel.Position = [150, 150, 300, 200]; % Sets where the label appears and its dimensions
            app.TranslationLabel.FontSize = 14;
            app.TranslationLabel.FontWeight = 'bold';
            app.TranslationLabel.HorizontalAlignment = 'center';
            app.TranslationLabel.BackgroundColor = [1, 1, 1];  
            app.TranslationLabel.VerticalAlignment = 'top';
            app.TranslationLabel.WordWrap = 'on';
            app.TranslationLabel.Text = '';
    
            % EXITBUTTON: Lets users close the translation window and return to the home screen
            exitButton = uibutton(app.UIFigure, 'push');
            exitButton.ButtonPushedFcn = createCallbackFcn(app, @exitButtonPushed, true);
            exitButton.Position = [app.UIFigure.Position(3) - 100, app.UIFigure.Position(4) - 40, 70, 30];  
            exitButton.FontColor = [1, 1, 1];
            exitButton.BackgroundColor = [0.3, 0.6, 1];
            exitButton.Text = 'Exit';
    
            % HANDLING EXIT BUTTON ACTION
            % Closes the translator window and brings the user back to the home screen
            function exitButtonPushed(app, ~)
                delete(app.UIFigure);  
                createHomeScreen(app); 
            end
        end