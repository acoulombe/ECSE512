y = zeros(1,103);
y(1) = 0; % y(-2)
y(2) = 0; % y(-1)
y(3) = 1/8; % y(0)
for n = 4:1:101
    y(n) = (-2*y(n-1)+3*y(n-2))/8; %because of indexing of matlab
end

n = -2:100;

figure
stem(n,y)
axis([-2 100 -0.05 1/8])
title('2.25 c), plot of 8y[n]+2y[n-1]-3y[n-2]=x[n], where x[n] = delta[n]')
xlabel('n')
ylabel('y[n]')