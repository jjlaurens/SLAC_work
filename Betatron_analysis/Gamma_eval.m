function [ S,  processed_img ] = Gamma_eval( img , xx, yy, i_max, K)

%% Function that evaluates the betatron signal on the different filters
%%% - "img" is the pre-analyzed camera image
%%% - "xx" and "yy" are the associated x and y axes
%%% - "i_max" is the position of the center around which the pick is made
%%% - "K" is the radius parameter. By default, 1 is expected. Change this
%%%   if you want to change the distance between the points and the center
%%% - [S] is a matrix containing the evaluated value of the betatron signal on each
%%%   filter.
%%% - [processed_img] is the camera image where the points used to evaluate
%%%   the signal were replaced by zero in order to display the pick
%%%
%%%   All positions are in mm

%%

 
t_corr=[0,-0.5];    %Used to adjust the pick
S=zeros(1,7);
processed_img = filter2(ones(5)/5^2, img);
T=zeros(800,800);


[X, Y] = meshgrid(xx, yy);

%%

%% 1
pick_center(1,1) = i_max(1) - 13.5;
pick_center(1,2) = i_max(2) - 6.75;
mask_lower_left = K*([pick_center(1,1)-1, pick_center(1,2)-1] + t_corr); 
mask_upper_right = K*([pick_center(1,1)+1, pick_center(1,2)+1] + t_corr); 
n(:,1)=size(processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2)),1);
T(1:n(1),1)= processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2));
processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2)) = 0;


%% 2
pick_center(2,1) = i_max(1) - 13.5;
pick_center(2,2) = i_max(2) + 6.75;
mask_lower_left = K*([pick_center(2,1)-1, pick_center(2,2)-1] + t_corr); 
mask_upper_right = K*([pick_center(2,1)+1, pick_center(2,2)+1] + t_corr);n(:,2)=size(processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2)),1);
T(1:n(2),2)= processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2));
processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2)) = 0;

%% 3
pick_center(3,1) = i_max(1) - 6.75;
pick_center(3,2) = i_max(2) + 13.5;
mask_lower_left = K*([pick_center(3,1)-1, pick_center(3,2)-1] + t_corr); 
mask_upper_right = K*([pick_center(3,1)+1, pick_center(3,2)+1] + t_corr);
n(:,3)=size(processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2)),1);
T(1:n(3),3)= processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2));
processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2)) = 0;

%% 4
pick_center(4,1) = i_max(1) + 6.75;
pick_center(4,2) = i_max(2) + 13.5;
mask_lower_left = K*([pick_center(4,1)-1, pick_center(4,2)-1] + t_corr); 
mask_upper_right = K*([pick_center(4,1)+1, pick_center(4,2)+1] + t_corr); 
n(:,4)=size(processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2)),1);
T(1:n(4),4)= processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2));
processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2)) = 0;

%% 5
pick_center(5,1) = i_max(1) + 13.5;
pick_center(5,2) = i_max(2) + 6.75;
mask_lower_left = K*([pick_center(5,1)-1, pick_center(5,2)-1] + t_corr); 
mask_upper_right = K*([pick_center(5,1)+1, pick_center(5,2)+1] + t_corr); 
n(:,5)=size(processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2)),1);
T(1:n(5),5)= processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2));
processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2)) = 0;

%% 6
pick_center(6,1) = i_max(1) + 13.5;
pick_center(6,2) = i_max(2) - 6.75;
mask_lower_left = K*([pick_center(6,1)-1, pick_center(6,2)-1] + t_corr); 
mask_upper_right = K*([pick_center(6,1)+1, pick_center(6,2)+1] + t_corr);
n(:,6)=size(processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2)),1);
T(1:n(6),6)= processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2));
processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2)) = 0;

%% 7 is made using the mean of two areas 
pick_center(7,1) = i_max(1) + 6.75;
pick_center(7,2) = i_max(2) - 13.5;
mask_lower_left = K*([pick_center(7,1)-1, pick_center(7,2)-1] + t_corr); 
mask_upper_right = K*([pick_center(7,1)+1, pick_center(7,2)+1] + t_corr);
n(:,7)=size(processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2)),1);
T(1:n(7),7)= processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2));
processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2)) = 0;

pick_center(8,1) = i_max(1) - 6.75;
pick_center(8,2) = i_max(2) - 13.5;
mask_lower_left = K*([pick_center(8,1)-1, pick_center(8,2)-1] + t_corr); 
mask_upper_right = K*([pick_center(8,1)+1, pick_center(8,2)+1] + t_corr);
n(:,8)=size(processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2)),1);
tmp=zeros(800,1);
tmp(1:n(8))=(processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2)));

T(1:max(n(7),n(8)),7)= (T(1:max(n(7),n(8)),7) + tmp(1:max(n(7),n(8))))/2;
processed_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
   Y>mask_lower_left(2) & Y<mask_upper_right(2)) = 0;


%%

for i=1:7
gamma_pick (1,i)= sum(sum(T(:,i)));
S(1,i)= gamma_pick (1,i) / n(i) ;
end
 clear T; 

end