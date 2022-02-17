function [num_hop_Shpath_mat] = comp_num_hop(shortestPaths,k_paths_final)
%This function comput number of hops for each selected path

 num_nods_ShPath_mat=[];
num_hop_Shpath_mat=[];

for kk=1:k_paths_final
    num_nods_ShPath_mat(1,kk)=numel(cell2mat(shortestPaths(kk)));
    num_hop_Shpath_mat(1,kk)=num_nods_ShPath_mat(1,kk)-1;
    
end

end

