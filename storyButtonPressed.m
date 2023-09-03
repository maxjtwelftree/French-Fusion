% STORYBUTTONPUSHED: Deletes the home page and opens the story select page
        function storyButtonPressed(app, ~)
            delete(app.HomeUI); 
            storySelect(app); 
        end