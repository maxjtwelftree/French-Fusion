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











