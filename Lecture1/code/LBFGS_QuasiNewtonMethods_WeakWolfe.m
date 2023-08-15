clc,clear;
close all;
% https://www.lmlphp.com/user/72262/article/item/766894/  L-BFGS的推导好好看看
% https://blog.csdn.net/u010234564/article/details/88764415  (L-BFGS算法的递归推导)
% https://blog.csdn.net/google19890102/article/details/46389869（优化算法——拟牛顿法之L-BFGS算法）****
% https://blog.csdn.net/ty44111144ty/article/details/101124123?utm_medium=distribute.pc_relevant.none-task-blog-2~default~baidujs_baidulandingword~default-0-101124123-blog-46389869.235^v38^pc_relevant_sort_base2&spm=1001.2101.3001.4242.1&utm_relevant_index=3
% （二阶优化方法——牛顿法、拟牛顿法(BFGS、L-BFGS)）
% https://zhuanlan.zhihu.com/p/514576143(数值优化（六）——拟牛顿法之LBFGS理论与实战)
% 这个有代码和图，看这个吧
% test1:f1(x1,x2)=(1-x1)^2+(x2-x1^2)^2
% df/dx1=-2*(1-x1)-4*x1*(x2-x1^2)
% df/dx2=2*(x2-x1^2)
x1_k = 0.5;
x2_k = 0.5;
c1=1e-4;
c2=0.9;
epsilon = 1e-6;
tau=1;
m=4;
[y_k,gradient_k]=f1(x1_k,x2_k);
B_k = eye(2);
n1=0;
thres_dot_y = 1e-10;
while norm(gradient_k,2)>thres_dot_y
    tau=10;
    if (n1<=(m+1))
        d= -B_k*gradient_k;
    else
        d=-d;
    end
    n1=n1+1;
    x1_k_p=x1_k+tau*d(1);
    x2_k_p=x2_k+tau*d(2);
    [y_k_p,gradient_k_p]=f1(x1_k_p,x2_k_p);
    lines_search_num = 1;   %1:inexact line search(weak wolfe conditions)  2:Lewis Overton line search
    % inexact line search(weak wolfe conditions)
    %和 Lewis Overton line search任选一个
    if lines_search_num == 1
        while ((y_k-y_k_p)<-c1*tau*d'*gradient_k)||(d'*gradient_k_p<c2*d'*gradient_k)
            tau = tau/2;
            x1_k_p=x1_k+tau*d(1);
            x2_k_p=x2_k+tau*d(2);
            [y_k_p,gradient_k_p]=f1(x1_k_p,x2_k_p);
        end
    end
    % end inexact line search
    % Lewis Overton line search
    if lines_search_num == 2
        l=0;
        u=Inf;
        tau=1;
        while ((y_k-y_k_p)<-c1*tau*d'*gradient_k)||(d'*gradient_k_p<c2*d'*gradient_k)
            if ((y_k-y_k_p)<-c1*tau*d'*gradient_k)
                u=tau;
            elseif (d'*gradient_k_p<c2*d'*gradient_k)
                l=tau;
            else
                x1_k_p=x1_k+tau*d(1);
                x2_k_p=x2_k+tau*d(2);
                [y_k_p,gradient_k_p]=f1(x1_k_p,x2_k_p);
                break
            end
            if u<Inf
                tau=(l+u)/2;
            else
                tau=2*l;
            end
            x1_k_p=x1_k+tau*d(1);
            x2_k_p=x2_k+tau*d(2);
            [y_k_p,gradient_k_p]=f1(x1_k_p,x2_k_p);
        end
    end
    % end Lewis Overton line search
    
    d_g = gradient_k_p-gradient_k;
    d_x = [x1_k_p,x2_k_p]'-[x1_k,x2_k]';
    dg_dx = d_g'*d_x;
    if(dg_dx)>epsilon*norm(gradient_k,2)*(d_x')*d_x
        B_k = (eye(2)-d_x*(d_g')/dg_dx)*B_k*(eye(2)-d_g*(d_x')/dg_dx)+d_x*(d_x')/dg_dx;
    end
    memory_save(n1,1)={d_x};
    memory_save(n1,2)={d_g};
    memory_save(n1,3)={1/(d_x'*d_g)};
    d=gradient_k_p;
    if n1>m+1
        for i=n1-1:-1:max(min(n1,n1-m),1)
            alpha(i)=cell2mat(memory_save(n1,3))*cell2mat(memory_save(n1,1))'*d;
            d=d-alpha(i)*cell2mat(memory_save(n1,2));
        end
        %         gama=cell2mat(memory_save(n1-1,3))*cell2mat(memory_save(n1-1,2))'*cell2mat(memory_save(n1-1,2));
        %         d=d/gama;
        for i=max(min(n1-1,n1-m),1):n1-1
            beta=cell2mat(memory_save(n1,3))*cell2mat(memory_save(n1,2))'*d;
            d=d+cell2mat(memory_save(n1,1))*(alpha(i)-beta);
        end
    end
    
    x1_k=x1_k_p;
    x2_k=x2_k_p;
    y_k=y_k_p;
    gradient_k=gradient_k_p;
    %     x1_k=x1_k-tau*d(1);
    %     x2_k=x2_k-tau*d(2);
    %     [y_k,gradient_k]=f1(x1_k,x2_k);
    
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