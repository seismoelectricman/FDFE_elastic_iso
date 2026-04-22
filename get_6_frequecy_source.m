% Call subroutine 《6》: get the frequency spectrum of source time function
%   input:  complex_f    : complex frequecy
%           timesource=  1. Ricker wavelet   
%                              f_c                   : central frequency  
%                              time_delay_ricker     : time_delay for Ricker 
%                        2. Cosine envelope pulse 
%                              f_0                   : central frequency  
%                              T_c                   : width of pulse
%                        3. Ramp  
%                              t0                    : rise time of Ramp
%                        4. triangle
%                              T_triangle            : width of triangle pulse
% 调用子程序《6》：根据采用的声源时间函数的种类timesource，输出其每个频率下频率响应函数S(w)
  % 输入频率complex_f，输出S_w

function [s_w_out]=get_6_frequecy_source(timesource,complex_f,f_c,time_delay_ricker,f_0,T_c,t0,T_triangle)    % 本子程序没有错误
 %%% The frequecy response of source s(t)---S(w) will be calculated here

 source=timesource;  

switch source
  case 0  % no time function, i.e., Sw=1 
          s_w_out = 1;
  case 1  % Ricker wavelet
%        s(t) = (u**2 - .5)*sqrt(2.)*.5*exp(-u**2/4.),
%            where, u  = 2*sqrt(6.)*(t-to)/tb, 
%                   to -- arrival time,
%                   tb -- width of wavelet.
%         Its spectral is:
%         S(w) =  (w/wc)**2 * exp(-(w/wc)**2),

%          Ricker wavelet 2 不同的Ricker子波 2016.7.21
%            s(t) = (1-2*pi^2*f0^2*t^2)*exp(-pi^2*f0^2*t^2),
%            S(w)=f^2/f0^3*2*/sqrt(pi)*exp(-f^2/f0^2)

            f_in=complex_f;
            pp=f_in/f_c; 
%             B_f=pp*pp/(f_c*2*pi)*exp(-pp*pp); % Ricker wavelet 1
              B_f=pp*pp/f_c*2/sqrt(pi)*exp(-pp*pp);   % Ricker wavelet 2

            s_w_out=B_f;
         if time_delay_ricker~=0
            s_w_out=B_f*exp(1i*2*pi*f_in*(time_delay_ricker)); % add time delay
         end
       
   case 2      % Cosine envelope pulse 
%       s(t)  =  1/2*[1+cos(2*pi/T_c*(t-T_c/2)]*cos(2*pi*f0*(t-T_c/2)),  0<=t<=T_c
%                0                                                    ,  t<0 and t>T_c 
         f_in=complex_f;
         pt=pi*T_c*f_in;
         p0=pi*T_c*f_0;
         A_f=0.25*T_c*(sin_x(pt+p0)+sin_x(pt-p0)+0.5*sin_x(pt+p0+pi)+0.5*sin_x(pt-p0-pi)+0.5*sin_x(pt+p0-pi)+0.5*sin_x(pt-p0+pi));
         s_w_out=A_f*exp(i*pt);   
         
   case  3     % Ramp    
%        s(t) = 0.0           for t < 0;
%        s(t) = t/t0          for 0 < t < tou;
%        s(t) = 1.0           for t > tou.
%        Its spectal is:      S(w) = (exp(-i*w*tou)-1.)/(tou*w**2).
         f_in=complex_f;
         omiga=2*pi*f_in;
         B_f=1/(omiga*omiga*t0)*(exp(i*omiga*t0)-1);
         s_w_out=B_f; 
         
   case 4      % triangle 三角脉冲
%        s(t)=0.0          for t<0 and t>T;
%        s(t)=2*t/T      for 0<=t<T/2;
%        s(t)=-2*t/T+2a  for T/2<=t<=T.
%         
%        Its spectral is:
%        S(w)=-2*(exp(i*w*T/2.)-1.)**2/(T*w*w). 
         f_in=complex_f;
         omiga=2*pi*f_in;
         T=T_triangle;
         s_w_out0=4/T/omiga^2*exp(i*omiga*T/2)-2/T/omiga^2-2/(omiga^2*T)*exp(i*omiga*T); % 三角函数
         
%          s_w_out=s_w_out0/(-1i*omiga);
         s_w_out=s_w_out0;
 end       
function [y]=sin_x(x)
              if abs(x)<1e-30
                  y=1;
              else
                  y=sin(x)/x;
              end