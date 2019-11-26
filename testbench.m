close all;
clear all;
% Parameters
M = 30;                     % Memory of the adaptive filter
nD = 100;                   % Delay of the input signal x[n]
samples = 10000;
n = 1:samples;
f=0.1;                      % frequency of the interference sine wave ]0,0.5[
i = sin(pi*f*n);            % narrowband interference signal i[n]

s = randn(size(i));         % wideband signal s[n]
x = s+i;                    % input signal x[n]
d = x;                      % Desired signal d[n]

mu =0.0001;                 % Learning rate/step-size of the convergence to the optimal system
lambda = 0.999;             % Forgetting rate of the convergence to the optimal system

% Filter Runner
%LMS
[y,e,h] = LMS(x,x,M,nD,mu);
% Data collection
SaveData('LMS',M,nD,f,mu,x,s,i,y,h,e);

%RLS
% [y,e,h] = RLS(x,x,M,nD,lambda);
% % Data collection
% SaveData('RLS',M,nD,f,lambda,x,s,i,y,h,e);

% Frequency response of the signals
fft_samples = ceil(samples*0.1);
x_fft = abs(fft(x(samples-fft_samples:samples)));
y_fft = abs(fft(y(samples-fft_samples:samples)));
e_fft = abs(fft(e(samples-fft_samples:samples)));
h_fft = abs(fft(h,fft_samples+1));

% Plot the values of interest
figure;
subplot(4,1,1); plot((M+nD:samples),x(M+nD:samples)); title('input signal x[n]');
subplot(4,1,2); plot((M+nD:samples),y(M+nD:samples)); title('estimated interference signal i[n]');
subplot(4,1,3); plot((M+nD:samples),e(M+nD:samples)); title('error signal e[n]');
subplot(4,1,4); plot((M+nD:samples),abs(s(M+nD:samples)-e(M+nD:samples))); title('Absolute error between s[n] and e[n]');

figure;
subplot(4,1,1); plot(0:2/fft_samples:2,h_fft); title('adaptive filter H(w)'); xlabel('angular frequency (pi rad/s)');
subplot(4,1,2); plot(0:2/fft_samples:2,x_fft); title('input signal X(w)'); xlabel('angular frequency (pi rad/s)');
subplot(4,1,3); plot(0:2/fft_samples:2,y_fft); title('estimated Interference I(w)'); xlabel('angular frequency (pi rad/s)');
subplot(4,1,4); plot(0:2/fft_samples:2,e_fft); title('output signal E(w)'); xlabel('angular frequency (pi rad/s)');
