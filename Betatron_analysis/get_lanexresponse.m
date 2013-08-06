%% Script to get the Lanex Response data simulations.  
%%% Needs the data stored by default in a R_Lanex_Response directory 
%%% Two versions are available for the Copper 10. Default is 2*2mm^2.
%%% 10*10mm^2 was used to try to adjust the simulation to inadequate experimental
%%% results but it seems that the mismatch comes from the experimental
%%% measure rather than the simulation.
%%% Since the W3 foil used is actually not pure W but W (90%) Ni (4%) Cu (3%) Fe(3%)
%%% a specific lanex response function was simulated to fit the
%%% experiment.


% Lanex_ref : 1 : Energy (in MeV)
%             2 : Cu 1mm
%             3 : Cu 3mm
%             4 : Cu 10mm
%             5 : W 3mm
%             6 : W 1mm
%             7 : Cu 0.3mm
%             8 : No Converter
%     
% 
%%
path_lanex = 'C:/Users/Jacques/Desktop/PRE/R_lanex_response/';

Lanex_ref=load([path_lanex 'lanex_regular_response_Cu1mm_2x2mm2.txt']);

Lanex_ref(:,5)=[]; Lanex_ref(:,2:3)=[];

tmp=load([path_lanex 'lanex_regular_response_Cu3mm_2x2mm2.txt']);
Lanex_ref(:,3)=tmp(:,4);
clear tmp;

tmp=load([path_lanex 'lanex_regular_response_Cu10mm_2x2mm2.txt']);
Lanex_ref(:,4)=tmp(:,4);
clear tmp;

% tmp=load([Lanex_path 'lanex_regular_response_Cu10mm_2x2mm2.txt']);
% Lanex_ref(:,4)=tmp(:,4);
% clear tmp;


tmp=load([path_lanex 'lanex_regular_response_W90-3mm_10x10mm2.txt']);
Lanex_ref(:,5)=tmp(:,4);
clear tmp;

% tmp=load([path_lanex 'lanex_regular_response_W3mm_2x2mm2.txt']);
% Lanex_ref(:,5)=tmp(:,4);
% clear tmp;

tmp=load([path_lanex 'lanex_regular_response_W1mm_2x2mm2.txt']);
Lanex_ref(:,6)=tmp(:,4);
clear tmp;

tmp=load([path_lanex 'lanex_regular_response_Cu300um_2x2mm2.txt']);
Lanex_ref(:,7)=tmp(:,4);
clear tmp;

tmp=load([path_lanex '/lanex_regular_response_no-converter_2x2mm2.txt']);
Lanex_ref(:,8)=tmp(:,4);
clear tmp;


