M = 50;                    % Controls how narrow the pass-band gets
nD = 50;                   % Makes the system uncorrelated with itself
samples = 1000;
n = 1:samples;
freq=0.125;
i = 2*sin(2*pi*freq*n);   % narrowband signal

s = randn(size(i));         % wideband signal
x = s+i;                    % input signal
mu =0.0001;              % Learning rate/step-size of the convergence to the optimal system
d = x;                      % Desired signal

[y,e,h] = LMS(x,x,M,nD, mu);

fft_samples = 500;
x_fft = abs(fft(x(samples-fft_samples:samples)));
y_fft = abs(fft(y(samples-fft_samples:samples)));
e_fft = abs(fft(e(samples-fft_samples:samples)));
h_fft = abs(fft(h,fft_samples+1));

subplot(6,1,1); plot(x); title('input signal');
subplot(6,1,2); plot(y); title('estimated interference signal');
subplot(6,1,3); plot((s-e).^2); title('error signal');
subplot(6,1,4); plot(0:2/fft_samples:2,h_fft); title('FFT of system'); xlabel('angular frequency (pi rad/s)');
subplot(6,1,5); plot(0:2/fft_samples:2,y_fft); title('FFT of estimated Interference'); xlabel('angular frequency (pi rad/s)');
subplot(6,1,6); plot(0:2/fft_samples:2,e_fft); title('FFT of output signal'); xlabel('angular frequency (pi rad/s)');
