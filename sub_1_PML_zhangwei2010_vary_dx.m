function [ PMLs ] = sub_1_PML_zhangwei2010_vary_dx( model,omega)
% PML
% Define damping profiles within PML boundary condition 
% according to Chen et al. (2013)
%
% update:
% -------
% modified for SH-modelling by D. Koehn and D. De Nil (23/09/2016)

% define thickness of PML [m]
    PML_lx = model.Npx * model.dx;
    PML_lz = model.Npz * model.dz;

%    Rc        = 0.0001;
%    d0        = -3*model.Vs(1)*log10(Rc)/(2*PML_lx)*1;
%    beta0     = 2;  % beta
%    alpha0    = pi*model.fc0;
    
         d0      =  model.PML_d0;
      beta0   =  model.PML_beta0;  % beta
      alpha0  =  model.PML_alpha0;
          mm  =  model.PML_m; 
%    
   
% calculate PML damping profiles sigma_x and sigma_y in x- and y-direction
for ii=1:model.Nx  
    
      d_x(ii)     = 0;
      beta_x(ii)  = 1;  
      alpha_x(ii) = alpha0;
    
    % define damping profile at left PML boundary 
    if  (ii >= (model.Npx0+1)) && (ii <= (model.Npx0+model.Npx+1))
        
      d_x(ii)     = d0*((model.Npx0+model.Npx-(ii-1))/model.Npx)^mm;
      beta_x(ii)  = 1+(beta0-1)*((model.Npx0+model.Npx-(ii-1))/model.Npx)^mm;  
      alpha_x(ii) = alpha0*(1-(model.Npx0+model.Npx-(ii-1))/model.Npx);
      
    end
    
    % define damping profile at right PML boundary 
    if (ii >= (model.Nx - (model.Npx+model.Npx0))) &&(ii <= (model.Nx -model.Npx0))
          
      d_x(ii)     = d0*((ii-(model.Nx-(model.Npx0+model.Npx)))/model.Npx)^mm;
      beta_x(ii)  = 1+(beta0-1)*((ii-(model.Nx-(model.Npx+model.Npx0)))/model.Npx)^mm;  
      alpha_x(ii) = alpha0*(1-((ii-(model.Nx-(model.Npx+model.Npx0)))/model.Npx));
      
    end 
    
end

%                       d_x(model.Npx0+1)=d_x(model.Npx0+2);         %
%                       beta_x(model.Npx0+1)=beta_x(model.Npx0+2);   %
%                       alpha_x(model.Npx0+1)=alpha_x(model.Npx0+2); %
%                       d_x(model.Nx - model.Npx0)=d_x(model.Nx - model.Npx0-1);         %
%                       beta_x(model.Nx - model.Npx0)=beta_x(model.Nx - model.Npx0-1);   %
%                       alpha_x(model.Nx - model.Npx0)=alpha_x(model.Nx - model.Npx0-1); %                     
                      

     d_x(1:model.Npx0)     = d_x(model.Npx0+1);
     beta_x(1:model.Npx0)  = beta_x(model.Npx0+1);
     alpha_x(1:model.Npx0) = alpha_x(model.Npx0+1);
     
     d_x((model.Nx - model.Npx0+1):model.Nx )         = d_x(model.Nx - model.Npx0);
     beta_x((model.Nx - model.Npx0+1):model.Nx )      = beta_x(model.Nx - model.Npx0);
     alpha_x((model.Nx - model.Npx0+1):model.Nx )     = alpha_x(model.Nx - model.Npx0);
     
%      PMLs.d_x=d_x;
%      PMLs.beta_x=beta_x;
%      PMLs.alpha_x=alpha_x;
     


for jj=1:model.Nz  
    
      d_z(jj)     = 0;
      beta_z(jj)  = 1;  
      alpha_z(jj) = alpha0;
    
    % define damping profile at down PML boundary 
    if  (jj >= (model.Npz0+1)) && (jj <= (model.Npz0+model.Npz+1))
        
      d_z(jj)     = d0*((model.Npz0+model.Npz-(jj-1))/model.Npz)^mm;
      beta_z(jj)  = 1+(beta0-1)*((model.Npz0+model.Npz-(jj-1))/model.Npz)^mm;  
      alpha_z(jj) = alpha0*(1-(model.Npz0+model.Npz-(jj-1))/model.Npz);
      
    end
    
    % define damping profile at up PML boundary 
    if (jj >= (model.Nz - (model.Npz+model.Npz0))) &&(jj <= (model.Nz -model.Npz0))
          
      d_z(jj)     = d0*((jj-(model.Nz-(model.Npz+model.Npz0)))/model.Npz)^mm;
      beta_z(jj)  = 1+(beta0-1)*((jj-(model.Nz-(model.Npz+model.Npz0)))/model.Npz)^mm;  
      alpha_z(jj) = alpha0*(1-((jj-(model.Nz-(model.Npz+model.Npz0)))/model.Npz));
      
    end 
    
end

%                    d_z(model.Npz0+1)=d_z(model.Npz0+2);      %
%                    beta_z(model.Npz0+1)=beta_z(model.Npz0+2);
%                    alpha_z(model.Npz0+1)=alpha_z(model.Npz0+2);
%                     d_z(model.Nz - model.Npz0)= d_z(model.Nz - model.Npz0-1);
%                    beta_z(model.Nz - model.Npz0)=beta_z(model.Nz - model.Npz0-1);
%                    alpha_z(model.Nz - model.Npz0)=alpha_z(model.Nz - model.Npz0-1);
                   

     d_z(1:model.Npz0)     = d_z(model.Npz0+1);           % 附加层中取与PML中一样
     beta_z(1:model.Npz0)  = beta_z(model.Npz0+1);
     alpha_z(1:model.Npz0) = alpha_z(model.Npz0+1);
     
     d_z((model.Nz - model.Npz0+1):model.Nz )         = d_z(model.Nz - model.Npz0);
     beta_z((model.Nz - model.Npz0+1):model.Nz )      = beta_z(model.Nz - model.Npz0);
     alpha_z((model.Nz - model.Npz0+1):model.Nz )     = alpha_z(model.Nz - model.Npz0);

     
     


% calculate sx and sy
for jj=1:model.Nz
    for ii=1:model.Nx
        
        % activate damping in PMLs
        sx(jj,ii) = beta_x(ii)+d_x(ii)/(alpha_x(ii)-1i*omega);
        sz(jj,ii) = beta_z(jj)+d_z(jj)/(alpha_z(jj)-1i*omega); %2017.8.31
        
      
        % deactivate damping in PMLs
%         sx(j,i) = 1.0;
%         sy(j,i) = 1.0;

    end
end

if model.model_free_surface ==1
    
       temp0 = (model.Nz - (model.Npz+model.Npz0)); % 模型顶部考虑是自由地表，不需要吸收
       sz(temp0:model.Nz,:) = 1;
%          temp0 = ((model.Npz+model.Npz0)); % 模型顶部考虑是自由地表，不需要吸收
%          sz(1:temp0,:) = 1;
end



PMLs.sx = sx ;
PMLs.sy = sz ;

%  for jj=2:(model.Nz-1)
%      for ii=2:(model.Nx-1)
%          
%          PMLs.sx(jj,ii) = (sx(jj,ii) + sx(jj,ii+1))/2.0;
%          PMLs.sz(jj,ii) = (sz(jj,ii) + sz(jj+1,ii))/2.0;
%        
%          
%      end
%  end



end
