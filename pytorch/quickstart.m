% Set the root directory where you want to store the dataset
global dataloc; % Assuming dataloc is a global variable defined elsewhere
savedir = [dataloc, 'ML/Fashion_mnist/'];

% Download the FashionMNIST dataset
url_images = 'https://github.com/zalandoresearch/fashion-mnist/raw/master/data/fashion/train-images-idx3-ubyte.gz';
url_labels = 'https://github.com/zalandoresearch/fashion-mnist/raw/master/data/fashion/train-labels-idx1-ubyte.gz';
filename_images = fullfile(savedir, 'train-images-idx3-ubyte.gz');
filename_labels = fullfile(savedir, 'train-labels-idx1-ubyte.gz');
websave(filename_images, url_images);
websave(filename_labels, url_labels);

% Unzip the downloaded files
gunzip(filename_images);
gunzip(filename_labels);

% Load the labels
fid = fopen(filename_labels, 'rb');
labelsData = fread(fid, inf, 'uint8');
fclose(fid);
labelsData = labelsData(9:end);

% Load the images
fid = fopen(filename_images, 'rb');
imagesData = fread(fid, inf, 'uint8');
fclose(fid);
imagesData = imagesData(17:end);

% Calculate the number of images
numImages = numel(imagesData) / (28 * 28);

% Ensure numImages is an integer
numImages = floor(numImages);

% Reshape the images array properly
imagesData = reshape(imagesData, 28, 28, numImages);

% Convert to double and normalize pixel values to the range [0,1]
imagesData = double(imagesData) / 255;

% Display the first image
imshow(imagesData(:, :, 1));

% You can now use imagesData and labelsData in your MATLAB code for training
