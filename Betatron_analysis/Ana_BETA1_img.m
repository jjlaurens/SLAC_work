function [output_img, filt_img, gamma_yield, gamma_max, gamma_div,xx_ana,yy_ana] = Ana_BETA1_img(xx, yy, img)
%%
%%%%% Function based on Ana_BETAL.  
%%%%% kx and ky are determined from the re-calibration of BETA1 and are
%%%%% used here for clarity.
%%%%% The resulting image is zoomed to only display the filters.


output_img = flipud(img(220:680, 600:1100));

kx = 0.574;  % recalibration of BETA1;
ky = 0.3752;
%%
[X, Y] = meshgrid(xx, yy);
img((X-kx*3).^2 + (Y-ky*8).^2 > (kx*110)^2) = 0;
img(X > kx * 88) = 0;
img(Y > ky * 61) = 0;
  

mask_lower_left = [kx*20, ky* -45]; % position in mm
mask_upper_right = [kx*54, ky*  -5]; % position in mm
img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
    Y>mask_lower_left(2) & Y<mask_upper_right(2)) = 0;

gamma_yield = sum(img(:));
filt_img = filter2(ones(5)/5^2, img);
gamma_max = max(filt_img(:));
tmp = filt_img>gamma_max/2.;
gamma_div = 2*sqrt( sum(tmp(:))*(xx(2)-xx(1))*(yy(2)-yy(1))/pi );
clear tmp;
filt_img = flipud(filt_img);
%% Zoom

xx_ana = xx(1,600:1100);
yy_ana = yy (1,360:820);

end
