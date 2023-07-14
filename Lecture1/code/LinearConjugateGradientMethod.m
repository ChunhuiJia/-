clc,clear;
close all;

x_init=[4;6;2];
A=[1,3,4
   3,2,3
   4,3,4];
b=[3;2;6];
x=x_init;
k=1;
v(k)={b-A*x};  % 残差，梯度f'(x)=A*x+b,令f'(x)=0，即A*x+b=0，则残差b-A*x就表示x接近于精确解x*的远近
u(k)=v(k);
epsilon=1e-6;
while norm(cell2mat(v(k)),2) > epsilon
   alpha=cell2mat(v(k))'*cell2mat(v(k))/(cell2mat(u(k))'*A*cell2mat(u(k)));
   x=x+alpha*cell2mat(u(k));
   v(k+1)={cell2mat(v(k))-alpha*A*cell2mat(u(k))};
   beta=cell2mat(v(k+1))'*cell2mat(v(k+1))/(cell2mat(v(k))'*cell2mat(v(k)));  
   u(k+1)={cell2mat(v(k+1))+beta*cell2mat(u(k))};
   disp_txt = strcat('(x1,x2,x3)：(',num2str(x(1)),', ',num2str(x(2)),', ',num2str(x(3)),')',', ||v(k)||^2：', num2str(norm(cell2mat(v(k+1)),2)));
   disp(disp_txt);
   gradient_disp(k)=norm(cell2mat(v(k+1)),2);
   k=k+1;
end
semilogy(1:length(gradient_disp),gradient_disp);

% function y=f1(A,b,x)
%     y=1/2*x'*A*x+b'*x;
% end