function [d]= Beta_spectrum(Lanex_ref, Nist_ref,pick,P)

%% Function used to get the simulated spectrum for the betatron radiation at a given pressure P 
%%% - "Lanex_ref" is from get_lanexresponse.m
%%% - "Nist_ref" is from get_nistdatas.m
%%% - "pick" is the list of filters wanted 
%%% - "P" is the wanted pressure. For now: P=4 Torr or P=8 Torr
%%% [d] is a numeric simulation of the signal on each filter.
%%% Convention: d(:,1:7) for BETA1, d(:,8:14) for BETA2 with 1:7 <=> [Cu 1, Cu3, Cu10, W3, W1, Cu0.3, No Filter]           

%%
path_betaspect='C:/Users/Jacques/Desktop/PRE/Betatron_spectrum/';    


if P==4
    ref=load([path_betaspect 'Betatron_spectrum_4.txt']);

elseif P==8
    ref=load([path_betaspect 'Betatron_spectrum_8.txt']);   
else
    error('Invalid Pressure')
end

%%
x=10^-6 *ref(:,1); % Reference energy is in eV. 
Beta_spec= ref(:,2);

S2=zeros(1,7); SL=zeros(1,7); S1=zeros(1,7);

n=size(x,1);
 
%%
for i=1:n-1
    SL(1) =  SL(1) + Lanex_response(Lanex_ref,x(i), 'W', 1)* Beta_spec(i)*(x(i+1) - x(i));
end
  
 if any(pick==1)
    for i=1:n-1
        S1(1) =  S1(1) +  Beta_spec(i) * Lanex_response(Lanex_ref,x(i), 'Cu', 1) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
 if any(pick==2)
    for i=1:n-1
        S1(2) =  S1(2) +  Beta_spec(i) * Lanex_response(Lanex_ref,x(i), 'Cu', 3) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
 if any(pick==3)
    for i=1:n-1
      S1(3) =  S1(3) +  Beta_spec(i) * Lanex_response(Lanex_ref,x(i), 'Cu', 10) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
 if any(pick==4)
    for i=1:n-1
      S1(4) =  S1(4) +  Beta_spec(i) * Lanex_response(Lanex_ref,x(i), 'W', 3) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
 if any(pick==5)
    for i=1:n-1
      S1(5) =  S1(5) +  Beta_spec(i) * Lanex_response(Lanex_ref,x(i), 'W', 1) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
 if any(pick==6)
    for i=1:n -1   
      S1(6) =  S1(6) +  Beta_spec(i) * Lanex_response(Lanex_ref,x(i), 'Cu', 0.3) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
 if any(pick==7)
    for i=1:n-1
      S1(7) =  S1(7) +  Beta_spec(i) * Lanex_response(Lanex_ref,x(i), '0',0) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
 
%%
 if any(pick==8)
    for i=1:n-1
     S2(1) =  S2(1) +  Beta_spec(i) * Lanex_response(Lanex_ref,x(i), 'W', 1)*  Filter_transparency(Nist_ref,x(i), 'Cu', 1) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
  if any(pick==9)
    for i=1:n-1
        S2(2) =  S2(2) +  Beta_spec(i) * Lanex_response(Lanex_ref,x(i), 'W', 1)*  Filter_transparency(Nist_ref,x(i), 'Cu', 3) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
  if any(pick==10)
    for i=1:n-1
     S2(3) =  S2(3) +  Beta_spec(i) * Lanex_response(Lanex_ref,x(i), 'W', 1)*  Filter_transparency(Nist_ref,x(i), 'Cu', 10) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
  if any(pick==11)
    for i=1:n-1
     S2(4) =  S2(4) +  Beta_spec(i) * Lanex_response(Lanex_ref,x(i), 'W', 1)* Filter_transparency(Nist_ref,x(i), 'W', 3) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
  end
 if any(pick==12)
    for i=1:n-1
        S2(5) =  S2(5) +  Beta_spec(i) * Lanex_response(Lanex_ref,x(i), 'W', 1)*  Filter_transparency(Nist_ref,x(i), 'W', 1) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end   
 if any(pick==13)
    for i=1:n-1
        S2(6) =  S2(6) +  Beta_spec(i) * Lanex_response(Lanex_ref,x(i), 'W', 1)* Filter_transparency(Nist_ref,x(i), 'Cu', 0.3) * Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
 if any(pick==14)
    for i=1:n-1
        S2(7) =  S2(7) +  Beta_spec(i) * Lanex_response(Lanex_ref,x(i), 'W',1)*  Filter_transparency(Nist_ref,x(i), 'W', 1)*(x(i+1) - x(i));
    end
 end
 
%%

SL(:)=SL(1);
 
 d(1,1:7)=S1./SL;
 d(1,8:14)=S2./SL;
 
end

