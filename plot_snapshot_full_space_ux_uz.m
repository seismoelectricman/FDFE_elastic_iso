
 
t_points=model.t_points;  % t_points=1024;
Nx1     = model.Nx-2;

Nz1     = model.Nz-2;

Nx=model.Nx;
Nz=model.Nz;

Npx    = model.Npx;
Npz    = model.Npz;
Npx0   = model.Npx0;
Npz0   = model.Npz0;
%Npz1   = model.Npz1;

delt_t = model.delt_t; % 0.002s

dx     = model.dx;
dz     = model.dz;
%  model.source_type=2;
%Nz =0;
Nxz1    = Nx1*Nz1 ;
%Nxz2    = Nx1*Nz2 ;

t=[0:(t_points-1)]*delt_t;  

ux_all=real(ux_rrtt(1:Nxz1,:));
uy_all=real(uy_rrtt(1:Nxz1,:));

dx=1;
dz=1;


  output_rwb;
   color1=gray; 
   
   
  if model.source_type==2
      scale_u=2e-12;
      scale_w=8e-17;
      scale_E=5e-12;
  elseif model.source_type ==6
      scale_u=1e-14;
      scale_w=5e-15;
      scale_E=5e-4;
  end

%       vidObj = VideoWriter('peaks.avi');
%       open(vidObj);     

%  margin1=[0.06,0.06]   
   margin1=[0.01,0.01] 
    figure(35);
%     set(gcf,'position',[100,100,1400,800])
   set(gcf,'position',[100,5,1000,1000])
   
%  for ii=1:300
%   for ii=130:131
  for ii=80:81   

    t_interval=ii*3;
     
    ux0=ux_all(:,t_interval);
    uy0=uy_all(:,t_interval);
    
    ux_z_x0=reshape(ux0,Nx1,Nz1);
    uy_z_x0=reshape(uy0,Nx1,Nz1);
    
    ux_z_x=ux_z_x0.';
    uy_z_x=uy_z_x0.';
    
    ux_slice=zeros(Nz,Nx);
    uy_slice=zeros(Nz,Nx);
 
    ux_slice(2:(Nz-1),2:(Nx-1))=ux_z_x(:,:);
    uy_slice(2:(Nz-1),2:(Nx-1))=uy_z_x(:,:);
    
    x0=(1:Nx);
    z0=(1:Nz);

  %---------------------------------------------------------        
       subplot_tight(1,2,1,margin1)
       
          scale1=[-1e-1,1e-1]*scale_u;
%         
           imagesc(x0,z0,ux_slice,scale1);   hold on       
%          imagesc(x0,z0,uy_z_x,scale1);   hold on
           title(['u_x     (Time = ',num2str(t_interval*delt_t*1000),'ms)']) 
%            
%          set(gca,'ytick',[-50,0,50,100,150,200],'ydir','normal')
%          set(gca,'ytick',[-50,0,50,100,150,200],'ydir','reverse')
           set(gca,'ytick',[0,200,400],'ydir','reverse')
           set(gca,'FontSize',15)
           xlim([0,Nx]);ylim([0,Nz]);axis equal;
           xlabel('Grid point (x)');ylabel('Grid point (z)');
           
           colormap(color1);  
            h2=colorbar;
           set(h2,'ylim',[scale1(1),scale1(2)],'ytick',[scale1(1),0,scale1(2)],'Fontsize',15)
            
%            plot((model.source_ii)*dx,(model.source_jj)*dz,'yP','markersize',12); 
           
                line([Npx0,Npx0]*dx,[Npz0,Nz-Npz0]*dz,'color',[0,0,0])
                line([Nx-Npx0,Nx-Npx0]*dx,[Npx0,Nz-Npz0]*dz,'color',[0,0,0])
                line([Npx0,Nx-Npx0,]*dx,[Npz0,Npz0]*dz,'color',[0,0,0])
                line([Npx0,Nx-Npx0,]*dx,[Nz-Npz0,Nz-Npz0]*dz,'color',[0,0,0])
%                 
                line([0,0]*dx,[0,Nz]*dz,'color',[0,0,0])
                line([0,Nx]*dx,[Nz,Nz]*dz,'color',[0,0,0])
                line([Nx,Nx]*dx,[0,Nz]*dz,'color',[0,0,0])
                line([0,Nx]*dx,[0,0]*dz,'color',[0,0,0])
%                  
                line([Npx+Npx0,Npx+Npx0]*dx,[Npz+Npz0,Nz-Npz0-Npz]*dz,'color',[0,0,0]) % left
                line([Nx-Npx-Npx0,Nx-Npx-Npx0]*dx,[Npz+Npz0,Nz-Npz0-Npz]*dz,'color',[0,0,0])  % right              
                line([Npx+Npx0,Nx-Npx-Npx0,]*dx,[Npz+Npz0,Npz+Npz0]*dz,'color',[0,0,0])   % bottom             
                line([Npx+Npx0,Nx-Npx-Npx0,]*dx,[Nz-Npz0-Npz,Nz-Npz0-Npz]*dz,'color',[0,0,0]) % 
                
%                 line([0,Nx]*dx,[model.interface_z,model.interface_z]*dz,'color',[0,0,0])
 
 %---------------------------------------------------------   
 
       subplot_tight(1,2,2,margin1)
       
          scale1=[-1e-1,1e-1]*scale_u;
%         
           imagesc(x0,z0,uy_slice,scale1);   hold on       
%          imagesc(x0,z0,uy_z_x,scale1);   hold on
           title(['u_z     (Time = ',num2str(t_interval*delt_t*1000),'ms)']) 
%            
%          set(gca,'ytick',[-50,0,50,100,150,200],'ydir','normal')
%          set(gca,'ytick',[-50,0,50,100,150,200],'ydir','reverse')
           set(gca,'ytick',[0,200,400],'ydir','reverse')
           set(gca,'FontSize',15)
           xlim([0,Nx]);ylim([0,Nz]);axis equal;
           xlabel('Grid point (x)');ylabel('Grid point (z)');
           
           colormap(color1);  
            h2=colorbar;
           set(h2,'ylim',[scale1(1),scale1(2)],'ytick',[scale1(1),0,scale1(2)],'Fontsize',15)
            
%            plot((model.source_ii)*dx,(model.source_jj)*dz,'yP','markersize',12); 
           
                line([Npx0,Npx0]*dx,[Npz0,Nz-Npz0]*dz,'color',[0,0,0])
                line([Nx-Npx0,Nx-Npx0]*dx,[Npx0,Nz-Npz0]*dz,'color',[0,0,0])
                line([Npx0,Nx-Npx0,]*dx,[Npz0,Npz0]*dz,'color',[0,0,0])
                line([Npx0,Nx-Npx0,]*dx,[Nz-Npz0,Nz-Npz0]*dz,'color',[0,0,0])
%                 
                line([0,0]*dx,[0,Nz]*dz,'color',[0,0,0])
                line([0,Nx]*dx,[Nz,Nz]*dz,'color',[0,0,0])
                line([Nx,Nx]*dx,[0,Nz]*dz,'color',[0,0,0])
                line([0,Nx]*dx,[0,0]*dz,'color',[0,0,0])
%                  
                line([Npx+Npx0,Npx+Npx0]*dx,[Npz+Npz0,Nz-Npz0-Npz]*dz,'color',[0,0,0]) % left
                line([Nx-Npx-Npx0,Nx-Npx-Npx0]*dx,[Npz+Npz0,Nz-Npz0-Npz]*dz,'color',[0,0,0])  % right              
                line([Npx+Npx0,Nx-Npx-Npx0,]*dx,[Npz+Npz0,Npz+Npz0]*dz,'color',[0,0,0])   % bottom             
                line([Npx+Npx0,Nx-Npx-Npx0,]*dx,[Nz-Npz0-Npz,Nz-Npz0-Npz]*dz,'color',[0,0,0]) % 
                
%                line([0,Nx]*dx,[model.interface_z,model.interface_z]*dz,'color',[0,0,0])
%---------------------------------------------------------              

pause(2.0) 



 end



