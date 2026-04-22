 

function [model]=sub_00_model_halfspace_dx5m_500_500_heter()

   model.Nx               = 500;    % column    
   model.Nz               = 500;    % row
   model.Npx              = 60;     % PML的宽度  %计算弹性波时，至少取30。取40就能达到非常好的效果。
   model.Npz              = 60;     % PML的宽度
   model.Npx0             = 1;     % 变步长网格区域的宽度
   model.Npz0             = 1;     % 变步长网格区域的宽度  在网格变化的地方仍有反射
   
      model.dx_vary_CC        =2; % 空间步长增加比例
      model.dx_max            =4;   % 最大空间步长 根据电磁波的波长取，矿化度0.001时，可以取1000，,矿化度0.01，取500
      model.dx_max1           =4;
   model.dx               = 4;      % f_c=25Hz时，取7效果最好
   model.dz               = 4;    
   
   model.source_ii        = 250*1;   % 注意有限元中，源是放置在单元中  halfspace--(300,300)  surface wave--(450,350)
   model.source_jj        = 458*1;   % source to free surface in Z direction: (model.Nz-model.Npz1-model.Npz0+1-model.source_jj)*model.dz-(1/2)*model.dz
   
   model.source_type      = 2;        % 1.Fy  2.Cy   
   
        model.source_Fx      = 1;   %   Fx 强度  (1)
        model.source_Fy      = 1;   %   Fy 强度  (2)
        model.source_fx      = 1;   %   fx 强度  (3)
        model.source_fy      = 1;   %   fy 强度  (4)
        
%         model.source_Cx      = 1;     %   Cx 强度  (5)
%         model.source_Cy      = 1;     %   Cy 强度  (6)

        
   model.PML_on           = 1;     % 1: PML on     0; PML off
      model.PML_type          = 1;     % 1. Zhang and Shen 2010 弹性波PML   default=1;
                                       % 2. Pure EM PML    % 2017.10.29 EM PML 没设置好 
    model.model_free_surface = 1;      % 0.不含自由地表 1. 含自由地表    影响PML设置是否吸收最上面的介质层               
    model.Npz1             = 40;       % 自由地表以上空气层的层数                                                                       
%   model.model_interface =2   ;        % 1. 介质参数配置在格点上  2. 配置在cell中，1倍、2倍步长按Min 2004文章中的平均       

    model.more_density_surface = 0;
    model.density_surface_layers = 10 ;
    
    model.more_density_source = 0;
 
%% 自动计算  
   model.Nxz              = model.Nx*model.Nz;      
   model.source_k         = model.source_ii+(model.source_jj-1)*model.Nx; % 源的位置

 %% █████████████████████-------------------- halfspace                   █████████████████████% 
     %%   注意坐标系 左为正x，上为正y（或z）  

%     model.interface_z=150;     %  注意有限元中，参数是赋值在单元中而不是节点上 比如此处取50，则表明第y方向 50和51是分界面
%     model.interface_z0=190;    %  源在界面上：(model.interface_z-model.source_jj+(1/2))）*model.dz
%                                %  源在界面下：((model.Nz-model.source_jj+(1/2))-model.interface_z)*model.dz
%     model.Vp(1:model.Nz,1:model.Nx)           = 4000;   % 3460
% 
%      model.Vs(1:model.interface_z,1:model.Nx)             = 2800;   % 2400
%           model.Vs((model.interface_z+1):(model.interface_z0),1:(model.Nx))      = 2800; 
%               model.Vs((model.interface_z0+1):(model.Nz),1:(model.Nx))      = 2800;
%    %            model.Vs((model.interface_z0+1):model.Nz,1:(model.Nx))      = 3000;   % 1. 直接赋值为0行不通,给一个很小的值（例如1），可以计算。但反射波与解析解有误差
%                               
%      model.dens(1:model.interface_z,1:model.Nx)           = 2000;   % 2800
%           model.dens((model.interface_z+1):(model.interface_z0),1:model.Nx)    = 2000;
%                 model.dens((model.interface_z0+1):(model.Nz),1:model.Nx)    = 2000;
%                 
%      model.dens_f(1:model.interface_z,1:model.Nx)           = 1000;   
%           model.dens_f((model.interface_z+1):(model.interface_z0),1:model.Nx)    = 1000;
%                 model.dens_f((model.interface_z0+1):(model.Nz),1:model.Nx)    = 1000;
%                 
%      model.Molarity(1:model.interface_z,1:model.Nx)           = 0.1;
%           model.Molarity((model.interface_z+1):(model.interface_z0),1:model.Nx)    = 0.1;
%                 model.Molarity((model.interface_z0+1):(model.Nz),1:model.Nx)    = 0.1;
%                                                      
%       model.porous(1:model.interface_z,1:model.Nx)           = 0.15; 
%           model.porous((model.interface_z+1):(model.interface_z0),1:model.Nx)    = 0.15;
%                 model.porous((model.interface_z0+1):(model.Nz),1:model.Nx)    = 0.15;                                                    
% 
%       model.epsi_rela_s(1:model.interface_z,1:model.Nx)           = 4; 
%           model.epsi_rela_s((model.interface_z+1):(model.interface_z0),1:model.Nx)    = 4;
%                 model.epsi_rela_s((model.interface_z0+1):(model.Nz),1:model.Nx)    = 4;                                                      
 



 %% █████████████████████-------------------- halfspace    with-2layers               █████████████████████%              
  
%     model.interface_z=150;     %  注意有限元中，参数是赋值在单元中而不是节点上 比如此处取50，则表明第y方向 50和51是分界面
%     model.interface_z0=400;    %  源在界面上：(model.interface_z-model.source_jj+(1/2))）*model.dz
%                                %  源在界面下：((model.Nz-model.source_jj+(1/2))-model.interface_z)*model.dz
% %     model.Vp(1:model.Nz,1:model.Nx)           = 4000; 
% 
%      model.Vp(1:model.interface_z,1:model.Nx)             = 5000;   % 4000
%         model.Vp((model.interface_z+1):(model.interface_z0),1:(model.Nx))      = 4000; 
%             model.Vp((model.interface_z0+1):(model.Nz),1:(model.Nx))      = 4000;
%            
%      model.Vs(1:model.interface_z,1:model.Nx)             = 3500;   % 4000
%           model.Vs((model.interface_z+1):(model.interface_z0),1:(model.Nx))      = 2800; 
%               model.Vs((model.interface_z0+1):(model.Nz),1:(model.Nx))      = 2800;
%    %            model.Vs((model.interface_z0+1):model.Nz,1:(model.Nx))      = 3000;   % 1. 直接赋值为0行不通,给一个很小的值（例如1），可以计算。但反射波与解析解有误差
%                               
%      model.dens(1:model.interface_z,1:model.Nx)           = 2400;   % 2800
%           model.dens((model.interface_z+1):(model.interface_z0),1:model.Nx)    = 2000;
%                 model.dens((model.interface_z0+1):(model.Nz),1:model.Nx)    = 2000;
%                 
%      model.dens_f(1:model.interface_z,1:model.Nx)           = 1000;   
%           model.dens_f((model.interface_z+1):(model.interface_z0),1:model.Nx)    = 1000;
%                 model.dens_f((model.interface_z0+1):(model.Nz),1:model.Nx)    = 1000;
%                 
%      model.Molarity(1:model.interface_z,1:model.Nx)           = 0.01;
%           model.Molarity((model.interface_z+1):(model.interface_z0),1:model.Nx)    = 0.1;
%                 model.Molarity((model.interface_z0+1):(model.Nz),1:model.Nx)    = 0.1;
%                                                      
%       model.porous(1:model.interface_z,1:model.Nx)           = 0.25; 
%           model.porous((model.interface_z+1):(model.interface_z0),1:model.Nx)    = 0.15;
%                 model.porous((model.interface_z0+1):(model.Nz),1:model.Nx)    = 0.15;                                                    
% 
%       model.epsi_rela_s(1:model.interface_z,1:model.Nx)           = 4; 
%           model.epsi_rela_s((model.interface_z+1):(model.interface_z0),1:model.Nx)    = 4;
%                model.epsi_rela_s((model.interface_z0+1):(model.Nz),1:model.Nx)    = 4;                    
                 

%% %%%%%%%%%%%%%%%%%%%%% Qudratic function (heterogenous model) %%%%%%%%%%%%%%%%%%%%%%

     %% Sandstone with water

      model.Vp(1:model.Nz,1:model.Nx)             = 2715;
      model.Vs(1:model.Nz,1:model.Nx)             = 1178;
      model.dens(1:model.Nz,1:model.Nx)           = 2650;
      model.dens_f(1:model.Nz,1:model.Nx)         = 1040;
      model.perm(1:model.Nz,1:model.Nx)           = 1.0e-13;
      model.visc(1:model.Nz,1:model.Nx)           = 1e-3;                
      model.porous(1:model.Nz,1:model.Nx)         = 0.335;


      x0_1=100;   % 50
%     x0_2=250;   % 250
      x0_3=400;   % 450
      
      fxx=zeros(1,500);
      fxx_t=zeros(1,500);
      
      for ii=1:500
%         fxx(ii)=-((ii-x0_1)*(ii-x0_3)/(1e4)*60)+120;
          fxx(ii)=-(2.4*(ii-x0_1)*(ii-x0_3)/(1e4)*60)-70;
          fxx_t(ii)=round(fxx(ii));
      end
       
   %  round(4.4)=4; round(4.5)=5;
      
      for ii=1:500     
          for jj=1:500             
            if (jj<(fxx_t(ii)))  
                               
         %% sandstone with gas

%                model.Vp(jj,ii)=2543;      %% h
%                model.Vs(jj,ii)=1288;      %% h
%                model.dens(jj,ii)=2650;    %% h
%                model.dens_f(jj,ii)=10;    %% h
%                model.perm(jj,ii)=1.0e-13; %% h
%                model.visc(jj,ii)=2.2e-5;  %% h
%                model.porous(jj,ii)=0.335; %% h

         %% sandstone with oil

               model.Vp(jj,ii)=2645;      %% h
               model.Vs(jj,ii)=1183;      %% h
               model.dens(jj,ii)=2650;    %% h
               model.dens_f(jj,ii)=985;   %% h
               model.perm(jj,ii)=1.0e-13; %% h
               model.visc(jj,ii)=150;     %% h
               model.porous(jj,ii)=0.335; %% h

            end
          end  
      end

      %% sandstone with  water

      model.Vp(1:140,1:model.Nx)             = 2715;
      model.Vs(1:140,1:model.Nx)             = 1178;
      model.dens(1:140,1:model.Nx)           = 2650;
      model.dens_f(1:140,1:model.Nx)         = 1040;
      model.perm(1:140,1:model.Nx)           = 1.0e-13;
      model.visc(1:140,1:model.Nx)           = 1e-3;
      model.porous(1:140,1:model.Nx)         = 0.335;


      %% Shale

      model.inter = 360;

      model.Vp(model.inter:model.Nz,1:model.Nx)             = 2293;
      model.Vs(model.inter:model.Nz,1:model.Nx)             = 1269;
      model.dens(model.inter:model.Nz,1:model.Nx)           = 2211;
      model.dens_f(model.inter:model.Nz,1:model.Nx)         = 1040;
      model.perm(model.inter:model.Nz,1:model.Nx)           = 1.0e-17;
      model.visc(model.inter:model.Nz,1:model.Nx)           = 1e-3;
      model.porous(model.inter:model.Nz,1:model.Nx)         = 0.01;

%%%%%%


      if model.model_free_surface == 1
          
          model.Vs((model.Nz-model.Npz1-model.Npz0+1):(model.Nz),1:(model.Nx))    = 1e-20;  % 0
          model.dens((model.Nz-model.Npz1-model.Npz0+1):(model.Nz),1:model.Nx)    = 1e-20;  % 0
          model.dens_f((model.Nz-model.Npz1-model.Npz0+1):(model.Nz),1:model.Nx)  = 1e-20;  % 0 
          model.Molarity((model.Nz-model.Npz1-model.Npz0+1):(model.Nz),1:model.Nx)    = 1e-20;
          model.porous((model.Nz-model.Npz1-model.Npz0+1):(model.Nz),1:model.Nx)    = 1e-20;
          model.epsi_rela_s((model.Nz-model.Npz1-model.Npz0+1):(model.Nz),1:model.Nx)    = 1;

%             model.Vs(1:(model.Npz1+model.Npz0),1:(model.Nx))    = 1e-20;  % 0
%             model.dens(1:(model.Npz1+model.Npz0),1:model.Nx)    = 1e-20;  % 0
%             model.dens_f(1:(model.Npz1+model.Npz0),1:model.Nx)  = 1e-20;  % 0 
%             model.Molarity(1:(model.Npz1+model.Npz0),1:model.Nx)    = 1e-20;
%             model.porous(1:(model.Npz1+model.Npz0),1:model.Nx)    = 1e-20;
%             model.epsi_rela_s(1:(model.Npz1+model.Npz0),1:model.Nx)    = 1;
            
      end
 
  %  model.porous       = ones(model.Nz,model.Nx)*0.15;
     model.alpha        = 4.34.*model.porous-6.78.*model.porous.*model.porous; %vernik model       
  %  model.perm         = ones(model.Nz,model.Nx)*0.1*1.0e-12;
     model.Molarity     = ones(model.Nz,model.Nx)*1e-3; 
     model.alpha_inf    = ones(model.Nz,model.Nx)*3;
     model.K_f          = ones(model.Nz,model.Nx)*2.25e9;        
     model.m_pore       = ones(model.Nz,model.Nx)*8;
  %  model.visc         = ones(model.Nz,model.Nx)*1e-3;  
  %  model.dens_f       = ones(model.Nz,model.Nx)*1e3;   
     model.Vclay        = ones(model.Nz,model.Nx)*0.03;
     model.Temperature  = ones(model.Nz,model.Nx)*298;        
     model.epsi_rela_f  = ones(model.Nz,model.Nx)*80;
     model.epsi_rela_s  = ones(model.Nz,model.Nx)*4; 
     model.Qp=20000;
     model.Qs=20000;      

 for jj=1:model.Nz
      for ii=1:model.Nx
                 
%       [model.M(jj,ii),model.C(jj,ii),model.H(jj,ii),model.G_b(jj,ii),model.dens(jj,ii)]=get_3_deduced_constant(model.porous(jj,ii),model.dens_f(jj,ii),model.K_f(jj,ii),model.Vclay(jj,ii));% to get M C H G den
      [model.M(jj,ii),model.C(jj,ii),model.H(jj,ii),model.G_b(jj,ii)]=get_3_deduced_constant_input_porous(model.Vp(jj,ii),model.Vs(jj,ii),model.dens(jj,ii),model.K_f(jj,ii),model.porous(jj,ii),model.alpha(jj,ii));% to get M C H G den    
      
      model.Vch_p(jj,ii)=sqrt(model.H(jj,ii)/model.dens(jj,ii)); model.Vch_s(jj,ii)=sqrt(model.G_b(jj,ii)/model.dens(jj,ii)); %等效P波速度、S波速度  % 
      
      model.G(jj,ii)=model.G_b(jj,ii);
      
      end
 end
                    
%%  variable step  

     model.dx0=ones(1,model.Nx)*model.dx;
     model.dz0=ones(model.Nz,1)*model.dz;
     
     model.dx1=ones(1,model.Nx);
     model.dz1=ones(model.Nz,1);
     
     for ii=1:model.Nx 
%           if(ii <= (model.Npx0+1))
             if(ii < (model.Npx0+1))
                 model.dx0(ii)=model.dx*model.dx_vary_CC^((model.Npx0-ii+1));
%                model.dx0(ii)=1000;
              if model.dx0(ii)>=model.dx_max
                  model.dx0(ii)=model.dx_max;
              end
             end
%           if(ii >= (model.Nx - model.Npx0))
            if(ii > (model.Nx - model.Npx0))
              model.dx0(ii)=model.dx*model.dx_vary_CC^((ii-(model.Nx-model.Npx0)));
%               model.dx0(ii)=1000;
              if model.dx0(ii)>=model.dx_max
                  model.dx0(ii)=model.dx_max;
              end
           end
     end   
             
             
     for jj=1:model.Nz
         
            if(jj < (model.Npz0+1))                
                model.dz0(jj)=model.dz*model.dx_vary_CC^((model.Npz0-jj+1));
                    if model.dz0(jj)>=model.dx_max
                      model.dz0(jj)=model.dx_max;
                    end
            end
                            
               if model.model_free_surface == 1;
                  if((jj > (model.Nz-model.Npz0-model.Npz1))&&(jj<model.Nz-model.Npz0+1))                 
        %          model.dz0(jj)=1000; 
                   model.dz0(jj)=5;
                  end 
               else
                   if((jj > (model.Nz-model.Npz0-model.Npz1))&&(jj<model.Nz-model.Npz0+1))                 
                       model.dz0(jj)=model.dz;                                 
                   end  
               end
               
               if(jj > (model.Nz - model.Npz0))
                   
                 if model.model_free_surface == 1;
                    model.dz0(jj)=model.dz*model.dx_vary_CC^((jj-(model.Nz-model.Npz0)));    
%                   model.dz0(jj)=400000; 
                    if model.dz0(jj)>=model.dx_max1
                      model.dz0(jj)=model.dx_max1;
                    end 
                 else                      
                   model.dz0(jj)=model.dz*model.dx_vary_CC^((jj-(model.Nz-model.Npz0)));
%                  model.dz0(jj)=1000;
                  if model.dz0(jj)>=model.dx_max
                    model.dz0(jj)=model.dx_max;
                  end
                  
                 end
                 
               end
     end
     
%      model.dz0(model.Nz-model.Npz0-model.Npz1)=model.dz-3;
%      model.dz0(model.Nz-model.Npz0-model.Npz1-1)=model.dz-3;
%      model.dz0(model.Nz-model.Npz0-model.Npz1-2)=model.dz-3;
%      model.dz0(model.Nz-model.Npz0-model.Npz1-3)=model.dz-3;
%      model.dz0(model.Nz-model.Npz0-model.Npz1-4)=model.dz-3;
%      model.dz0(model.Nz-model.Npz0-model.Npz1-5)=model.dz-3;
%      model.dz0(model.Nz-model.Npz0-model.Npz1-6)=model.dz-3;
%      model.dz0(model.Nz-model.Npz0-model.Npz1-7)=model.dz-3;
%      model.dz0(model.Nz-model.Npz0-model.Npz1-8)=model.dz-3;
%      model.dz0(model.Nz-model.Npz0-model.Npz1-9)=model.dz-3;
%      model.dz0(model.Nz-model.Npz0-model.Npz1-10)=model.dz-3;
     
     model.dx1(1)=0;
     for ii=2:(model.Nx+1)        
         model.dx1(ii)=sum(model.dx0(1:ii-1));
     end
     
     model.dz1(1)=0;
     for ii=2:(model.Nz+1)       
         model.dz1(ii)=sum(model.dz0(1:ii-1));
     end
     
     sum(model.dx0(1:model.Npx0)); % 计算出变步长区域的总长度，该长度必须足够长，能够使得电磁波几何衰减得足够小

     
     
      if model.more_density_source == 1
          
      %   model.dz0(model.source_jj)=model.dz/2;        
      %   model.dx0(model.source_ii)=model.dx/2;
      
          model.dz0((model.source_jj-1):(model.source_jj+1))=model.dz/2;        
          model.dx0((model.source_ii-1):(model.source_ii+1))=model.dx/2;
      %  (source_jj-1):(source_jj+1),(source_ii-1):(source_ii+1)
          
      %  model.source_ii        = 300*1;   % 注意有限元中，源是放置在单元中
      %  model.source_jj        = 300*1;   % sour
         
      end
      
      if model.more_density_surface == 1
          
         model.dz0((model.Nz-model.Npz0-model.Npz1-model.density_surface_layers):(model.Nz-model.Npz0-model.Npz1))=model.dz/2; 
          
      end
     
         
%% █████████████████████-------------------- 3 声源频率、记录时间                   █████████████████████% 

     model.timesource=1;                              % Type of source time function： 
        model.f_c=25;    model.time_delay_ricker=1/model.f_c;      % timesource=1. Ricker wavelet: center frequency and time delay. Usualy time_delay_ricker=1/f_c
        model.f_0=15;    model.NN=2;        model.T_0=2/10;   % timesource=2. Cosine envelope pulse:  
                                                %                   f_0:center frequency;    NN>=2;   T_0:length of  the pulse
        model.t0=0.2;                                 % timesource=3. Ramp function: rise time t0：
        model.T_triangle=1;                           % timesource=4. Width of triangle function
     model.fmin=0.1;       model.fmax=75;                 % minimal and maximal frequency in calculation,
                                                %   for Ramp: f_max=1/t0 is a good choice
                                                %   for Ricker:  f_max>2*fc
     model.T_length=1.024*2;                            % Length of the seismic record
     model.fft_ftn=1024*2;                              % Sampling number for time-frequency Fourier transofrm 
       
  %% █████████████████████--      4   PML parameter from Zhang and Shen 2010 Geophysics, 75(4)                 █████████████████████%     
      
       if model.timesource==1
%        model.fc0=model.fmax;
           model.fc0=model.f_c;
       elseif model.timesource==2
           model.fc0=model.f_0;
       end 
 
       if model.PML_type==1 
            %% 1 Zhang wei 弹性波吸收条件      
        %   Cp=model.Vs(1);
           Cp=max(max(model.Vs(:,:)));
           model.PML_m       =2; 
           model.PML_Rc      = 0.0001;                                                                    % default = 0.0001;  
           model.PML_d0      = -(model.PML_m+1)*Cp*log10(model.PML_Rc)/(2*model.Npx*model.dx)*2;          % default = -3*Cp*log10(model.PML_Rc)/(2*model.Npx*model.dx)*2;; 
           model.PML_beta0   = 2;  % beta                                                                 % default = 2;   
           model.PML_alpha0  = pi*model.fc0*1;                                                            % default = pi*model.fc0*1; 
             
       else
           error('model.PML_type must be 1  . But now it is %4.2f', model.PML_type)
       end
       
end