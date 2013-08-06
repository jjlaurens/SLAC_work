%%  
%    Script to get the NIST datas on copper and tungsten cross-sections.
%    Needs the data stored by default in a "Nist_datas" directory

%    Nist_ref . copper :     1 : Copper Energy Axis
%                            2 : Copper Cross Section
%             . tungsten :   1 : Tungsten Energy Axis
%                            2 : Tungsten Cross Section             
%               
%%

path_nist = 'C:/Users/Jacques/Desktop/PRE/Nist_datas/';

Nist_ref.copper=load([path_nist 'Copper_nist.txt']);
Nist_ref.copper(:,[2:6,8])=[]; 

Nist_ref.tungsten=load([path_nist 'Tungsten_nist.txt']);
Nist_ref.tungsten(:,[2:6,8])=[]; 

Nist_ref.tungsten90=load([path_nist 'Tungsten90_nist.txt']);
Nist_ref.tungsten90(:,[2:6,8])=[]; 

