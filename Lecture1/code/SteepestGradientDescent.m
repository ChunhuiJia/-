clc,clear;
% test1:f1(x)=(x-1)^2+3;
x_k=10;  % init x
c=0.5; % c in [0,1]
tau=10;  % init iter step
[y_k,dot_y_k]=f1(x_k);
x_k_p=x_k-tau*dot_y_k;
[y_k_p,dot_y_k_p]=f1(x_k_p);
n=0;
thres_dot_y = 1e-3;
while abs(dot_y_k)>thres_dot_y
    while y_k_p > y_k-c*tau*dot_y_k*dot_y_k
        tau = tau/2;
        x_k_p=x_k-tau*dot_y_k;
        [y_k_p,~]=f1(x_k_p);
        n=n+1;
    end
    x_k = x_k-tau*dot_y_k;
    [y_k,dot_y_k]=f1(x_k);
    x_k_p=x_k-tau*dot_y_k;
    [y_k_p,dot_y_k_p]=f1(x_k_p);
     n=n+1;
end


% test2: f2(x1,x2)=exp(x1+3*x2-0.1)+exp(x1-3*x2-0.1)+exp(-x1-0.1)
% df/dx1=exp(x1+3*x2-0.1)+exp(x1-3*x2-0.1)-exp(-x1-0.1)
% df/dx2=3*exp(x1+3*x2-0.1)-3*exp(x1-3*x2-0.1)
x1_k=2;
x2_k=3;
tau=1;
c=0.5; % c in [0,1]
n=0;
thres_dot_y = 1e-3;
[y_k,gradient_k]=f2(x1_k,x2_k);
x1_k_p=x1_k-tau*gradient_k(1);
x2_k_p=x2_k-tau*gradient_k(2);
[y_k_p,gradient_k_p]=f2(x1_k_p,x2_k_p);
while norm(gradient_k,2)>thres_dot_y
    while y_k_p > y_k-c*tau*gradient_k'*gradient_k
        tau = tau/2;
        x1_k_p=x1_k-tau*gradient_k(1);
        x2_k_p=x2_k-tau*gradient_k(2);
        [y_k_p,~]=f2(x1_k_p,x2_k_p);
        n=n+1;
    end
    x1_k=x1_k-tau*gradient_k(1);
    x2_k=x2_k-tau*gradient_k(2);
    [y_k,gradient_k]=f2(x1_k,x2_k);
    x1_k_p=x1_k-tau*gradient_k(1);
    x2_k_p=x2_k-tau*gradient_k(2);
    [y_k_p,gradient_k_p]=f2(x1_k_p,x2_k_p);
     n=n+1;
end

% test3: f3(x1,x2)=gama/2*x1*x1+1/2*x2*x2
% df/dx1=gama*x1
% df/dx2=x2
x1_k=2;
x2_k=3;
tau=1;
c=0.1; % c in [0,1]
n=0;
thres_dot_y = 1e-3;
[y_k,gradient_k]=f3(x1_k,x2_k);
x1_k_p=x1_k-tau*gradient_k(1);
x2_k_p=x2_k-tau*gradient_k(2);
[y_k_p,gradient_k_p]=f3(x1_k_p,x2_k_p);
while norm(gradient_k,2)>thres_dot_y
    while y_k_p > y_k-c*tau*gradient_k'*gradient_k
        tau = tau/2;
        x1_k_p=x1_k-tau*gradient_k(1);
        x2_k_p=x2_k-tau*gradient_k(2);
        [y_k_p,~]=f3(x1_k_p,x2_k_p);
        n=n+1;
    end
    x1_k=x1_k-tau*gradient_k(1);
    x2_k=x2_k-tau*gradient_k(2);
    [y_k,gradient_k]=f3(x1_k,x2_k);
    x1_k_p=x1_k-tau*gradient_k(1);
    x2_k_p=x2_k-tau*gradient_k(2);
    [y_k_p,gradient_k_p]=f3(x1_k_p,x2_k_p);
    n=n+1;
end

% function
% test1:f1(x)=(x-1)^2+3;
function [y,dot_y]=f1(x)
y=(x-1)^2+3;
dot_y = 2*(x-1);
end

% test2: f2(x1,x2)=exp(x1+3*x2-0.1)+exp(x1-3*x2-0.1)+exp(-x1-0.1)
% df/dx1=exp(x1+3*x2-0.1)+exp(x1-3*x2-0.1)-exp(-x1-0.1)
% df/dx2=3*exp(x1+3*x2-0.1)-3*exp(x1-3*x2-0.1)
function [y,gradient]=f2(x1,x2)
y=exp(x1+3*x2-0.1)+exp(x1-3*x2-0.1)+exp(-x1-0.1);
gradient(1)=exp(x1+3*x2-0.1)+exp(x1-3*x2-0.1)-exp(-x1-0.1);
gradient(2)=3*exp(x1+3*x2-0.1)-3*exp(x1-3*x2-0.1);
gradient=gradient';
end

% test3: f3(x1,x2)=gama/2*x1*x1+1/2*x2*x2
% df/dx1=gama*x1
% df/dx2=x2
function [y,gradient]=f3(x1,x2)
gama=6;
y=gama/2*x1*x1+1/2*x2*x2;
gradient(1)=gama*x1;
gradient(2)=x2;
gradient=gradient';
end