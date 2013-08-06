function [Res]=energy_fit(y,S_BETA1, S_BETA2, S_BETAL, Synchro_ref,Lanex_ref, Nist_ref,pick,K_B1L,K_B2L)
%% Fit function for the critical energy
%%% - "y" is the fitted critical energy
%%% - "S_BETA1/2/L" are the measurements of the betatron signal on the
%%%    respective cameras
%%% - "Synchro/Lanex/Nist_ref/" and "pick" are needed for Gamma_num, see
%%%    its description for further details.
%%% - "K_B1L" and "K_B2L" are the fitted values of the ratio of the number 
%%%   of particles per count in the cameras for various critical energies
%%% - [Res] is the residual of the fit. It consists in the rms of the
%%% difference between the simulated value and the measured value of signal
%%% on each selected filter (and camera). 


S_ratio_tot(:,1:7)=S_BETA1*interp1(logspace(-1,3,200), K_B1L, y)./S_BETAL;
S_ratio_tot(:,8:14)=S_BETA2*interp1(logspace(-1,3,200), K_B2L, y)./S_BETAL;
S=Gamma_num(y, 200, Synchro_ref, Lanex_ref, Nist_ref, S_ratio_tot, pick,1);

Res=rms(S,2);
end
