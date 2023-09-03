function myScript()
    % Open the file for reading
    fid = fopen('dictionary.txt', 'r');

    % Read the data using textscan with format specifications
    C = textscan(fid, '%s %s %s %s', 'Delimiter', ';');

    % Close the file
    fclose(fid);

    % Extract the French words and English translations from the data
    french_words = C{1};
    english_translations = C{4};

    % Create a dictionary where each French word maps to its translations
    dictionary = containers.Map('KeyType', 'char', 'ValueType', 'any');
    for i = 1:numel(french_words)
        word = french_words{i};
        translation = english_translations{i};

        % Check if the French word already exists in the dictionary
        if isKey(dictionary, word)
            % Append the translation to the existing cell array
            translations = dictionary(word);
            translations{end+1} = translation;
        else
            % Create a new cell array with the translation
            translations = {translation};
        end

        % Update the dictionary entry for the French word
        dictionary(word) = translations;
    end

    % Create the GUI
    figure('Position', [100, 100, 600, 400], 'Name', 'Francais Fusion'); % Adjust the position and size of the figure and set the title
    handles = struct(); % Create an empty handles structure
    
    % Place the Language Label
    handles.LanguageLabel = uicontrol('Style', 'text', 'String', 'Francais', 'Position', [250, 350, 100, 30], 'FontSize', 14); % Adjust the position of the label and set the font size
    
    % Place the Submit Button
    handles.SubmitButton = uicontrol('Style', 'pushbutton', 'String', 'Submit', 'Position', [250, 10, 150, 50], 'Callback', @check_answer, 'FontSize', 14); % Adjust the position and size of the button and set the font size
    
    % Place the Text Edit field
    handles.EditText = uicontrol('Style', 'edit', 'Position', [250, 200, 150, 30], 'Callback', @check_answer, 'FontSize', 14); % Adjust the position of the text field and set the font size
    
    % Place the Translation Label
    handles.TranslationLabel = uicontrol('Style', 'text', 'Position', [250, 300, 150, 30], 'FontSize', 14); % Adjust the position of the label and set the font size

    % Store the handles structure and the dictionary in the figure's UserData
    set(gcf, 'UserData', struct('handles', handles, 'dictionary', dictionary));

    % Define the callback function
    function check_answer(~, ~)
        % Get the handles structure and the dictionary from the figure's UserData
        userData = get(gcf, 'UserData');
        handles = userData.handles;
        dictionary = userData.dictionary;

        % Get the user's guess
        guess = get(handles.EditText, 'String');

        % Find the translations for the French word
        translations = dictionary(guess);

        % Display the translations or a message if no translations are found
        if ~isempty(translations)
            translationStr = sprintf('English translation for "%s":', guess);
            for i = 1:numel(translations)
                translationStr = sprintf('%s\n%s', translationStr, translations{i});
            end
            set(handles.TranslationLabel, 'String', translationStr);
        else
            set(handles.TranslationLabel, 'String', 'Translation not found');
        end
    end
end