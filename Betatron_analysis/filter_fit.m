%% Script to analyze how it fits on each filter
%%% This script calculates the residual for each filter on BETA1 and BETA2.
%%% It then determines the critical energy that fits best on each filter
%%% and plots the residual. 

%% Settings
do_plot_beta1l=1;
do_plot_beta2l=1;
color(1,:)=[0 0 1]; color(2,:)=[0 1 0]; color(3,:)=[1 1 0]; color(4,:)=[0 1 1]; 
color(5,:)=[1 0 1]; color(6,:)=[1 0 0]; color(7,:)=[0 0 0];
%% Calculates the residual on each filter for multiple critical energies

for i=1:14
    for k=1:149
        D(i,k)=Gamma_num(y(k), 100, Synchro_ref, Lanex_ref, Nist_ref, S_ratio_tot, i,1);
    end
end

%% Finds the critical energy that fits best each filter
 
for i=1:14
    [Ec_f(i), d_min(i)]=fminsearch(@(z) Gamma_num(z, 200, Synchro_ref, Lanex_ref, Nist_ref, S_ratio_tot, i,1),1);
end

%% BETA1 plot

if do_plot_beta1l
    clf(figure(3));
    figure(3) 

    for i=1:7
    plot(y,D(i,:),'color',color(i,:))

    hold on
    end
    line([0 100], [0.1 0.1])
    legend('Cu1 mm', 'Cu 3mm', 'Cu 10mm', 'W 3mm', 'W 1mm', 'Cu 0.3mm', 'NF');
     h_text = axes('Position', [0.17, 0.95, 0.3, 0.035], 'Visible', 'off');
         Pick_text =text(0., 0.75, ['Ec fit = [' num2str(Ec_f(1:7)) ']'], 'fontsize', 12); 
end

%% BETA2 plot

if do_plot_beta2l
    clf(figure(4));
    figure(4) 

    for i=8:14
    plot(y,D(i,:),'color',color(i-7,:))

    hold on
    end
    line([0 100], [0.1 0.1])
    legend('Cu1 mm', 'Cu 3mm', 'Cu 10mm', 'W 3mm', 'W 1mm', 'Cu 0.3mm', 'NF');
     h_text = axes('Position', [0.17, 0.95, 0.3, 0.035], 'Visible', 'off');
         Pick_text =text(0., 0.75, ['Ec fit = [' num2str(Ec_f(1,8:14)) ']'], 'fontsize', 12); 
end
