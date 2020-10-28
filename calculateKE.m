% Depending on the method, the resulting matrix is obtained by calculating 
% some topological characteristics.

function ke = calculateKE(CN, siz, method)
    % CN = digraph.
    % siz = image size.
    % method = method to use.
    
    % ke = resulting matrix with the same dimension of the image.

    switch(method)
        case 1 
            % Calculates the sum of weight of the incoming edges.
            C = centrality(CN, 'indegree', 'Importance', CN.Edges.Weight);
        case 2
            % The 'outcloseness' computes the inverse sum of the distance from a
            % node to all other nodes in the graph.
            C = centrality(CN, 'outcloseness', 'Cost', CN.Edges.Weight);
        case 3
            % The 'outcloseness' computes the inverse sum of the distance from a
            % node to all other nodes in the graph.
            C = centrality(CN, 'outcloseness', 'Cost', CN.Edges.Weight);         
    end

    % Converts from vector to matrix.
    ke = reshape(C, siz(1), siz(2));   
end