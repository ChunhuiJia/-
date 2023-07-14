clc,clear;
close all;

x_init=[4;6];  % [4,6]时收敛不了，[1.5;1.7]距离local minimum点比较近时能很快收敛比BFGS和LBFGS都快，[5,7]能收敛，那为什么[4,6]收敛不了呢,[4.1;6.1]也能收敛，但是很慢，[4.2;6.2]能很快收敛，BFGS和LBFGS就能非常快收敛，为什么呢？程序有什么bug？？？，把最速下降法的tau改的很大的话会非常快收敛，可能在计算LCG的时候有些点会有非常大的奇异点吧
x=x_init;
k=1;
c=1e-4; % c in [0,1]
epsilon=1e-10;
[y_k,gradient_k,hessian_k]=f1(x);
while norm(gradient_k,2)>epsilon
    kesai=min([1,norm(gradient_k,2)/10]);
    j=1;
    d(j)={zeros(2,1)};
    v(j)={-gradient_k};
    u(j)=v(j);
    while norm(cell2mat(v(j)),2) > kesai*norm(gradient_k,2)
        A=hessian_k;
        if cell2mat(u(j))'*hessian_k*gradient_k*cell2mat(u(j))<=0
            if j==1
                d(j)={-gradient_k};
            end
            break
        end
        alpha=cell2mat(v(j))'*cell2mat(v(j))/(cell2mat(u(j))'*A*cell2mat(u(j)));
        x=x+alpha*cell2mat(u(j));
        v(j+1)={cell2mat(v(j))-alpha*A*cell2mat(u(j))};
        beta=cell2mat(v(j+1))'*cell2mat(v(j+1))/(cell2mat(v(j))'*cell2mat(v(j)));
        u(j+1)={cell2mat(v(j+1))+beta*cell2mat(u(j))};
        disp_txt  = strcat('(x1,x2)：(',num2str(x(1)),', ',num2str(x(2)),', ||v(j)||^2：', num2str(norm(cell2mat(v(j+1)),2)));
        disp(disp_txt);
        j=j+1;
    end
    [y_k,gradient_k,hessian_k]=f1(x);
    if norm(gradient_k,2)<epsilon
        disp_txt = strcat('(x1,x2)：(',num2str(x(1)),', ',num2str(x(2)),')',', 梯度范数为：', num2str(norm(gradient_k,2)));
        disp(disp_txt);
        gradient_disp(k)=norm(gradient_k,2);
        break
    end
    tau=100;  % 这个值要非常大，要不然非常难收敛
    x_p=x-tau*gradient_k;
    [y_k_p,gradient_k_p,hessian_k_p]=f1(x_p);
    while y_k_p > y_k-c*tau*gradient_k'*gradient_k
        tau = tau/2;
        x_p=x-tau*gradient_k;
        [y_k_p,gradient_k_p,hessian_k_p]=f1(x_p);
    end
    x=x_p;
    [y_k,gradient_k,hessian_k]=f1(x);
    
    disp_txt = strcat('(x1,x2)：(',num2str(x(1)),', ',num2str(x(2)),')',', 梯度范数为：', num2str(norm(gradient_k,2)));
    disp(disp_txt);
    gradient_disp(k)=norm(gradient_k,2);
    k=k+1;
end
semilogy(1:length(gradient_disp),gradient_disp);

function [y,gradient,hessian]=f1(x)
x1=x(1);
x2=x(2);
y=(1-x1)^2+(x2-x1^2)^2;
gradient(1)= -2*(1-x1)-4*x1*(x2-x1^2);
gradient(2)= 2*(x2-x1^2);
gradient=gradient';
hessian(1,1)=2-4*x2+12*x1*x1;
hessian(1,2)=-4*x1;
hessian(2,1)=-4*x1;
hessian(2,2)=2;
end