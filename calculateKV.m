% Depending on the method, the resulting matrix is obtained by calculating 
% some topological characteristics. 

function kv = calculateKV(CN, siz, method)
    % CN = digraph.
    % siz = image size.
    % method = method to use.
    
    % kv = resulting matrix with the same dimension of the image.

    switch(method)
        case 1 
            % Calculates the outdegree for each node.
            C = centrality(CN, 'outdegree');
        case 2
            % Calculates the outdegree for each node.
            C = centrality(CN, 'outdegree');
        case 3
            % Calculates the outdegree for each node.
            C = centrality(CN, 'outdegree');         
    end
	
    % Converts from vector to matrix.
    kv = reshape(C, siz(1), siz(2));
end