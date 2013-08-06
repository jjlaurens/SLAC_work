%% Main script used to fit the critical energy. 
%%%  This is the main script used to determine the critical energy. 
%%%  It is designed as a loop on each shot of a selection of shots. 
%%%
%%%  For a given shot, the script will fit the critical energy if do_fit is
%%%  enabled and will plot the residual if do_plot is enabled. 
%%%  In case both are set to 1, then it will also calculate the 10% Error
%%%  margin and display it on the plot. 
%%%  If neither do_fit or do_plot are enabled, the script will scan
%%%  through various critical energies and plot the relative error on each
%%%  filter for each energy.
%%%    
%%%  The script will display on figure 1 the processed images of BETAL/1/2,
%%%  the measured signal on the different filters and the relative errors
%%%  between simulation at a given energy and measurement. 
%%%  On figure 2 is displayed the residual for the different critical
%%%  energies (if do_plot=1). 
%%%   
%%%  To make the calculations faster, three pre-calculated matrices are
%%%  loaded. To calculate them the first time, use "mat_num_eval.m"
%%%
%%%  The pick on the BETA cameras is centered using a maximum detection
%%%  function. As it is, this requires a manual test to properly center the
%%%  selection because of regular shot-to-shot variation. 
%%%  If do_max_pick=1, the script will use the first shot to determine the
%%%  center. Since this position shouldn't change from a dataset to another,
%%%  a default position of the center has been determined on E200_10567 and
%%%  will be used if do_max_pick=0. 
%%%
%%%  The shots are indexed in a Ind matrix whose first line (I) is the step
%%%  index and second line (J) is the shot number. 
%%%  If do_shot_pick=1, the script will expect a pre-selection of shots to
%%%  be hand-picked and entered (see below). Else, it will run on all shots
%%%  of the dataset. 


%%  If you want to switch between single shot and loop
ec0=1; l0=1;     
l=l0;          
ec=ec0;
%% Settings
do_fit =1;       
do_plot= 1;
do_max_pick=0;
do_shot_pick=1;
do_save_1=0;
do_save_2=0;
%% Initialize path variables

addpath('C:/Users/Jacques/Desktop/PRE/Matlab/E200_scripts/facet_daq/');
addpath('C:/Users/Jacques/Desktop/PRE/Matlab/E200_scripts/sc_ana/');
addpath('C:/Users/Jacques/Desktop/PRE/Matlab/E200_scripts/tools/');

prefix = 'C:/Users/Jacques/Desktop/PRE/Volumes/PWFA_4big';
day = '20130423';
data_set = 'E200_10567';
do_save = 0;
save_path =['C:/Users/Jacques/Desktop/PRE/Saves/2013_E200_Data_Analysis/Energy_Scan/' day '/'];

%%
y=logspace(-1,3,200);  %Critical energy interval 
y(150:200)=[];         %Activate in case you want to zoom in the plot 
Err=zeros(1,size(y,2));


%% Generate function references
get_synchrotron;
get_lanexresponse;
get_nistdatas;

%% Load useful variables
load('./K_B1L.mat');
load('./K_B2L.mat');
load('./S_num.mat');

%% Get dataset info and sets BETA variables and background

cmap = custom_cmap();

BETAL_caxis = [0 1000];
BETA1_caxis = [0 1000];
BETA2_caxis = [0 1000];

path = [prefix '/nas/nas-li20-pm01/E200/2013/' day '/' data_set '/'];
if(~exist([save_path data_set], 'dir')); mkdir([save_path data_set '/frames/']); end;


scan_info_file = dir([path '*scan_info*']);
if size(scan_info_file,1) == 1
    load([path scan_info_file.name]);
    n_step = size(scan_info,2);
    is_qsbend_scan = strcmp(scan_info(1).Control_PV_name, 'set_QSBEND_energy');
    is_qs_scan = strcmp(scan_info(1).Control_PV_name, 'set_QS_energy');
    is_scan = 1;
        
elseif ( size(scan_info_file,1) == 0 || day <= 20130423 )
        list = dir([path data_set '*BETAL*.header']);
    scan_info.BETAL = strtok(['/nas/nas-li20-pm01/E200/2013/' day '/' data_set '/' list.name],'.');
    list = dir([path data_set '*BETA1*.header']);
    scan_info.BETA1 = strtok(['/nas/nas-li20-pm01/E200/2013/' day '/' data_set '/' list.name],'.');
    list = dir([path data_set '*BETA2*.header']);
    scan_info.BETA2 = strtok(['/nas/nas-li20-pm01/E200/2013/' day '/' data_set '/' list.name],'.');
    list = dir([path data_set '*CEGAIN*.header']);
    scan_info.CEGAIN = strtok(['/nas/nas-li20-pm01/E200/2013/' day '/' data_set '/' list.name],'.');
    list = dir([path data_set '*CELOSS*.header']);
    scan_info.CELOSS = strtok(['/nas/nas-li20-pm01/E200/2013/' day '/' data_set '/' list.name],'.');
    list = dir([path data_set '*YAG*.header']);
    scan_info.YAG = strtok(['/nas/nas-li20-pm01/E200/2013/' day '/' data_set '/' list.name],'.');
    clear list;
    n_step = 1;
    is_qsbend_scan = 0;
    is_qs_scan = 0;
    is_scan = 0;
    
elseif (size(scan_info_file,1) == 0 || day > 20130423 )
    filenames_file = dir([path data_set '*_filenames.mat']);
    load([path filenames_file.name]);
    scan_info = filenames ;   
    n_step = 1;
    is_qsbend_scan = 0;
    is_qs_scan = 0;
    is_scan = 0;
    
else
    error('There are more than 1 scan info file.');
end




list = dir([path data_set '_2013*.mat']);
mat_filenames = {list.name};
if(day > 20130423)
    mat_filenames = {mat_filenames{1:2:end}};
end
    
load([path mat_filenames{1}]);
n_shot = param.n_shot;
%%

BETAL = cam_back.BETAL;
BETA1 = cam_back.BETA1;
BETA2 = cam_back.BETA2;

BETAL.X_RTCL_CTR = 700;
BETAL.Y_RTCL_CTR = 500;
BETA1.X_RTCL_CTR = 700;
BETA1.Y_RTCL_CTR = 500;
BETA2.X_RTCL_CTR = 700;
BETA2.Y_RTCL_CTR = 500;

BETAL.xx = 1e-3*BETAL.RESOLUTION * ( (BETAL.ROI_X-BETAL.X_RTCL_CTR+1):(BETAL.ROI_X+BETAL.ROI_XNP-BETAL.X_RTCL_CTR) );
BETAL.yy = sqrt(2) * 1e-3*BETAL.RESOLUTION * ( (BETAL.ROI_Y-BETAL.Y_RTCL_CTR+1):(BETAL.ROI_Y+BETAL.ROI_YNP-BETAL.Y_RTCL_CTR) );
BETA1.xx = 0.1148 * ( (BETA1.ROI_X-BETA1.X_RTCL_CTR+1):(BETA1.ROI_X+BETA1.ROI_XNP-BETA1.X_RTCL_CTR) );
BETA1.yy = 0.1061 * ( (BETA1.ROI_Y-BETA1.Y_RTCL_CTR+1):(BETA1.ROI_Y+BETA1.ROI_YNP-BETA1.Y_RTCL_CTR) );
BETA2.xx = 1e-3*BETA2.RESOLUTION * ( (BETA2.ROI_X-BETA2.X_RTCL_CTR+1):(BETA2.ROI_X+BETA2.ROI_XNP-BETA2.X_RTCL_CTR) );
BETA2.yy = sqrt(2) * 1e-3*BETA2.RESOLUTION * ( (BETA2.ROI_Y-BETA2.Y_RTCL_CTR+1):(BETA2.ROI_Y+BETA2.ROI_YNP-BETA2.Y_RTCL_CTR) );


B5D36 = getB5D36(E200_state);
QS = getQS(E200_state);

%%  Get first maximum used to center the picking

if do_max_pick
    [BETAL.img, ~, BETAL.pid] = E200_readImages([prefix scan_info(1).BETAL]);
    BETAL.img = double(BETAL.img);
    for k=1:size(BETAL.img,3); BETAL.img(:,:,k) = BETAL.img(:,:,k) - cam_back.BETAL.img(:,:); end;

    [BETA1.img, ~, BETA1.pid] = E200_readImages([prefix scan_info(1).BETA1]);
    BETA1.img = double(BETA1.img);
    for k=1:size(BETA1.img,3); BETA1.img(:,:,k) = BETA1.img(:,:,k) - cam_back.BETA1.img(:,:); end;

    [BETA2.img, ~, BETA2.pid] = E200_readImages([prefix scan_info(1).BETA2]);
    BETA2.img = double(BETA2.img);
    for k=1:size(BETA2.img,3); BETA2.img(:,:,k) = BETA2.img(:,:,k) - cam_back.BETA2.img(:,:); end;

    [BETAL.img2, BETAL.ana.img, BETAL.ana.GAMMA_YIELD, BETAL.ana.GAMMA_MAX, BETAL.ana.GAMMA_DIV] = Ana_BETAL_img(BETAL.xx, BETAL.yy, BETAL.img(:,:,1));
    [BETA1.img2, BETA1.ana.img, BETA1.ana.GAMMA_YIELD, BETA1.ana.GAMMA_MAX, BETA1.ana.GAMMA_DIV,BETA1.ana.xx,BETA1.ana.yy] = Ana_BETA1_img(BETA1.xx, BETA1.yy, BETA1.img(:,:,1));
    [BETA2.img2, BETA2.ana.img, BETA2.ana.GAMMA_YIELD, BETA2.ana.GAMMA_MAX, BETA2.ana.GAMMA_DIV] = Ana_BETA2_img(BETA2.xx, BETA2.yy, BETA2.img(:,:,1));

    BETAL.ana.i_max = get_beta_max(filter2(ones(5)/5^2,BETAL.img2), BETAL.xx, BETAL.yy);
else
     BETAL.ana.i_max=[-0.75,12.13];
end

BETA1.ana.i_max(1)= BETAL.ana.i_max(1) +20.2906; BETA1.ana.i_max(2)= BETAL.ana.i_max(2) + 1.5526;
BETA2.ana.i_max(1)= BETA1.ana.i_max(1) -11.2836; BETA2.ana.i_max(2)= BETA1.ana.i_max(2) -3.5933;

%% figure preparation

fig1 = figure(1);
    clf(fig1)
    set(fig1, 'position', [500, 100, 1100, 900]);
    set(fig1, 'PaperPosition', [0.25, 0.25, 30, 30]);
    set(fig1, 'color', 'w');

    if do_plot
 fig2 = figure(2);
    clf(fig2)
    set(fig2, 'position', [500, 100, 1100, 900]);
    set(fig2, 'PaperPosition', [0.25, 0.25, 30, 30]);
    set(fig2, 'color', 'w');
    end
    
    
  %% Shot selection
clear I J Ind;
if do_shot_pick;
       if strcmp(data_set, 'E200_10567')
        I(1:3)=2; I(4:19)=3; I(20:32)=4; I(33:42)=5; I(43:45)=6;
        J=[18,19,20, 2:6, 8:12, 14:18, 20, 1:5, 10:14,16:18, 1,2,5,8,11,14:17,19,3,4,19]; 
       else
         error('No preselection entered');
       end
else
    for k=1:n_step
        I(1+(k-1)*n_shot:k*n_shot)=k;
        J(1+(k-1)*n_shot:k*n_shot)=[1:n_shot];
    end
end

Ind(1,:)=I; Ind(2,:)=J;

%% Initialize processed scalars
clear processed;
processed.scalars.GAMMA_MAX = zeros(n_step, n_shot);
processed.scalars.GAMMA_YIELD = zeros(n_step, n_shot);
processed.scalars.GAMMA_DIV = zeros(n_step, n_shot);
processed.scalars.ENERGY_FIT = zeros(n_step, n_shot);
processed.scalars.ENERGY_FIT_RMS =zeros(n_step,n_shot);
processed.scalars.ENERGY_FIT_Err_min=zeros(n_step,n_shot);
processed.scalars.ENERGT_FIT_Err_max=zeros(n_step,n_shot);
%% Loop on the different shots
 
     for l=l0:size(J,2)
      
  i=I(l); j=J(l);

  
  if(l==l0 || I(l) ~= I(l-1))
      
[BETAL.img, ~, BETAL.pid] = E200_readImages([prefix scan_info(i).BETAL]);
BETAL.img = double(BETAL.img);
for k=1:size(BETAL.img,3); BETAL.img(:,:,k) = BETAL.img(:,:,k) - cam_back.BETAL.img(:,:); end;
[BETA1.img, ~, BETA1.pid] = E200_readImages([prefix scan_info(i).BETA1]);
BETA1.img = double(BETA1.img);
for k=1:size(BETA1.img,3); BETA1.img(:,:,k) = BETA1.img(:,:,k) - cam_back.BETA1.img(:,:); end;
[BETA2.img, ~, BETA2.pid] = E200_readImages([prefix scan_info(i).BETA2]);
BETA2.img = double(BETA2.img);
for k=1:size(BETA2.img,3); BETA2.img(:,:,k) = BETA2.img(:,:,k) - cam_back.BETA2.img(:,:); end;
  end
  
[BETAL.img2, BETAL.ana.img, BETAL.ana.GAMMA_YIELD, BETAL.ana.GAMMA_MAX, BETAL.ana.GAMMA_DIV] = Ana_BETAL_img(BETAL.xx, BETAL.yy, BETAL.img(:,:,j));
[BETA1.img2, BETA1.ana.img, BETA1.ana.GAMMA_YIELD, BETA1.ana.GAMMA_MAX, BETA1.ana.GAMMA_DIV,BETA1.ana.xx,BETA1.ana.yy] = Ana_BETA1_img(BETA1.xx, BETA1.yy, BETA1.img(:,:,j));
[BETA2.img2, BETA2.ana.img, BETA2.ana.GAMMA_YIELD, BETA2.ana.GAMMA_MAX, BETA2.ana.GAMMA_DIV] = Ana_BETA2_img(BETA2.xx, BETA2.yy, BETA2.img(:,:,j));


[S_BETAL, BETAL.pick.img] = Gamma_eval(BETAL.img2, BETAL.xx, BETAL.yy, BETAL.ana.i_max,1);
[S_BETA1, BETA1.pick.img] = Gamma_eval(BETA1.img2, BETA1.ana.xx, BETA1.ana.yy, BETA1.ana.i_max,1);
[S_BETA2, BETA2.pick.img] = Gamma_eval(BETA2.img2, BETA2.xx, BETA2.yy, BETA2.ana.i_max,1);

    processed.scalars.GAMMA_MAX(I(l),J(l)) = BETAL.ana.GAMMA_MAX;
    processed.scalars.GAMMA_YIELD(I(l),J(l)) = BETAL.ana.GAMMA_YIELD;
    processed.scalars.GAMMA_DIV(I(l),J(l)) = BETAL.ana.GAMMA_DIV;

%% Fit attempt on a selection of filters %%

if do_fit==1 
            
           pick= [1:2 4:14]; 
           
           [ec_fit, d_min]=fminsearch(@(z) energy_fit(z, S_BETA1,S_BETA2, S_BETAL,Synchro_ref, Lanex_ref, Nist_ref, pick, K_B1L, K_B2L), 1);
           processed.scalars.ENERGY_FIT(I(l),J(l))=ec_fit;
           processed.scalars.ENERGY_FIT_RMS(I(l),J(l))=d_min;
           K_B1Lf= interp1(y, K_B1L(1:size(y,2)), ec_fit);
           K_B2Lf= interp1(y, K_B2L(1:size(y,2)), ec_fit); 
           err_fit= 1.2 *d_min;

end
 
%% Energy scan to calculate the Residual

for ec=ec0:size(y,2)

    if ~do_fit 
            K_B1Lf=0.82;
            K_B2Lf=0.97;
    end
    
            K_B21f= K_B2Lf./K_B1Lf;
            S_ratio1L=K_B1Lf*S_BETA1./S_BETAL;
            S_ratio2L=K_B2Lf*S_BETA2./S_BETAL;
            S_ratio21=K_B21f*S_BETA2./S_BETA1;
            S_ratio_tot(1,1:7)=S_ratio1L(:,:);
            S_ratio_tot(1,8:14)=S_ratio2L(:,:);
            S_ratio_tot(1,15:21)=S_ratio21(:,:);
        
Err_1L(ec,1:7)=100*(S_ratio1L(:,:) - S_num(ec,1:7))./S_ratio1L(:,:);   
Err_2L(ec,1:7)=100*(S_ratio2L(:,:) - S_num(ec,8:14))./S_ratio2L(:,:);
Err_21(ec,1:7)=100*(S_ratio21(:,:) - S_num(ec,15:21))./S_ratio21(:,:);

%%Display raw difference instead%%
% Err_1L=S_ratio1L(:,:) - S_num(ec,1:7)
% Err_2L=S_ratio2L(:,:) - S_num(ec,8:14)
% Err_21=S_ratio21(:,:) - S_num(ec,15:21)

if do_plot;
Err(ec) = Gamma_num(y(ec), 50, Synchro_ref, Lanex_ref, Nist_ref, S_ratio_tot, pick,1);
end;
%%


   if ec==ec0 && l==l0
       
 figure(1)
 
 h_text = axes('Position', [0.17, 0.95, 0.3, 0.035], 'Visible', 'off');
        if is_scan; STEP = text(0., 1., [char(regexprep(scan_info(i).Control_PV_name, '_', '\\_')) ' = ' num2str(scan_info(i).Control_PV)], 'fontsize', 20); end;
                    SHOT = text(0., 0., ['Shot #' num2str(j)], 'fontsize', 20);

 h_text2 = axes('Position', [0.58, 0.95, 0.2, 0.05], 'Visible', 'off');
        if is_qs_scan; B5D36_text = text(0., 0., ['B5D36 = ' num2str(B5D36, '%.2f') ' GeV'], 'fontsize', 20); end;
        if ~is_qs_scan && ~is_qsbend_scan; 
            QS_text = text(1., 0., ['QS = ' num2str(QS, '%.0f') ' GeV'], 'fontsize', 20);
            B5D36_text = text(0., 0., ['B5D36 = ' num2str(B5D36, '%.2f') ' GeV'], 'fontsize', 20);
        end;
        if ~do_fit     Ec_text=text(0.,0.5, ['Ec = ' num2str(y(ec))],'fontsize', 20); end;
        if do_fit;     Ec_fit_text=text(0., 0.5, ['Ec fit = ' num2str(ec_fit)], 'fontsize', 20); end;
     
if do_plot        
 figure(2)
 
     h_text = axes('Position', [0.17, 0.95, 0.3, 0.035], 'Visible', 'off');
             if do_fit;    Pick_text =text(0., 0.75, ['Pick = [' num2str(pick) ']'], 'fontsize', 16); end;

     h_text2 = axes('Position', [0.52, 0.9, 0.2, 0.05], 'Visible', 'off');
             if do_fit;     Ec_fit_text2=text(0.8, 0.8, ['Ec fit = ' num2str(ec_fit)], 'fontsize', 20); end; 
            
     end

%% Figure settings 
   figure(1)
   ax_betal = axes('position', [0.05, 0.64, 0.28, 0.25]);
        image(BETAL.xx,BETAL.yy,BETAL.pick.img,'CDataMapping','scaled');
        colormap(cmap.wbgyr);
        fig_betal = get(gca,'Children');
        daspect([1 1 1]);
        axis xy;
        if BETAL.ana.GAMMA_MAX > BETAL_caxis(1)
            caxis([BETAL_caxis(1) BETAL.ana.GAMMA_MAX]);
        else
            caxis(BETAL_caxis);
        end
        colorbar();
        xlabel('x (mm)'); ylabel('y (mm)');
        title('BETAL');

  ax_beta1 = axes('position', [0.35, 0.64, 0.33, 0.25]);
        image(BETA1.ana.xx,BETA1.ana.yy,BETA1.pick.img,'CDataMapping','scaled');
        colormap(cmap.wbgyr);
        fig_beta1 = get(gca,'Children');
        daspect([1 1 1]);
        axis xy;
        if BETA1.ana.GAMMA_MAX > BETA1_caxis(1)
            caxis([BETA1_caxis(1) BETA1.ana.GAMMA_MAX]);
        else
            caxis(BETAL_caxis);
        end
        colorbar();
        title('BETA1');
               
  ax_beta2 = axes('position', [0.70, 0.64, 0.28, 0.25]);
        image(BETA2.xx,BETA2.yy,BETA2.pick.img,'CDataMapping','scaled');
        colormap(cmap.wbgyr);
        fig_beta2 = get(gca,'Children');
        daspect([1 1 1]);
        axis xy;
        if BETA2.ana.GAMMA_MAX > BETA2_caxis(1)
            caxis([BETA2_caxis(1) BETA2.ana.GAMMA_MAX]);
        else
            caxis(BETA2_caxis);
        end
        colorbar();
        title('BETA2');
        
 %%
 
 ax_S_ratio1L = axes ('position', [0.02, 0.32, 0.29, 0.25]);
        bar( S_ratio1L, 'b');
        fig_S_ratio1L = get(gca, 'Children');
        name= {'Cu 1' ; 'Cu 3' ; 'Cu 10' ; 'W 3' ;'W 1' ; 'Cu 0.3'; 'No filter'};
        set(gca, 'xticklabel', name);
        title('S BETA1/S BETAL');
              
ax_S_ratio2L = axes('position', [0.37, 0.32, 0.29, 0.25]);
        bar(S_ratio2L, 'b');
        fig_S_ratio2L= get(gca, 'Children');
        %name= {'Cu 1' ; 'Cu 3' ; 'Cu 10' ; 'W 3' ;'W 1' ; 'Cu 0.3'; 'No filter'};
        set(gca, 'xticklabel', name);
        title('S BETA2/S BETAL');
        
 
 ax_S_ratio21 = axes('position', [0.7, 0.32, 0.29, 0.25]);
        bar( S_ratio21, 'b');
        fig_S_ratio21 = get(gca, 'Children');
       % name= {'Cu 1' ; 'Cu 3' ; 'Cu 10' ; 'W 3' ;'W 1' ; 'Cu 0.3'; 'No filter'};
        set(gca, 'xticklabel', name);
        title('S BETA2/S BETA1');
        
 %%
  
 ax_fit_err1L = axes ('position', [0.02, 0.02, 0.29, 0.23]);
        fig_fit_err1L=bar(Err_1L(ec,:),'b');
        fig_fit_err1L=get(gca, 'Children');
        set(gca, 'xticklabel', name); 
        title('%Err 1L');

 ax_fit_err2L = axes ('position', [0.37, 0.02, 0.29, 0.23]);
        bar(Err_2L(ec,:),'b');
        fig_fit_err2L=get(gca, 'Children');
        set(gca, 'xticklabel', name); 
        title('%Err 2L');

ax_fit_err21 = axes ('position', [0.7, 0.02, 0.29, 0.23]);
        bar(Err_21(ec,:),'b');
        fig_fit_err21=get(gca, 'Children');
        set(gca, 'xticklabel', name); 
        title('%Err 21');    

if do_plot
figure(2) 

ax_fit_Err = axes('position', [0.2, 0.2, 0.7, 0.7]);
        plot(y, Err);
        fig_fit_Err= get(gca, 'Children');
        title('Energy scan'); 
        xlabel('Critical Energy'); ylabel('rms(Res)');
      end  
        
    else
%%  Figure update
    
       if ec==ec0 && l~=l0
            figure(1);
            if is_scan; set(STEP, 'String', [char(regexprep(scan_info(i).Control_PV_name, '_', '\\_')) ' = ' num2str(scan_info(i).Control_PV)]); end;
            set(SHOT, 'String', ['Shot #' num2str(j)]);

             set(fig_betal,'CData',BETAL.pick.img);
             if BETAL.ana.GAMMA_MAX > BETAL_caxis(1)
                set(ax_betal, 'CLim', [BETAL_caxis(1) BETAL.ana.GAMMA_MAX]);
            else
              set(ax_betal, 'CLim', BETAL_caxis);
             end


             set(fig_beta1,'CData',BETA1.pick.img);
             if BETA1.ana.GAMMA_MAX > BETA1_caxis(1)
                set(ax_beta1, 'CLim', [BETA1_caxis(1) BETA1.ana.GAMMA_MAX]);
            else
              set(ax_beta1, 'CLim', BETAL_caxis);
             end

             set(fig_beta2,'CData',BETA2.pick.img);
            if BETA2.ana.GAMMA_MAX > BETA2_caxis(1)
                set(ax_beta2, 'CLim', [BETA2_caxis(1) BETA2.ana.GAMMA_MAX]);
            else
                set(ax_beta2, 'CLim', BETA2_caxis);
            end

            set(fig_S_ratio2L,'YData',S_ratio2L);
            set(fig_S_ratio1L, 'YData', S_ratio1L);
            set(fig_S_ratio21, 'YData', S_ratio21);
       
            if do_fit;        set(Ec_fit_text, 'string', ['Critical Energy = ' num2str(ec_fit)]); end
       end
       
          if ~do_fit;        set(fig_fit_err1L, 'YData', Err_1L(ec))
                             set(fig_fit_err2L, 'YData', Err_2L(ec))
                             set(fig_fit_err21, 'YData', Err_21(ec)) 
                             set(Ec_text, 'string', ['Ec = ' num2str(y(ec))]) ; 
          end
          
          if do_plot      figure(2);
                          set(fig_fit_Err,'YData', Err); end;
                      
   end
end


%%  Error bars 
    if do_plot;
            x=y(1):0.1:y(size(y,2));
            err1x=1; 
            err2x=0;
            scan_plot=interp1(y,Err,x);
            for k=1:size(x,2)
                if scan_plot(k)>err_fit
                err1x=err1x +1; 
                end
                err2x=err2x +1;
                if (x(k)>ec_fit) && (scan_plot(k)>err_fit)
                    break;
                end
            end
            err(1)=x(err1x);
            err(2)=x(err2x);
            processed.scalars.ENERGY_FIT_Err_min(I(l),J(l))=err(1);
            processed.scalars.ENERGY_FIT_Err_max(I(l),J(l))=err(2);

            
             if l==l0   
                        figure(2);
                        y1=line([1 y(size(y,2))], [d_min d_min]);
                        x_err1=line([err(1) err(1)], [0 Err(1)]);
                        x_err2=line([err(2) err(2)], [0 Err(1)]);
                        y2=line([1 y(size(y,2))], [1.1*d_min 1.1*d_min]);
                        
                        h_text3 = axes('Position', [0.48, 0.9, 0.2, 0.05], 'Visible', 'off');
                         if do_fit;     Ec_fit_m_text=text(0.7, 0.2, ['10% Margin = [' num2str(err(1)) ' ; ' num2str(err(2)) ']'] , 'fontsize', 16); end;
             else
                       set(y1, 'YData', [d_min d_min]);
                       set(x_err1, 'XData', [err(1) err(1)]);
                       set(x_err2, 'XData', [err(2) err(2)]);
                       set(y2, 'Ydata', [1.1*d_min 1.1*d_min]);
                       
                       set(Ec_fit_m_text,'string',['10% Margin = [' num2str(err(1)) ' ; ' num2str(err(2)) ']'] );
             end; 
     end;
%% In case of fit, displays the relative error bars at the fitted critical energy 

        if do_fit
            figure(1)
            set(fig_fit_err1L, 'YData', interp1(y,Err_1L,ec_fit));
            set(fig_fit_err2L, 'YData', interp1(y,Err_2L,ec_fit));
            set(fig_fit_err21, 'YData', interp1(y,Err_21,ec_fit)); 
        
        end


%% Saving
    if do_save_1;
  
         filename1 = ['frame_' num2str(i, '%.2d') '_' num2str(j, '%.3d') '_' num2str(ec_fit) '_pick.png' ];
          print('-f1', [save_path data_set '/frames/' filename1], '-dpng', '-r100'); end; 

    if  do_save_2; 
        filename2 = ['frame_' num2str(i, '%.2d') '_' num2str(j, '%.3d') '_' num2str(ec_fit) '_fit.png' ];
         print('-f2', [save_path data_set '/frames/' filename2], '-dpng', '-r100');
          end


  end

