w0 = pi/2;
L = 2*pi/w0;
X = zeros(1,257);
w = -pi:pi/128:pi;

for i = 1:1:257
    X(i) = 0.5*(sin((w(i)-w0)*(L+0.5))/sin((w(i)-w0)/2))+0.5*(sin((w(i)+w0)*(L+0.5))/sin((w(i)+w0)/2));
end


figure
plot(w,X)
grid on
title('2.47 c), plot of X(e^j^w)')
xlabel('w')
ylabel('X(e^j^w)')