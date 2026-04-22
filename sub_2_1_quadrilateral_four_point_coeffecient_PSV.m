%% 输入：  x1,x2,x3,x4,y1,y2,y3,y4     矩形单元四个点的x、y坐标， 左上为局部节点1，逆时针分别为2、3、4，
%          αx、αy、β，                   方程中的系数
%          source_0                        判定含有源，值为1,不含有源值为0）


%% 输出： a_4：矩形四个节点相对中心点函数值的迭代系数 
%           source_4

% function [a_4,source_4]=sub_2_1_1_quadrilateral_four_point_coeffecient(x1,x2,x3,x4,y1,y2,y3,y4,alpha_xg,alpha_yg,beta_g,source_0_input)
% function [ux_p,uy_p,wx_p,wy_p,source_4]=sub_2_1_quadrilateral_four_point_coeffecient_PSV(x1,x3,y1,y2,factor,source_0_input,location)
% function [ux_p,uy_p,wx_p,wy_p,source_4]=sub_2_1_quadrilateral_four_point_coeffecient_PSV(x1,x3,y1,y2,factor,Fx_inputd,Fy_inputd,fx_inputd,fy_inputd,location,kindnum)
function [ux_p,uy_p,source_2]=sub_2_1_quadrilateral_four_point_coeffecient_PSV(x1,x3,y1,y2,factor,Fx_inputd,Fy_inputd,location)

    
   if ((Fx_inputd(1,1)~=0)&&(Fx_inputd(1,2)~=0)&&(Fx_inputd(2,1)~=0)&&(Fx_inputd(2,2)~=0)) 
        Fx_input=Fx_inputd(1,1);
   else
        Fx_input=0;
   end
    
   if ((Fy_inputd(1,1)~=0)&&(Fy_inputd(1,2)~=0)&&(Fy_inputd(2,1)~=0)&&(Fy_inputd(2,2)~=0)) 
        Fy_input=Fy_inputd(1,1);
   else
        Fy_input=0;
   end
   


%% lead in some known coefficients

Hxx=factor(1); Hyy=factor(2);
Gxx=factor(3); Gyy=factor(4); Gxy=factor(5);
H_2Gxy=factor(6);
dens=factor(7);

%%  Prepare the related coefficients 

         dxx=x3-x1;
         dyy=y2-y1;
         Area = (dxx)*(dyy);      
          
     % 1 - the integral terms for the coefficients a_a 
         temp_y11=(1/3)*(dyy)^3; temp_y22 = temp_y11; temp_y12 = -(1/6)*(dyy)^3;
         aa=zeros(4,4);
         
         aa(1,1)=temp_y11*dxx;   aa(2,1)=-temp_y12*dxx;   aa(3,1)=-aa(2,1);   aa(4,1)=-aa(1,1);
         aa(1,2)=aa(2,1);        aa(2,2)=aa(1,1);         aa(3,2)=-aa(1,1);   aa(4,2)=-aa(2,1);
         aa(1,3)=-aa(2,1);       aa(2,3)=-aa(1,1);        aa(3,3)=aa(1,1);    aa(4,3)=aa(2,1);
         aa(1,4)=-aa(1,1);       aa(2,4)=-aa(2,1);        aa(3,4)=aa(2,1);    aa(4,4)=aa(1,1);
         
      % 2 - the integral terms for the coefficients b_b                  
         temp_x11 = (1/3)*(dxx)^3;  temp_x33 = temp_x11; temp_x13 = -(1/6)*(dxx)^3;
         bb=zeros(4,4);
                  
         bb(1,1)=temp_x11*dyy;    bb(2,1)=-bb(1,1);  bb(3,1)=temp_x13*dyy;    bb(4,1)=-bb(3,1);
         bb(1,2)=-bb(1,1);        bb(2,2)=bb(1,1);   bb(3,2)=-bb(3,1);        bb(4,2)=bb(3,1);
         bb(1,3)=bb(3,1);         bb(2,3)=-bb(3,1);  bb(3,3)=bb(1,1);         bb(4,3)=-bb(1,1);
         bb(1,4)=-bb(3,1);        bb(2,4)=bb(3,1);   bb(3,4)=-bb(1,1);        bb(4,4)=bb(1,1);
         
      % 3 - the integral terms for the coefficients a_b   
      
         temp_x3 = (1/2)*(dxx)^2;     temp_x4 = temp_x3;  temp_x1 = -temp_x3; temp_x2 = temp_x1;
         temp_y1 = -((1/2)*(dyy)^2);  temp_y2 = -temp_y1; temp_y4 = temp_y1;  temp_y3 = temp_y2;
         ab=zeros(4,4);
         
         ab(1,1)=temp_x3*temp_y3;  ab(2,1)=-temp_x3*temp_y4; ab(3,1)=temp_x3*temp_y1;  ab(4,1)=-temp_x3*temp_y2;
         ab(1,2)=-temp_x4*temp_y3; ab(2,2)=temp_x4*temp_y4;  ab(3,2)=-temp_x4*temp_y1; ab(4,2)=temp_x4*temp_y2;
         ab(1,3)=temp_x1*temp_y3;  ab(2,3)=-temp_x1*temp_y4; ab(3,3)=temp_x1*temp_y1;  ab(4,3)=-temp_x1*temp_y2;
         ab(1,4)=-temp_x2*temp_y3; ab(2,4)=temp_x2*temp_y4;  ab(3,4)=-temp_x2*temp_y1; ab(4,4)=temp_x2*temp_y2;
         
      % 4 - the integral terms for the coefficients b_a 
      
         ba=zeros(4,4);
         
         ba(1,1)=ab(1,1); ba(2,1)=ab(1,2); ba(3,1)=ab(1,3); ba(4,1)=ab(1,4);
         ba(1,2)=ab(2,1); ba(2,2)=ab(2,2); ba(3,2)=ab(2,3); ba(4,2)=ab(2,4);
         ba(1,3)=ab(3,1); ba(2,3)=ab(3,2); ba(3,3)=ab(3,3); ba(4,3)=ab(3,4);
         ba(1,4)=ab(4,1); ba(2,4)=ab(4,2); ba(3,4)=ab(4,3); ba(4,4)=ab(4,4);
         
      % 5 - the integral terms for the double interpolation function N_N  
       
        NN=zeros(4,4);
        
        NN(1,1) = (1/(Area*Area))*temp_x33*temp_y22; 
        NN(1,2) = -(1/(Area*Area))*temp_x33*temp_y12; 
        NN(1,3) = (1/(Area*Area))*temp_x13*temp_y12; 
        NN(1,4) = -(1/(Area*Area))*temp_x13*temp_y22;
        
        NN(2,1) = NN(1,2); NN(2,2) = (1/(Area*Area))*temp_x33*temp_y11; NN(2,3) = -(1/(Area*Area))*temp_x13*temp_y11; NN(2,4) = (1/(Area*Area))*temp_x13*temp_y12;
        NN(3,1) = NN(1,3); NN(3,2) = NN(2,3);                           NN(3,3) = (1/(Area*Area))*temp_x11*temp_y11;  NN(3,4) = -(1/(Area*Area))*temp_x11*temp_y12;
        NN(4,1) = NN(1,4); NN(4,2) = NN(2,4);                           NN(4,3) = NN(3,4);                            NN(4,4) = (1/(Area*Area))*temp_x11*temp_y22;
     
      % 6 - the integral terms for the single interpolation function N
      
        N_4=zeros(1,4);
        
        N_4(1) = (1/(Area))*temp_x3*temp_y2; N_4(2)= -(1/(Area))*temp_x3*temp_y1; N_4(3) = (1/(Area))*temp_x1*temp_y1; N_4(4) =  -(1/(Area))*temp_x1*temp_y2;
      
%%  Form the real format.      
      

      
        jj=location;

        % for ux
        % Pux=zeros(9,16);
        Pux=zeros(3,8);
        
        Pux(1,1)=(Hxx/(Area*Area))*aa(1,jj)+(Gyy/(Area*Area))*bb(1,jj);        Pux(1,3)=(Hxx/(Area*Area))*aa(2,jj)+(Gyy/(Area*Area))*bb(2,jj); 
        Pux(1,5)=(Hxx/(Area*Area))*aa(3,jj)+(Gyy/(Area*Area))*bb(3,jj);        Pux(1,7)=(Hxx/(Area*Area))*aa(4,jj)+(Gyy/(Area*Area))*bb(4,jj);
        
        Pux(2,2)=(Gxy/(Area*Area))*ab(1,jj)+((H_2Gxy)/(Area*Area))*ab(jj,1);   Pux(2,4)=(Gxy/(Area*Area))*ab(2,jj)+((H_2Gxy)/(Area*Area))*ab(jj,2);  
        Pux(2,6)=(Gxy/(Area*Area))*ab(3,jj)+((H_2Gxy)/(Area*Area))*ab(jj,3);   Pux(2,8)=(Gxy/(Area*Area))*ab(4,jj)+((H_2Gxy)/(Area*Area))*ab(jj,4);       
      
        Pux(3,1)=(-dens)*NN(1,jj); Pux(3,3)=(-dens)*NN(2,jj); Pux(3,5)=(-dens)*NN(3,jj);  Pux(3,7)=(-dens)*NN(4,jj);
        
        
        % for uy
        Puy=zeros(3,8);
        
        Puy(1,2)=(Hyy/(Area*Area))*bb(1,jj)+(Gxx/(Area*Area))*aa(1,jj);        Puy(1,4)=(Hyy/(Area*Area))*bb(2,jj)+(Gxx/(Area*Area))*aa(2,jj); 
        Puy(1,6)=(Hyy/(Area*Area))*bb(3,jj)+(Gxx/(Area*Area))*aa(3,jj);        Puy(1,8)=(Hyy/(Area*Area))*bb(4,jj)+(Gxx/(Area*Area))*aa(4,jj);

        Puy(2,1)=(Gxy/(Area*Area))*ab(jj,1)+((H_2Gxy)/(Area*Area))*ab(1,jj);   Puy(2,3)=(Gxy/(Area*Area))*ab(jj,2)+((H_2Gxy)/(Area*Area))*ab(2,jj);  
        Puy(2,5)=(Gxy/(Area*Area))*ab(jj,3)+((H_2Gxy)/(Area*Area))*ab(3,jj);   Puy(2,7)=(Gxy/(Area*Area))*ab(jj,4)+((H_2Gxy)/(Area*Area))*ab(4,jj);

        Puy(3,2)=(-dens)*NN(1,jj); Puy(3,4)=(-dens)*NN(2,jj); Puy(3,6)=(-dens)*NN(3,jj);  Puy(3,8)=(-dens)*NN(4,jj);           
  
     ux_p=zeros(1,8); uy_p=zeros(1,8);
        
       for kk = 1:8
            ux_p(kk)=sum(Pux(:,kk));           
            uy_p(kk)=sum(Puy(:,kk));
        end
        

      source_2 = zeros(2,1);
        
               
                jj=location;            
                source_2(1)=Fx_input*N_4(jj);
                source_2(2)=Fy_input*N_4(jj);
         
              
            
 
        
        