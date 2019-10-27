M = 100;                    % Controls how narrow the pass-band gets
nD = 100;                   % Makes the system uncorrelated with itself
samples = 10000000;
n = 1:samples;
freq=0.2;
i = 5*sin(2*pi*freq*n);   % narrowband signal

s = randn(size(i));         % wideband signal
x = s+i;                    % input signal
mu =0.0000001;              % Learning rate/step-size of the convergence to the optimal system
d = x;                      % Desired signal

h = zeros(1,M);             % System function
e = zeros(1,samples);       % Error signal
y = zeros(1,samples);       % Output estimate signal

for j = nD+M:samples 
    y(j) = x(j-M-nD+1:j-nD)*h';
    e(j) = d(j)-y(j);
    h = h + mu*e(j)*x(j-M-nD+1:j-nD);
end

x_fft = abs(fft(x(samples-1000:samples)));
y_fft = abs(fft(y(samples-1000:samples)));
e_fft = abs(fft(e(samples-1000:samples)));
h_fft = abs(fft(flip(h),1001));

subplot(5,1,1); plot(x); title('input signal');
subplot(5,1,2); plot(y); title('estimated interference signal');
subplot(5,1,3); plot(h_fft); title('FFT of system');
subplot(5,1,4); plot(y_fft); title('FFT of estimated Interference');
subplot(5,1,5); plot(e_fft); title('FFT of output signal');
