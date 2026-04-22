function [M1,C1,H1,G_b1,den1]=get_3_deduced_constant(porous1,dens_f1,K_f1,Vclay1)
  % 本子程序没有错误
           if Vclay1<0.02
               dens_gr1=2650; K_s1=38.83e9; G_s1=43.4e9;
               if porous1<=0.3
                   alph1=3.95*porous1-0.02*porous1*porous1;
                   beta1=3.93*porous1-4.68*porous1*porous1;
               elseif porous1<=0.4
                   alph1=-4.7088+28.544*porous1-35.68*porous1*porous1;
                   beta1=-2.8752+19.376*porous1-24.22*porous1*porous1;   
               else
                   alph1=1;
                   beta1=1;
               end
           elseif Vclay1<=0.12
               dens_gr1=2650; K_s1=35.7e9; G_s1=33e9;
               if porous1<=0.29
                   alph1=4.34*porous1-6.78*porous1*porous1;
                   beta1=3.65*porous1-3.85*porous1*porous1;
               elseif porous1<=0.4
                   alph1=-3.1256+20.628*porous1-25.785*porous1*porous1;
                   beta1=-2.5080+17.540*porous1-21.925*porous1*porous1;   
               else
                   alph1=1;
                   beta1=1;
               end 
           elseif Vclay1<=0.27
               dens_gr1=2670; K_s1=33.1660e9; G_s1=26.5e9;
                   alph1=5.24*porous1-8.91*porous1*porous1;
                   beta1=4.6*porous1-5.96*porous1*porous1;                     
           end
          % alph1 and beta1 is determined 
          K_b1=(1-alph1)*K_s1;
          G_b1=(1-beta1)*G_s1;
        
          den1=dens_gr1*(1-porous1)+porous1*dens_f1;
          M1=K_f1*K_s1/(porous1*K_s1+(alph1-porous1)*K_f1);
          C1=alph1*M1;
          H1=alph1*alph1*M1+(K_b1+4/3*G_b1);
          den1*C1/(dens_f1*H1);
       
%           K_s1
%           K_b1
%           G_b1
    
          
          
          
          
          