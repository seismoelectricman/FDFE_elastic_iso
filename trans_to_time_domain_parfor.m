


% parral=1
% if parral==1
%     CoreNum=30
%     if matlabpool('size')<=0  %之前没有打开
%       matlabpool('open',CoreNum);
%     else  %之前已经打开
%       disp('matlab pool already started');
%     end
%         disp(matlabpool('size'));
% end

   parral=1;
        
   CoreNum=40;  % 60 can
   if parral==1
       if isempty(gcp('nocreate'))
         parpool(CoreNum);
       end
   end  

% tic

% if freesurface ==0;
  tic
  
  [size1,size2]=size(ux_rrff);

  parfor Number_Real=1:size1 

   [ux_rrtt(Number_Real,:)]=get_8_freq2time(ux_rrff(Number_Real,:),model.fft_ftn,model.end_f_point,model.t_points,model.delt_f);
   [uy_rrtt(Number_Real,:)]=get_8_freq2time(uy_rrff(Number_Real,:),model.fft_ftn,model.end_f_point,model.t_points,model.delt_f);
%    [wx_rrtt(Number_Real,:)]=get_8_freq2time(wx_rrff(Number_Real,:),model.fft_ftn,model.end_f_point,model.t_points,model.delt_f);
%    [wy_rrtt(Number_Real,:)]=get_8_freq2time(wy_rrff(Number_Real,:),model.fft_ftn,model.end_f_point,model.t_points,model.delt_f);
   
   
  end
  
  toc  
    
    
  [St]=get_8_freq2time(Sw,model.fft_ftn,model.end_f_point,model.t_points,model.delt_f);
  
   
  t=[0:(model.t_points-1)]*model.delt_t;  


figure(100)
plot(t,real(St))


