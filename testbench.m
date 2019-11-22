M = 50;                     % Controls how narrow the pass-band gets
nD = 100;                   % Makes the system uncorrelated with itself
samples = 100000;
n = 1:samples;
freq=0.1;
i = sin(2*pi*freq*n);     % narrowband signal

s = randn(size(i));         % wideband signal
x = s+i;                    % input signal
d = x;                      % Desired signal

mu =0.00001;                % Learning rate/step-size of the convergence to the optimal system
lambda = 1;                 % Forgetting rate of the convergence to the optimal system

%[y,e,h] = LMS(x,x,M,nD,mu);
[y,e,h] = RLS(x,x,M,nD,lambda);


fft_samples = ceil(samples*0.1);
x_fft = abs(fft(x(samples-fft_samples:samples)));
y_fft = abs(fft(y(samples-fft_samples:samples)));
e_fft = abs(fft(e(samples-fft_samples:samples)));
h_fft = abs(fft(h,fft_samples+1));

figure;
subplot(4,1,1); plot((M+nD:samples),x(M+nD:samples)); title('input signal');
subplot(4,1,2); plot((M+nD:samples),y(M+nD:samples)); title('estimated interference signal');
subplot(4,1,3); plot((M+nD:samples),e(M+nD:samples)); title('error signal');
subplot(4,1,4); plot((M+nD:samples),(s(M+nD:samples)-e(M+nD:samples)).^2); title('Square error between the wideband signal and error signal');

figure;
subplot(4,1,1); plot(0:2/fft_samples:2,h_fft); title('FFT of system'); xlabel('angular frequency (pi rad/s)');
subplot(4,1,2); plot(0:2/fft_samples:2,x_fft); title('FFT of input signal'); xlabel('angular frequency (pi rad/s)');
subplot(4,1,3); plot(0:2/fft_samples:2,y_fft); title('FFT of estimated Interference'); xlabel('angular frequency (pi rad/s)');
subplot(4,1,4); plot(0:2/fft_samples:2,e_fft); title('FFT of output signal'); xlabel('angular frequency (pi rad/s)');
