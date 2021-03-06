
clear all
close all
clc

%% Farhad Arpanaei
% farhad.arpanaei@polito.it
%% Initilaizing

%load('InitialParam_MCF41.mat') % Rs = 32 GBaud





alpha_db = 0.227; %Attenuation dB/km

alpha_norm = alpha_db/(2*10*log10(exp(1))*1e3); %(1/m)
%     alpha_norm =alpha_db/(10*log10(exp(1))*1e3); %(1/m)

beta_2 = 2.4875e-26; %-21.45562e-27;  % group velocity dispersion (s^2/m)

gama =1.2e-3; %1.31e-3 % nonlinear parameter 1/(W.m)

%     L_eff_a=1/alpha_norm;% L_eff_a is defined as 1/alfa

L_eff_a = 1/(2*alpha_norm);% L_eff_a is defined as 1/alfa


target_ber=3.8e-3; %3.8e-3;



%M=2;PM-BPSK
target_SNR_dB_2=10*log10(1*(erfcinv(2*target_ber)).^2);
%M=4;PM-QPSK
target_SNR_dB_4=10*log10(2*(erfcinv(2*target_ber)).^2);
%M=8;PM-8QAM
target_SNR_dB_8=10*log10((14/3)*(erfcinv(1.5*target_ber)).^2);
%M=16;PM-16QAM
target_SNR_dB_16=10*log10((10)*(erfcinv((8/3)*target_ber)).^2);
M=32;%PM-32QAM
target_SNR_dB_32=10*log10(2*(erfcinv(log2(M)*target_ber/2/(1-1/sqrt(M)))).^2*(M-1)./3);
M=64;%PM-64QAM
target_SNR_dB_64=10*log10(2*(erfcinv(log2(M)*target_ber/2/(1-1/sqrt(M)))).^2*(M-1)./3);

target_SNR_dB=[target_SNR_dB_2 target_SNR_dB_4 target_SNR_dB_8 target_SNR_dB_16 target_SNR_dB_32 target_SNR_dB_64];

adjacent_core = [0	1	0	0	0	1	1;
    1	0	1	0	0	0	1;
    0	1	0	1	0	0	1;
    0	0	1	0	1	0	1;
    0	0	0	1	0	1	1;
    1	0	0	0	1	0	1;
    1	1	1	1	1	1	0];

%% ASE Parameters



F = 10^0.6;            % Nois Figure 6 dB

h_plank = 6.626e-34;   % Planck's constant (J s)
%% Network's Topology: BT

% s=[1 1 1 1 2 2 3 3 3 3 4 4 5 5 6 6 6 7 7 7 8 8 8 9 10 11 11 12 12 15 15 15 17 17 20];
% t=[2 9 18 19 9 19 4 5 16 18 10 16 13 14 14 19 22 11 12 20 10 11 21 14 13 13 22 21 22 16 17 18 18 19 21];
% weights = 1e3.*[5 20 59 2 23 7 27 89 234 203 160 439 73 163 105 183 275 419 686 48 62 109 182 127 75 99 87 120 163 71 226 197 55 115 240];
% names = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20' '21' '22'};
% G = graph(s,t,weights,names);
% G_origin = G;
% num_link= numedges(G); % Number of Liks in graph
% nn = numnodes(G); % Number of Liks in graph
% [s,t] = findedge(G);
% A = sparse(s,t,G.Edges.Weight,nn,nn);
% netCostMatrix=full(A);
% netCostMatrix=netCostMatrix+netCostMatrix';
% for i=1:1:nn
%     for q=1:1:nn
%         if netCostMatrix(i,q)==0
%             netCostMatrix(i,q)=1./netCostMatrix(i,q);
%         end
%     end
% end



%% IT Toppo



s=[1,1,1,2,2,2,3,3,4,4,6,7,7,7,8,8,9,9,10,10,11,12,12,13,13,14,14,15,16,16,16,16,17,18,19,20];

t=[2,3,5,3,6,7,4,8,5,8,7,8,9,10,10,11,10,13,12,13,14,14,13,15,16,16,17,19,17,18,19,20,18,21,20,21];

weights = 1e3.*[140,110,210,110,95,90,90,95,85,95,90,130,120,150,55,200,60,190,110,180,130,120,170,...
    460,180,200,270,420,210,90,310,350,100,200,150,210];
weights_origin = weights;
names = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20' '21'};
G = graph(s,t,weights,names);
G_origin = G;
num_link= numedges(G); % Number of Liks in graph
nn = numnodes(G); % Number of Liks in graph
[s,t] = findedge(G);
A = sparse(s,t,G.Edges.Weight,nn,nn);
netCostMatrix=full(A);
netCostMatrix=netCostMatrix+netCostMatrix';
for i=1:1:nn
    for q=1:1:nn
        if netCostMatrix(i,q)==0
            netCostMatrix(i,q)=1./netCostMatrix(i,q);
        end
    end
end

netCostMatrix_origin = netCostMatrix;


%% Network's Topology: JPN

% s=[1 1 2 3 3 4 5 5 6 7 7 8 9 9 10 10 11];
% t=[2 4 3 4 7 5 6 7 8 8 10 9 10 11 11 12 12];
% weights = 1e3.*[593.3 1256.4 351.8 47.4 366 250.7 252.2 250.8 263.8 186.6 490.7 341.6 66.2 280.7 365 1158.7 911.9];
% weights_origin = weights;
% names = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12'};
% G = graph(s,t,weights,names);
% G_origin = G;
% num_link= numedges(G); % Number of Liks in graph
% nn = numnodes(G); % Number of Liks in graph
% [s,t] = findedge(G);
% A = sparse(s,t,G.Edges.Weight,nn,nn);
% netCostMatrix=full(A);
% netCostMatrix=netCostMatrix+netCostMatrix';
% for i=1:1:nn
%     for q=1:1:nn
%         if netCostMatrix(i,q)==0
%             netCostMatrix(i,q)=1./netCostMatrix(i,q);
%         end
%     end
% end
%
% netCostMatrix_origin = netCostMatrix;

%% RMSA

% Tx_Rx Configuration

n_Rs=1;                                             % 1 2 3 4 for 14 32 64 96 GBd

rof= 0;                                             % roll-off

Rs = 32e9;

B_ch= Rs;                         % Channels' Bandwidth (GHz)

Lspan = 100e3;

Freq_Grinularity_mat = ceil(32./12.5).*12.5; %GHz

Rb_FEC3 = [60 119	179	238	298	357];

[mat_f_c, num_Ch_mat] = creat_spectrum(Freq_Grinularity_mat,Rs);



mat_f_c = cell2mat(mat_f_c(n_Rs));  % Slot based


num_FS = numel(mat_f_c);

%%
Power_state_path = 10.^((0.64-30)/10);

L_eff =(1-exp(-2*alpha_norm*Lspan))/(2*alpha_norm);   % L_eff is defined as (1-e^(alpha*L_s))/alpha

A_path =(16/27)*gama^2*L_eff^2;

A_prim_self_mode = A_path *Power_state_path/B_ch;

ic_xt = 10.^(-72.21/10)/(1000*10*log10(exp(1)))* Lspan;

%% Traffic and Erlang Configurations

Rb_req_list = 400:200:1000; %Gbps

lambda = 0.01;     %the average of occurance for arrival request time

mio = 7.9:0.1:8.5;     %the average of holding time for arrival request %[0.2,0.25,0.3,0.35,0.4,0.45,0.5]

% SNR_m_mat = 1.2:0.2:4;

a_Erlang = mio./lambda;

OTL = (a_Erlang.*(mean(Rb_req_list)*100*1e-6))/100; % OTL [Tbps]: Offered_traffic_load  --> 1e-3 for Pbps

% Therefore, the offered traffic load is ??????? normalized traffic units
% (NTUs). Since the average bit rate of one request is 550 Gb/s, 100 NTUs
% of traffic refers to about 55 Tb/s of offered traffic load.

KSP_num = 3;

% dist_max_Rs=dist_max(n_Rs,:);

% Ns_max = floor(dist_max(n_Rs,:)./Lspan);

Ns_max = [71 35 14 7 3 1];

num_mode= 1;

num_cores =7;

SpeSpa_div = num_mode*num_cores*num_FS;

% SEC_MF = 1:6;
% 
% MF_Index_list = flip((1:numel(SEC_MF)));

cost_weight_path = [1 0 0 0 0];

time_start=tic;

% rng('shuffle');

for j_mio=1:numel(mio)

    j_mio

    for j_iter=1:3

        j_iter


        %% initializiation


%         load DA_10000
% 
        Link_state = zeros(num_cores,num_FS,numedges(G_origin));

        est_serv_in_first_path_1=0;

        est_serv_in_second_path_2=0;

        est_serv_in_third_path_3=0;

        est_serv_in_first_path=0;

        est_serv_in_second_path=0;

        est_serv_in_third_path=0;

        sim_time=0;

        num_req=0;

        num_blocked_req=0;

        matx_DT=inf*ones(num_cores,num_FS,numedges(G_origin));

        MF_selected_1=0;
        MF_selected_2=0;
        MF_selected_3=0;
        MF_selected_4=0;
        MF_selected_5=0;
        MF_selected_6=0;

        num_BUFS_net = 0;

        num_tx_rx = 0;

        Rb_offered=0;

        BW_offered = 0;

        Rb_blocked=0;

        BW_blocked =0;

        num_established_req=0;

        Sim_time_SA_2 = [];

        links_req_selected = {};

        pos_IdCh_req = {};

        Nspan_req = {};

        snr_req = {};

        wss_req = [];

        TxRx_req = [];

        MF_req = [];

        added_lenght_path_final = [];

        %%  start event-based algorithm

        TTA=exprnd(lambda);  %TTA:time to the arrival

        num_req_max = 10^5;

        req_info = inf*ones(num_req_max,14);

        req_info (1,1) = TTA;

        %% Start!!

        %         rng('shuffle');

        while  num_req < num_req_max

            %             rng('shuffle');

            %% re-initialize Topology

            s=[1,1,1,2,2,2,3,3,4,4,6,7,7,7,8,8,9,9,10,10,11,12,12,13,13,14,14,15,16,16,16,16,17,18,19,20];

            t=[2,3,5,3,6,7,4,8,5,8,7,8,9,10,10,11,10,13,12,13,14,14,13,15,16,16,17,19,17,18,19,20,18,21,20,21];

            weights = weights_origin;

            G = G_origin;

            num_link = numedges(G); % Number of Liks in graph

            netCostMatrix = netCostMatrix_origin;


            %% set request-source,destination and rate of request

            mat_node=1:nn;

            source_indx=randi([1 nn],1);

            source_slected=mat_node(source_indx);

            mat_node(source_indx)=[];

            destination_indx = randi([1 nn-1],1);

            destination_slected = mat_node(destination_indx);

            TTD = min(min(min(matx_DT)));         % TTD:time to the diparture, check the departure time for all channels in all links

            delta_t = min(TTA,TTD);               % time is arriving or depart?

            Flag_SA=0;

            if delta_t==TTA

                %%   ****************** request is served ****************

                index_Rb_req = randi([1 numel(Rb_req_list)],1);

                Rb_req = Rb_req_list(index_Rb_req);

                req_info (num_req+1,3) = Rb_req;

                Rb_offered = Rb_offered + Rb_req;

                TTA = exprnd(lambda);%+delta_t;                              % Arrival time for the next request

                DT_req = exprnd(mio(j_mio));                       % Holding time for the ongoing request

                matx_DT = matx_DT-delta_t;               % update the HT matrix (the HT's of the already established requests)

                DT_req_live(num_req+1) = inf;

                %  DT_req_live{num_req+1} = DT_req;

                DT_req_live = DT_req_live-delta_t;


                req_info(num_req+1,2) = DT_req;

                num_req = num_req+1

                req_info(num_req+1,1) = TTA;

                %% Routing: K-Shortest Path Algorithm is started disjoint links

                k_paths = 1;

                k_path_count = 1;

                totalCosts_final=[];

                while k_path_count <= KSP_num

                    if k_path_count > 1

                        s(selected_link)=[];
                        t(selected_link)=[];
                        weights(selected_link)=[];

                        G = graph(s,t,weights,names);
                        num_link= numedges(G); % Number of Liks in graph
                        A = sparse(s,t,G.Edges.Weight,nn,nn);
                        netCostMatrix=full(A);
                        netCostMatrix=netCostMatrix+netCostMatrix';

                        for i=1:1:nn
                            for q=1:1:nn
                                if netCostMatrix(i,q)==0
                                    netCostMatrix(i,q)=1./netCostMatrix(i,q);
                                end
                            end
                        end

                    end

                    [shortestPaths, totalCosts] = kShortestPath(netCostMatrix, source_slected, destination_slected, k_paths);

                    nodes_ShPath_array{k_path_count} = cell2mat(shortestPaths);

                    if any(totalCosts)

                        totalCosts_final(k_path_count)  = totalCosts;

                    end

                    nodes_ShPath =cell2mat(shortestPaths);

                    num_nods_ShPath = numel(cell2mat(shortestPaths));

                    source_link = nodes_ShPath(1:num_nods_ShPath-1);

                    destination_link = nodes_ShPath(2:num_nods_ShPath);

                    idx_link = findedge(G,source_link,destination_link);

                    selected_link = idx_link';

                    k_path_count= k_path_count+1;

                end

                path_candidate_final =0;

                for jj= 1:numel(nodes_ShPath_array)

                    nodes_ShPath = nodes_ShPath_array{jj};

                    num_nods_ShPath = numel(nodes_ShPath);

                    source_link = nodes_ShPath(1:num_nods_ShPath-1);

                    destination_link = nodes_ShPath(2:num_nods_ShPath);

                    idx_link = findedge(G_origin,source_link,destination_link);

                    array_link_list_candidate_path{jj} = idx_link';

                    if any(array_link_list_candidate_path{jj})
                        path_candidate_final = path_candidate_final +1;
                    end

                end

                %%

                %                 figure
                %
                %                 p=plot(G_origin,'EdgeLabel',G_origin.Edges.Weight);
                %                 p.NodeColor = 'm';
                %                 p.MarkerSize = 10;
                %                 p.Marker = 'o';
                %                 % p.XData = [0 1 1 3 3 4];
                %                 % p.YData = [1 2 0 2 0 1];
                %                 p.EdgeColor = 'b';
                %                 p.LineWidth=3;
                %
                %                 highlight(p,nodes_ShPath_array{1},'EdgeColor','g')
                %                 highlight(p,nodes_ShPath_array{2},'EdgeColor','r')
                %                 highlight(p,nodes_ShPath_array{3},'EdgeColor','y')
                %
                %                 title('Network Topology')
                %

                Shp_list_distance = totalCosts_final;

                Link_state_path_array = cell(1,path_candidate_final);

                %% Create the Path State for an all-Optical network and compute Idle FSs


                Cost_Fun_path = inf*ones(1,path_candidate_final);

                F_max_path = inf*ones(1,path_candidate_final);

                snr_NewReq_path = zeros(1,path_candidate_final);

                wss_path = inf*ones(1,path_candidate_final);

                TxRx_path = inf*ones(1,path_candidate_final);

                MF_path = zeros(1,path_candidate_final);

                Idle_FS_path_mat = zeros(1,path_candidate_final);

                busy_FSs = zeros(1,path_candidate_final);

                selected_path = 0;

                tstart_SA= tic;

                Nspan_KSHP_list = [];

                FS_list_GB_path = [];

                Nspan_path = cell(1,path_candidate_final);

                PST_path = cell(1,path_candidate_final) ;

                %% Compute number of Hops

                [num_hop_Shpath_mat] = comp_num_hop(nodes_ShPath_array,path_candidate_final);

                index_cand_MF_Shpath = [];


                for k_path_count = 1: path_candidate_final

                    PST = [];

                    Link_state_path = Link_state;

                    selected_link = array_link_list_candidate_path{k_path_count};

                    Nspan_KSHP = 0;

                    Nspan_path_link = [];

                    Lenght_link_final = [];

                    flag_QoT = 0;

                    Flag_SA = 0;

                    flag_not_enough_IFS_exist = 0;


                    for link_count = 1:numel(selected_link)

                        Nspan_KSHP = Nspan_KSHP + ceil(weights_origin(selected_link(link_count))/Lspan);

                        Nspan_path_link(link_count) = ceil(weights_origin(selected_link(link_count))/Lspan);

                        Lenght_link_final(link_count) = ceil(weights_origin(selected_link(link_count))/Lspan)*Lspan;%/Nspan_path_link(link_count);

                    end

                    added_lenght_path(k_path_count)= sum(Lenght_link_final);

                    Nspan_KSHP_list(k_path_count) = Nspan_KSHP;

                    if Nspan_KSHP_list(k_path_count) <=  Ns_max(6)

                        index_cand_MF_Shpath(k_path_count) = 6;

                    elseif (  Ns_max(6) <  Nspan_KSHP_list(k_path_count)  && Nspan_KSHP_list(k_path_count) <= Ns_max(5))

                        index_cand_MF_Shpath(k_path_count) = 5;

                    elseif (  Ns_max(5) <  Nspan_KSHP_list(k_path_count)  && Nspan_KSHP_list(k_path_count) <= Ns_max(4))

                        index_cand_MF_Shpath(k_path_count) = 4;

                    elseif (  Ns_max(4) <  Nspan_KSHP_list(k_path_count)  && Nspan_KSHP_list(k_path_count) <= Ns_max(3))

                        index_cand_MF_Shpath(k_path_count) = 3;

                    elseif (  Ns_max(3) < Nspan_KSHP_list(k_path_count)  && Nspan_KSHP_list(k_path_count) <=  Ns_max(2))

                        index_cand_MF_Shpath(k_path_count) = 2;

                    elseif (  Ns_max(2) < Nspan_KSHP_list(k_path_count)  && Nspan_KSHP_list(k_path_count) <=  Ns_max(1))

                        index_cand_MF_Shpath(k_path_count) = 1;

                    elseif Ns_max(1) < Nspan_KSHP_list(k_path_count)

                        index_cand_MF_Shpath(k_path_count) = 0;

                    end

                    if index_cand_MF_Shpath(k_path_count) == 0

                        Flag_MF_no_exist = 0;

                        Disp MF is not exist

                        stop

                    else


                        for core_c = 1:num_cores
                            for FS_c=1:num_FS
                                vector_state_FS=[];
                                for count_link=1:numel(selected_link)
                                    vector_state_FS(count_link)= Link_state_path(core_c,FS_c,selected_link(count_link));
                                end
                                if any(vector_state_FS>=1)
                                    PST(core_c,FS_c)=1;
                                elseif all(vector_state_FS==0)
                                    PST(core_c,FS_c)=0;
                                    %                                 elseif all(vector_state_FS<=0) && any(vector_state_FS<0)
                                    %                                     PST(core_c,FS_c)=-1;
                                end
                            end
                        end

                        PST_path{k_path_count} = PST;

                        busy_FSs(k_path_count) = nnz(PST(:,:));

                        Idle_FS_path_mat(k_path_count) = SpeSpa_div-busy_FSs(k_path_count);

                        %% compute number of required FSs

                        Rb_SbCh = Rb_FEC3(n_Rs,index_cand_MF_Shpath(k_path_count));

                        req_SbCh = ceil(Rb_req/Rb_SbCh);

                        FS_req = req_SbCh*ceil(B_ch/(12.5e9));

                        BW_offered_path(k_path_count) = FS_req*12.5;

                        %% Initial checking for N_FS

                        flag_not_enough_IFS_exist = 0;

                        if Idle_FS_path_mat(k_path_count) < req_SbCh

                            flag_not_enough_IFS_exist = 1;

                        else

                            %%  Spectrum Assignment FF


                            core_count = 1;

                            FS_count = 0;

                            F_max_options = inf*ones(1,num_cores);

                            FS_list_main_options = {};

                            num_active_neighb_options = [];

                            num_FS_options = [];

                            core_list_main_options = {};

                            %                             busy_Ch_cores =[];

                            while core_count <= num_cores

                                Flag_SA=0;
                                FS_count=0;
                                FS_list_main=[];
                                uu=0;
                                ff=1;

                                %                                 busy_Ch_cores(core_count) = nnz(PST(core_count,:));

                                while  ff<= num_FS && FS_count<req_SbCh

                                    Flag_SA = 0;

                                    FS_list_main = [];

                                    FS_count = 0;

                                    core_list_main = [];

                                    uu=0;

                                    while ff<= num_FS && FS_count<req_SbCh

                                        if  PST(core_count,ff)==0

                                            if  FS_count<req_SbCh
                                                FS_count=FS_count+1;
                                                FS_list_main(uu+1)=ff;
                                                uu=uu+1;
                                            end

                                        else
                                            FS_count=0;
                                            FS_list_main=[];
                                            uu=0;
                                            break
                                        end

                                        ff=ff+1;
                                    end

                                    if FS_count==req_SbCh

                                        Flag_SA=1;

                                        core_list_main = core_count;

                                        break
                                    else
                                        FS_count = 0;
                                        ff = ff+1;
                                    end
                                end

                                if Flag_SA == 1

                                    break

                                else

                                    core_count = core_count + 1;

                                end

                            end


                            if Flag_SA ==1

                                zeros_mat=[];

                                zeros_mat(:,2) = FS_list_main;

                                zeros_mat(:,1) = core_count;


                                pos_fc = unique(zeros_mat(:,2));


                                for link_count = 1:numel(selected_link)

                                    for sbch_count = 1:numel(zeros_mat(:,1))


                                        Link_state_path(zeros_mat(sbch_count,1), zeros_mat(sbch_count,2), selected_link(link_count)) = num_req;


                                    end
                                end

                                Sim_time_SA_1 = toc(tstart_SA);


                                %% QoT_Tool

                                SNR_Path_SbChs_dB = [];

                                SNR_link_AseNLI_dB = [];

                                flag_QoT = 0;


                                for SbCh_count = 1:req_SbCh

                                    SNR_Path_AseNLI = 0;

                                    fc_SbCh_CUT = mat_f_c(1,zeros_mat(SbCh_count,2)); %Hz

                                    for link_count = 1:numel(selected_link)

                                        AER_list_fc = [];

                                        link_UT_SbCh = Link_state_path(zeros_mat(SbCh_count,1),:,selected_link(link_count));

                                        AER_list_fc = find(link_UT_SbCh > 0);

                                        B_prim=0;

                                        for freq_count = 1:numel(AER_list_fc)

                                            f_q_prim = mat_f_c(AER_list_fc(freq_count));

                                            if f_q_prim == fc_SbCh_CUT
                                                delat_q_q_prim=1;
                                            else
                                                delat_q_q_prim=0;
                                            end

                                            K_q_q_prim=(1/(4*pi*L_eff_a*abs(beta_2)))*...
                                                (asinh(pi^2*abs(beta_2)*L_eff_a*B_ch*(-fc_SbCh_CUT+f_q_prim+(B_ch*0.5)))-...
                                                asinh(pi^2*abs(beta_2)*L_eff_a*B_ch*(f_q_prim-fc_SbCh_CUT-(B_ch*0.5))));

                                            B_prim=B_prim+((2-delat_q_q_prim)*K_q_q_prim*(Power_state_path/B_ch)^2);

                                        end

                                        P_NLI_span = B_ch*A_prim_self_mode*B_prim;

                                        P_ASE= B_ch*h_plank*1.933775e+14*(exp(2*alpha_norm*Lspan)-1)*F;

                                        P_XC_span=0;

                                        adjacent_core_list = adjacent_core(zeros_mat(SbCh_count,1),:);

                                        adjacent_core_list_index = find(adjacent_core_list~=0);

                                        num_neighbour = nnz(Link_state_path(adjacent_core_list_index,zeros_mat(SbCh_count,2),selected_link(link_count)));

                                        P_XC_span = num_neighbour*ic_xt*Power_state_path;

                                        SNR_link_AseNLI = Power_state_path/(P_ASE+P_NLI_span+P_XC_span)/ Nspan_path_link(link_count);

                                        SNR_Path_AseNLI = SNR_Path_AseNLI + SNR_link_AseNLI^-1;


                                        SNR_link_AseNLI_dB(SbCh_count,link_count)= 10*log10(SNR_link_AseNLI);

                                    end

                                    SNR_Path_SbChs_dB(SbCh_count)= 10*log10(SNR_Path_AseNLI.^-1);

                                end

                                if all(SNR_Path_SbChs_dB>=target_SNR_dB(index_cand_MF_Shpath(k_path_count)))
                                    flag_QoT =1;
                                else
                                    disp flag_QoT_error
                                    stop
                                end

                            end

                        end
                    end

                    tstart_SA_2 = tic;

                    if Flag_SA == 1 && flag_not_enough_IFS_exist == 0 && flag_QoT == 1

                        Link_state_path_array{k_path_count} = Link_state_path;

                        TxRx_path(k_path_count) = req_SbCh;

                        MF_path(k_path_count) = index_cand_MF_Shpath(k_path_count);

                        min_snr_mrg_sbch_req_path(k_path_count) = min(SNR_Path_SbChs_dB) - target_SNR_dB(index_cand_MF_Shpath(k_path_count));

                        ave_snr_mrg_sbch_req_path(k_path_count) = mean(SNR_Path_SbChs_dB) - target_SNR_dB(index_cand_MF_Shpath(k_path_count));

                        snr_req_path{k_path_count} = SNR_Path_SbChs_dB;

                        %                         num_BUFS_path(k_path_count) = num_BUFS;

                        F_max_path(k_path_count) = max(pos_fc);

                        snr_NewReq_path(k_path_count) = mean(SNR_Path_SbChs_dB);

                        Cost_Fun_path(k_path_count) = cost_weight_path(1)*F_max_path(k_path_count);

                        Nspan_path{k_path_count} = Nspan_path_link;

                        Lenght_link_final_path{k_path_count} = Lenght_link_final;

                        pos_idles_path{k_path_count} = zeros_mat;


                    end

                end

                BW_offered = BW_offered + mean(BW_offered_path);

                if any(Cost_Fun_path ~= inf)

                    selected_path = find(Cost_Fun_path == min(Cost_Fun_path));

                    if numel(selected_path) > 1
                        selected_path = find(F_max_path == min(F_max_path));
                        if numel(selected_path) > 1
                            selected_path = find(snr_NewReq_path == max(snr_NewReq_path));
                            if numel(selected_path) > 1
                                selected_path= find(TxRx_path== min(TxRx_path));
                                if numel(selected_path) > 1
                                    dist_selected_path = Shp_list_distance(selected_path);
                                    selected_path = find(dist_selected_path == min(dist_selected_path));
                                    if numel(selected_path) > 1
                                        selected_path = selected_path(randi([1 numel(selected_path)],1));
                                    end
                                end
                            end
                        end
                    end
                end

                if   selected_path ~= 0

                    num_established_req = num_established_req + 1;

                    Sim_time_SA_2(num_established_req) = toc(tstart_SA_2)+Sim_time_SA_1;

                    num_tx_rx = num_tx_rx + TxRx_path(selected_path);

                    if MF_path(selected_path) ==1
                        MF_selected_1=MF_selected_1+1;
                    elseif MF_path(selected_path)==2
                        MF_selected_2=MF_selected_2+1;
                    elseif MF_path(selected_path)==3
                        MF_selected_3=MF_selected_3+1;
                    elseif MF_path(selected_path)==4
                        MF_selected_4=MF_selected_4+1;
                    elseif MF_path(selected_path)==5
                        MF_selected_5=MF_selected_5+1;
                    elseif MF_path(selected_path)==6
                        MF_selected_6=MF_selected_6+1;
                    end

                    if selected_path==1
                        est_serv_in_first_path=est_serv_in_first_path+1;
                    elseif selected_path==2
                        est_serv_in_second_path=est_serv_in_second_path+1;
                    elseif selected_path==3
                        est_serv_in_third_path=est_serv_in_third_path+1;
                    end

                    req_info(num_req,4) = Shp_list_distance(selected_path)/1000;


                    Link_state = Link_state_path_array{selected_path};


                    if ~any(Link_state)
                        disp error
                        stop
                    end

                    links_req_selected{num_req} = array_link_list_candidate_path{selected_path};

                    links_ShP_selected = array_link_list_candidate_path{selected_path};

                    pos_IdCh_req{num_req} = pos_idles_path{selected_path};

                    zeros_mat_NER = pos_idles_path{selected_path};

                    for link_count = 1:numel(links_ShP_selected)

                        for sbch_count = 1:numel(zeros_mat_NER(:,1))


                            matx_DT(zeros_mat_NER(sbch_count,1),zeros_mat_NER(sbch_count,2),links_ShP_selected(link_count)) = DT_req;


                        end
                    end

                    DT_req_live(num_req) = DT_req;

                    req_info(num_req,5) = snr_NewReq_path(selected_path); % SNR at the serving time

                    req_info(num_req,6) = 1;

                    req_info(num_req,7) = TxRx_path(selected_path);

                    req_info(num_req,8) = MF_path(selected_path);

                    wss_req(num_req) = num_hop_Shpath_mat(selected_path);

                    TxRx_req(num_req) = TxRx_path(selected_path);

                    MF_req(num_req) = MF_path(selected_path);

                    req_info(num_req,9) = min_snr_mrg_sbch_req_path(selected_path);

                    req_info(num_req,10) = ave_snr_mrg_sbch_req_path(selected_path);

                    if MF_path(selected_path) < 6

                        req_info(num_req,11) = min(snr_req_path{selected_path})- target_SNR_dB(MF_path(selected_path)+1);

                        req_info(num_req,12) = mean(snr_req_path{selected_path}) - target_SNR_dB(MF_path(selected_path)+1);
                    end

                    snr_req{num_req} = snr_req_path{selected_path};

                    Nspan_req{num_req} = Nspan_path{selected_path};

                    added_lenghth_selected_path = sum(Lenght_link_final_path{selected_path}) - Shp_list_distance(selected_path);

                    added_lenght_path_final(num_req) = added_lenghth_selected_path(1);

                    Sbch_pos_NER = pos_idles_path{selected_path};

                else

                    %% Blocking

                    num_blocked_req = num_blocked_req + 1;

                    Rb_blocked = Rb_blocked + Rb_req;

                    BW_blocked = BW_blocked + mean(BW_offered_path);

                    req_info(num_req,6) = -1;

                    BBP_Rb = Rb_blocked/Rb_offered;

                    BBP_BW = BW_blocked/BW_offered;

                    req_info (num_req,13) = BBP_Rb;

                    wss_req (num_req)= 0;

                    TxRx_req (num_req)= 0;

                    MF_req (num_req)= 0;


                end

            else

                %% DT

                SNR_Path_SbChs_dB_DT = [];

                index_req_depart = find(DT_req_live==delta_t);

                links_ShP_DT = links_req_selected{index_req_depart};

                pos_IdCh_DT  = pos_IdCh_req{index_req_depart};

                Index_MF_req_DT = MF_req(index_req_depart);

                Nspan = Nspan_req{index_req_depart} ;

                % QoT-DT
% 
%                 for SbCh_count=1:numel(pos_IdCh_DT(:,1))
% 
%                     SNR_Path_AseNLI = 0;
% 
%                     fc_SbCh_CUT = mat_f_c(1,pos_IdCh_DT(SbCh_count,2)); %Hz
% 
%                     for link_count = 1:numel(links_ShP_DT)
% 
%                         link_UT_adjacent_DT = Link_state(1:num_cores,pos_IdCh_DT(SbCh_count,2),links_ShP_DT(link_count));
% 
%                         AER_list_DT_adjacent = (unique(link_UT_adjacent_DT(link_UT_adjacent_DT > 0)));
% 
% 
%                         link_UT_SbCh_DT = Link_state(pos_IdCh_DT(SbCh_count,1),:,links_ShP_DT(link_count));
% 
%                         AER_list_DT = find(link_UT_SbCh_DT > 0);
% 
%                         B_prim=0;
% 
%                         for freq_count = 1:numel(AER_list_DT) % " qq " is frequency slot counter in the under study SbCh's mode
% 
%                             f_q_prim = mat_f_c(AER_list_DT(freq_count));
% 
%                             if f_q_prim == fc_SbCh_CUT
%                                 delat_q_q_prim=1;
%                             else
%                                 delat_q_q_prim=0;
%                             end
% 
%                             K_q_q_prim=(1/(4*pi*L_eff_a*abs(beta_2)))*...
%                                 (asinh(pi^2*abs(beta_2)*L_eff_a*B_ch*(-fc_SbCh_CUT+f_q_prim+(B_ch*0.5)))-...
%                                 asinh(pi^2*abs(beta_2)*L_eff_a*B_ch*(f_q_prim-fc_SbCh_CUT-(B_ch*0.5))));
% 
%                             B_prim=B_prim+((2-delat_q_q_prim)*K_q_q_prim*(Power_state_path/B_ch)^2);
% 
%                         end
% 
%                         P_NLI_span = B_ch*A_prim_self_mode*B_prim;
% 
%                         P_ASE = B_ch*h_plank*1.933775e+14*(exp(2*alpha_norm*Lspan)-1)*F;
% 
%                         adjacent_core_list = adjacent_core(pos_IdCh_DT(SbCh_count,1),:);
% 
%                         adjacent_core_list_index = find(adjacent_core_list~=0);
% 
%                         num_neighbour = nnz(Link_state(adjacent_core_list_index,pos_IdCh_DT(SbCh_count,2),links_ShP_DT(link_count)));
% 
%                         P_XC_span = num_neighbour*ic_xt*Power_state_path;
% 
%                         SNR_link_AseNLI = Power_state_path/(P_ASE+P_NLI_span+P_XC_span)/Nspan(link_count);
% 
%                         SNR_Path_AseNLI = SNR_Path_AseNLI + SNR_link_AseNLI^-1;
% 
%                         %                         end
%                     end
% 
%                     SNR_Path_SbChs_dB_DT(SbCh_count)= 10*log10(SNR_Path_AseNLI.^-1); %for end-to-end path fixed margin
% 
%                 end
% 
%                 req_info(index_req_depart,10) = mean(SNR_Path_SbChs_dB_DT);
% 
%                 min_snr_mrg_sbch_req_DT(index_req_depart) = min(SNR_Path_SbChs_dB_DT) - target_SNR_dB(Index_MF_req_DT);
% 
%                 ave_snr_mrg_sbch_req_DT(index_req_depart) = mean(SNR_Path_SbChs_dB_DT) - target_SNR_dB(Index_MF_req_DT);
% 
%                 flag_QoT_DT = 0;

%                 if all(SNR_Path_SbChs_dB_DT >= target_SNR_dB(Index_MF_req_DT))
%                     flag_QoT_DT =1;
% 
%                 else
%                     disp flag_QoT_DT_error
%                     stop
%                 end
% 
%                 req_info(index_req_depart,13) = min_snr_mrg_sbch_req_DT(index_req_depart);
% 
%                 req_info(index_req_depart,14) = ave_snr_mrg_sbch_req_DT(index_req_depart);
% 
%                 req_info(index_req_depart,15) = req_info(index_req_depart,11)- req_info(index_req_depart,13);
% 
%                 req_info(index_req_depart,16) = req_info(index_req_depart,12)- req_info(index_req_depart,14);
% 
%                 if Index_MF_req_DT < 6
% 
%                     req_info(index_req_depart,19) = min(SNR_Path_SbChs_dB_DT) - target_SNR_dB(Index_MF_req_DT+1);
% 
%                     req_info(index_req_depart,20) = mean(SNR_Path_SbChs_dB_DT) - target_SNR_dB(Index_MF_req_DT+1);
%                 end
% 
%                 snr_req_DT{index_req_depart} = SNR_Path_SbChs_dB_DT;

                TTA=TTA-delta_t;

                Link_state(matx_DT==delta_t)=0;

                HT_req(index_req_depart) = req_info(index_req_depart,2) - delta_t; % or delta_t = DT_req_live(index_req_depart)

                req_info(index_req_depart,14) = HT_req(index_req_depart);

                matx_DT(matx_DT==delta_t)=inf*ones(1,1);

                DT_req_live(index_req_depart)=inf*ones(1,1);

                matx_DT=matx_DT-delta_t;

                DT_req_live = DT_req_live-delta_t;


            end
            sim_time=sim_time+delta_t;
        end

%         num_BUFS_net_per_req_iter(j_iter) = num_BUFS_net/num_established_req;

%         max_min_snr_sbch_req_vect = req_info(:,15);
% 
%         max_min_snr_sbch_req_vect(max_min_snr_sbch_req_vect == inf) = [];
% 
%         max_min_snr_sbch_req (j_iter) = max(max_min_snr_sbch_req_vect);



        Array_req_inf {j_iter} = req_info;

        mat_iter_wss_req(j_iter,:) = wss_req;

        mat_iter_TxRx_req(j_iter,:) = TxRx_req;

        mat_iter_MF_req(j_iter,:) = MF_req;

        Array_iter_Sim_time_SA {j_iter} = Sim_time_SA_2;

        mat_iter_ave_Sim_time_SA(j_iter) = mean(Sim_time_SA_2);

        matx_bloking_probability(j_iter) = num_blocked_req/num_req;

        % BBP is defined as the volume of rejected
        %traffic divided by the volume of all traffic offered to the
        %network.

        matx_BBP(j_iter) = Rb_blocked/Rb_offered;

        matx_BBP_BW(j_iter) = BW_blocked/BW_offered;

        matx_num_established_req(j_iter) = num_established_req;

        matx_mean_num_Tx_Rx(j_iter) = (num_tx_rx/num_established_req);

        matx_MF_selected_1(j_iter)=(MF_selected_1/num_established_req)*100;
        matx_MF_selected_2(j_iter)=(MF_selected_2/num_established_req)*100;
        matx_MF_selected_3(j_iter)=(MF_selected_3/num_established_req)*100;
        matx_MF_selected_4(j_iter)=(MF_selected_4/num_established_req)*100;
        matx_MF_selected_5(j_iter)=(MF_selected_5/num_established_req)*100;
        matx_MF_selected_6(j_iter)=(MF_selected_6/num_established_req)*100;

        matx_est_serv_in_first_path(j_iter)=(est_serv_in_first_path/num_established_req)*100;
        matx_est_serv_in_second_path(j_iter)=(est_serv_in_second_path/num_established_req)*100;
        matx_est_serv_in_third_path(j_iter)=(est_serv_in_third_path/num_established_req)*100;

        save('DA_FF_IT_MCF7_IndSw_07012022_iter.mat','-v7.3');

    end

%     Output.num_BUFS_net_per_req_mio(j_mio) = mean(num_BUFS_net_per_req_iter);

    Output.Array_req_inf_final {j_mio} = Array_req_inf;

    Output.ave_Simt_ime_SA_final(j_mio) = mean(mat_iter_ave_Sim_time_SA);

    Output.Array_Simt_ime_SA_final{j_mio} = Array_iter_Sim_time_SA;

    Output.AvePerEstReq_RxTx(j_mio) = mean(matx_mean_num_Tx_Rx);

    Output.BP_NumReq(j_mio) = mean(matx_bloking_probability);

    Output.STD_BP_NumReq(j_mio) = std(matx_bloking_probability);

    Output.BBP(j_mio) = mean(matx_BBP);

    Output.STD_BBP(j_mio) = std(matx_BBP);

    Output.AvePerEstReq_MF1(j_mio)=mean(matx_MF_selected_1);

    Output.AvePerEstReq_MF2(j_mio)=mean(matx_MF_selected_2);

    Output.AvePerEstReq_MF3(j_mio)=mean(matx_MF_selected_3);

    Output.AvePerEstReq_MF4(j_mio)=mean(matx_MF_selected_4);

    Output.AvePerEstReq_MF5(j_mio)=mean(matx_MF_selected_5);

    Output.AvePerEstReq_MF6(j_mio)=mean(matx_MF_selected_6);

    Output.Path1(j_mio)=mean(matx_est_serv_in_first_path);

    Output.Path2(j_mio)=mean(matx_est_serv_in_second_path);

    Output.Path3(j_mio)=mean(matx_est_serv_in_third_path);

    Output.wss_req_arra{j_mio} = mat_iter_wss_req;

    Output.TxRx_req_arra{j_mio} = mat_iter_TxRx_req;

    Output.MF_req_arra{j_mio} = mat_iter_MF_req;

%     Output.mean_max_min_snr_sbch_req(j_mio) = mean(max_min_snr_sbch_req);
% 
%     Output.max_max_min_snr_sbch_req_mio(j_mio) = max(max_min_snr_sbch_req);

    save('DA_FF_IT_MCF7_IndSw_07012022_mio.mat','-v7.3');

end

Output.time_sim_total=toc(time_start);

save('DA_FF_IT_MCF7_IndSw_07012022_mio_iter.mat','-v7.3');
