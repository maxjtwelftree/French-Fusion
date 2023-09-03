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