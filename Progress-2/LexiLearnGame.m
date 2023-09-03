%% Start of the program
clc
clear

fprintf("Welcome to art with algorithms, brought to you by a voronoi art generator program!\n\n")


%% read the image

fileName=input("Please enter the file name (remember to attach the suffix of the image file and single quotation marks): ");
fprintf("\n")
[image]=readimage(fileName); % This function is used to get the image file name and transfer the variable type.
[original_image]=readimage(fileName); % original_image is an array used to fill in the rest of parts (out of mosaic)

%% Voronoi Diagram Generation and Color Clustering
numCells = 5000; % Number of Voronoi cells (you can adjust this)
numColors = 20;  % Number of representative colors (you can adjust this)

% Generate Voronoi points
voronoiPointsX = randi(size(image, 2), 1, numCells);
voronoiPointsY = randi(size(image, 1), 1, numCells);

% Compute Voronoi diagram
[voronoiIndices, ~] = dsearchn([voronoiPointsX', voronoiPointsY'], [1:size(image, 2); 1:size(image, 1)]');

% Perform k-means clustering on colors
pixelColors = reshape(image, [], 3);
[clusterIndices, clusterCenters] = kmeans(double(pixelColors), numColors);

%% Apply Voronoi Art Style
for i = 1:numCells
    cellIndices = voronoiIndices == i;
    representativeColor = clusterCenters(clusterIndices(i), :);
    
    % Fill Voronoi cell with representative color
    image(cellIndices, :) = repmat(uint8(representativeColor), sum(cellIndices), 1);
end

%% Display Original and Voronoi Art
subplot(1, 2, 1);
imshow(original_image);
title('Original Image');

subplot(1, 2, 2);
imshow(image);
title('Voronoi Art');

%% End of the program
fprintf("Program finished. Thank you for using!\n");












%% Showcase the Rules

fprintf('Rules of the Game:\n');
fprintf('------------------\n');
fprintf('1. Two players compete in a 2-player game (not against the computer)\n');
fprintf('2. Choose the number of rounds to play (0 to 9)\n');
fprintf('3. Enter two usernames, each with 8 characters\n');
fprintf('4. Engage in the Fight Arena during rounds\n');
fprintf('5. The goal: Reduce your opponent''s health to 0 to win the round\n');
fprintf('6. You have three bars: Health, Armour, and XP\n');
fprintf('7. Gain 30 XP for shooting a gunshot\n');
fprintf('8. Spend 20 XP to pierce with a sword\n');
fprintf('9. Use 100 XP to fire a cannon\n');
fprintf('10. Medic can be used when your health is <= 20\n');
fprintf('11. Skipping a move earns you 40 XP\n');
fprintf('12. Press "d" during "Enter Your Attack" to view damage details\n\n');

fprintf('For a better view, undock the command window and position the displayed image below.\n\n');
fprintf('Enjoy playing the game!\n');
enter = input('Press Enter to start: ');
