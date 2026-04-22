
% t_points=model.t_points;
% Nx=model.Nx;
% Nz=model.Nz;
% Npx=model.Npx;
% Npz=model.Npz;
% delt_t=model.delt_t;
% Nxz=model.Nxz;
% dx=model.dx;
%   dx=1;
% dz=model.dz;
% 
% Nz1     = model.Nz-model.Npz0-model.Npz1;
% Nz2     = model.Nz-2;
% 
% delt_t=model.delt_t;
% t=[0:(t_points-1)]*delt_t;  
% 
% Nx1     = model.Nx-2;
% 
% Nxz1    = Nx1*Nz1 ;
% Nxz2    = Nx1*Nz2 ;
%source_ii = model.source_ii;
%S_offset  = source_ii*dx;


%t=[0:(t_points-1)]*delt_t;  

load tt.mat
t=tt;

%xlim1=0;xlim2=model.T_length/1  % 时间轴的上限和下限；

  output_rwb;
  % color1=rwb; 
color1=gray;
%% █████████████████████-------------------- heterogeneous medium density speed                  █████████████████████%


load XX

X=XX;

load uz2gh.mat
load wz2gh.mat
load uz2oh.mat
load wz2oh.mat

uz2gh=uz2gh;
wz2gh=wz2gh;

uz2oh=uz2oh;
wz2oh=wz2oh;


uz2ogh=uz2gh-uz2oh;
wz2ogh=wz2gh-wz2oh;

%uz2gh= 

%       scale_u=5e-13;   % 力源
%       scale_E=5e-16;   % 力源
           
       scale_u=1e-12;   % 电流源
       scale_w=1e-20;    % 电流源

       scale_u1=2e-13;   % 电流源
       scale_w1=2e-21;    % 电流源  
            
figure(15)  

set(gcf,'position',[200,10,1000,950])


subplot 321
imagesc(X,t,uz2gh.',[-scale_u,scale_u]);
%xlabel('Offset (m)'); 
ylabel('Time (s)');
ylim([0,1.2]);

% text (1000,0.09,'EM','color','[1,1,0]','Fontsize',12);
% text (300,0.05,'EM','color','[0,0,0]','Fontsize',12);

title(['(a)  u_z  Gas']) ; 

h2=colorbar;
set(h2,'ylim',[-scale_u,scale_u],'ytick',[-scale_u,0,scale_u])
set(gca,'FontSize',12)
set(gca,'Ytick',[0,0.4,0.8,1.2])
set(gca,'Xtick',[-800,-400,0,400,800])
% colormap(color1);


subplot 322
imagesc(X,t,wz2gh.',[-scale_w,scale_w]);

%xlabel('Offset (m)');
ylabel('Time (s)');
% xlim([50,450]);
%xlim([50,450]*dx-S_offset);
ylim([0,1.2]);
% set(gca,'xtick',linspace(Rx(1),Rx(end),3),'fontsize',9);
% text (120,0.17,'S_d','color','[1,1,0]','Fontsize',14);

% text (300,0.05,'EM','color','[0,0,0]','Fontsize',12);
% text (300,0.16,'S','color','[0,0,0]','Fontsize',12);
% text (-50,0.28,'ES1','color','[0,0,0]','Fontsize',12);
% text (-50,0.43,'ES2','color','[0,0,0]','Fontsize',12);
% text (-250,0.56,'EM-S1','color','[0,0,0]','Fontsize',12);
% text (-250,0.85,'EM-S2','color','[0,0,0]','Fontsize',12);


title(['(b)  w_z  Gas']); 

% annotation('arrow',[0.25,0.14],[0.33,0.8],'LineStyle','-','Linewidth',1.5,'color',[1,1,1])   %,'HeadStyle','cback3')
h2=colorbar;
set(h2,'ylim',[-scale_w,scale_w],'ytick',[-scale_w,0,scale_w])
set(gca,'FontSize',12) 
% set(gca,'Xtick',[50,100,150,200,250,300,350])
set(gca,'Ytick',[0,0.4,0.8,1.2])
%set(gca,'Xtick',[-750,-500,-250,0,250,500,750])
set(gca,'Xtick',[-800,-400,0,400,800])
% set(gca,'Xtick',[50,150,250,350,450])
colormap(color1);
% colormap('gray');
%000,-500,0,500,1000])
% colormap(color1);


subplot 323
imagesc(X,t,uz2oh.',[-scale_u,scale_u]);

%xlabel('Offset (m)');
ylabel('Time(s)');
% xlim([50,450]);
% xlim([50,450]*dx-S_offset);
ylim([0,1.2]);
% set(gca,'xtick',linspace(Rx(1),Rx(end),3),'fontsize',9);
% text (120,0.17,'S_d','color','[1,1,0]','Fontsize',14);
% 
% text (300,0.05,'EM','color','[0,0,0]','Fontsize',12);
% text (300,0.16,'S','color','[0,0,0]','Fontsize',12);
% text (-50,0.28,'ES1','color','[0,0,0]','Fontsize',12);
% text (-50,0.43,'ES2','color','[0,0,0]','Fontsize',12);
% text (-250,0.56,'EM-S1','color','[0,0,0]','Fontsize',12);
% text (-250,0.85,'EM-S2','color','[0,0,0]','Fontsize',12);


title(['(c)  u_z  Oil']); 

% annotation('arrow',[0.25,0.14],[0.33,0.8],'LineStyle','-','Linewidth',1.5,'color',[1,1,1])   %,'HeadStyle','cback3')
h2=colorbar;
set(h2,'ylim',[-scale_u,scale_u],'ytick',[-scale_u,0,scale_u])
set(gca,'FontSize',12) 
% set(gca,'Xtick',[50,100,150,200,250,300,350])
% set(gca,'Xtick',[60,150,250,350,440])
set(gca,'Ytick',[0,0.4,0.8,1.2])
set(gca,'Xtick',[-800,-400,0,400,800])
%set(gca,'Xtick',[-750,-500,-250,0,250,500,750])
% set(gca,'Xtick',[-500,0,500,1000,1500])
% set(gca,'Xtick',[50,150,250,350,450])
colormap(color1);
% colormap('gray');
%000,-500,0,500,1000])
% colormap(color1);

subplot 324
imagesc(X,t,wz2oh.',[-scale_w,scale_w]);

%xlabel('Offset (m)');
ylabel('Time(s)');
% xlim([50,450]);
%xlim([50,450]*dx-S_offset);
ylim([0,1.2]);
% set(gca,'xtick',linspace(Rx(1),Rx(end),3),'fontsize',9);
% text (120,0.17,'S_d','color','[1,1,0]','Fontsize',14);

% text (300,0.05,'EM','color','[0,0,0]','Fontsize',12);
% text (300,0.16,'S','color','[0,0,0]','Fontsize',12);
% text (-50,0.28,'ES1','color','[0,0,0]','Fontsize',12);
% text (-50,0.43,'ES2','color','[0,0,0]','Fontsize',12);
% text (-250,0.56,'EM-S1','color','[0,0,0]','Fontsize',12);
% text (-250,0.85,'EM-S2','color','[0,0,0]','Fontsize',12);


title(['(d)  w_z  Oil']); 

% annotation('arrow',[0.25,0.14],[0.33,0.8],'LineStyle','-','Linewidth',1.5,'color',[1,1,1])   %,'HeadStyle','cback3')
h2=colorbar;
set(h2,'ylim',[-scale_w,scale_w],'ytick',[-scale_w,0,scale_w])
set(gca,'FontSize',12) 
% set(gca,'Xtick',[50,100,150,200,250,300,350])
% set(gca,'Xtick',[60,150,250,350,440])
set(gca,'Ytick',[0,0.4,0.8,1.2])
set(gca,'Xtick',[-800,-400,0,400,800])
%set(gca,'Xtick',[-750,-500,-250,0,250,500,750])
% set(gca,'Xtick',[-500,0,500,1000,1500])
% set(gca,'Xtick',[50,150,250,350,450])
colormap(color1);
% colormap('gray');
%000,-500,0,500,1000])
% colormap(color1);

subplot 325
imagesc(X,t,uz2ogh.',[-scale_u1,scale_u1]);

xlabel('Offset (m)');
ylabel('Time(s)');
% xlim([50,450]);
% xlim([50,450]*dx-S_offset);
ylim([0,1.2]);
% set(gca,'xtick',linspace(Rx(1),Rx(end),3),'fontsize',9);
% text (120,0.17,'S_d','color','[1,1,0]','Fontsize',14);
% 
% text (300,0.05,'EM','color','[0,0,0]','Fontsize',12);
% text (300,0.16,'S','color','[0,0,0]','Fontsize',12);
% text (-50,0.28,'ES1','color','[0,0,0]','Fontsize',12);
% text (-50,0.43,'ES2','color','[0,0,0]','Fontsize',12);
% text (-250,0.56,'EM-S1','color','[0,0,0]','Fontsize',12);
% text (-250,0.85,'EM-S2','color','[0,0,0]','Fontsize',12);


title(['(e)  u_z  Oil-Gas']); 

% annotation('arrow',[0.25,0.14],[0.33,0.8],'LineStyle','-','Linewidth',1.5,'color',[1,1,1])   %,'HeadStyle','cback3')
h2=colorbar;
set(h2,'ylim',[-scale_u1,scale_u1],'ytick',[-scale_u1,0,scale_u1])
set(gca,'FontSize',12) 
% set(gca,'Xtick',[50,100,150,200,250,300,350])
% set(gca,'Xtick',[60,150,250,350,440])
set(gca,'Ytick',[0,0.4,0.8,1.2])
set(gca,'Xtick',[-800,-400,0,400,800])
%set(gca,'Xtick',[-750,-500,-250,0,250,500,750])
% set(gca,'Xtick',[-500,0,500,1000,1500])
% set(gca,'Xtick',[50,150,250,350,450])
colormap(color1);
% colormap('gray');
%000,-500,0,500,1000])
% colormap(color1);

subplot 326
imagesc(X,t,wz2ogh.',[-scale_w1,scale_w1]);

xlabel('Offset (m)');
ylabel('Time(s)');
% xlim([50,450]);
% xlim([50,450]*dx-S_offset);
ylim([0,1.2]);
% set(gca,'xtick',linspace(Rx(1),Rx(end),3),'fontsize',9);
% text (120,0.17,'S_d','color','[1,1,0]','Fontsize',14);
% 
% text (300,0.05,'EM','color','[0,0,0]','Fontsize',12);
% text (300,0.16,'S','color','[0,0,0]','Fontsize',12);
% text (-50,0.28,'ES1','color','[0,0,0]','Fontsize',12);
% text (-50,0.43,'ES2','color','[0,0,0]','Fontsize',12);
% text (-250,0.56,'EM-S1','color','[0,0,0]','Fontsize',12);
% text (-250,0.85,'EM-S2','color','[0,0,0]','Fontsize',12);


title(['(f)  w_z  Oil-Gas']); 

% annotation('arrow',[0.25,0.14],[0.33,0.8],'LineStyle','-','Linewidth',1.5,'color',[1,1,1])   %,'HeadStyle','cback3')
h2=colorbar;
set(h2,'ylim',[-scale_w1,scale_w1],'ytick',[-scale_w1,0,scale_w1])
set(gca,'FontSize',12) 
% set(gca,'Xtick',[50,100,150,200,250,300,350])
% set(gca,'Xtick',[60,150,250,350,440])
set(gca,'Ytick',[0,0.4,0.8,1.2])
set(gca,'Xtick',[-800,-400,0,400,800])
%set(gca,'Xtick',[-750,-500,-250,0,250,500,750])
% set(gca,'Xtick',[-500,0,500,1000,1500])
% set(gca,'Xtick',[50,150,250,350,450])
colormap(color1);
% colormap('gray');
%000,-500,0,500,1000])
% colormap(color1);

