 % EXITBUTTONPUSHED: Closes the translator window and brings the user back to the home screen
            function exitButtonPushed(app, ~)
                delete(app.UIFigure);  
                createHomeScreen(app); 
            end