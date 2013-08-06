function [output_img, filt_img, gamma_yield, gamma_max, gamma_div] = Ana_BETA2_img(xx, yy, img)

%%Function based on Ana_BETAL. 


output_img = flipud(img);

[X, Y] = meshgrid(xx, yy);
img((X-3).^2 + (Y-8).^2 > 45^2) = 0;
img(X > 36) = 0;
img(Y > 25) = 0;


mask_lower_left = [-3, -11]; % position in mm
mask_upper_right = [18, 0]; % position in mm
img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2)) = 0;

gamma_yield = sum(img(:));
filt_img = filter2(ones(5)/5^2, img);
gamma_max = max(filt_img(:));
tmp = filt_img>gamma_max/2.;
gamma_div = 2*sqrt( sum(tmp(:))*(xx(2)-xx(1))*(yy(2)-yy(1))/pi );

filt_img = flipud(filt_img);

end
