 

%%   坐标系 左为正x，上为正y
%     2020.1.29 按陈小斌硕士论文编程，但是不同的是，建立了总体矩阵 通过与全空间SH波对比，结果表明是正确的
%     2020.2.1  解决反射波极性相反的问题。与两层解析解比，结果正确。自由地表还未解决
%     2020.2.2  自由地表解决了.采用的方法是方法4

function [ux_rrff,uy_rrff]=sub_0_finite_element_construct_global_matrix_method(freq,model)
 
           omega = 2*pi*freq;
      


%  for jj=1:model.Nz
%       for ii=1:model.Nx
%                  
%          
%       [model.M(jj,ii),model.C(jj,ii),model.H(jj,ii),model.G_b(jj,ii)]=get_3_frequency_dependence_input_parameter(model.Vp(jj,ii),model.Vs(jj,ii),model.dens(jj,ii),model.K_f(jj,ii),model.porous(jj,ii),model.alpha(jj,ii),model.Qp(jj,ii),model.Qs(jj,ii),model,omega);% to get M C H G den 
%       
%       model.Vch_p(jj,ii)=sqrt(model.H(jj,ii)/model.dens(jj,ii)); model.Vch_s(jj,ii)=sqrt(model.G_b(jj,ii)/model.dens(jj,ii)); %等效P波速度、S波速度  % 
%       
%       model.G(jj,ii)=model.G_b(jj,ii);
%       
%       end
%  end
           
 
                dx   =  model.dx;
                dy   =  model.dz;
                Nx   =  model.Nx;
                Ny   =  model.Nz;
                Npz0 = model.Npz0;
                Npz1 = model.Npz1;
                dx1  = model.dx1;
                dy1  = model.dz1;
                
%                 (model.Nx-2)*(model.Nz-model.Npz0-model.Npz1)
                
                free_surface = model.model_free_surface;
                source_type  = model.source_type;
                
%                 alpha_xg = model.Vs.*model.Vs.*model.dens;
%                 alpha_yg = model.Vs.*model.Vs.*model.dens;
%                 beta_g=zeros(Ny,Nx);    % first equation
%                 
%                 alpha_xh = ones(Ny,Nx);
%                 alpha_yh = ones(Ny,Nx);
%                 beta_h=zeros(Ny,Nx);    % second equation 
                
%            for jj = 1:Ny
%                for ii = 1:Nx             
%                    beta_g(jj,ii)   = ((model.dens_f(jj,ii)*model.dens_f(jj,ii))/(dens_w(jj,ii))-model.dens(jj,ii))*omega*omega;
%                %   beta_g(jj,ii)   = -model.dens(jj,ii)*omega*omega;   % 弹性波动方程
%                    beta_h(jj,ii)   = -miu0*omega*omega*(epsilon_w(jj,ii)+dens_w(jj,ii)*L_w(jj,ii)*L_w(jj,ii));               
%                end
%            end

                source_Fx = zeros(Ny,Nx);
                source_Fy = zeros(Ny,Nx);
                
                
                source_jj = model.source_jj;
                source_ii = model.source_ii;
                
             if model.source_type == 1         % Fx
%               source_Fx(model.source_jj,   model.source_ii) = model.source_Fx/dx/dy;%/dx/dy;  % 这里除以dx*dy的乘积是因为震源是delta函数，
                source_Fx(source_jj:(source_jj+1),source_ii:(source_ii+1)) = model.source_Fx/dx/dy;%/dx/dy;  % 这里除以dx*dy的乘积是因为震源是delta函数，
             elseif model.source_type == 2       % Fy
%               source_Fy(model.source_jj,   model.source_ii) = model.source_Fy/dx/dy;%/dx/dy;
                source_Fy(source_jj:(source_jj+1),source_ii:(source_ii+1)) = model.source_Fy/dx/dy;%/dx/dy;

             end

%            b_all_u   = zeros((Nx-2)*(Ny-Npz0-Npz1),1);
%            b_all_E   = zeros((Nx-2)*(Ny-2),1);
             Nx0      = Nx-2; % 因为最外围的点已经被赋值为0，因此，实际含未知场量的节点只有 （Nx-2）*（Ny-2）个
             Ny0      = Ny-2; % 最终建立的刚度矩阵是 （Nx-2）*（Ny-2）维的方阵          
             Nxy      = Nx0*Ny0;
             Nxy1     = Nx0*(Ny-Npz0-Npz1);
%            model.model_free_surface = 1;       % 1. 含自由地表  0.不含自由地表  影响PML设置是否吸收最上面的介质层 
 
 
    if free_surface == 0      % do not consider the free surface
         
          ux_rrff=zeros(Nxy,1); uy_rrff=zeros(Nxy,1);
 
         if ((source_type==1)||(source_type==2))  % force source  - Fx,Fy
               
               [b_all_u,A_all_u]=sub_3_2_fullspace_matrix_PSV(Nx,Ny,Nx0,dx1,dy1,source_Fx,source_Fy,model,omega);
             
               x22   = A_all_u\b_all_u;  % ux,uy
               
               for kk = 1:Nxy                  
                 ux_rrff(kk)=x22((kk-1)*2+1);
                 uy_rrff(kk)=x22((kk-1)*2+2);
               
               end  
               
         end
         
    else                       % consider the free surface
        
         ux_rrff=zeros(Nxy1,1); uy_rrff=zeros(Nxy1,1);
        
         if ((source_type==1)||(source_type==2))  % force source  - Fx,Fy,fx,fy
           
             
             [b_all_u,A_all_u]=sub_3_2_freesurface_matrix_PSV(Nx,Ny,Nx0,dx1,dy1,source_Fx,source_Fy,model,omega);
             
              x22   = A_all_u\b_all_u;  % ux,uy,wx,wy
             
             for kk = 1:Nxy1                  
                 ux_rrff(kk)=x22((kk-1)*2+1);
                 uy_rrff(kk)=x22((kk-1)*2+2);               
             end
             
             ux_temp1 = reshape(ux_rrff,[(model.Nx-2),(Ny-Npz0-Npz1)]);
             uy_temp1 = reshape(uy_rrff,[(model.Nx-2),(Ny-Npz0-Npz1)]);
             
             ux_temp2 = ux_temp1.';
             uy_temp2 = uy_temp1.';
             
             ux_temp3 = zeros(model.Nz-2,model.Nx-2);
             uy_temp3 = zeros(model.Nz-2,model.Nx-2);

             ux_temp3(1:(Ny-Npz0-Npz1),(1:(model.Nx-2))) = ux_temp2;
             uy_temp3(1:(Ny-Npz0-Npz1),(1:(model.Nx-2))) = uy_temp2;
             
             ux_temp33 = ux_temp3.';
             uy_temp33 = uy_temp3.';
             
             ux_rrff = reshape(ux_temp33,[1,(model.Nx-2)*(model.Nz-2)]);  % add
             uy_rrff = reshape(uy_temp33,[1,(model.Nx-2)*(model.Nz-2)]);  % add
   
                 
         end         
         
    end 
     

 end



