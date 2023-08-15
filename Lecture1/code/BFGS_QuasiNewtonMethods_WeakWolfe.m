clc,clear;
close all;
% test1:f1(x1,x2)=(1-x1)^2+(x2-x1^2)^2
% df/dx1=-2*(1-x1)-4*x1*(x2-x1^2)
% df/dx2=2*(x2-x1^2)
x1_k = 4;   % 0.5
x2_k = 6;   % 0.5
c1=1e-4;
c2=0.9;
epsilon = 1e-6;
alpha=1;
[y_k,gradient_k]=f1(x1_k,x2_k);
B_k = eye(2);
n1=0;
thres_dot_y = 1e-10;
while norm(gradient_k,2)>thres_dot_y
    alpha=10;
    d= -B_k*gradient_k;
    x1_k_p=x1_k+alpha*d(1);
    x2_k_p=x2_k+alpha*d(2);
    [y_k_p,gradient_k_p]=f1(x1_k_p,x2_k_p);
    while ((y_k-y_k_p)<-c1*alpha*d'*gradient_k)||(d'*gradient_k_p<c2*d'*gradient_k)
        alpha = alpha/2;
        x1_k_p=x1_k+alpha*d(1);
        x2_k_p=x2_k+alpha*d(2);
        [y_k_p,gradient_k_p]=f1(x1_k_p,x2_k_p);
    end
    x1_k_p=x1_k+alpha*d(1);
    x2_k_p=x2_k+alpha*d(2);
    [y_k_p,gradient_k_p]=f1(x1_k_p,x2_k_p);
    d_g = gradient_k_p-gradient_k;
    d_x = [x1_k_p,x2_k_p]'-[x1_k,x2_k]';
    dg_dx = d_g'*d_x;
    if(dg_dx)>epsilon*norm(gradient_k,2)*(d_x')*d_x
        B_k = (eye(2)-d_x*(d_g')/dg_dx)*B_k*(eye(2)-d_g*(d_x')/dg_dx)+d_x*(d_x')/dg_dx;
    end
    x1_k=x1_k_p;
    x2_k=x2_k_p;
    y_k=y_k_p;
    gradient_k=gradient_k_p;
    n1=n1+1;
    disp_txt = strcat('(x1,x2)：(',num2str(x1_k),', ',num2str(x2_k),')',', 梯度范数为：', num2str(norm(gradient_k,2)));
    disp(disp_txt);
    gradient_disp(n1)=norm(gradient_k,2);
end
semilogy(1:length(gradient_disp),gradient_disp);


function [y,gradient]=f1(x1,x2)
y=(1-x1)^2+(x2-x1^2)^2;
gradient(1)= -2*(1-x1)-4*x1*(x2-x1^2);
gradient(2)= 2*(x2-x1^2);
gradient=gradient';
end