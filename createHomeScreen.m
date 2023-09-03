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