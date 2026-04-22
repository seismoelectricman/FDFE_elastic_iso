
% function [b_all,A_all_E1]=sub_3_2_fullspace_matrix_PSV(Nx,Ny,Nx0,dx1,dy1,source_Fx,source_Fy,source_fx,source_fy,model,omega,kindtype)
function [b_all,A_all_E1]=sub_3_2_fullspace_matrix_PSV(Nx,Ny,Nx0,dx1,dy1,source_Fx,source_Fy,model,omega)

%% 获得所有网格点的坐标伸缩因子 sx和sy
            

 for jj=1:model.Nz
      for ii=1:model.Nx
                 
         
      [model.M(jj,ii),model.C(jj,ii),model.H(jj,ii),model.G_b(jj,ii)]=get_3_frequency_dependence_input_parameter(model.Vp(jj,ii),model.Vs(jj,ii),model.dens(jj,ii),model.K_f(jj,ii),model.porous(jj,ii),model.alpha(jj,ii),model.Qp(jj,ii),model.Qs(jj,ii),model,omega);% to get M C H G den 
      
      model.Vch_p(jj,ii)=sqrt(model.H(jj,ii)/model.dens(jj,ii)); model.Vch_s(jj,ii)=sqrt(model.G_b(jj,ii)/model.dens(jj,ii)); %等效P波速度、S波速度  % 
      
      model.G(jj,ii)=model.G_b(jj,ii);
      
      end
 end



                if model.PML_type==1      %% 1. Zhang wei 弹性波吸收条件
                    [ PMLs ] = sub_1_PML_zhangwei2010_vary_dx( model,omega);
                elseif model.PML_type==2  %% 2. 电磁波吸收条件
                    [ PMLs ] = sub_1_PML_EM_vary_dx( model,omega);
                else
                    error('model.PML_type must be 1 or 2. But now it is %4.2f', model.PML_type)
                end
                

        b_all_Fx = zeros((Nx-2)*(Ny-2),1);
        b_all_Fy = zeros((Nx-2)*(Ny-2),1);

        k        = 1;
        count    = 1;     
        
        for iy = 2:(Ny-1)
            
            for ix =2:(Nx-1)
                

                x8   = dx1(ix-1);   x7   = dx1(ix-0);      x6   = dx1(ix+1);
                x1   = dx1(ix-1);   x0   = dx1(ix-0);      x5   = dx1(ix+1);
                x2   = dx1(ix-1);   x3   = dx1(ix-0);      x4   = dx1(ix+1);

                y8   = dy1(iy-1);   y7   = dy1(iy-1);      y6   = dy1(iy-1);
                y1   = dy1(iy-0);   y0   = dy1(iy-0);      y5   = dy1(iy-0);
                y2   = dy1(iy+1);   y3   = dy1(iy+1);      y4   = dy1(iy+1);  % 右-正；上-正。
                
                
   %% 1  四个亚基本结构的中心点用其周围四个点的迭代系数 （行，列）
%    miu0=pi*4e-7;
   Factor=zeros(4,7);
   for nn=1:4  % nn=1 (左上); nn=2 (左下)；nn=3 (右下); nn=4 (右上);
       if nn==1
           yy=iy-1; xx=ix-1;
       elseif nn==2
           yy=iy; xx=ix-1;
       elseif nn==3
           yy=iy; xx=ix;
       else
           yy=iy-1; xx=ix;
       end

       Factor(nn,1)=model.H(yy,xx)/(PMLs.sx(yy,xx)^2);   % Hxx
       Factor(nn,2)=model.H(yy,xx)/(PMLs.sy(yy,xx)^2);   % Hyy
       Factor(nn,3)=model.G(yy,xx)/(PMLs.sx(yy,xx)^2);   % Gxx
       Factor(nn,4)=model.G(yy,xx)/(PMLs.sy(yy,xx)^2);   % Gyy
       Factor(nn,5)=model.G(yy,xx)/(PMLs.sx(yy,xx)*PMLs.sy(yy,xx));   % Gxy
       Factor(nn,6)=(model.H(yy,xx)-2*model.G(yy,xx))/(PMLs.sx(yy,xx)*PMLs.sy(yy,xx)); % (H-2G)xy
       Factor(nn,7)=omega*omega*model.dens(yy,xx);   % ps

  end

    %  左上的亚基本结构  逆时针顺序节点 8、1、0、7                source_Fx,source_Fy,source_fx,source_fy,
    locat = 3;
%     [ux_4_1,uy_4_1,wx_4_1,wy_4_1,S_4_1]=sub_2_1_quadrilateral_four_point_coeffecient_PSV(x8,x0,y8,y1,alpha_xg(iy-1,ix-1)/(PMLs.sx(iy-1,ix-1)^2),  alpha_yg(iy-1,ix-1)/(PMLs.sy(iy-1,ix-1)^2),  beta_g(iy-1,ix-1),  source_0(iy-1,ix-1), locat );
    [ux_4_1,uy_4_1,S_4_1]=sub_2_1_quadrilateral_four_point_coeffecient_PSV(x8,x0,y8,y1,Factor(1,:),source_Fx((iy-1):iy,(ix-1):ix),source_Fy((iy-1):iy,(ix-1):ix),locat);
    %  左下的亚基本结构  逆时针顺序节点 1、2、3、0
    locat = 4;
%     [ux_4_2,uy_4_2,wx_4_2,wy_4_2,S_4_2]=sub_2_1_quadrilateral_four_point_coeffecient_PSV(x1,x3,y1,y2,alpha_xg(iy,ix-1)/(PMLs.sx(iy,ix-1)^2),  alpha_yg(iy,ix-1)/(PMLs.sy(iy,ix-1)^2),  beta_g(iy,ix-1),  source_0(iy,ix-1), locat );
    [ux_4_2,uy_4_2,S_4_2]=sub_2_1_quadrilateral_four_point_coeffecient_PSV(x1,x3,y1,y2,Factor(2,:),source_Fx(iy:(iy+1),(ix-1):ix),source_Fy(iy:(iy+1),(ix-1):ix),locat);              
    %  右下的亚基本结构  逆时针顺序节点 0、3、4、5
    locat = 1;
%     [ux_4_3,uy_4_3,wx_4_3,wy_4_3,S_4_3]=sub_2_1_quadrilateral_four_point_coeffecient_PSV(x0,x4,y0,y3,alpha_xg(iy,ix)/(PMLs.sx(iy,ix)^2),  alpha_yg(iy,ix)/(PMLs.sy(iy,ix)^2),  beta_g(iy,ix),  source_0(iy,ix), locat );
    [ux_4_3,uy_4_3,S_4_3]=sub_2_1_quadrilateral_four_point_coeffecient_PSV(x0,x4,y0,y3,Factor(3,:),source_Fx(iy:(iy+1),ix:(ix+1)),source_Fy(iy:(iy+1),ix:(ix+1)),locat);              
    %  右上的亚基本结构  逆时针顺序节点 7、0、5、6
    locat = 2;
    [ux_4_4,uy_4_4,S_4_4]=sub_2_1_quadrilateral_four_point_coeffecient_PSV(x7,x5,y7,y0,Factor(4,:),source_Fx((iy-1):iy,ix:(ix+1)),source_Fy((iy-1):iy,ix:(ix+1)),locat);
                 
                  %% 2 关联基本结构中心点，也就是点 ix iy 用其周围8个点表示的迭代系数 
                  
%                   bs(1,:)=a_4_1;
%                   bs(2,:)=a_4_2;
%                   bs(3,:)=a_4_3;
%                   bs(4,:)=a_4_4; 

                %%  ux-partial derivatives-a               

                  a9_1=zeros(1,2); a9_2=zeros(1,2); a9_3=zeros(1,2); a9_4=zeros(1,2); a9_5=zeros(1,2); a9_6=zeros(1,2); a9_7=zeros(1,2); a9_8=zeros(1,2); a9_9=zeros(1,2);
                  
                  a9_1(1)=ux_4_1(3)+ux_4_2(1);         a9_1(2)=ux_4_1(4)+ux_4_2(2);     
                  a9_2(1)=ux_4_2(3);                   a9_2(2)=ux_4_2(4);  
                  a9_3(1)=ux_4_2(5)+ux_4_3(3);         a9_3(2)=ux_4_2(6)+ux_4_3(4);   
                  a9_4(1)=ux_4_3(5);                   a9_4(2)=ux_4_3(6); 
                  a9_5(1)=ux_4_3(7)+ux_4_4(5);         a9_5(2)=ux_4_3(8)+ux_4_4(6); 
                  a9_6(1)=ux_4_4(7);                   a9_6(2)=ux_4_4(8);
                  a9_7(1)=ux_4_4(1)+ux_4_1(7);         a9_7(2)=ux_4_4(2)+ux_4_1(8); 
                  a9_8(1)=ux_4_1(1);                   a9_8(2)=ux_4_1(2); 

                  a9_9(1)=ux_4_1(5)+ux_4_2(7)+ux_4_3(1)+ux_4_4(3);     a9_9(2)=ux_4_1(6)+ux_4_2(8)+ux_4_3(2)+ux_4_4(4);
                  
                  
                %%  uy-partial derivatives-b

                  b9_1=zeros(1,2); b9_2=zeros(1,2); b9_3=zeros(1,2); b9_4=zeros(1,2); b9_5=zeros(1,2); b9_6=zeros(1,2); b9_7=zeros(1,2); b9_8=zeros(1,2); b9_9=zeros(1,2);
                  
                  b9_1(1)=uy_4_1(3)+uy_4_2(1);         b9_1(2)=uy_4_1(4)+uy_4_2(2);     
                  b9_2(1)=uy_4_2(3);                   b9_2(2)=uy_4_2(4);  
                  b9_3(1)=uy_4_2(5)+uy_4_3(3);         b9_3(2)=uy_4_2(6)+uy_4_3(4);   
                  b9_4(1)=uy_4_3(5);                   b9_4(2)=uy_4_3(6); 
                  b9_5(1)=uy_4_3(7)+uy_4_4(5);         b9_5(2)=uy_4_3(8)+uy_4_4(6); 
                  b9_6(1)=uy_4_4(7);                   b9_6(2)=uy_4_4(8);
                  b9_7(1)=uy_4_4(1)+uy_4_1(7);         b9_7(2)=uy_4_4(2)+uy_4_1(8); 
                  b9_8(1)=uy_4_1(1);                   b9_8(2)=uy_4_1(2); 

                  b9_9(1)=uy_4_1(5)+uy_4_2(7)+uy_4_3(1)+uy_4_4(3);     b9_9(2)=uy_4_1(6)+uy_4_2(8)+uy_4_3(2)+uy_4_4(4);

                                
                %%  wx-partial derivatives-c                                              
                %%  wy-partial derivatives-d                             
                  
                  S_Fx    = S_4_1(1)+S_4_2(1)+S_4_3(1)+S_4_4(1);
                  S_Fy    = S_4_1(2)+S_4_2(2)+S_4_3(2)+S_4_4(2);

                                
                 %% 组装刚度矩阵【1】 第 2 行   注意从上往下数，第一行是最下面的一行  
                if ((iy==2) &&(ix==2))

                    tmp1=(((k+0)*2-1):((k+1)*2))+0*Nx0;
                    tmp2=(((k+0)*2-1):((k+1)*2))+2*Nx0;

                    Ti(count+(0:7))=k;
                    Tj(count+(0:7))=[tmp1,tmp2];

                    T11(count+(0:7))=[a9_9,a9_5,a9_3,a9_4];  % ux                    
                    T21(count+(0:7))=[b9_9,b9_5,b9_3,b9_4];  % uy

                    count=count+8;   
                      
                
                end
                
                 if ((iy==2) &&(ix>2) &&(ix<(Nx-1)))

                    tmp1=(((k-1)*2-1):((k+1)*2))+0*Nx0;
                    tmp2=(((k-1)*2-1):((k+1)*2))+2*Nx0;

                    Ti(count+(0:11))=k;
                    Tj(count+(0:11))=[tmp1,tmp2];

                    T11(count+(0:11))=[a9_1,a9_9,a9_5,a9_2,a9_3,a9_4];                    
                    T21(count+(0:11))=[b9_1,b9_9,b9_5,b9_2,b9_3,b9_4];

                    count=count+12;


                end
                
                if ((iy==2) &&(ix==(Nx-1)))

                    tmp1=(((k-1)*2-1):((k+0)*2))+0*Nx0;
                    tmp2=(((k-1)*2-1):((k+0)*2))+2*Nx0;

                    Ti(count+(0:7))=k;
                    Tj(count+(0:7))=[tmp1,tmp2];

                    T11(count+(0:7))=[a9_1,a9_9,a9_2,a9_3];                 
                    T21(count+(0:7))=[b9_1,b9_9,b9_2,b9_3];

                    count=count+8;


                end
                %% 【2】 第 3 to Ny-2 行;
                if ((iy>2) && (iy<(Ny-1)) && (ix==2))
                
                    tmp1=(((k-0)*2-1):((k+1)*2))-2*Nx0;
                    tmp2=(((k-0)*2-1):((k+1)*2))+0*Nx0;
                    tmp3=(((k-0)*2-1):((k+1)*2))+2*Nx0;

                    Ti(count+(0:11))=k;
                    Tj(count+(0:11))=[tmp1,tmp2,tmp3];

                    T11(count+(0:11))=[a9_7,a9_6,a9_9,a9_5,a9_3,a9_4];
                    T21(count+(0:11))=[b9_7,b9_6,b9_9,b9_5,b9_3,b9_4];

                    count=count+12;    

                end
                
                 if ((iy>2) && (iy<(Ny-1)) && (ix>2) && (ix<(Nx-1)))
                

                    tmp1=(((k-1)*2-1):((k+1)*2))-2*Nx0;
                    tmp2=(((k-1)*2-1):((k+1)*2))+0*Nx0;
                    tmp3=(((k-1)*2-1):((k+1)*2))+2*Nx0;

                    Ti(count+(0:17))=k;
                    Tj(count+(0:17))=[tmp1,tmp2,tmp3];

                    T11(count+(0:17))=[a9_8,a9_7,a9_6,a9_1,a9_9,a9_5,a9_2,a9_3,a9_4];                  
                    T21(count+(0:17))=[b9_8,b9_7,b9_6,b9_1,b9_9,b9_5,b9_2,b9_3,b9_4];
                    
                    count=count+18;
                    
                    
                end
                
                if ((iy>2) && (iy<(Ny-1)) && (ix==(Nx-1)))


                    tmp1=(((k-1)*2-1):((k+0)*2))-2*Nx0;
                    tmp2=(((k-1)*2-1):((k+0)*2))+0*Nx0;
                    tmp3=(((k-1)*2-1):((k+0)*2))+2*Nx0;

                    Ti(count+(0:11))=k;
                    Tj(count+(0:11))=[tmp1,tmp2,tmp3];

                    T11(count+(0:11))=[a9_8,a9_7,a9_1,a9_9,a9_2,a9_3];  
                    T21(count+(0:11))=[b9_8,b9_7,b9_1,b9_9,b9_2,b9_3];

                    count=count+12;

                end
                
                if ((iy==Ny-1) && (ix==2))

                
                    tmp1=(((k-0)*2-1):((k+1)*2))-2*Nx0;
                    tmp2=(((k-0)*2-1):((k+1)*2))+0*Nx0;                    

                    Ti(count+(0:7))=k;
                    Tj(count+(0:7))=[tmp1,tmp2];

                    T11(count+(0:7))=[a9_7,a9_6,a9_9,a9_5];
                    T21(count+(0:7))=[b9_7,b9_6,b9_9,b9_5];

                    count=count+8;


                end   
               
                if ((iy==Ny-1) && (ix>2) && (ix<(Nx-1)))
                    
                    tmp1=(((k-1)*2-1):((k+1)*2))-2*Nx0;
                    tmp2=(((k-1)*2-1):((k+1)*2))+0*Nx0;
                

                    Ti(count+(0:11))=k;
                    Tj(count+(0:11))=[tmp1,tmp2];

                    T11(count+(0:11))=[a9_8,a9_7,a9_6,a9_1,a9_9,a9_5];
                    T21(count+(0:11))=[b9_8,b9_7,b9_6,b9_1,b9_9,b9_5];

                    count=count+12;

                    
                end
                
                if ((iy==Ny-1) && (ix==(Nx-1)))
                    

                    tmp1=(((k-1)*2-1):((k+0)*2))-2*Nx0;
                    tmp2=(((k-1)*2-1):((k+0)*2))+0*Nx0; 

                    Ti(count+(0:7))=k;
                    Tj(count+(0:7))=[tmp1,tmp2];

                    T11(count+(0:7))=[a9_8,a9_7,a9_1,a9_9];
                    T21(count+(0:7))=[b9_8,b9_7,b9_1,b9_9];

                    count=count+8;
                    
                    
                end
                
                b_all_Fx(k) =  S_Fx;
                b_all_Fy(k) =  S_Fy;
                
                k=k+1;
                
            end
        end
        
        A11_all_E1 = sparse(Ti,Tj,T11);
        A21_all_E1 = sparse(Ti,Tj,T21);

        A_all_E1=[A11_all_E1;A21_all_E1];

        b_all = [b_all_Fx;b_all_Fy];
        
   
