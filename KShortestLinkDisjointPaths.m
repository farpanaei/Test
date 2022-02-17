% (c)Buddhika Gunawardena , 2009
% Filename: KShortestLinkDisjointPaths.m
% Description: A simple function to calculate k shortest and link disjoint
% paths of a given undirected graph (G) from source (src) to destination
% (dst)
% Inputs:
%     G: A connectivity matrix where if (i,j) = 1, there is a link from
%        node i to node j, and 0 otherwise. Here it is always a symmetric matrix.
%     k : The number of paths to be calculated
%     src: source node
%     dst: destination node
% Outputs:
%     paths: a k x NNodes matrix that shows all k paths found. NNodes is
%     the number of nodes in the Graph. row in the matrix contain a single
%     path from source to destination. (node numbers from source until
%     destination)


function paths = KShortestLinkDisjointPaths(G,src,dst,k)

NNodes = size(G,1);

paths = zeros(k,NNodes);
for p = 1:k
    [dist, path]= graphshortestpath(sparse(G), src, dst);
    if (dist~=inf)
        n = size(path,2);
        paths(p,1:n)= path;
        for i = 1:n-1
            G(path(i),path(i+1))=0;
            G(path(i+1),path(i))=0;
        end
    end
end