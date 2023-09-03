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