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