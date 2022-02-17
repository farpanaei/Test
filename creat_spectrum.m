function [mat_f_c, Nch_mat] = creat_spectrum(Freq_Grinularity_mat,Rs_mat)

for Rs_count=1:numel(Rs_mat)
                               
        f_c_start=(2.99792458*10^8)/(1530.0555*10^-9);      %  starting Freq in C band (Hz)
        
        f_c_final=(2.99792458*10^8)/(1565*10^-9);           % ending Freq in C band (Hz)

        Freq_Grinularity = Freq_Grinularity_mat(Rs_count);    
        
        f_ref=193.1e12;                                     %(Hz)
        
        mat_f_c_1=[];
        
        mat_f_c_r=[];
        
        
        mat_f_c_1(1)=f_ref;
        
        mat_f_c_r(1)=f_ref+((Freq_Grinularity*1e-3)*1e12);
        
        i=1;
        
        while mat_f_c_1(i) > f_c_final
            
            mat_f_c_1(i+1)=f_ref-((i)*((Freq_Grinularity*1e-3)*1e12));
            i=i+1;
        end
        
        i=1;
        
        while mat_f_c_r(i) < f_c_start
            mat_f_c_r(i+1)=f_ref+((i+1)*((Freq_Grinularity*1e-3)*1e12));
            i=i+1;
        end
        
        mat_f_c{Rs_count} = [flip(mat_f_c_r),mat_f_c_1(1:numel(mat_f_c_1)-1)];
        
        Nch_mat (Rs_count) = numel(mat_f_c{Rs_count});
end


end

