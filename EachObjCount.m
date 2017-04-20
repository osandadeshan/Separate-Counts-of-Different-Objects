% Read in image, convert to black and white - Link comes from your image posted here
im = imread('/lBGU1.png');
imBW = im2bw(im, 0.3); %// Specify manual threshold of 0.3

% Invert intensities and fill in holes
imBWFilled = imfill(~imBW, 'holes');

% Count how many unique objects there are
[L,num] = bwlabel(imBWFilled);

% Show final image and display number of objects counted in the title
imshow(imBWFilled);


 % Counting the number of objects
   text(15,15,strcat('\color{yellow}Number of objects Found:',num2str(num)))

   %%% For each object in the image, find the centre of mass
centres = zeros(num,2);
% Cycle through each unique object label and extract (X,Y) co-ordinates
% that belong to each object.  Compute centre of mass for each.
for n = 1 : num
    bmap = L == n;
    [rows,cols] = find(bmap == 1);
    centres(n,:) = [mean(cols) mean(rows)];
end

% Find boundaries of all objects
bwBound = bwperim(imBWFilled, 8);

% For each object, find the distances between the centre of mass with all
% of the pixels along the boundary for each object.  Find the range (max -
% min).
ranges = zeros(num,1);
for n = 1 : num
    bmap = L == n; % Obtain all pixels for an object
    boundPix = bwBound & bmap; % Logical AND with boundaries map to extract
                               % only those pixels around the perimeter
    [rows,cols] = find(boundPix == 1); % Find these locations
    % Compute the distances between the centre of mass with these points
    dists = sqrt((cols - centres(n,1)).^2 + (rows - centres(n,2)).^2);

    % Find the difference between the maximum and minimum distances
    ranges(n) = max(dists(:)) - min(dists(:));
end



% Find those object IDs that have less than a range of 15.  These are the
% bolts
% The rest are nuts
indBolts = find(ranges < 15);
indNuts =  find(ranges >= 15);

% Total number of nuts and bolts
numBolts = numel(indBolts);
numNuts = numel(indNuts);


finalMap = uint8(zeros(size(imBW)));

for n = 1 : numBolts
    finalMap(L == indBolts(n)) = 128;
end
for n = 1 : numNuts
    finalMap(L == indNuts(n)) = 255;
end

figure;
imshow(finalMap);

% Counting the number of each objects seperately
   text(15,15,strcat('\color{yellow}Number of Nuts: ', num2str(numNuts)))
   text(15,35,strcat('\color{yellow}Number of Bolts: ', num2str(numBolts)))