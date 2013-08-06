%% This script calculates S_num, K_B1L and K_B2L. 
%%% Use this to calculate and save those matrices for quicker use in E200_Energy_Scan
%%% 
%%% S_num is the numerical simulation of the signal on each filter for various 
%%% critical energies using the convention S_num(:,1:7) for BETA1/BETAL and
%%% S_num(:,8:14) for BETA2/BETAL. 
%%% 
%%% K_B1L is the ratio of the number of counts per pixel on BETA1 over the
%%% one on BETAL as fit for various critical energies. K_B2L is the same
%%% for BETA2/BETAL. 
%%% These matrices are determined for a pre-selection of good shots on a
%%% dataset and then averaged on all shots to get one mean value for each
%%% critical energy.  

y=logspace(-1,3,200);


%% S_num
for k=1:14
for m=1:48;
    
    S_num(m,k)= Gamma_num(y(m), 300, Synchro_ref, Lanex_ref, Nist_ref, zeros(1,14), k );
end
end

S_num(:,15:21)=S_num(:,8:14)./S_num(:,1:7);


%% Shot selection
%%% Selection made on E200_10567
I(1:3)=2; I(4:19)=3; I(20:32)=4; I(33:42)=5; I(43:45)=6;
J=[18,19,20, 2:6, 8:12, 14:18, 20, 1:5, 10:14,16:18, 1,2,5,8,11,14:17,19,3,4,19];

for l=1:size(J,2)
  i=I(l); j=J(l);
    
  if(l==1 || I(l) ~= I(l-1))
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


[S_BETAL(l,:)] = Gamma_eval(BETAL.img2, BETAL.xx, BETAL.yy, BETAL.ana.i_max,1);
[S_BETA1(l,:)] = Gamma_eval(BETA1.img2, BETA1.ana.xx, BETA1.ana.yy, BETA1.ana.i_max,1);
[S_BETA2(l,:)] = Gamma_eval(BETA2.img2, BETA2.xx, BETA2.yy, BETA2.ana.i_max,1);

end


%% K_B1L
for j=1:size(J,2)
for ec=1:200;
S_B1Lx=S_BETA1./S_BETAL;
S_numx=S_num(:,1:7);
S_B1Lx(:,3)=[]; S_numx(:,3)=[];

fun = @(z) (S_B2Lx(j,:) * z - S_numx(ec,:));

K_B1L(j,ec)=fminsearch(@(z) rms(fun(z)),0.5);
end
end
K_B1L=rms(K_B2L,1);

%% K_B2L
for j=1:size(J,2)
for ec=1:200;
    
S_B2Lx=S_BETA2./S_BETAL; 
S_numx=S_num(:,8:14);
 
fun = @(z) (S_B2Lx(j,:) * z - S_numx(ec,:));

K_B2L(j,ec)=fminsearch(@(z) rms(fun(z)),0.5);
end
end
K_B2L=rms(K_B2L,1);


