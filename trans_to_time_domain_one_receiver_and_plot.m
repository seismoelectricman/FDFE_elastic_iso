

read_model=0
if read_model==1
     
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
       model.wave_length_S    = min(model.Vch_s)/model.fmax;
 
       model.x1_rrff=zeros(model.Nx*model.Nz,model.fft_ftn); 
       model.x2_rrff=zeros(2*model.Nx*model.Nz,model.fft_ftn); 
       model.model_length=(model.Nx-model.Npx)*model.dx;
   
       fprintf('wave_length_S= %8.6f\n', model.wave_length_S);
       fprintf('           dx= %8.6f\n', model.dx);
       fprintf(' model_length= %8.6f\n', model.model_length);
       fprintf('       P time= %8.6f\n', model.model_length/max(model.Vch_p));
       fprintf('       S time= %8.6f\n', model.model_length/max(model.Vch_s));
       fprintf('     P-S time= %8.6f\n', model.model_length/max(model.Vch_s)-model.model_length/max(model.Vch_p));
       fprintf('     start_f= %8.6f\n', model.start_f_point);
       fprintf('       end_f= %8.6f\n', model.end_f_point);

end
%%       以上是读取模型




% X_receivers=[100,200,300,400,500];
% Z_receivers=[100,100,100,100,100];

X_receivers=[-320-0]; %  free_surface [x(-320),z(160)] surface_wave [x(-300), z(8)]  full_space [x(400),z(-200)] 
Z_receivers=[-160-0];  %  20 '-'代表接收点在源的下方,坐标轴的反方向.
                  % slow wave [-100-0]/2000  [-20-0]/2000
                  % 如果接收点在源下方，那么该距离减 （dz/2）;
                  % 如果接收点在源上方，那么该距离加 （dz/2）;
                  
                  % 如果接收点在源右方，那么该距离减  （dx/2）
                  % 如果接收点在源左方，那么该距离加  （dx/2）
 
    color1='b';
    
xlim1=0;xlim2=1;

for in=1:length(X_receivers)

X=X_receivers(in);
Z=Z_receivers(in);    

ii=(model.source_ii-1)+floor(X/model.dx);
jj=(model.source_jj-1)+floor(Z/model.dz);

kk=ii+(jj-1)*(model.Nx-2);

ux_rrff_tmp=ux_rrff(kk,:);
uy_rrff_tmp=uy_rrff(kk,:);


[ux_rrtt_tmp]=get_8_freq2time(ux_rrff_tmp,model.fft_ftn,model.end_f_point,model.t_points,model.delt_f);
[uy_rrtt_tmp]=get_8_freq2time(uy_rrff_tmp,model.fft_ftn,model.end_f_point,model.t_points,model.delt_f);



%% 


ux(in,:)=real(ux_rrtt_tmp);
uy(in,:)=real(uy_rrtt_tmp);
 

end


t=[0:(model.t_points-1)]*model.delt_t;  
  



in=1;

figure(63);      set(gcf,'outerposition',[100,100,1028,724])
subplot 211; hold on; plot(t,ux(in,:),color1); legend('ux-couple'); xlim([xlim1,xlim2]);% ylim([-5,7]*1e-6)
subplot 212; hold on; plot(t,uy(in,:),color1); legend('uy-couple'); xlim([xlim1,xlim2]);%ylim([-1,1]*8e-14)

uxx=ux';
uyy=uy';






