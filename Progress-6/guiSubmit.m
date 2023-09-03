function guiSubmit()
    % Create the GUI figure
    app.UIFigure = uifigure('Position', [100, 100, 500, 500]);
    
    % Create the submit button
    app.SubmitButton = uibutton(app.UIFigure, 'Position', [200, 200, 100, 50], 'Text', 'Submit');
    
    % Add a callback function to the submit button
    app.SubmitButton.ButtonPushedFcn = @(~,~) submitButtonCallback(app);
end

function submitButtonCallback(app)
    % Your code for submitting translations here
    disp('Submit button pressed!');
end
