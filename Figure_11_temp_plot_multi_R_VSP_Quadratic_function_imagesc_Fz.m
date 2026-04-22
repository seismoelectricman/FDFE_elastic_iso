
t_points=model.t_points;
Nx=model.Nx;
Nz=model.Nz;
Npx=model.Npx;
Npz=model.Npz;
delt_t=model.delt_t;
Nxz=model.Nxz;
dx=model.dx;
%   dx=1;
dz=model.dz;

Nz1     = model.Nz-model.Npz0-model.Npz1;
Nz2     = model.Nz-2;

delt_t=model.delt_t;
t=[0:(t_points-1)]*delt_t;  

Nx1     = model.Nx-2;

Nxz1    = Nx1*Nz1 ;
Nxz2    = Nx1*Nz2 ;

source_ii = model.source_ii;
S_offset  = source_ii*dx;
inter_offset = (model.Npz1)*(model.dz);

t=[0:(t_points-1)]*delt_t;  

ux_all=real(ux_rrtt(1:Nxz2,:));
uz_all=real(uy_rrtt(1:Nxz2,:));
wx_all=real(wx_rrtt(1:Nxz2,:));
wz_all=real(wy_rrtt(1:Nxz2,:));


% uy_all=real(x2_rrtt(1:Nxz,:));   % 得到时间域，对于所有时间点，对应位移值得实部；
% Ey_all=real(x2_rrtt((1:Nxz)+Nxz,:));

xlim1=0;xlim2=model.T_length/1  % 时间轴的上限和下限；

  output_rwb;
  % color1=rwb; 
color1=gray;
%% █████████████████████-------------------- heterogeneous medium density speed                  █████████████████████%


for in=1:400

% ii=49+in*1;
% jj=457;

 ii=400;
 jj=459-in*1;

kk=ii+(jj-1)*(Nx-2);    % 第90 行，从左往右，从50到250个网格点的所有时间节点对应的位移值；

% X(in)=(ii)*dx-S_offset;
% Z(in)=jj;

X(in)=(ii)*dx-S_offset;
Z(in)=(-1)*(jj-459)*dz-inter_offset;

%inter_offset

ux2(in,:)=ux_all(kk,:);
uz2(in,:)=uz_all(kk,:);
wx2(in,:)=wx_all(kk,:);
wz2(in,:)=wz_all(kk,:);

% Ey3=abs(Ey2);

end



%       scale_u=5e-13;   % 力源
%       scale_E=5e-16;   % 力源
           
       scale_u=1e-12;   % 电流源
       scale_w=1e-17;    % 电流源     
            
figure(10)  

set(gcf,'position',[200,50,1000,900])


subplot 221
imagesc(t,Z,ux2.',[-scale_u,scale_u]);
ylabel('Depth (m)');  xlabel('Time (s)');
xlim([0,1.5]);

% text (1000,0.09,'EM','color','[1,1,0]','Fontsize',12);
% text (300,0.05,'EM','color','[0,0,0]','Fontsize',12);

title(['(a)     u_x']) ; 

h2=colorbar;
set(h2,'ylim',[-scale_u,scale_u],'ytick',[-scale_u,0,scale_u])
set(gca,'FontSize',12)
% set(gca,'Xtick',[60,150,250,350,440])
%set(gca,'Xtick',[-750,-500,-250,0,250,500,750])
% colormap(color1);


subplot 222
imagesc(t,Z,uz2.',[-scale_u,scale_u]);

ylabel('Offset (m)');xlabel('Time (s)');
% xlim([50,450]);
%xlim([50,450]*dx-S_offset);
xlim([0,1.5]);
% set(gca,'xtick',linspace(Rx(1),Rx(end),3),'fontsize',9);
% text (120,0.17,'S_d','color','[1,1,0]','Fontsize',14);

% text (300,0.05,'EM','color','[0,0,0]','Fontsize',12);
% text (300,0.16,'S','color','[0,0,0]','Fontsize',12);
% text (-50,0.28,'ES1','color','[0,0,0]','Fontsize',12);
% text (-50,0.43,'ES2','color','[0,0,0]','Fontsize',12);
% text (-250,0.56,'EM-S1','color','[0,0,0]','Fontsize',12);
% text (-250,0.85,'EM-S2','color','[0,0,0]','Fontsize',12);


title(['(b)     u_z']); 

% annotation('arrow',[0.25,0.14],[0.33,0.8],'LineStyle','-','Linewidth',1.5,'color',[1,1,1])   %,'HeadStyle','cback3')
h2=colorbar;
set(h2,'ylim',[-scale_u,scale_u],'ytick',[-scale_u,0,scale_u])
set(gca,'FontSize',12) 
% set(gca,'Xtick',[50,100,150,200,250,300,350])
% set(gca,'Xtick',[60,150,250,350,440])
set(gca,'Xtick',[-750,-500,-250,0,250,500,750])
% set(gca,'Xtick',[-500,0,500,1000,1500])
% set(gca,'Xtick',[50,150,250,350,450])
colormap(color1);
% colormap('gray');
%000,-500,0,500,1000])
% colormap(color1);


subplot 223
imagesc(t,Z,wx2.',[-scale_w,scale_w]);

ylabel('Offset (m)');xlabel('Time(s)');
% xlim([50,450]);
% xlim([50,450]*dx-S_offset);
xlim([0,1.5]);
% set(gca,'xtick',linspace(Rx(1),Rx(end),3),'fontsize',9);
% text (120,0.17,'S_d','color','[1,1,0]','Fontsize',14);
% 
% text (300,0.05,'EM','color','[0,0,0]','Fontsize',12);
% text (300,0.16,'S','color','[0,0,0]','Fontsize',12);
% text (-50,0.28,'ES1','color','[0,0,0]','Fontsize',12);
% text (-50,0.43,'ES2','color','[0,0,0]','Fontsize',12);
% text (-250,0.56,'EM-S1','color','[0,0,0]','Fontsize',12);
% text (-250,0.85,'EM-S2','color','[0,0,0]','Fontsize',12);


title(['(c)     w_x']); 

% annotation('arrow',[0.25,0.14],[0.33,0.8],'LineStyle','-','Linewidth',1.5,'color',[1,1,1])   %,'HeadStyle','cback3')
h2=colorbar;
set(h2,'ylim',[-scale_w,scale_w],'ytick',[-scale_w,0,scale_w])
set(gca,'FontSize',12) 
% set(gca,'Xtick',[50,100,150,200,250,300,350])
% set(gca,'Xtick',[60,150,250,350,440])
%set(gca,'Xtick',[-750,-500,-250,0,250,500,750])
% set(gca,'Xtick',[-500,0,500,1000,1500])
% set(gca,'Xtick',[50,150,250,350,450])
colormap(color1);
% colormap('gray');
%000,-500,0,500,1000])
% colormap(color1);

subplot 224
imagesc(t,Z,wz2.',[-scale_w,scale_w]);

xlabel('Offset (m)');ylabel('Time(s)');
% xlim([50,450]);
% xlim([50,450]*dx-S_offset);
xlim([0,1.5]);
% set(gca,'xtick',linspace(Rx(1),Rx(end),3),'fontsize',9);
% text (120,0.17,'S_d','color','[1,1,0]','Fontsize',14);

% text (300,0.05,'EM','color','[0,0,0]','Fontsize',12);
% text (300,0.16,'S','color','[0,0,0]','Fontsize',12);
% text (-50,0.28,'ES1','color','[0,0,0]','Fontsize',12);
% text (-50,0.43,'ES2','color','[0,0,0]','Fontsize',12);
% text (-250,0.56,'EM-S1','color','[0,0,0]','Fontsize',12);
% text (-250,0.85,'EM-S2','color','[0,0,0]','Fontsize',12);


title(['(d)     w_z']); 

% annotation('arrow',[0.25,0.14],[0.33,0.8],'LineStyle','-','Linewidth',1.5,'color',[1,1,1])   %,'HeadStyle','cback3')
h2=colorbar;
set(h2,'ylim',[-scale_w,scale_w],'ytick',[-scale_w,0,scale_w])
set(gca,'FontSize',12) 
% set(gca,'Xtick',[50,100,150,200,250,300,350])
% set(gca,'Xtick',[60,150,250,350,440])
set(gca,'Xtick',[-750,-500,-250,0,250,500,750])
% set(gca,'Xtick',[-500,0,500,1000,1500])
% set(gca,'Xtick',[50,150,250,350,450])
colormap(color1);
% colormap('gray');
%000,-500,0,500,1000])
% colormap(color1);

