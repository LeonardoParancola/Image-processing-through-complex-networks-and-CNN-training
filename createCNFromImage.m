% Function that converts an image from a gray-scale format to a digraph.
% Two vertices are connected if dist(i, j) <= radius and I(i) < I(j),
% where dist is the Euclidean distance between i and j and I is the value 
% associated to the node.
% The nodes of the graph are the pixels of the image, each containing the
% intensity value.
% Initially, all the possible combinations of the coordinates are defined.
% 
% Then, two matrices are calculated: 
%   - euclideanDistance, that contains the Euclidean distance between all the 
%       possible pairs of coordinates;
%   - diffIntensity, which contains the difference between all the possible 
%       pairs of intensity.
% 
% After that, the adjacency matrix is calculated in order to construct the
% corresponding digraph. A value of the matrix is 1 if 
% (euclideanDistance <= radius) & (euclideanDistance > 0) & (diffIntensity > 0),
% 0 otherwise.
% 
% Starting from the value of the radius (and depending of the method), the
% weights of the edges are calculated. The resulting matrix is multiplied,
% value by value, with the adjacency matrix, in order to assign the
% corresponding weight to the edge.
% 
% Finally, the graph CN is created.

function CN = createCNFromImage(image, radius, method)
    % image = gray-scale image.
    % radius = radius to consider for the graph construction.
    % method = method to use.
    % 
    % CN = digraph obtained from image processing.

    % From matrix to vector (each element is the pixel's intensity).
    value = reshape(image, 1, []); % column vector.
    
    % Sets the number of rows and columns.
    numrow = size(image,1);
    numcol = size(image,2);
    
    [Y, X] = ndgrid(1:numrow, 1:numcol);
    x = X(:); % 1 1 1 ... 1  2 2 2 ...  
    y = Y(:); % 1 2 3 ... 64 1 2 3 ...
    
    % Calculates a matrix which indicates the Euclidean distance between 
    % each pair of points.
    euclideanDistance = pdist2([x,y], [x,y]);
    
    % Calculates a matrix that indicates the difference between 
    % all the possible values.
    diffIntensity = bsxfun(@minus,value,value')*-1;

    % Adjacency matrix used to create a digraph. 
    % Nodes with the Euclidean distance <= radius and > 0 and with 
    % a positive value of intensity will be connected.
    % If the intensity is > 0, an edge from the node with lower intensity 
    % to the higher is created.
    adjacencyMatrix = (euclideanDistance <= radius) & (euclideanDistance > 0) & (diffIntensity > 0);
    
    % Maximum value.
    L = max(image(:));
    
    % Calculates the weight depending on the radius.
    switch(method)
        case 1
            weight = abs(diffIntensity)/L;
            if radius > 1
                weight = (weight + (diffIntensity - 1)/(radius-1))/2;
            end
        case 2
            weight = abs(diffIntensity)/L;
            if radius > 1
                weight = (weight + (diffIntensity - 1)/(radius-1))/2;
            end
        case 3
            weight = abs(diffIntensity)/L;
            if radius > 1
                weight = (weight + (diffIntensity - 1)/(radius-1))/2;
            end
    end
    
    % Multiplies each element of the adjacency matrix (1 or 0)
    % by the corresponding weight.
    adjacencyMatrix = adjacencyMatrix.*weight;
    
    % Creates a digraph using the adjacency matrix.
    CN = digraph(adjacencyMatrix);
    
    % Assigns the intensity to each node.
    CN.Nodes.Value = value';
end