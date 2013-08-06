function [ R] = Lanex_response(ref, e, atom, z )
%% Evaluates the response of the Lanex for a given filter at a given energy.
    %%% - "ref" expects the Lanex response reference given by get_lanexresponse.m
    %%% - "e" is the wanted energy in MeV
    %%% - "atom" is the atomic symbol of the wanted filter's component. Expected
    %%%    as a string.
    %%% - "z" is the wanted filter width in mm
    %%% [R] returns the fraction of energy deposited.

    if strcmp(atom,'Cu')
        
           if z==1
               val= ref(:,2);

           elseif z==3
                val= ref(:,3);
           
           elseif z==0.3
                val = ref(:,7);
                
           elseif z==10
                val= ref(:,4);

           else 
                error('Invalid foil width');     

           end
       
    elseif strcmp(atom,'W')
        
            if z==3
                val= ref(:,5);
        
            elseif z==1
                val= ref(:,6);
        
            else 
                error('Invalid foil width');  
                
            end
            
    elseif atom=='0' && z==0
            val= ref(:,8);
            
    else
            error('Invalid atom');
    end
        

    R= interp1(ref(:,1), val, e);  

    
end

