%Implementation of LFRS

s=[0 0 1 0 ] %Initial value
t=[3 2] %fuction f(x)= 1+x^3+x^4 
 
n=length(s);
c(1,:)=s;
m=length(t);
for k=1:2^n-2;
b(1)=xor(s(t(1)), s(t(2)));
if m>2;
    for i=1:m-2;
    b(i+1)=xor(s(t(i+2)), b(i));
    end
end
j=1:n-1;
s(n+1-j)=s(n-j);
s(1)=b(m-1);
c(k+1,:)=s;
end
seq=c(:,n)';