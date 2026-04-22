%  subroutine 《3》: input : Vch_p(ii),Vch_s(ii),den(ii),K_f(ii),porous(ii),alpha(ii)
%                    output: M(ii) C(ii) H(ii) G_b(ii)

% comments in chinese
%调用子程序《3》：根据弹性介质模型的纵波、横波速度和密度，通过改变孔隙度φ和系数α得到等效的Biot弹性模量 H C M Gb
%                 输入： 纵波速度    Vp    
%                       横波 速度    Vs
%                       密度        ρ 
%                       流体体积模量 Kf 
%                       孔隙度      porous1      ，
%                       系数        alph1        
%                 输出： H C M G
% 程序计算依赖 H C M G，在主程序中也可以自行定义这四个物理参数

  function [M1 C1 H1 G1]=get_3_deduced_constant_input_porous(Vp1,Vs1,dens1,Kf1,porous1,alpha1)

  
          H1=dens1*Vp1*Vp1;
          G1=dens1*Vs1*Vs1;
          Ku1=H1-4/3*G1;   %undrained bulk modulus
          
          a=porous1*(1-alpha1);
          b=(alpha1-porous1+alpha1*porous1)*Kf1-porous1*Ku1;
          c=-(alpha1-porous1)*Ku1*Kf1;
          
          Ks1=(-b+sqrt(b*b-4*a*c))/(2*a);
          
          Kd1=(1-alpha1)*Ks1;
          M1=Kf1*Ks1/(porous1*Ks1+(alpha1-porous1)*Kf1);
                    
          C1=alpha1*M1;
          
%           fprintf('H=');fprintf('%12.1f\t',H1);
%           fprintf('C=');fprintf('%12.1f\t',C1);
%           fprintf('M=');fprintf('%12.1f\t',M1);
%           fprintf('G=');fprintf('%12.1f]\n',G1);
          
         
       
          
        
          
        
          
          
          
          
          