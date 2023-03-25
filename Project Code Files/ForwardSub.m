%reference:https://www.youtube.com/watch?v=4mOFl6VvH-0
function x= ForwardSub(a,b)
 n=length(b);
 x=zeros(n,1);
 x(1)=b(1)/a(1,1);
 for i=2:n
     x(i)=(b(i)-a(i,1:i-1)*x(1:i-1))./a(i,i);
 end