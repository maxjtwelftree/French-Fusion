function myScript()
    % Load the Dictionary Data
    fid = fopen('dictionary.txt', 'r');
    C = textscan(fid, '%s %s %s %s', 'Delimiter', ';');
    fclose(fid);

    french_words = C{1};
    english_translations = C{4};

    dictionary = containers.Map('KeyType', 'char', 'ValueType', 'any');
    for i = 1:numel(french_words)
        word = french_words{i};
        translation = english_translations{i};

        if isKey(dictionary, word)
            translations = dictionary(word);
            translations{end+1} = translation;
        else
            translations = {translation};
        end

        dictionary(word) = translations;
    end

    % Create and Customize the GUI
    figure('Position', [100, 100, 600, 400]);

    % Load and display the GIF animation
    [gifFile, map] = imread('loadscreen.gif', 'Frames', 'all');
    numLoops = Inf;
    numFrames = size(gifFile, 4);
    frameIndex = 1;

    axes('Units', 'normalized', 'Position', [0, 0, 1, 1]);
    imshow(gifFile(:,:,:,frameIndex), map, 'InitialMagnification', 'fit');

    while numLoops > 0
        imshow(gifFile(:,:,:,frameIndex), map, 'InitialMagnification', 'fit');
        drawnow;
        frameIndex = frameIndex + 1;
        if frameIndex > numFrames
            frameIndex = 1;
            numLoops = numLoops - 1;
        end
    end

    % Create the submit button
    handles.SubmitButton = uicontrol('Style', 'pushbutton', 'String', 'Submit', 'Position', [250, 10, 100, 30]);

    % Create the translation label
    handles.TranslationLabel = uicontrol('Style', 'text', 'String', '', 'Position', [150, 50, 300, 30]);

    % Define the Callback Function for the Submit Button
    function check_answer(~, ~)
        guess = get(handles.EditField, 'String');

        translations = dictionary(guess);

        if ~isempty(translations)
            translationStr = sprintf('Translations for "%s":', guess);
            for i = 1:numel(translations)
                translationStr = sprintf('%s\n%s', translationStr, translations{i});
            end
            set(handles.TranslationLabel, 'String', translationStr);
        else
            set(handles.TranslationLabel, 'String', 'Translation not found');
        end
    end

    % Add the Callback Function to the Submit Button and Adjust the GUI
    handles.SubmitButton.Callback = @check_answer;
    handles.EditField = uicontrol('Style', 'edit', 'Position', [200, 100, 100, 30]);
    set(gcf, 'UserData', struct('handles', handles));

    set(handles.SubmitButton, 'BackgroundColor', [0.929 0.694 0.125]);
    set(handles.SubmitButton, 'FontName', 'Arial');
    set(handles.SubmitButton, 'FontSize', 14);
    set(handles.EditField, 'FontName', 'Arial');
    set(handles.EditField, 'FontSize', 12);
    set(handles.TranslationLabel, 'FontName', 'Arial');
    set(handles.TranslationLabel, 'FontSize', 16);

end

% Run the GUI
myScript();
