classdef LexiLearnGame
    properties (Access = private)
        StartQuestButton      matlab.ui.control.Button
    end

    methods (Access = private)
        function createUI(app)
            app.StartQuestButton = uibutton('push');
            app.StartQuestButton.Position = [50, 150, 200, 60];
            app.StartQuestButton.Text = 'Start Your Quest';
            app.StartQuestButton.FontSize = 16;
            app.StartQuestButton.FontColor = [1, 1, 1];
            app.StartQuestButton.BackgroundColor = [1, 0, 0];
        end
        
        function displayTitleAndRules(app)
            disp('*********  Welcome  **********');
            disp(' ');
            disp('*****  To Lexi Learn  *******');
            disp(' ');
            disp('Developed by Max Twelftree');
            disp(' ');
            disp('Here are the rules of the game:');
            disp('1. It''s a single player game');
            disp('2. Starts with asking what house you wish to be apart of');
            disp('3. Asks for a username (must be 8 characters)');
            disp('4. Pushes to the word Arena (Round play)');
            disp('5. The game is simple, try to add the correct letters to words and score Xp');
            disp('6. You have 3 lives');
            disp('7. A streak of 5 correct words gives you a wand (extra Xp)');
            disp('8. Upgrading a wand costs you Xp');
            disp('9. Skipping a move costs you an extra 40 Xp');
            disp('10. To get the damage details, press d in Enter Your Attack');
        end
    end
    
    methods (Access = private)
        % Button pushed function: StartQuestButton
        function StartQuestButtonPushed(app, event)
            displayTitleAndRules(app);
        end
    end

    methods (Access = public)
        function app = LexiLearnGame
            app.createUI();
        end
    end
end
