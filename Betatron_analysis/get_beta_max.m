function [ i_max] = get_beta_max(filt_img, xx , yy)
%% This function is used to find the position of the maximum of the radiation signal on a camera
%%% -"filt_img" expects a pre-filtered image of the camera whose maximum is
%%% to be determined. In the default code, the filter used is filter2(ones(5)/5^2,img)
%%% -"xx" and "yy" are respectively the x and y axis of the considered
%%% camera
%%% -[i_max] is the position of the maximum

%%% This is designed as a recursive function that searches for the maximum
%%% of the Bremsstrahlung radiation. In theory, it should coincide with the
%%% center of the radiation beam. To exclude local peaks, it is designed as
%%% a recursive function that checks if the are surrounding the found
%%% maximum is coherent with what should be the beam center. 




B = zeros(5);

[tmp,tmp1] = max(filt_img);
[gamma_max,i_max2] = max(tmp);
i_max1= tmp1(1,i_max2); 
clear tmp;
clear tmp1; 
A= 9*gamma_max/10 * ones(5); 


B(1,1)= filt_img(i_max1 -2, i_max2 -2);
B(1,2)= filt_img(i_max1 -2, i_max2 -1);
B(1,3)= filt_img(i_max1 -2, i_max2 );
B(1,4)= filt_img(i_max1 -2, i_max2 +1 );
B(1,5)= filt_img(i_max1 -2, i_max2 +2 );

B(2,1)= filt_img(i_max1 -1, i_max2 -2);
B(2,2)= filt_img(i_max1 -1, i_max2 -1);
B(2,3)= filt_img(i_max1 -1, i_max2 );
B(2,4)= filt_img(i_max1 -1, i_max2 +1 );
B(2,5)= filt_img(i_max1 -1, i_max2 +2 );

B(3,1)= filt_img(i_max1 , i_max2 -2);
B(3,2)= filt_img(i_max1 , i_max2 -1);
B(3,3)= filt_img(i_max1 , i_max2 );
B(3,4)= filt_img(i_max1 , i_max2 +1 );
B(3,5)= filt_img(i_max1 , i_max2 +2 );

B(4,1)= filt_img(i_max1 +1, i_max2 -2);
B(4,2)= filt_img(i_max1 +1, i_max2 -1);
B(4,3)= filt_img(i_max1 +1, i_max2 );
B(4,4)= filt_img(i_max1 +1, i_max2 +1 );
B(4,5)= filt_img(i_max1 +1, i_max2 +2 );

B(5,1)= filt_img(i_max1 +2, i_max2 -2);
B(5,2)= filt_img(i_max1 +2, i_max2 -1);
B(5,3)= filt_img(i_max1 +2, i_max2 );
B(5,4)= filt_img(i_max1 +2, i_max2 +1 );
B(5,5)= filt_img(i_max1 +2, i_max2 +2 );
 
if( B > A)
    
        i_max(1,1)=xx(1,i_max2);
        i_max(1,2)=yy(1,i_max1);

      
else 
    filt_img(i_max1, i_max2) = 0;
    i_max = get_beta_max(filt_img, xx, yy);
end
 

end

