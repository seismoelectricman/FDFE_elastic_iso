 
%% 2020.1.29 按陈小斌硕士论文编程，
%  注意坐标系 x正向：右； y正向：上

clc

clear all
        
        parral=0;
        
        CoreNum=2;  % 60 can
        if parral==1
           if isempty(gcp('nocreate'))
            parpool(CoreNum);
           end
        end                
        
        freesurface =1;  % 0 -- do not consider freesurface.
        
        fprintf('freesurface  = %4.2f\n', freesurface);
        
        if freesurface == 0           
          [model]=sub_00_model_fullspace_dx5m_500_500();
        %  [model]=sub_00_model_fullspace_dx5m_500_500_slow_wave();
        else
           [model]=sub_00_model_halfspace_dx5m_500_500();
         %  [model]=sub_00_model_halfspace_dx5m_500_500_heter();
        end


   %% █████████████████████--------------------自动计算 delt_t, delt_f, f_min, f_max,                  █████████████████████% 
%% ######################         根据记录时间、采样点数计算 delt_f、delf_t、start_f_point、end_f_point、f_points  ######################%  
            
        model.delt_f        = 1/model.T_length;
        model.delt_t        = model.T_length/model.fft_ftn;
        model.start_f_point = floor(model.fmin/model.delt_f);
    
        if  model.start_f_point==0;
            model.start_f_point=1;
        end
        model.end_f_point=floor(model.fmax/model.delt_f)  ;                  

        model.t_points     = model.T_length/model.delt_t;
        model.f_points     = model.end_f_point-model.start_f_point+1;   
        model.f_max        = model.end_f_point*model.delt_f ; 
        model.f_min        = model.start_f_point*model.delt_f ; 
        
        model.f_Nyquist    = 1/(model.delt_t*2); 
     
   % wavelength of S wave
       model.wave_length_S    = min(min(model.Vs))/model.fmax;
 
       model.x1_rrff=zeros(model.Nx*model.Nz,model.fft_ftn); 
       model.x2_rrff=zeros(2*model.Nx*model.Nz,model.fft_ftn); 
       model.model_length=(model.Nx-model.Npx)*model.dx;
   
       fprintf('wave_length_S  = %8.6f\n', model.wave_length_S);
       fprintf('           dx  = %8.6f\n', model.dx);
       fprintf(' model_length  = %8.6f\n', model.model_length);
       fprintf('       P time  = %8.6f\n', model.model_length/max(max(model.Vp)));
       fprintf('       S time  = %8.6f\n', model.model_length/max(max(model.Vs)));
       fprintf('     P-S time  = %8.6f\n', model.model_length/max(max(model.Vs))-model.model_length/max(max(model.Vp)));
       fprintf('     start_f   = %8.6f\n', model.start_f_point);
       fprintf('       end_f   = %8.6f\n', model.end_f_point);
   

   % %% █████████████████████--------------------3  频率循环,   求解频率响应                █████████████████████%   
%%  

      ux_rrff = zeros(((model.Nz-2)*(model.Nx-2)),model.fft_ftn);
      uy_rrff = zeros(((model.Nz-2)*(model.Nx-2)),model.fft_ftn);
      

   
   freq_all = (0:(model.end_f_point-1))*model.delt_f;
     
 if parral==1 % 采用并行计算
                  fprintf('parral running')  

         parfor circle_f_point = model.start_f_point:model.end_f_point

              tic

            freq(circle_f_point) = freq_all(circle_f_point);

            if freq(circle_f_point) == 0
                freq(circle_f_point) =model.delt_f/1000;
            end


            [S_w]=get_6_frequecy_source(model.timesource, freq(circle_f_point), model.f_c, model.time_delay_ricker, model.f_0, model.T_0, model.t0, model.T_triangle);

%             [u_rrff0,u_rrff1]=sub_0_finite_element_construct_global_matrix_method(freq(circle_f_point),model);
           % [ux_rrff0,uy_rrff0,wx_rrff0,wy_rrff0,Ex_rrff0,Ey_rrff0]=sub_0_finite_element_construct_global_matrix_method(freq(circle_f_point),model);
           [ux_rrff0,uy_rrff0]=sub_0_finite_element_construct_global_matrix_method(freq(circle_f_point),model);
%            [ux_rrff0,uy_rrff0,wx_rrff0,wy_rrff0]=sub_0_finite_element_construct_global_matrix_method(freq(circle_f_point),model);
            
            ux_rrff(:,circle_f_point)=ux_rrff0*S_w;
            uy_rrff(:,circle_f_point)=uy_rrff0*S_w;
%             wx_rrff(:,circle_f_point)=wx_rrff0*S_w;
%             wy_rrff(:,circle_f_point)=wy_rrff0*S_w;
            
%             Ex_rrff(:,circle_f_point)=Ex_rrff0*S_w;
%             Ey_rrff(:,circle_f_point)=Ey_rrff0*S_w;
            
                         
            Sw(circle_f_point)=S_w;              
        toc
        
         end
  
 else  %% 不采用并行计算
     
  for circle_f_point = model.start_f_point:model.end_f_point

              tic

            freq = freq_all(circle_f_point);

            if freq == 0
                freq =model.delt_f/1000;
            end


            [S_w]=get_6_frequecy_source(model.timesource, freq, model.f_c, model.time_delay_ricker, model.f_0, model.T_0, model.t0, model.T_triangle);

        %    [u_rrff0,u_rrff1]=sub_0_finite_element_construct_global_matrix_method(freq,model);

            [ux_rrff0,uy_rrff0]=sub_0_finite_element_construct_global_matrix_method(freq,model);

%              xu_rrff(:,circle_f_point)=u_rrff0*S_w;   
%              xE_rrff(:,circle_f_point)=u_rrff1*S_w;  

             ux_rrff(:,circle_f_point)=ux_rrff0*S_w;
             uy_rrff(:,circle_f_point)=uy_rrff0*S_w;
            
            Sw(circle_f_point)=S_w;
               
        toc
    end 
     
           close(h)
     
 end
  
    
    
%     x_all = (1:model.Nx);
%     y_all = (1:model.Nz);
%     scale0 = [-1,1]*1e-16;
%     figure(2)
%   % imagesc(y_all,x_all,abs(u_rrff_Nz_Nx(:,:)))
%   % imagesc(x_all,y_all,abs(u_rrff_Nz_Nx(:,:)))
%     set(gca,'ydir','normal')
     
%     imagesc(y_all,x_all,abs(x1_rrff(:,:,circle_f_point)))

  save -v7.3 Fz_FS_25Hz_2023_01_17_PML_60_S_250_200_dxdz_4
 % save -v7.3 Fz_FS_25Hz_2023_01_12_PML_60_S_250_250_dxdz_4_slow_wave

  % save -v7.3 Fz_HS_25Hz_2023_01_12_PML_60_S_300_350_dxdz_4
%   save -v7.3 Fz_HS_25Hz_2023_01_13_PML_60_S_458_250_dxdz_4_oil
 %   save -v7.3 Fz_FS_25_2000_Hz_2022_12_15_PML_60_S_250_200_dxdz_4_slow_wave_diff_perm
 %  save -v7.3 Fz_HS_25Hz_2022_12_14_PML_50_S_450_350_dxdz_4_surface_wave
 % save -v7.3 Fz_HS_25Hz_2022_12_14_PML_50_S_300_300_dxdz_4
 % save -v7.3 Fz_HS_25Hz_2022_12_13_PML_Rc_0_001_PML_50_S_300_300_dxdz_5_varia_grid
 

    