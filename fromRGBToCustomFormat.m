% This function provides the steps to convert an image from the RGB format
% to a customized one.
% Firstly, the image is converted in a gray-scale format.
% Secondly, the corresponding graph of the image is constructed, using the 
% createCNFromImage function.
% Finally, from the graph are calculated three different matrices, which
% are going to substitute the original three matrices of the RGB image.
% These matrices are obtained using calculateKV, calculateKS and calculateKE
% funcitons.

function IM = fromRGBToCustomFormat(rgbImage, radius, method)
    % rgbImage = RGB image to process.
    % radius = considered radius for the graph construction.
    % method = which method is used.
    
    % IM = processed image to return.

    % Converts the image from RGB to gray-scale.
    grayLevelImage = cast(rgb2gray(rgbImage), 'double');

    % Transforms the image into the corresponding complex network.
    complexNetwork = createCNFromImage(grayLevelImage, radius, method);

    % Calculates 3 different values and assigns them to the new
    % image.
    % Note: kv, ks and ke are matrix with the same size of the image.
    siz = size(rgbImage);
    IM(:,:,1) = calculateKV(complexNetwork, siz, method);
    IM(:,:,2) = calculateKS(complexNetwork, siz, method);
    IM(:,:,3) = calculateKE(complexNetwork, siz, method);
end