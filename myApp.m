%% Start of the application
% French Fusion executes a simplistic immersive language learning
% application for French learners.
% Three main features are included to allow for a better experience with
% the application. Story, translator and challenge. Story shares three
% graded readers users can utilise to build upon their reading
% comprehension. Translator reads off a text file of all French to English
% words and the challenge button executes three level's allowing users to
% attempt at testing their French vocabulary.
classdef myApp < matlab.apps.AppBase
    %% Public properties utilised within the application
    % The public roperties can be accessed from any other class or function
    % Figures, represent the loaded pages that come with callbacks utilised
    % Labels show design on figures without any action
    % Buttons alike labels show design but include functionality allowing
    % for user interation and execution via callbacks
    properties (Access = public)
        UIFigure           matlab.ui.Figure % Main user interface window for the loading and translator pages
        HomeUI             matlab.ui.Figure % User interface utilised for the home screen
        LoadingLabel       matlab.ui.control.Label % Label displaying loading status or messages
        StartButton        matlab.ui.control.Button % vuttton to initiate the application
        SubmitButton       matlab.ui.control.Button % Burtton to submit user responses 
        sumbitTranslation  matlab.ui.control.Button % Button to submit translated wird via user input 
        EditText           matlab.ui.control.EditField % Text field for user to input and edit 
        TranslationLabel   matlab.ui.control.Label % Label to display translated content 
        Data               struct % Data structure to store various relevant data  
        audioPlayer        audioplayer % Compornent to play audio content 
        StoryUI            matlab.ui.Figure % Usser interface to manage stories
        ChallengeUI        matlab.ui.Figure % User interface for challenges 
        Story1UI           matlab.ui.Figure % User interface specifically for Story 1 content
        Story2UI           matlab.ui.Figure % User interface specifically for Story 2 content
        Story3UI           matlab.ui.Figure % User interface specifically for Story 3 content
        StorySelectUI      matlab.ui.Figure % User interface to allow users to select a story
    end

    %% Private properites utilised within 
    % Differently, private properties can be accessed only from methods 
    % within the same class. As shown, many of which are utilised for
    % increased design and purpose amongst UI figures utilised within the
    % application
    properties (Access = private)
        LoadingAnimationTimer       % Timer object to control the loading animation
        LoadingAnimationStep = 0    % Current frame in the loading animation 
        StartTime                   % Start time used in the study music
        RuntimeLabel                % Larbel to display the runtime of the study music
        AudioTimer                  % Timer to manage audio time
        VolumeSlider                % User interface control to adjust audio volume
        InitialVolume = 0.5;        % Defaulrt or startup volume setting for study music 
        isPlayingAudio = false;     % Boolean flag to check if audio is currently playing
        HomeUIBackgroundColor       % Color setting for the background of the Home UI
        MusicPanel                  % UI panel or component related to music or audio settings
        ChallengeLevel = 1;         % Current challenge level or difficulty setting
        streak = 0;                 % Counter for consecutive successful actions of correct answers in a row within the challenge function
        CurrentLevel = 1;           % Current level or stage in the application or game, to allow users to increase levels as used within the challenges
        storyIndex                  % Index or identifier for the currently selected or active story
    end

    % All private methods utilised within the applications functionality 
    methods (Access = private)
        % STARTUPFCN: reads the dictionary utilised, loads the time and
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

        %% Loading page created
        % CREATELOADINGPAGE: shows the loading animation with a start
        % button initialising the application.
        function createLoadingPage(app)
            app.UIFigure = uifigure('Visible', 'on'); % The loading page UI figure
            app.UIFigure.Position = [100, 100, 600, 400]; % Position of the GUI, maintained by other pages
            app.UIFigure.Name = 'Loading'; % Title of the GUI for context
            app.UIFigure.Color = [1 1 1];  % White background colour as followed by other pages within the application
            
            app.LoadingLabel = uilabel(app.UIFigure); % Loading... label
            app.LoadingLabel.Text = 'Loading'; % Loading text for the label
            app.LoadingLabel.FontSize = 20;
            app.LoadingLabel.FontWeight = 'bold';
            app.LoadingLabel.FontColor = [239, 65, 53] / 255;  
            app.LoadingLabel.Position = [150, 180, 300, 30];
            app.LoadingLabel.HorizontalAlignment = 'center'; % Aligned in the centre for aesthetic

            app.StartButton = uibutton(app.UIFigure, 'push'); % Button functionality utilised to start the game
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @startButtonPushed, true); % Callback used for the buttons execution
            app.StartButton.Position = [250, 150, 100, 30];
            app.StartButton.Text = 'Start'; % Start text for the label
            app.StartButton.FontSize = 14;
            app.StartButton.BackgroundColor = [0.3, 0.6, 1]; % Different colours used as followed through the remainder of the app to match french colours
            app.StartButton.FontColor = [1, 1, 1]; % White colouring used as followed by the other buttons within the app
            
            % ... animation created and utilised for appearance within the
            % loading table
            app.LoadingAnimationTimer = timer(...
                'ExecutionMode', 'fixedRate', ...
                'Period', 0.5, ...
                'TimerFcn', @(~,~) toggleDots(app) ...
            );
            start(app.LoadingAnimationTimer);
        end
        
        % TOGGLEDOTS: Function to toggle the display of dots on the loading label
        % animating the loading screen
        function toggleDots(app)
            % Define an array of dots to cycle through
            dots = {'.', '..', '...'};
            % Update the loading label with the appropriate number of dots
            app.LoadingLabel.Text = ['Loading', dots{app.LoadingAnimationStep+1}];
            % Update the animation step, looping back to 0 after reacting 2
            app.LoadingAnimationStep = mod(app.LoadingAnimationStep + 1, 3); 
        end

        % Function to execute when the Start button is pushed
        function startButtonPushed(app, ~)
            % Make the loading label invisible
            app.LoadingLabel.Visible = 'off';
            % Make the start button invisible
            app.StartButton.Visible = 'off';
            % Call another function to create the home screen
            createHomeScreen(app); 
        end

        %% Home screen development with buttons, colour and text for the GUI
        % CREATEHOMESCREEN: initialises a home screen page with each main
        % mode of the application being present. Allowing users to go back
        % and forth from either mode and utilise further unique features.
        function createHomeScreen(app)
            % Check if the HomeUI property is empty or if the figure associated with it is not valid
            if isempty(app.HomeUI) || ~isvalid(app.HomeUI)
                % Create a new uifigure for the HomeUI if it doesn't exist or isn't valid
                app.HomeUI = uifigure('Visible', 'off'); % Initialize the figure with visibility set to off
                app.HomeUI.Position = [100, 100, 600, 400]; % Set the position and size of the uifigure
                app.HomeUI.Name = 'Home Screen'; % Name it
                app.HomeUI.Color = [1 1 1]; % Set the background color to white
                app.HomeUIBackgroundColor = app.HomeUI.Color; % Store the background color for future reference or use
            end
            
            % TITLELABEL: Title on the HomeUI for displaying the title, hence
            % the HomeScreen is not empty 
            titleLabel = uilabel(app.HomeUI);
            titleLabel.Text = 'French Fusion'; % Set the text of the label to 'French Fusion' which is the application title
            titleLabel.FontSize = 28; % Set the font size to 28
            titleLabel.FontWeight = 'bold'; % Use bold font weight for the title (for emphasis)
            titleLabel.FontColor = [0 85/255 164/255]; % The font color
            titleLabel.Position = [150, 320, 300, 40]; % Defines the position and size of the title 
            titleLabel.HorizontalAlignment = 'center'; % Center-align the title text 
            
            % WELCOMELABEL: Weclome in french to incease UI aesthetic and allow
            % for a more pleasant home screen
            welcomeLabel = uilabel(app.HomeUI);
            welcomeLabel.Text = 'Bienvenue!'; % Welcome title 
            welcomeLabel.FontSize = 32; % Set the font size to 32
            welcomeLabel.FontWeight = 'bold'; % Bold text for all sub headings and headings
            welcomeLabel.FontColor = [239, 65, 53] / 255; % The font color
            welcomeLabel.Position = [150, 280, 300, 40]; % Defines the position and size of the weclome  
            welcomeLabel.HorizontalAlignment = 'center'; % Center-align the title text 

            % EXITBUTTON: Takes the users out of the application entirely
            exitButton = uibutton(app.HomeUI, 'push'); % Push button for exiting the app
            exitButton.ButtonPushedFcn = @(~,~) app.exitButtonPushed(); % Executing and responding the the function supplied for the exit button (ie: leaving the application)
            exitButton.Position = [10, app.HomeUI.Position(4) - 40, 70, 30]; % Positioning in the top corner to allow less overflow of UI and design
            exitButton.FontColor = [1, 1, 1]; % White colour given and used with all buttons to correspond to the colours utilised throughout the applications entirety 
            exitButton.BackgroundColor = [0.3, 0.6, 1]; % home page exit buttons background colour as followed by all other buttons
            exitButton.Text = 'Exit'; % text for the button
                
            %  dimensions and spacing for the buttons
            buttonWidth = 120; % width of each button
            buttonHeight = 40; % Height of each button
            buttonSpacing = 20; % Spacing between adjacent buttons
            
            % Calculate the starting X-coordinate for the first button. This calculation ensures that all the buttons (considering their width and spacing) are centered within the HomeUI's width.
            startX = (app.HomeUI.Position(3) - (3 * buttonWidth + 2 * buttonSpacing)) / 2; 
            
            % Calculate the Y-coordinate for the button(s). This positions the button vertically centered in the HomeUI's height.
            buttonY = (app.HomeUI.Position(4) - buttonHeight) / 2; 
            
            % STORYBUTTON: Takes the users to the story page
            storyButton = uibutton(app.HomeUI, 'push'); 
            storyButton.ButtonPushedFcn = createCallbackFcn(app, @storyButtonPressed, true); % create the callback for the story button such that it repsonds to the button and opens the select your story page
            storyButton.Position = [startX, buttonY, buttonWidth, buttonHeight]; % Positioning the button with the above positioning
            storyButton.BackgroundColor = [0.3, 0.6, 1]; % Background colour as followed for all buttons 
            storyButton.FontColor = [1, 1, 1]; % font colour as followed by others 
            storyButton.Text = 'Story'; % text for the button 
                        
            % TRANSLATORBUTTON: Takes the users to the translator page
            translatorButton = uibutton(app.HomeUI, 'push'); 
            translatorButton.ButtonPushedFcn = createCallbackFcn(app, @translatorButtonPushed, true); % Creates the callback for the translator bytton so it responds and the translator page is opened once pressed
            translatorButton.Position = [startX + buttonWidth + buttonSpacing, buttonY, buttonWidth, buttonHeight];% Positioning the button with the above positioning
            translatorButton.BackgroundColor = [0.3, 0.6, 1]; % Background colour as followed for all buttons 
            translatorButton.FontColor = [1, 1, 1]; % font colour as followed by others 
            translatorButton.Text = 'Translator'; % text for the button 
                
            % CHALLENGEBUTTON: Takes the users to the challenge page
            challengeButton = uibutton(app.HomeUI, 'push'); % Button to take the users to the challenge 
            challengeButton.ButtonPushedFcn = createCallbackFcn(app, @challengeButtonPushed, true);% Creates the callback for the challenge button so it responds and the select your challenge page is opened once pressed
            challengeButton.Position = [startX + 2 * (buttonWidth + buttonSpacing), buttonY, buttonWidth, buttonHeight]; % Positioning the button with the above positioning
            challengeButton.BackgroundColor = [0.3, 0.6, 1]; % Background colour as followed for all buttons 
            challengeButton.FontColor = [1, 1, 1]; % font colour as followed by others 
            challengeButton.Text = 'Challenge';  % text for the button 
        
            % DEVELOPEDBYLABEL: Credits the developer within the home
            % screen
            developedByLabel = uilabel(app.HomeUI); 
            developedByLabel.Text = 'Developed By Max Twelftree';  % Set the label's text
            developedByLabel.FontSize = 10;  % Set the font size
            developedByLabel.FontColor = [0.5 0.5 0.5];  % Set the font color to a light gray, allowing for greater aesthetic 
            developedByLabel.Position = [150, 240, 300, 40];  % Set the position and size of the label
            developedByLabel.HorizontalAlignment = 'center';  % Center-align the label's text
            
            % MUSICPANEL: Stores a panel for user interation with study
            % The panel that will have the study music controls 
            musicPanel = uipanel(app.HomeUI);  
            musicPanel.Position = [200, 20, 200, 100];% Set position and size of the panel
            musicPanel.BorderType = 'none';  % Remove border around the panel
            musicPanel.BackgroundColor = [1, 1, 1];  % Set the panel's background color to white
            
            % Define the label inside the music panel
            musicLabel = uilabel(musicPanel);  
            musicLabel.Text = 'Study Music';  % Set label's text
            musicLabel.FontSize = 14;  % Set font size
            musicLabel.FontWeight = 'bold';  % Set font weight to bold for emphasis
            musicLabel.FontColor = [0 85/255 164/255];  % Set the font color, likely part of a theme
            musicLabel.BackgroundColor = [1 1 1];  % Set the label's background color to white
            musicLabel.Position = [50, 80, 100, 20];  % Set position and size of the label
            musicLabel.HorizontalAlignment = 'center';  % Center-align the label's text
                
            % music features
            app.MusicPanel = musicPanel;  
                
            % PLAYBUTTON: Plays the music allowing for users to choose
            % when they want to have the music playing
            % Define the play button inside the music panel
            playPauseButton = uibutton(musicPanel, 'push');  
            playPauseButton.Position = [45, 20, 50, 30];  % Set position and size of the button
            playPauseButton.Text = '▶️';  % Set button text to play icon
            playPauseButton.ButtonPushedFcn = @(~,~) app.playPauseButtonPushed(playPauseButton);  % Define the function to execute when button is pushed
                
            % PAUSEBUTTON: Pauses the music allowing for users to choose
            % when they want to have the music playing
            % Define the pause button inside the music panel
            pauseButton = uibutton(musicPanel, 'push');  
            pauseButton.Position = [105, 20, 50, 30];  % Set position and size of the button
            pauseButton.Text = '⏸️';  % Set button text to pause icon
            pauseButton.ButtonPushedFcn = @(~,~) app.pauseButtonPushed();  % Define the function to execute when button is pushed
               
            % RUNTIMELABEL: Showcases the runtime of the music within the
            % study music music panel 
            % Define the label showing music runtime
            app.RuntimeLabel = uilabel(app.HomeUI);  
            app.RuntimeLabel.Position = [250, 75, 100, 20];  % Set position and size of the label
            app.RuntimeLabel.FontSize = 12;  % Set the font size
            app.RuntimeLabel.Text = '🎶: 0 seconds';  % Set the label's initial text
            app.RuntimeLabel.HorizontalAlignment = 'center';  % Center-align the label's text
            
            % SETTIMEREFERENCE: Initializes the reference point to measure elapsed time 
            % of the study music.
            app.StartTime = tic(); 
            
            % UPDATELABELDISPLAY: Refresh or recalibrate the label that reflects 
            % the current runtime or duration of the application.
            app.refreshRuntimeLabel(); 
            
            % INITVOLUMESLIDER: Establishes a volume control slider inside the dedicated 
            % music panel for dynamic audio level adjustments.
            app.VolumeSlider = uislider(app.MusicPanel); 
            app.VolumeSlider.Position = [20, 10, 160, 3];  
            app.VolumeSlider.Value = app.InitialVolume;  
            app.VolumeSlider.Limits = [0, 1];  
            app.VolumeSlider.MajorTicks = [0, 0.5, 1];  
            app.VolumeSlider.MajorTickLabels = {'0', '0.5', '1'};  
            app.VolumeSlider.ValueChangedFcn = @(~,~) volumeSliderChanged(app);  

            app.HomeUI.Visible = 'on'; % Reassuring the home UI is visible and users can view
        end

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

        % HANDLING THE STORYBUTTON ACTION
        function storyButtonPressed(app, ~)
            delete(app.HomeUI); % Deletes the home page and opens the story select page
            storySelect(app); 
        end
        
        %% Story select screen
        % STORYSELECT: Initializes the story selection interface where users can choose 
        % a story to display.
        function storySelect(app)
            % STORYUI: Represents the main story selection interface
            app.StoryUI = uifigure('Visible', 'on');
            app.StoryUI.Position = [100, 100, 600, 400];
            app.StoryUI.Name = 'Select a Story';
            app.StoryUI.Color = [1 1 1];
    
            % SELECTLABEL: Informs users about the purpose of the interface
            selectLabel = uilabel(app.StoryUI);
            selectLabel.Text = 'Select your story 📖';
            selectLabel.FontSize = 16;
            selectLabel.FontWeight = 'bold';
            selectLabel.Position = [150, 350, 300, 30]; 
            selectLabel.HorizontalAlignment = 'center';
            selectLabel.FontColor = [0 85/255 164/255];
    
            % EXITBUTTON: Lets users close the story selection interface
            exitButton = uibutton(app.StoryUI, 'push');
            exitButton.ButtonPushedFcn = @(~,~) app.exitButtonPushedStory();
            exitButton.Position = [app.StoryUI.Position(3) - 100, app.StoryUI.Position(4) - 40, 70, 30];  
            exitButton.FontColor = [1, 1, 1];
            exitButton.BackgroundColor = [0.3, 0.6, 1];
            exitButton.Text = 'Exit';
    
            % Hiding the main application window duriEng story selection
            app.UIFigure.Visible = 'off'; 
            
            % STORY''BUTTON: involve buttons for seperate stories
            % Each button corresponds to a different story. When a button is pressed, 
            % it triggers the respective story to be displayed.
            story1Button = uibutton(app.StoryUI, 'push');
            story1Button.ButtonPushedFcn = @(~,~) app.displayStory(1);
            story1Button.Position = [150, 300, 300, 30];
            story1Button.BackgroundColor = [0.3, 0.6, 1];
            story1Button.FontColor = [1, 1, 1];
            story1Button.Text = 'Sherlock Holmes';
            story2Button = uibutton(app.StoryUI, 'push');
            story2Button.ButtonPushedFcn = @(~,~) app.displayStory(2); 
            story2Button.Position = [150, 250, 300, 30];
            story2Button.BackgroundColor = [0.3, 0.6, 1];
            story2Button.FontColor = [1, 1, 1];
            story2Button.Text = 'Baskerville Hall';
    
            story3Button = uibutton(app.StoryUI, 'push');
            story3Button.ButtonPushedFcn = @(~,~) app.displayStory(3); 
            story3Button.Position = [150, 200, 300, 30];
            story3Button.BackgroundColor = [0.3, 0.6, 1];
            story3Button.FontColor = [1, 1, 1];
            story3Button.Text = 'Fixing the Nets';
        end
    
        % DISPLAYSTORY: Displays the story content based on the selected index
        % STORYINDEX: An integer determining which story file to load
        function displayStory(app, storyIndex)
            if storyIndex == 1
                app.createStoryUI('Sherlock Holmes', 'sherlock_holmes.txt');
            elseif storyIndex == 2
                app.createStoryUI('Baskerville Hall', 'baskerville_hall.txt');
            elseif storyIndex == 3
                app.createStoryUI('Fixing the Nets', 'fixing_the_nets.txt');
            end
        end

        %% Story reading screen 
        % CREATESTORYUI: Cronstructs the user interface for displaying a story
        function createStoryUI(app, storyTitle, storyFileName)
            % Check if the story UI exists and is still valid.
            if isempty(app.Story1UI) || ~isvalid(app.Story1UI)
                % Initialize the main story window with specified properties
                app.Story1UI = uifigure('Visible', 'off');
                app.Story1UI.Position = [100, 100, 600, 400];
                app.Story1UI.Name = storyTitle; % The title of the story to be displayed
                app.Story1UI.Color = [1 1 1]; 
        
                % Create a scrosllable panel to contain the story text
                storyPanel = uipanel(app.Story1UI);
                storyPanel.Position = [20, 20, 560, 360];  
                storyPanel.BackgroundColor = [1, 1, 1];  
                storyPanel.Scrollable = 'on';  
        
                % Create a text area inside the panel to display the story
                storyTextArea = uitextarea(storyPanel);
                storyTextArea.Position = [10, 10, 540, 340];
                storyTextArea.FontSize = 14;
                storyTextArea.Value = fileread(storyFileName);  
        
                % Add an exit button to close the story UI
                exitButton = uibutton(app.Story1UI, 'push');
                exitButton.ButtonPushedFcn = createCallbackFcn(app, @exitButtonPushedStoryUI, true);
                exitButton.Position = [app.Story1UI.Position(3) - 100, app.Story1UI.Position(4) - 40, 70, 30];  
                exitButton.FontColor = [1, 1, 1];
                exitButton.BackgroundColor = [0.3, 0.6, 1];
                exitButton.Text = 'Exit';
    
                % Display the story UI
                app.Story1UI.Visible = 'on';
            end
        end
        
        %% Dictionary text file, translation function
        % READDICTIONARYFILE: Reads a dictionary file with translations
        % - filename: The name of the dictionary file to be read
        % Returns:
        % - data: A structure containing the dictionary
        function data = readDictionaryFile(~, filename)
            % Open the dictionary file for reading
            fid = fopen(filename, 'r');
            % Read the file contents and store them in columns
            C = textscan(fid, '%s %s %s %s', 'Delimiter', ';');
            fclose(fid);
    
            % Extract the French words and their English translations, note
            % the column index's were used due to the structure of the
            % dictionary text file 
            frenchWords = C{1};
            englishTranslations = C{4};
    
            % Create an empty dictionary to store word-translation pairs
            dictionary = containers.Map('KeyType', 'char', 'ValueType', 'any');
            for i = 1:numel(frenchWords)
                word = frenchWords{i};
                translation = englishTranslations{i};
                
                % If the word is already a key in the dictionary, append the translation to its list
                if isKey(dictionary, word)
                    translations = dictionary(word);
                    translations{end+1} = translation;
                else
                    translations = {translation};
                end
                dictionary(word) = translations;
            end
    
            % Return the dictionary
            data.dictionary = dictionary;
        end
        
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
    
        % EDITTEXTVALUECHANGED: Callback for when the value of the EditText field changes
        function EditTextValueChanged(app, ~)
            updateTranslationLabel(app); % updates the translationlabel page
        end

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
    
        % REFRESHRUNTIMELABEL: Updates the audio runtime label
        function refreshRuntimeLabel(app)
            if ~isempty(app.audioPlayer) && isplaying(app.audioPlayer)
                elapsedTime = toc(app.StartTime);
                app.RuntimeLabel.Text = sprintf('🎶: %d seconds', round(elapsedTime));
            end
        end
        
        % PAUSEBUTTONPUSHED: Pauses the audio playback
        function pauseButtonPushed(app, ~)
            if ~isempty(app.audioPlayer) && isplaying(app.audioPlayer)
                pause(app.audioPlayer);
                app.isPlayingAudio = false;
                app.updatePlayPauseButtonLabel();
            end
        end
        
        % UPDATEPLAYPAUSEBUTTONLABEL: Updates the play/pause button label based on the audio playback state
        function updatePlayPauseButtonLabel(app, playPauseButton)
            if app.isPlayingAudio
                playPauseButton.Text = '⏸️';
            else
                playPauseButton.Text = '▶️';
            end
        end
    
        % TRANSLATORBUTTONPUSHED: Switches the interface to the translator screen
        function translatorButtonPushed(app, ~)
            delete(app.HomeUI);   % Remove the home UI
            createTranslator(app); % Create the translator UI
        end
    
        % EXITBUTTONPUSHED: Exits the home interface
        function exitButtonPushed(app, ~)
            close(app.HomeUI);
        end
        
        % EXITBUTTONPUSHEDSTORY: exits the story interface and returns to the home screen.
        function exitButtonPushedStory(app, ~)
            delete(app.StoryUI);  % Hide the StoryUI
            createHomeScreen(app); % create the home screen UI
        end
    
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
    
        % CHALLENGEBUTTONPUSHED: switches to the challenge screen
        function challengeButtonPushed(app, ~)    
            delete(app.HomeUI);   % Remove the home UI
            createChallenge(app); % Creates the challenge UI.
        end
        
        %% Challenge screen
        % CREATECHALLENGE: Constructs the challenge user interface within the main application.
        function createChallenge(app)        
            app.ChallengeUI = uifigure('Visible', 'on');
            app.ChallengeUI.Position = [100, 100, 600, 400];
            app.ChallengeUI.Name = 'Challenge';
            app.ChallengeUI.Color = [1 1 1];
        
            % Hide the main application's figure
            app.UIFigure.Visible = 'off';
        
            % Create a label prompting the user to select a challenge level
            selectLabel = uilabel(app.ChallengeUI);
            selectLabel.Text = 'Select a level ⚡';
            selectLabel.FontSize = 16;
            selectLabel.FontWeight = 'bold';
            selectLabel.Position = [150, 350, 300, 30];
            selectLabel.HorizontalAlignment = 'center';
            selectLabel.FontColor = [0 85/255 164/255];
            
            % Exit button to allow users to go back to the main page 
            exitButtonChallenge = uibutton(app.ChallengeUI, 'push');
            exitButtonChallenge.ButtonPushedFcn = @(~,~) app.exitChallenge();
            exitButtonChallenge.Position = [30, 30, 100, 30];
            exitButtonChallenge.FontColor = [1, 1, 1];
            exitButtonChallenge.BackgroundColor = [0.3, 0.6, 1];
            exitButtonChallenge.Text = 'Exit';
        
            % Button for starting Level 1 of the challenge
            level1Button = uibutton(app.ChallengeUI, 'push');
            level1Button.ButtonPushedFcn = @(~,~) app.startChallenge(1);
            level1Button.Position = [150, 300, 300, 30];
            level1Button.BackgroundColor = [0.3, 0.6, 1];
            level1Button.FontColor = [1, 1, 1];
            level1Button.Text = 'Level 1';
        
            % Button for starting Level 2 of the challenge
            level2Button = uibutton(app.ChallengeUI, 'push');
            level2Button.ButtonPushedFcn = @(~,~) app.startChallenge(2);
            level2Button.Position = [150, 250, 300, 30];
            level2Button.BackgroundColor = [0.3, 0.6, 1];
            level2Button.FontColor = [1, 1, 1];
            level2Button.Text = 'Level 2';
        
            % Button for starting Level 3 of the challenge
            level3Button = uibutton(app.ChallengeUI, 'push');
            level3Button.ButtonPushedFcn = @(~,~) app.startChallenge(3);
            level3Button.Position = [150, 200, 300, 30];
            level3Button.BackgroundColor = [0.3, 0.6, 1];
            level3Button.FontColor = [1, 1, 1];
            level3Button.Text = 'Level 3';
        end
        
        %% Start the challenge
        % STARTCHALLENGE:starts the challenge with an extensive amount of
        % functionality allowing for user's to gain streaks and increase
        % levels
        function startChallenge(app, selectedLevel)        
            app.ChallengeUI = uifigure('Visible', 'on');
            app.ChallengeUI.Position = [100, 100, 600, 400];
            app.ChallengeUI.Name = 'Challenge';
            app.ChallengeUI.Color = [1 1 1];

            % Exit button to allow users to go back to the main page 
            exitButtonLevel = uibutton(app.ChallengeUI, 'push');
            exitButtonLevel.ButtonPushedFcn = @(~,~) app.exitChallenge();
            exitButtonLevel.Position = [30, 30, 100, 30];
            exitButtonLevel.FontColor = [1, 1, 1];
            exitButtonLevel.BackgroundColor = [0.3, 0.6, 1];
            exitButtonLevel.Text = 'Exit'

            app.UIFigure.Visible = 'off';
    
            % a switch statement to determine the appropriate level file based on the selected level.
            switch selectedLevel
                case 1
                    % If the selected level is 1, set the level file to level1.txt
                    levelFile = 'level1.txt';
                case 2
                    % If the selected level is 2, set the level file to level2.txt
                    levelFile = 'level2.txt';
                case 3
                    % If the selected level is 3, set the level file to level3.txt
                    levelFile = 'level3.txt';
                otherwise
                    % Foer any other value of selected level, default to level1.txt
                    levelFile = 'level1.txt';
            end
        
            % load the challenge content from the corresponding level's file
            challengeContent = fileread(levelFile);
        
            % Spldit the content into lines
            lines = strsplit(challengeContent, '\n');
        
            % Initialize variables to store French words and English translations
            frenchWords = {};
            englishTranslations = {};
        
            % parse the lines to extract French words and English translations
            for i = 1:length(lines)
                line = lines{i};
                parts = strsplit(line, ';');
                
                % Check if the line has the expected number of parts
                if numel(parts) >= 4
                    frenchWords{end+1} = parts{1};
                    englishTranslations{end+1} = parts{4};
                else
                    % Print a warning or handle missing translations as needed
                    fprintf('Warning: Line %d does not have the expected format\n', i);
                end
            end

            % Choose a random word from the challenge content
            randomIndex = randi(length(frenchWords));
            frenchWord = frenchWords{randomIndex};
            correctTranslation = englishTranslations{randomIndex};

            % Cereate a label to display instructions for the challenge
            translateLabel = uilabel(app.ChallengeUI);
            translateLabel.Text = 'Translate the French word to English. 5 in a row allows you to level up!';
            translateLabel.HorizontalAlignment = 'center'; % Center the text within the label
            translateLabel.FontSize = 16;
            translateLabel.FontWeight = 'bold';
            translateLabel.FontColor = [0 85/255 164/255];
            translateLabel.Position = [150, 350, 300, 30];
            
            % Create a label to display the French word that needs translation
            frenchWordLabel = uilabel(app.ChallengeUI);
            frenchWordLabel.Text = frenchWord;
            frenchWordLabel.FontSize = 16;
            frenchWordLabel.HorizontalAlignment = 'center'; % Center the French word text within the label
            frenchWordLabel.Position = [150, 300, 300, 30]; % set position for the French word label
            
            % Create an edit field where users can input their English translation guess
            guessEditField = uieditfield(app.ChallengeUI, 'text');
            guessEditField.Position = [200, 250, 200, 30]; % Set the position for the edit field
            
            % Create a "Submit" button for users to submit their translation guess
            submitButton = uibutton(app.ChallengeUI, 'push');
            submitButton.Text = 'Submit';
            submitButton.Position = [250, 200, 100, 30];
            submitButton.FontWeight = 'bold';
            submitButton.FontSize = 14;
            submitButton.BackgroundColor = [0.3, 0.6, 1];
            submitButton.FontColor = [1, 1, 1];
            submitButton.ButtonPushedFcn = @(~,~) checkGuess(app, guessEditField.Value, correctTranslation); % Setr the callback function to check the guess when the button is pressed
              
            % CHECKGUESS: Compare the guess to the correct translation
            function checkGuess(app, guess, correctTranslation, frenchWords, englishTranslations, frenchWordLabel, guessEditField, submitButton)
                if strcmp(guess, correctTranslation)
                    % Increment the streak by one
                    app.streak = app.streak + 1;
                
                    % Display a message indicating correctness and streak
                    message = uilabel(app.ChallengeUI);
                    message.Text = sprintf('Correct 🔥 Streak: %d', app.streak);
                    message.FontSize = 16;
                    message.FontColor = [0 85/255 164/255];
                    message.Position = [200, 150, 200, 30];
                    message.HorizontalAlignment = 'center'; % Center the text

                    % Check if the streak reaches 10
                    if app.streak >= 5 && selectedLevel < 3
                        % suggest to go to the next level due to the high
                        % streak
                        nextLevelButton = uibutton(app.ChallengeUI, 'push');
                        nextLevelButton.Position = [250, 100, 100, 30];
                        nextLevelButton.Text = 'Next Level';
                        nextLevelButton.FontWeight = 'bold';
                        nextLevelButton.FontSize = 12;
                        nextLevelButton.BackgroundColor = [0.3, 0.6, 1];
                        nextLevelButton.FontColor = [1, 1, 1];
                        nextLevelButton.ButtonPushedFcn = @(~,~) app.startChallenge(selectedLevel + 1); % Move to the next level
                    end
                    
                    % wait for a moment to show the correct message
                    pause(1);
                    
                    % delete the message
                    delete(message);
                    
                    % Chooese another new random word from the same level
                    randomIndex = randi(length(frenchWords));
                    frenchWord = frenchWords{randomIndex};
                    correctTranslation = englishTranslations{randomIndex};
                    
                    % Update UI components with the new word
                    frenchWordLabel.Text = frenchWord;
                    guessEditField.Value = '';
                    
                else
                    % display a message indicating incorrectness
                    app.streak = 0;
                    message = uilabel(app.ChallengeUI);
                    message.Text = 'Incorrect ❌';
                    message.FontSize = 16;
                    message.Position = [230, 150, 140, 30];
                    message.FontColor = [0 85/255 164/255];
                    message.HorizontalAlignment = 'center'; % Center the text
                    
                    % Wait for a moment to show the incorrect message
                    pause(1);
                    
                    % delete the message
                    delete(message);
                end
            end
            % Adjust the submit button's callback function to check the user's translation guess
            submitButton.ButtonPushedFcn = @(~,~) checkGuess(app, guessEditField.Value, correctTranslation, frenchWords, englishTranslations, frenchWordLabel, guessEditField, submitButton);
        end

        % STORYBUTTONPUSHED: executed when the story button is pushed
        function storyButtonPushed(app, ~)    
            delete(app.HomeUI); % Delete the home UI.
            createStorySelect(app); % Transition to the story selection interface.
        end
        
        % EXITBUTTONPUSHEDSTORYUI: executed when the exit button in the StoryUI is pushed
        function exitButtonPushedStoryUI(app, ~)
            delete(app.Story1UI);  % Remove the story UI.
            createHomeScreen(app); % Return to the home screen
        end
        
        % EXITCHALLENGE: executed when the exit button in the ChallengeUI is pushed
        function exitChallenge(app)
            delete(app.ChallengeUI);  % Remove the challenge UI
            createHomeScreen(app);    % Return to the home screen
        end
    end

    methods (Access = public)
        % Constructor for the 'myApp' class
        function app = myApp
            app.UIFigure = uifigure('Visible', 'off'); % initialize the main app window, but keep it hidden
            app.UIFigure.Color = [1 1 1];  
            
            startupFcn(app); % call the startup function for the app
            registerApp(app, app.UIFigure); % register app
            app.UIFigure.Visible = 'on'; % Make main app window visible
            app.UIFigure.CloseRequestFcn = @(~,~) app.closeApp(); % Set the function to be called upon trying to close the main app window
    
            % If the constructor does not have any output arguments, clear the app variable
            if nargout == 0
                clear app
            end
        end
        
        % Method to refresh the app's display
        function refresh(app)
            updateTranslationLabel(app); % Update the translation label to reflect the current state
        end
    end
end