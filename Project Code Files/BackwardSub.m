function  y = BackwardSub(a,b)
n = length(b);
y=zeros(n,1);
y(n) = b(n)/a(n,n);
for i=n-1:-1:1
    y(i)=(b(i)-a(i,i+1:n)*y(i+1:n))/a(i,i);
end