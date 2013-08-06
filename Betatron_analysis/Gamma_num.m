function [d]= Gamma_num(y,n,Synchro_ref, Lanex_ref, Nist_ref,S_tot,pick,do_fit)
%% Simulates the value of the Gamma signal for a given critical energy and returns its difference with a reference 
%%% - "y" is the critical energy 
%%% - "n" is the number of points used to simulate the integration. A minimum of ~50 is needed to get a result that makes sense. 
%%%       It stabilizes around n=100. It is not necessary to go beyond n=150.
%%% - "Synchro_ref" is gotten from get_synchrotron.m
%%% - "Lanex_ref" is gotten from get_lanexresponse.m
%%% - "Nist_ref" is gotten from get_nistdatas.m
%%% - "S_tot" is the reference to which the signal is compared. 
%%% - "pick" is the selection of filters. 1:7 are for BETA1, 8:14 for BETA2
%%%    with the convention 1:7 <-> [Cu1,Cu3,Cu10,W3,W1,Cu0.3,No Filter]
%%% - "do_fit" indicates if the function is used to fit the critical
%%%   energy, in which case the rms of the difference is returned instead.
%%% - [d] is the output difference. It is a 1*14 vector if do_fit=0 and a scalar
%%%   if do_fit=1
%%%
%%% As the values of the used synchrotron function are limited to
%%% synchrotron1(x<15) before becoming almost null, a limiting parameter n1 is
%%% determined to avoid unnecessary calculations
%%
S2=zeros(1,7); SL=zeros(1,7); S1=zeros(1,7);
x=logspace(-2,4,n);

 n1=1;
 while( n1<n && x(n1)<15*y )
     n1=n1+1;
 end
 
%% BETAL 
 
for i=1:n1-1
    SL(1) =  SL(1) + Lanex_response(Lanex_ref,x(i), 'W', 1)* synchrotron1(Synchro_ref, x(i)/y(1))*(x(i+1) - x(i));
end

%% BETA1
if any(pick==1)
    for i=1:n1-1
        S1(1) =  S1(1) +  synchrotron1(Synchro_ref, x(i)/y(1)) * Lanex_response(Lanex_ref,x(i), 'Cu', 1) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
 if any(pick==2)
    for i=1:n1-1
        S1(2) =  S1(2) +  synchrotron1(Synchro_ref, x(i)/y(1)) * Lanex_response(Lanex_ref,x(i), 'Cu', 3) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
 if any(pick==3)
    for i=1:n1-1
      S1(3) =  S1(3) +  synchrotron1(Synchro_ref, x(i)/y(1)) * Lanex_response(Lanex_ref,x(i), 'Cu', 10) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
 if any(pick==4)
    for i=1:n1-1
      S1(4) =  S1(4) +  synchrotron1(Synchro_ref, x(i)/y(1)) * Lanex_response(Lanex_ref,x(i), 'W', 3) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
 if any(pick==5)
    for i=1:n1-1
      S1(5) =  S1(5) +  synchrotron1(Synchro_ref, x(i)/y(1)) * Lanex_response(Lanex_ref,x(i), 'W', 1) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
 if any(pick==6)
    for i=1:n1 -1
      S1(6) =  S1(6) +  synchrotron1(Synchro_ref, x(i)/y(1)) * Lanex_response(Lanex_ref,x(i), 'Cu', 0.3) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
 if any(pick==7)
    for i=1:n1-1
      S1(7) =  S1(7) +  synchrotron1(Synchro_ref, x(i)/y(1)) * Lanex_response(Lanex_ref,x(i), '0',0) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
 
 %% BETA2
 if any(pick==8)
    for i=1:n1-1
     S2(1) =  S2(1) +  synchrotron1(Synchro_ref, x(i)/y(1)) * Lanex_response(Lanex_ref,x(i), 'W', 1)*  Filter_transparency(Nist_ref,x(i), 'Cu', 1) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
  if any(pick==9)
    for i=1:n1-1
        S2(2) =  S2(2) +  synchrotron1(Synchro_ref, x(i)/y(1)) * Lanex_response(Lanex_ref,x(i), 'W', 1)*  Filter_transparency(Nist_ref,x(i), 'Cu', 3) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
  if any(pick==10)
    for i=1:n1-1
     S2(3) =  S2(3) +  synchrotron1(Synchro_ref, x(i)/y(1)) * Lanex_response(Lanex_ref,x(i), 'W', 1)*  Filter_transparency(Nist_ref,x(i), 'Cu', 10) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
  if any(pick==11)
    for i=1:n1-1
     S2(4) =  S2(4) +  synchrotron1(Synchro_ref, x(i)/y(1)) * Lanex_response(Lanex_ref,x(i), 'W', 1)* Filter_transparency(Nist_ref,x(i), 'W', 3) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
  end
 if any(pick==12)
    for i=1:n1-1
        S2(5) =  S2(5) +  synchrotron1(Synchro_ref, x(i)/y(1)) * Lanex_response(Lanex_ref,x(i), 'W', 1)*  Filter_transparency(Nist_ref,x(i), 'W', 1) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end   
 if any(pick==13)
    for i=1:n1-1
        S2(6) =  S2(6) +  synchrotron1(Synchro_ref, x(i)/y(1)) * Lanex_response(Lanex_ref,x(i), 'W', 1)* Filter_transparency(Nist_ref,x(i), 'Cu', 0.3) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
 if any(pick==14)
    for i=1:n1-1
        S2(7) =  S2(7) +  synchrotron1(Synchro_ref, x(i)/y(1)) * Lanex_response(Lanex_ref,x(i), 'W', 1)*  Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
 
       
%%     
SL(:)=SL(1);

S_ratio2L = S2./SL;
S_ratio1L=  S1./SL;
 
 tmp(1,1:7)=S_ratio1L; 
 tmp(1,8:14)=S_ratio2L;

 tmp(1,:)= S_tot(:,1:14) - tmp(:,:);
 d(1,1:size(pick,2))=tmp(1,pick); 
 
%% Fit on rms difference  
 
 if do_fit==1
 d=rms(d,2);
 end
 
 %% Fit on summed difference
% if do_fit==1;
% d=0;
%  for k=1:size(pick,2)
%      d=d+ rms(tmp(1,k))
%  end
%  end
end

