%%%Gets pre-generated synchrotron from a .txt file
%%%The synchrotron function used is taken from GNU's Scientific Library

path_synchrotron='C:/Users/Jacques/Desktop/PRE/C/';

txt= fopen([path_synchrotron 'synchrotron1.txt']);
Synchro_ref= fscanf(txt, '%f', [5600,3]);
clear txt;

 %% Use this if you want to plot the Synchrotron function to check its shape
 %%Adjusts the zero for proper plotting
    % synchro_val=exp(Synchro_ref(:,3));
    % synchro_axis=Synchro_ref(:,1);
    % synchro_axis(1)=0;
    % synchro_val(1)=0;
    %  
    % figure(1);
    % plot(synchro_axis(:),synchro_val(:));
    % set(figure(1), 'position', [500, 100, 1000, 900]);
    % 
    % figure(2);
    % plot(synchro_axis(1:2500),synchro_val(1:2500));
    % set(figure(2), 'position', [1200, 300, 400, 700]);
    %%