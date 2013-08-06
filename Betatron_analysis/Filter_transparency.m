function [ T ] = Filter_transparency(ref, e, atom, z)
 %% Evaluates the transparency of a given filter at a given energy
 %%% - "ref" expects the NIST datas reference given by get_nistdatas.m
 %%% - "e" is the Energy wanted in MeV;
 %%% - "atom" is the atomic symbol of the wanted filter's component. Expected
 %%% as a string.
 %%% - "z" is the width of the filter, expected in mm.
 %%% [T] returns the Transparency
%%
      z= z/10;  % converts z in [cm]
%%    
        if  atom=='Cu'
            rho = 8.02; % [g/cm^3]
            xsection = ref.copper; % [cm^2/g]

    elseif  atom=='W'
            if  z==3
                rho=17.9;
                xsection = ref.tungsten90;
            else
                rho = 19.25;
                xsection = ref.tungsten; 
            end


       else 
             error('Invalid atom')

       end

%%
interp_xsection = interp1(xsection(:,1),xsection(:,2),e);
T= exp( - interp_xsection * rho * z);
    
end

