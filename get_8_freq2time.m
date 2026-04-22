 
function [ux_rrt1]=get_8_freq2time(ux_rrff,fft_ftn,end_f_point,t_points,delt_f)



       ux_rrf=ux_rrff;   
       ux_rrf((end_f_point+1):fft_ftn)=0; 
       ux_rrf(fft_ftn:-1:(fft_ftn/2+2))=conj(ux_rrf(2:(fft_ftn/2)));
       ux_rrt=fft(ux_rrf,fft_ftn)*delt_f;
       
       ux_rrt1=ux_rrt(1:t_points);
      