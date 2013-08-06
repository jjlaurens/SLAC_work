
% Variation on the E200_ana scan script. Use it to analyze E200 2013 data
% and plot BETAL, BETA1, BETA2, CEGAIN and CELOSS on a single figure. 
% Includes a new calibration of the BETA1 cam compatible with the 20130423 datas 

%%
addpath('C:/Users/Jacques/Desktop/PRE/Matlab/E200_scripts/facet_daq/');
addpath('C:/Users/Jacques/Desktop/PRE/Matlab/E200_scripts/sc_ana/');
addpath('C:/Users/Jacques/Desktop/PRE/Matlab/E200_scripts/tools/');

prefix = 'C:/Users/Jacques/Desktop/PRE/Volumes/PWFA_4big';
day = '20130423';
data_set = 'E200_10585';
do_save = 1;
save_path =['C:/Users/Jacques/Desktop/PRE/Saves/2013_E200_Data_Analysis/' day '/'];


%%

cmap = custom_cmap();

BETAL_caxis = [0 1000];
CEGAIN_caxis = [0.8 3.2];
CELOSS_caxis = [0.8 3.2];
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
        
 %%%%%%%%%% Modified the routine to get the scan informations to make it
 %%%%%%%%%% compatible with older datasets 
    
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
    scan_info = filenames    
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
CEGAIN = cam_back.CEGAIN;
CELOSS = cam_back.CELOSS;
%%

BETAL.X_RTCL_CTR = 700;
BETAL.Y_RTCL_CTR = 500;
BETA1.X_RTCL_CTR = 700;
BETA1.Y_RTCL_CTR = 500;
BETA2.X_RTCL_CTR = 700;
BETA2.Y_RTCL_CTR = 500;
CEGAIN.X_RTCL_CTR = 700;
CEGAIN.Y_RTCL_CTR = 500;
CELOSS.X_RTCL_CTR = 700;
CELOSS.Y_RTCL_CTR = 500;

BETAL.xx = 1e-3*BETAL.RESOLUTION * ( (BETAL.ROI_X-BETAL.X_RTCL_CTR+1):(BETAL.ROI_X+BETAL.ROI_XNP-BETAL.X_RTCL_CTR) );
BETAL.yy = sqrt(2) * 1e-3*BETAL.RESOLUTION * ( (BETAL.ROI_Y-BETAL.Y_RTCL_CTR+1):(BETAL.ROI_Y+BETAL.ROI_YNP-BETAL.Y_RTCL_CTR) );

%%%%%%%% Old BETA1 calibration was inadequate. Those are the new values measured
%%
BETA1.xx = 0.1148 * ( (BETA1.ROI_X-BETA1.X_RTCL_CTR+1):(BETA1.ROI_X+BETA1.ROI_XNP-BETA1.X_RTCL_CTR) );
BETA1.yy = 0.1061 * ( (BETA1.ROI_Y-BETA1.Y_RTCL_CTR+1):(BETA1.ROI_Y+BETA1.ROI_YNP-BETA1.Y_RTCL_CTR) );

BETA2.xx = 1e-3*BETA2.RESOLUTION * ( (BETA2.ROI_X-BETA2.X_RTCL_CTR+1):(BETA2.ROI_X+BETA2.ROI_XNP-BETA2.X_RTCL_CTR) );
BETA2.yy = sqrt(2) * 1e-3*BETA2.RESOLUTION * ( (BETA2.ROI_Y-BETA2.Y_RTCL_CTR+1):(BETA2.ROI_Y+BETA2.ROI_YNP-BETA2.Y_RTCL_CTR) );

CEGAIN.xx = 1e-3*CEGAIN.RESOLUTION * ( (CEGAIN.ROI_X-CEGAIN.X_RTCL_CTR+1):(CEGAIN.ROI_X+CEGAIN.ROI_XNP-CEGAIN.X_RTCL_CTR) );
CEGAIN.yy = 1e-3*CEGAIN.RESOLUTION * ( (CEGAIN.ROI_Y-CEGAIN.Y_RTCL_CTR+1):(CEGAIN.ROI_Y+CEGAIN.ROI_YNP-CEGAIN.Y_RTCL_CTR) );
CELOSS.xx = 1e-3*CELOSS.RESOLUTION * ( (CELOSS.ROI_X-CELOSS.X_RTCL_CTR+1):(CELOSS.ROI_X+CELOSS.ROI_XNP-CELOSS.X_RTCL_CTR) );
CELOSS.yy = 1e-3*CELOSS.RESOLUTION * ( (CELOSS.ROI_Y-CELOSS.Y_RTCL_CTR+1):(CELOSS.ROI_Y+CELOSS.ROI_YNP-CELOSS.Y_RTCL_CTR) );

clear processed;
processed.scalars.GAMMA_MAX = zeros(n_step, n_shot);
processed.scalars.GAMMA_YIELD = zeros(n_step, n_shot);
processed.scalars.GAMMA_DIV = zeros(n_step, n_shot);
processed.scalars.E_ACC = zeros(n_step, n_shot);
processed.scalars.E_DECC = zeros(n_step, n_shot);
processed.scalars.E_UNAFFECTED = zeros(n_step, n_shot);
processed.scalars.E_UNAFFECTED2 = zeros(n_step, n_shot);
processed.scalars.E_EMIN = zeros(n_step, n_shot);
processed.scalars.E_EMIN_ind = zeros(n_step, n_shot);
processed.scalars.E_EMAX = zeros(n_step, n_shot);
processed.scalars.E_EMAX2 = zeros(n_step, n_shot);
processed.scalars.E_EMAX3 = zeros(n_step, n_shot);
processed.scalars.E_EMAX_ind = zeros(n_step, n_shot);
processed.scalars.E_EMAX2_ind = zeros(n_step, n_shot);
processed.scalars.E_EMAX3_ind = zeros(n_step, n_shot);
processed.scalars.PYRO = zeros(n_step, n_shot);
processed.scalars.EX_CHARGE = zeros(n_step, n_shot);

clear waterfall;
waterfall.CEGAIN = zeros(1392, n_shot, n_step);
waterfall.CEGAIN2 = zeros(1392, n_shot, n_step);
waterfall.CELOSS = zeros(1392, n_shot, n_step);

B5D36 = getB5D36(E200_state);
QS = getQS(E200_state);
E_EGAIN = E200_cher_get_E_axis('20130423', 'CEGAIN', 0, 1:1392, 0, B5D36);
E_ELOSS = E200_cher_get_E_axis('20130423', 'CELOSS', 0, 1:1392, 0, B5D36);

%%

fig = figure(1);
set(fig, 'position', [500, 100, 1000, 900]);
set(fig, 'PaperPosition', [0.25, 0.25, 25, 25]);
set(fig, 'color', 'w');
clf();


for i=1:n_step
data = load([path mat_filenames{i}]);
if is_qsbend_scan; B5D36 = 20.35 + scan_info(i).Control_PV; end;

[BETAL.img, ~, BETAL.pid] = E200_readImages([prefix scan_info(i).BETAL]);
[BETA1.img, ~, BETA1.pid] = E200_readImages([prefix scan_info(i).BETA1]);
[BETA2.img, ~, BETA2.pid] = E200_readImages([prefix scan_info(i).BETA2]);
[CEGAIN.img, ~, CEGAIN.pid] = E200_readImages([prefix scan_info(i).CEGAIN]);
[CELOSS.img, ~, CELOSS.pid] = E200_readImages([prefix scan_info(i).CELOSS]);

BETAL.img = double(BETAL.img);
BETA1.img = double(BETA1.img);
BETA2.img = double(BETA2.img);
CEGAIN.img = double(CEGAIN.img);
CELOSS.img = double(CELOSS.img);

for j=1:size(BETAL.img,3); BETAL.img(:,:,j) = BETAL.img(:,:,j) - cam_back.BETAL.img(:,:); end;
for j=1:size(BETA1.img,3); BETA1.img(:,:,j) = BETA1.img(:,:,j) - cam_back.BETA1.img(:,:); end;
for j=1:size(BETA2.img,3); BETA2.img(:,:,j) = BETA2.img(:,:,j) - cam_back.BETA2.img(:,:); end;
for j=1:size(CEGAIN.img,3); CEGAIN.img(:,:,j) = CEGAIN.img(:,:,j) - cam_back.CEGAIN.img(:,:); end;
for j=1:size(CELOSS.img,3); CELOSS.img(:,:,j) = CELOSS.img(:,:,j) - cam_back.CELOSS.img(:,:); end;

pid = [data.epics_data.PATT_SYS1_1_PULSEID];
[C, IA, IB] = intersect(BETAL.pid, pid', 'stable');

if( day> 20130423)
    USTORO = E200_state.SIOC_SYS1_ML01_AO028 + E200_state.SIOC_SYS1_ML01_AO027*[data.epics_data.GADC0_LI20_EX01_AI_CH2_];
    DSTORO = E200_state.SIOC_SYS1_ML01_AO030 + E200_state.SIOC_SYS1_ML01_AO029*[data.epics_data.GADC0_LI20_EX01_AI_CH3_];
    processed.scalars.EX_CHARGE(i,:) = 1.6e-7*(DSTORO(IB) - USTORO(IB));
end

PYRO = [data.epics_data.BLEN_LI20_3014_BRAW];
processed.scalars.PYRO(i,:) = PYRO(IB);

for j=1:n_shot
    fprintf('\n%d \t %d \t %d\n', BETAL.pid(j), BETA1.pid(j), BETA2.pid(j), CEGAIN.pid(j), CELOSS.pid(j));
    
    [BETAL.img2, BETAL.ana.img, BETAL.ana.GAMMA_YIELD, BETAL.ana.GAMMA_MAX, BETAL.ana.GAMMA_DIV] = Ana_BETAL_img(BETAL.xx, BETAL.yy, BETAL.img(:,:,j));
    [BETA1.img2, BETA1.ana.img, BETA1.ana.GAMMA_YIELD, BETA1.ana.GAMMA_MAX, BETA1.ana.GAMMA_DIV, BETA1.ana.xx, BETA1.ana.yy] = Ana_BETA1_img(BETA1.xx, BETA1.yy, BETA1.img(:,:,j));
    [BETA2.img2, BETA2.ana.img, BETA2.ana.GAMMA_YIELD, BETA2.ana.GAMMA_MAX, BETA2.ana.GAMMA_DIV] = Ana_BETA2_img(BETA2.xx, BETA2.yy, BETA2.img(:,:,j));
    [CEGAIN.ana, CEGAIN.ana.img] = Ana_CEGAIN_img(E_EGAIN, CEGAIN.img(:,:,j));
    CELOSS.ana = Ana_CELOSS_img(E_ELOSS, CELOSS.img(:,:,j));
    
    processed.scalars.GAMMA_MAX(i,j) = BETAL.ana.GAMMA_MAX;
    processed.scalars.GAMMA_YIELD(i,j) = BETAL.ana.GAMMA_YIELD;
    processed.scalars.GAMMA_DIV(i,j) = BETAL.ana.GAMMA_DIV;
    processed.scalars.E_ACC(i,j) = CEGAIN.ana.E_ACC;
    processed.scalars.E_UNAFFECTED(i,j) = CEGAIN.ana.E_UNAFFECTED;
    processed.scalars.E_EMAX(i,j) = CEGAIN.ana.E_EMAX;
    processed.scalars.E_EMAX2(i,j) = CEGAIN.ana.E_EMAX2;
    processed.scalars.E_EMAX3(i,j) = CEGAIN.ana.E_EMAX3;
    processed.scalars.E_EMAX_ind(i,j) = CEGAIN.ana.E_EMAX_ind;
    processed.scalars.E_EMAX2_ind(i,j) = CEGAIN.ana.E_EMAX2_ind;
    processed.scalars.E_EMAX3_ind(i,j) = CEGAIN.ana.E_EMAX3_ind;
    processed.scalars.E_DECC(i,j) = CELOSS.ana.E_DECC;
    processed.scalars.E_UNAFFECTED2(i,j) = CELOSS.ana.E_UNAFFECTED2;
    processed.scalars.E_EMIN(i,j) = CELOSS.ana.E_EMIN;
    processed.scalars.E_EMIN_ind(i,j) = CELOSS.ana.E_EMIN_ind;
    processed.vectors.CEGAIN_SPEC = CEGAIN.ana.spec;
    processed.vectors.CEGAIN_SPEC2 = CEGAIN.ana.spec2;
    processed.vectors.CELOSS_SPEC = sum(CELOSS.img(:,:,j),1);
    
    waterfall.CEGAIN(:,j,i) = processed.vectors.CEGAIN_SPEC;
    waterfall.CEGAIN2(:,j,i) = processed.vectors.CEGAIN_SPEC2;
    waterfall.CELOSS(:,j,i) = processed.vectors.CELOSS_SPEC;
    
    CEGAIN.ana.img(CEGAIN.ana.img<1) = 1;
    CEGAIN.img2 = CEGAIN.img(:,:,j);
    CEGAIN.img2(CEGAIN.img2<1) = 1;
    CELOSS.img2 = CELOSS.img(:,:,j);
    CELOSS.img2(CELOSS.img2<1) = 1;
    
    if i==1 && j==1

        h_text = axes('Position', [0.17, 0.95, 0.3, 0.035], 'Visible', 'off');
        if is_scan; STEP = text(0., 1., [char(regexprep(scan_info(i).Control_PV_name, '_', '\\_')) ' = ' num2str(scan_info(i).Control_PV)], 'fontsize', 20); end;
        SHOT = text(0., 0., ['Shot #' num2str(j)], 'fontsize', 20);
        h_text2 = axes('Position', [0.58, 0.95, 0.2, 0.05], 'Visible', 'off');
        if is_qs_scan; B5D36_text = text(0., 0., ['B5D36 = ' num2str(B5D36, '%.2f') ' GeV'], 'fontsize', 20); end;
        if ~is_qs_scan && ~is_qsbend_scan; 
            QS_text = text(0., 0.5, ['QS = ' num2str(QS, '%.0f') ' GeV'], 'fontsize', 20);
            B5D36_text = text(0., 0., ['B5D36 = ' num2str(B5D36, '%.2f') ' GeV'], 'fontsize', 20);
        end;
       

         ax_betal = axes('position', [0.05, 0.5, 0.28, 0.5]);
            image(BETAL.xx,BETAL.yy,BETAL.img2,'CDataMapping','scaled');
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

        ax_beta1 = axes('position', [0.375, 0.5, 0.28, 0.5]);
            image(BETA1.ana.xx,BETA1.ana.yy,BETA1.img2,'CDataMapping','scaled');
            colormap(cmap.wbgyr);
            fig_beta1 = get(gca,'Children');
            daspect([1 1 1]);
            axis xy;
            if BETA1.ana.GAMMA_MAX > BETA1_caxis(1)
                caxis([BETA1_caxis(1) BETA1.ana.GAMMA_MAX]);
            else
                caxis(BETA1_caxis);
            end
            colorbar();
            title('BETA1');

         ax_beta2 = axes('position', [0.70, 0.5, 0.28, 0.50]);
            image(BETA2.xx,BETA2.yy,BETA2.img2,'CDataMapping','scaled');
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


        axes('position', [0.1, 0.05, 0.6, 0.15])
            image(1:1392,CEGAIN.yy,log10(CEGAIN.img2),'CDataMapping','scaled');
            colormap(cmap.wbgyr);
            fig_cegain = get(gca,'Children');
            axis xy;
            caxis(CEGAIN_caxis);
            xlabel('y (mm)'); ylabel('x (mm)'); xlim([49 1392]);
            set(gca, 'XTick', 50:100:1392);
            set(gca, 'XTickLabel', CEGAIN.xx(50:100:1392));
            axesPosition = get(gca, 'Position');
            hNewAxes = axes('Position', axesPosition, 'Color', 'none', 'XAxisLocation', 'top', 'YTick', [], ...
                'Box', 'off','XLim', [49,1392], 'XTick', 50:100:1392, ...
                'XTickLabel', E_EGAIN(50:100:1392));
            xlabel('E (GeV)');
            title('CEGAIN (log scale)');

        axes('position', [0.1, 0.3, 0.6, 0.15])
            image(1:1392,CELOSS.yy,log10(CELOSS.img2),'CDataMapping','scaled');
            colormap(cmap.wbgyr);
            fig_celoss = get(gca,'Children');
            axis xy;
            caxis(CELOSS_caxis);
            xlabel('y (mm)'); ylabel('x (mm)'); xlim([49 1392]);
            set(gca, 'XTick', 50:100:1392);
            set(gca, 'XTickLabel', CELOSS.xx(50:100:1392));
            axesPosition = get(gca, 'Position');
            hNewAxes = axes('Position', axesPosition, 'Color', 'none', 'XAxisLocation', 'top', 'YTick', [], ...
                'Box', 'off','XLim', [49,1392], 'XTick', 50:100:1392, ...
                'XTickLabel', E_ELOSS(50:100:1392));
            xlabel('E (GeV)');
            title('CELOSS (log scale)');

    else
        if is_scan; set(STEP, 'String', [char(regexprep(scan_info(i).Control_PV_name, '_', '\\_')) ' = ' num2str(scan_info(i).Control_PV)]); end;
        set(SHOT, 'String', ['Shot #' num2str(j)]);
        set(fig_betal,'CData',BETAL.img2);
        if BETAL.ana.GAMMA_MAX > BETAL_caxis(1)
            set(ax_betal, 'CLim', [BETAL_caxis(1) BETAL.ana.GAMMA_MAX]);
        else
            set(ax_betal, 'CLim', BETAL_caxis);
        end

         set(fig_beta1,'CData',BETA1.img2);
        if BETA1.ana.GAMMA_MAX > BETA1_caxis(1)
            set(ax_beta1, 'CLim', [BETA1_caxis(1) BETA1.ana.GAMMA_MAX]);
        else
            set(ax_beta1, 'CLim', BETA1_caxis);
        end

          set(fig_beta2,'CData',BETA2.img2);
        if BETA2.ana.GAMMA_MAX > BETA2_caxis(1)
            set(ax_beta2, 'CLim', [BETA2_caxis(1) BETA2.ana.GAMMA_MAX]);
        else
            set(ax_beta2, 'CLim', BETA2_caxis);
        end
        set(fig_cegain,'CData',log10(CEGAIN.img2));
        set(fig_celoss,'CData',log10(CELOSS.img2));
    end
     if do_save
         filename = ['frame_' num2str(i, '%.2d') '_' num2str(j, '%.3d') '.png'];
         print('-f1', [save_path data_set '/frames/' filename], '-dpng', '-r100');
     else
         pause(0.1);
     end
end




end

%% Saving

clear tmp;
if do_save
    if exist([save_path data_set '.mat'], 'file'); tmp = load([save_path data_set]); end;
    tmp.data.user.scorde.processed = processed;
    tmp.data.user.scorde.waterfall = waterfall;
    save([save_path data_set '.mat'], '-struct', 'tmp');
end














