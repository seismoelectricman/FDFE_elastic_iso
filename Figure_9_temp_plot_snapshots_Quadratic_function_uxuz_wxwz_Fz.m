
 
t_points=model.t_points;  % t_points=1024;
Nx1     = model.Nx-2;

Nz1     = model.Nz-model.Npz0-model.Npz1;
Nz2     = model.Nz-2;

Nx=model.Nx;
Nz=model.Nz;

Npx    = model.Npx;
Npz    = model.Npz;
Npx0   = model.Npx0;
Npz0   = model.Npz0;
Npz1   = model.Npz1;

delt_t = model.delt_t; % 0.002s

dx     = model.dx;
dz     = model.dz;
%  model.source_type=2;
%Nz =0;
Nxz1    = Nx1*Nz1 ;
Nxz2    = Nx1*Nz2 ;

t=[0:(t_points-1)]*delt_t;  


ux_all=real(ux_rrtt(1:Nxz2,:));
uy_all=real(uy_rrtt(1:Nxz2,:));
wx_all=real(wx_rrtt(1:Nxz2,:));
wy_all=real(wy_rrtt(1:Nxz2,:));



source_ii = model.source_ii;
S_offset  = source_ii*dx;
up_free   = (Npz0+Npz1)*dz;


  output_rwb;
  %  color1=rwb; 
  color1=gray;
   
   
  if model.source_type==1
%     scale_u=1e-6;
%     scale_E=5e-9;
      scale_u=8e-12;
      scale_E=7e-16;

  elseif model.source_type ==2
      scale_u=2e-11; % 2e-17
      scale_w=6e-16;  % 1e-8
  end

%       vidObj = VideoWriter('peaks.avi');
%       open(vidObj);     

    margin1=[0.07,0.07]   
%     margin1=[0.1,0.1] 
    figure(90);
%     set(gcf,'position',[100,100,1400,800])
   set(gcf,'position',[200,10,1010,1100])
   
%  for ii=1:300
%  for ii=130:131
 for ii=140:141   % 39:40(a); 85:86(b)  80:90

    t_interval=ii*3;
%     t_interval1=ii*3+40;
    
%    t_interval_tep=(ii+20)*3;   
%     t_interval_tep1=(ii+20)*3;
     
    ux0=ux_all(:,t_interval);   
    uy0=uy_all(:,t_interval);
    wx0=wx_all(:,t_interval);   
    wy0=wy_all(:,t_interval);
    
    ux_z_x0=reshape(ux0,Nx1,Nz2);
    uy_z_x0=reshape(uy0,Nx1,Nz2);
    wx_z_x0=reshape(wx0,Nx1,Nz2);
    wy_z_x0=reshape(wy0,Nx1,Nz2);

    ux_z_x=ux_z_x0.';
    uy_z_x=uy_z_x0.';
    wx_z_x=wx_z_x0.';
    wy_z_x=wy_z_x0.';
    
    ux_slice=zeros(Nz,Nx);
    uy_slice=zeros(Nz,Nx);
    wx_slice=zeros(Nz,Nx);
    wy_slice=zeros(Nz,Nx);
    
    ux_slice_1=zeros(Nz,Nx);
    uy_slice_1=zeros(Nz,Nx);
    wx_slice_1=zeros(Nz,Nx);
    wy_slice_1=zeros(Nz,Nx);
    
   ux_slice_1(2:(Nz-1),2:(Nx-1))=ux_z_x(:,:);
   uy_slice_1(2:(Nz-1),2:(Nx-1))=uy_z_x(:,:);
   wx_slice_1(2:(Nz-1),2:(Nx-1))=wx_z_x(:,:);
   wy_slice_1(2:(Nz-1),2:(Nx-1))=wy_z_x(:,:);
    
    
    for jk = 1: Nz
       
        ux_slice(jk,:)=ux_slice_1(Nz-jk+1,:);
        uy_slice(jk,:)=uy_slice_1(Nz-jk+1,:);
        wx_slice(jk,:)=wx_slice_1(Nz-jk+1,:);
        wy_slice(jk,:)=wy_slice_1(Nz-jk+1,:);
        
     %   uy_slice_tep(jk,:)=uy_slice_1tep(Nz-jk+1,:);
     %   Ey_slice_tep(jk,:)=Ey_slice_1tep(Nz-jk+1,:); % reverse
        
    end
    
    x0=(1:Nx)*dx-S_offset;
    z0=(1:Nz)*dz-up_free;
    
%     x0=(1:Nx);
%     z0=(1:Nz);

  %---------------------------------------------------------        
       subplot_tight(2,2,1,margin1)
       
%           x0=((1:Nx)-0)*dx;
%           z0=((1:Nz1)-0)*dz;
       
          scale1=[-1e-1,1e-1]*scale_u;
%         
          imagesc(x0,z0,ux_slice,scale1);   hold on       
%         imagesc(x0,z0,uy_z_x,scale1);   hold on
          title(['(a) u_x     (Time = ',num2str(t_interval*delt_t*1000),'ms)']) 
%            
%         set(gca,'ytick',[-50,0,50,100,150,200],'ydir','normal')
%         set(gca,'ytick',[-50,0,50,100,150,200],'ydir','reverse')
%         set(gca,'ytick',[0,100,200,300,400,500],'ydir','reverse')

          set(gca,'ytick',[0,400,800,1200,1600],'ydir','reverse')
          set(gca,'FontSize',12)
%         xlim([0,Nx]);ylim([0,Nz]);axis equal;
          xlim([-S_offset,Nx*dx-S_offset]);ylim([-up_free,Nz*dz-up_free]);axis equal;
%         xlabel('Grid point (x)');ylabel('Grid point (z)');
          xlabel('Offset (m)');ylabel('Depth (m)');
           
          colormap(color1);  
%         colormap(gray); 
          h2=colorbar;
          set(h2,'ylim',[scale1(1),scale1(2)],'ytick',[scale1(1),0,scale1(2)],'Fontsize',12)
          
          plot((model.source_ii)*dx-S_offset,(Nz-model.source_jj)*dz-up_free,'bP','markersize',8); 
          
%         plot((model.source_ii)*dx,(Nz-model.source_jj)*dz,'bP','markersize',10); 

          line([Npx0,Npx0]*dx-S_offset,[Npz0,Nz-Npz0]*dz-up_free,'color',[0,0,0])
          line([Nx-Npx0,Nx-Npx0]*dx-S_offset,[Npz0,Nz-Npz0]*dz-up_free,'color',[0,0,0])
 %          line([Npx0,Nx-Npx0,]*dx-S_offset,[Npz0,Npz0]*dz-up_free,'color',[0,0,0])
%           line([Npx0,Nx-Npx0,]*dx-S_offset,[Nz-Npz0,Nz-Npz0]*dz-up_free,'color',[0,0,0])

%            line([0,0]*dx-S_offset,[0,Nz]*dz-up_free,'color',[0,0,0])
%            line([0,Nx]*dx-S_offset,[Nz,Nz]*dz-up_free,'color',[0,0,0])
%            line([Nx,Nx]*dx-S_offset,[0,Nz]*dz-up_free,'color',[0,0,0])
%            line([0,Nx]*dx-S_offset,[0,0]*dz-up_free,'color',[0,0,0])
                
           line([Npx+Npx0,Npx+Npx0]*dx-S_offset,[Nz-Npz0-Npz,Npz0+Npz1]*dz-up_free,'color',[0,0,0]) % left
           line([Nx-Npx-Npx0,Nx-Npx-Npx0]*dx-S_offset,[Nz-Npz0-Npz,Npz0+Npz1]*dz-up_free,'color',[0,0,0]) % right
           line([Npx+Npx0,Nx-Npx-Npx0,]*dx-S_offset,[Nz-Npz0-Npz,Nz-Npz0-Npz]*dz-up_free,'color',[0,0,0]) % bottom
                                
           line([Npx0,Nx-Npx0]*dx-S_offset,[Npz0+Npz1,Npz0+Npz1]*dz-up_free,'color',[0,0,0])

           line([Npx0+Npx,Nx-Npx0-Npx]*dx-S_offset,[Nz-model.inter,Nz-model.inter]*dz-up_free,'color',[0,0,0],'LineWidth',0.5)  
%                
                
                x0_1=100;
%               x0_2=250;
                x0_3=400;
      
                fxx=zeros(1,500);
                fxx_t=zeros(1,500);
                
                aa=(1:1:500);
      
                for ii=1:500

%                    fxx(ii)=-(((ii-x0_1)*(ii-x0_2)*(ii-x0_3)/(1e6)*15+170)-500);
%                    fxx(ii)=-((-((ii-x0_1)*(ii-x0_3)/(1e4)*60)+120)-500);
                     fxx(ii)=-((-(2.4*(ii-x0_1)*(ii-x0_3)/(1e4)*60)-70)-500);
                     fxx_t(ii)=round(fxx(ii));
                     
                end
                
%               aa_t   = aa(90:411);
%               fxx_tt = fxx_t(90:411);

                aa_t   = aa(160:340);
                fxx_tt = fxx_t(160:340);
                
%               plot(aa_t,fxx_tt,'LineWidth',1,'color',[0,0,0]);
                plot(aa_t*dx-S_offset,fxx_tt*dz-up_free,'LineWidth',1,'color',[0,0,0]);
%                 
%               line([0,160]*dx-S_offset,[360,360]*dz-up_free,'color',[0,0,0]);
%               line([340,500]*dx-S_offset,[360,360]*dz-up_free,'color',[0,0,0]);
%               line([160,340]*dx-S_offset,[360,360]*dz-up_free,'color',[0,0,0]);
                line([160,340]*dx-S_offset,[361,361]*dz-up_free,'color',[0,0,0]);
%               line([0,90]*dx-S_offset,[400,400]*dz-up_free,'color',[0,0,0]);
%               line([410,500]*dx-S_offset,[400,400]*dz-up_free,'color',[0,0,0]);

                                                      
% %---------------------------------------------------------  
      %  Nz1=9;
       subplot_tight(2,2,2,margin1)
       
%           x1=((1:Nx)-0)*dx;
%           z1=((1:Nz2)-0)*dz;
%           scale1=[-1e-1,1e-1]*scale_u;
          scale1=[-1,1]*scale_u;

%            scale1=[-1e-0,1e-0]*scale_E;
           
%           imagesc(x0,z0,Ey_z_x,scale1);   hold on
          imagesc(x0,z0,uy_slice,scale1);   hold on
          
%           t_interval=t_interval+100;
          
          title(['(b) u_z     (Time = ',num2str(t_interval*delt_t*1000),'ms)']) 
          set(gca,'ytick',[0,400,800,1200,1600],'ydir','reverse')
%            set(gca,'ytick',[-50,0,50,100,150,200],'ydir','reverse')
%            set(gca,'ytick',[0,100,200,300,400,500],'ydir','reverse')
           set(gca,'FontSize',12)
%            xlim([0,Nx]);ylim([0,Nz]);axis equal;
           xlim([-S_offset,Nx*dx-S_offset]);ylim([-up_free,Nz*dz-up_free]);axis equal;
           xlabel('Offset (m)');
           %ylabel('Grid point (z)');
           
           colormap(color1);  
%             colormap(gray); 
           h2=colorbar;
           set(h2,'ylim',[scale1(1),scale1(2)],'ytick',[scale1(1),0,scale1(2)],'Fontsize',12)

           plot((model.source_ii)*dx-S_offset,(Nz-model.source_jj)*dz-up_free,'bP','markersize',8); 
           
           line([Npx0,Npx0]*dx-S_offset,[Npz0,Nz-Npz0]*dz-up_free,'color',[0,0,0])
           line([Nx-Npx0,Nx-Npx0]*dx-S_offset,[Npz0,Nz-Npz0]*dz-up_free,'color',[0,0,0])
         %  line([Npx0,Nx-Npx0]*dx-S_offset,[Npz0,Npz0]*dz-up_free,'color',[0,0,0])
         %  line([Npx0,Nx-Npx0]*dx-S_offset,[Nz-Npz0,Nz-Npz0]*dz-up_free,'color',[0,0,0])
% 
%            line([0,0]*dx-S_offset,[0,Nz]*dz-up_free,'color',[0,0,0])
%            line([0,Nx]*dx-S_offset,[Nz,Nz]*dz-up_free,'color',[0,0,0])
%            line([Nx,Nx]*dx-S_offset,[0,Nz]*dz-up_free,'color',[0,0,0])
%            line([0,Nx]*dx-S_offset,[0,0]*dz-up_free,'color',[0,0,0])
                
           line([Npx+Npx0,Npx+Npx0]*dx-S_offset,[Nz-Npz0-Npz,Npz0+Npz1]*dz-up_free,'color',[0,0,0]) % left
           line([Nx-Npx-Npx0,Nx-Npx-Npx0]*dx-S_offset,[Nz-Npz0-Npz,Npz0+Npz1]*dz-up_free,'color',[0,0,0]) % right
           line([Npx+Npx0,Nx-Npx-Npx0,]*dx-S_offset,[Nz-Npz0-Npz,Nz-Npz0-Npz]*dz-up_free,'color',[0,0,0]) % bottom
                                
           line([Npx0,Nx-Npx0]*dx-S_offset,[Npz0+Npz1,Npz0+Npz1]*dz-up_free,'color',[0,0,0])    

           line([Npx0+Npx,Nx-Npx0-Npx]*dx-S_offset,[Nz-model.inter,Nz-model.inter]*dz-up_free,'color',[0,0,0],'LineWidth',0.5)  
           % interface


                x0_1=100;
%               x0_2=250;
                x0_3=400;
      
                fxx=zeros(1,500);
                fxx_t=zeros(1,500);
                
                aa=(1:1:500);
      
                for ii=1:500

%                    fxx(ii)=-(((ii-x0_1)*(ii-x0_2)*(ii-x0_3)/(1e6)*15+170)-500);
%                    fxx(ii)=-((-((ii-x0_1)*(ii-x0_3)/(1e4)*60)+120)-500);
                     fxx(ii)=-((-(2.4*(ii-x0_1)*(ii-x0_3)/(1e4)*60)-70)-500);
                     fxx_t(ii)=round(fxx(ii));
                     
                end
                
%               aa_t   = aa(90:411);
%               fxx_tt = fxx_t(90:411);

                aa_t   = aa(160:340);
                fxx_tt = fxx_t(160:340);
                
%               plot(aa_t,fxx_tt,'LineWidth',1,'color',[0,0,0]);
                plot(aa_t*dx-S_offset,fxx_tt*dz-up_free,'LineWidth',0.8,'color',[0,0,0]);
%                 
%               line([0,160]*dx-S_offset,[360,360]*dz-up_free,'color',[0,0,0]);
%               line([340,500]*dx-S_offset,[360,360]*dz-up_free,'color',[0,0,0]);
%               line([160,340]*dx-S_offset,[360,360]*dz-up_free,'color',[0,0,0]);
                line([160,340]*dx-S_offset,[361,361]*dz-up_free,'color',[0,0,0]);
%               line([0,90]*dx-S_offset,[400,400]*dz-up_free,'color',[0,0,0]);


      subplot_tight(2,2,3,margin1)
       
%           x0=((1:Nx)-0)*dx;
%           z0=((1:Nz1)-0)*dz;
       
          scale1=[-1e-1,1e-1]*scale_w;
%         
          imagesc(x0,z0,wx_slice,scale1);   hold on       
%         imagesc(x0,z0,uy_z_x,scale1);   hold on
          title(['(c) w_x     (Time = ',num2str(t_interval*delt_t*1000),'ms)']) 
%            
%         set(gca,'ytick',[-50,0,50,100,150,200],'ydir','normal')
%         set(gca,'ytick',[-50,0,50,100,150,200],'ydir','reverse')
%         set(gca,'ytick',[0,100,200,300,400,500],'ydir','reverse')

          set(gca,'ytick',[0,400,800,1200,1600],'ydir','reverse')
          set(gca,'FontSize',12)
%         xlim([0,Nx]);ylim([0,Nz]);axis equal;
          xlim([-S_offset,Nx*dx-S_offset]);ylim([-up_free,Nz*dz-up_free]);axis equal;
%         xlabel('Grid point (x)');ylabel('Grid point (z)');
          xlabel('Offset (m)');ylabel('Depth (m)');
           
          colormap(color1);  
%         colormap(gray); 
          h2=colorbar;
          set(h2,'ylim',[scale1(1),scale1(2)],'ytick',[scale1(1),0,scale1(2)],'Fontsize',12)
          
          plot((model.source_ii)*dx-S_offset,(Nz-model.source_jj)*dz-up_free,'bP','markersize',8); 
          
%         plot((model.source_ii)*dx,(Nz-model.source_jj)*dz,'bP','markersize',10); 

           line([Npx0,Npx0]*dx-S_offset,[Npz0,Nz-Npz0]*dz-up_free,'color',[0,0,0])
           line([Nx-Npx0,Nx-Npx0]*dx-S_offset,[Npz0,Nz-Npz0]*dz-up_free,'color',[0,0,0])
%            line([Npx0,Nx-Npx0,]*dx-S_offset,[Npz0,Npz0]*dz-up_free,'color',[0,0,0])
%            line([Npx0,Nx-Npx0,]*dx-S_offset,[Nz-Npz0,Nz-Npz0]*dz-up_free,'color',[0,0,0])
% 
%            line([0,0]*dx-S_offset,[0,Nz]*dz-up_free,'color',[0,0,0])
%            line([0,Nx]*dx-S_offset,[Nz,Nz]*dz-up_free,'color',[0,0,0])
%            line([Nx,Nx]*dx-S_offset,[0,Nz]*dz-up_free,'color',[0,0,0])
    %       line([0,Nx]*dx-S_offset,[0,0]*dz-up_free,'color',[0,0,0])
                
           line([Npx+Npx0,Npx+Npx0]*dx-S_offset,[Nz-Npz0-Npz,Npz0+Npz1]*dz-up_free,'color',[0,0,0]) % left
           line([Nx-Npx-Npx0,Nx-Npx-Npx0]*dx-S_offset,[Nz-Npz0-Npz,Npz0+Npz1]*dz-up_free,'color',[0,0,0]) % right
           line([Npx+Npx0,Nx-Npx-Npx0,]*dx-S_offset,[Nz-Npz0-Npz,Nz-Npz0-Npz]*dz-up_free,'color',[0,0,0]) % bottom
                                
           line([Npx0,Nx-Npx0]*dx-S_offset,[Npz0+Npz1,Npz0+Npz1]*dz-up_free,'color',[0,0,0])
                
           line([Npx0+Npx,Nx-Npx0-Npx]*dx-S_offset,[Nz-model.inter,Nz-model.inter]*dz-up_free,'color',[0,0,0],'LineWidth',0.5)  
                x0_1=100;
%               x0_2=250;
                x0_3=400;
      
                fxx=zeros(1,500);
                fxx_t=zeros(1,500);
                
                aa=(1:1:500);
      
                for ii=1:500

%                    fxx(ii)=-(((ii-x0_1)*(ii-x0_2)*(ii-x0_3)/(1e6)*15+170)-500);
%                    fxx(ii)=-((-((ii-x0_1)*(ii-x0_3)/(1e4)*60)+120)-500);
                     fxx(ii)=-((-(2.4*(ii-x0_1)*(ii-x0_3)/(1e4)*60)-70)-500);
                     fxx_t(ii)=round(fxx(ii));
                     
                end
                
%               aa_t   = aa(90:411);
%               fxx_tt = fxx_t(90:411);

                aa_t   = aa(160:340);
                fxx_tt = fxx_t(160:340);
                
%               plot(aa_t,fxx_tt,'LineWidth',1,'color',[0,0,0]);
                plot(aa_t*dx-S_offset,fxx_tt*dz-up_free,'LineWidth',1,'color',[0,0,0]);
%                 
%               line([0,160]*dx-S_offset,[360,360]*dz-up_free,'color',[0,0,0]);
%               line([340,500]*dx-S_offset,[360,360]*dz-up_free,'color',[0,0,0]);
%               line([160,340]*dx-S_offset,[360,360]*dz-up_free,'color',[0,0,0]);
                line([160,340]*dx-S_offset,[361,361]*dz-up_free,'color',[0,0,0]);
%               line([0,90]*dx-S_offset,[400,400]*dz-up_free,'color',[0,0,0]);
           
       subplot_tight(2,2,4,margin1)
       
%           x0=((1:Nx)-0)*dx;
%           z0=((1:Nz1)-0)*dz;
       
          scale1=[-1e-1,1e-1]*scale_w;
%         
          imagesc(x0,z0,wy_slice,scale1);   hold on       
%         imagesc(x0,z0,uy_z_x,scale1);   hold on
          title(['(d) w_z     (Time = ',num2str(t_interval*delt_t*1000),'ms)']) 
%            
%         set(gca,'ytick',[-50,0,50,100,150,200],'ydir','normal')
%         set(gca,'ytick',[-50,0,50,100,150,200],'ydir','reverse')
%         set(gca,'ytick',[0,100,200,300,400,500],'ydir','reverse')

          set(gca,'ytick',[0,400,800,1200,1600],'ydir','reverse')
          set(gca,'FontSize',12)
%         xlim([0,Nx]);ylim([0,Nz]);axis equal;
          xlim([-S_offset,Nx*dx-S_offset]);ylim([-up_free,Nz*dz-up_free]);axis equal;
%         xlabel('Grid point (x)');ylabel('Grid point (z)');
          xlabel('Offset (m)');% ylabel('Depth (m)');
           
          colormap(color1);  
%         colormap(gray); 
          h2=colorbar;
          set(h2,'ylim',[scale1(1),scale1(2)],'ytick',[scale1(1),0,scale1(2)],'Fontsize',12)
          
          plot((model.source_ii)*dx-S_offset,(Nz-model.source_jj)*dz-up_free,'bP','markersize',8); 
          
%         plot((model.source_ii)*dx,(Nz-model.source_jj)*dz,'bP','markersize',10); 

           line([Npx0,Npx0]*dx-S_offset,[Npz0,Nz-Npz0]*dz-up_free,'color',[0,0,0])
           line([Nx-Npx0,Nx-Npx0]*dx-S_offset,[Npz0,Nz-Npz0]*dz-up_free,'color',[0,0,0])
%            line([Npx0,Nx-Npx0,]*dx-S_offset,[Npz0,Npz0]*dz-up_free,'color',[0,0,0])
%            line([Npx0,Nx-Npx0,]*dx-S_offset,[Nz-Npz0,Nz-Npz0]*dz-up_free,'color',[0,0,0])
% 
%            line([0,0]*dx-S_offset,[0,Nz]*dz-up_free,'color',[0,0,0])
%            line([0,Nx]*dx-S_offset,[Nz,Nz]*dz-up_free,'color',[0,0,0])
%            line([Nx,Nx]*dx-S_offset,[0,Nz]*dz-up_free,'color',[0,0,0])
 %          line([0,Nx]*dx-S_offset,[0,0]*dz-up_free,'color',[0,0,0])
                
           line([Npx+Npx0,Npx+Npx0]*dx-S_offset,[Nz-Npz0-Npz,Npz0+Npz1]*dz-up_free,'color',[0,0,0]) % left
           line([Nx-Npx-Npx0,Nx-Npx-Npx0]*dx-S_offset,[Nz-Npz0-Npz,Npz0+Npz1]*dz-up_free,'color',[0,0,0]) % right
           line([Npx+Npx0,Nx-Npx-Npx0,]*dx-S_offset,[Nz-Npz0-Npz,Nz-Npz0-Npz]*dz-up_free,'color',[0,0,0]) % bottom
                                
           line([Npx0,Nx-Npx0]*dx-S_offset,[Npz0+Npz1,Npz0+Npz1]*dz-up_free,'color',[0,0,0])
line([Npx0+Npx,Nx-Npx0-Npx]*dx-S_offset,[Nz-model.inter,Nz-model.inter]*dz-up_free,'color',[0,0,0],'LineWidth',0.5)  
                
                x0_1=100;
%               x0_2=250;
                x0_3=400;
      
                fxx=zeros(1,500);
                fxx_t=zeros(1,500);
                
                aa=(1:1:500);
      
                for ii=1:500

%                    fxx(ii)=-(((ii-x0_1)*(ii-x0_2)*(ii-x0_3)/(1e6)*15+170)-500);
%                    fxx(ii)=-((-((ii-x0_1)*(ii-x0_3)/(1e4)*60)+120)-500);
                     fxx(ii)=-((-(2.4*(ii-x0_1)*(ii-x0_3)/(1e4)*60)-70)-500);
                     fxx_t(ii)=round(fxx(ii));
                     
                end
                
%               aa_t   = aa(90:411);
%               fxx_tt = fxx_t(90:411);

                aa_t   = aa(160:340);
                fxx_tt = fxx_t(160:340);
                
%               plot(aa_t,fxx_tt,'LineWidth',1,'color',[0,0,0]);
                plot(aa_t*dx-S_offset,fxx_tt*dz-up_free,'LineWidth',1,'color',[0,0,0]);
%                 
%               line([0,160]*dx-S_offset,[360,360]*dz-up_free,'color',[0,0,0]);
%               line([340,500]*dx-S_offset,[360,360]*dz-up_free,'color',[0,0,0]);
%               line([160,340]*dx-S_offset,[360,360]*dz-up_free,'color',[0,0,0]);
                line([160,340]*dx-S_offset,[361,361]*dz-up_free,'color',[0,0,0]);
%               line([0,90]*dx-S_offset,[400,400]*dz-up_free,'color',[0,0,0]);

pause(2.0) 



 end

%  break
 
%  Ey_z_x_296s=Ey_z_x ;
%  uy_z_x_296s=uy_z_x ;  
%  
%  Ey_z_x_360s=Ey_z_x ;
%  uy_z_x_360s=uy_z_x ; 
%  
%  Ey_z_x_420s=Ey_z_x ;
%  uy_z_x_420s=uy_z_x ; 
 
 
% save Figure5_snapshot.mat  x0 z0 Ey_z_x_420s uy_z_x_420s Ey_z_x_360s uy_z_x_360s Ey_z_x_296s uy_z_x_296s 
%        close(vidObj);


