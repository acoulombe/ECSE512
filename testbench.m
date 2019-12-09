close all;
clear all;

% User Modifyable Parameters ==========================
type = 'RLS';               % Type of adaptive filter to use (LMS or RLS)
M = 25;                     % Memory of the adaptive filter
nD = 50;                    % Delay of the input signal x[n]
f = 0.05;                   % Frequency of the interference sine wave ]0,0.5[

env = 'non-stationary';     % Determine environment to use
switch env
    case 'stationary'
        samples = 10000;
        s = randn(1,samples);               % Wideband signal s[n]
    case 'non-stationary'
        src_file = "48k/CA/CA01_01.wav";    % Audio file to use as wideband signal s[n]
        [v, Fs] = audioread(src_file);
        samples = length(v);
        s = v'; 
end
n = 1:samples;    
i = 0.1*sin(pi*f*n);            % narrowband interference signal i[n]
%i = 0.2*sin(pi*sqrt(n/100));   % Time-varying narrowband interference
x = s+i;                        % Input signal x[n]
d = x;                          % Desired signal d[n]

mu = 0.01;                  % Learning rate/step-size of the convergence to the optimal system
lambda = 1;                 % Forgetting rate of the convergence to the optimal system

%====================================================================================
%                       Main Runnable Script (do not modify)
%====================================================================================

% Filter Runner
switch type
    case 'LMS'
        [y,e,h] = LMS(x,x,M,nD,mu);
        % Data collection
        SaveData(env,'LMS',M,nD,f,mu,x,s,i,y,h,e);
    case 'RLS'
        [y,e,h] = RLS(x,x,M,nD,lambda);
        % Data collection
        SaveData(env,'RLS',M,nD,f,lambda,x,s,i,y,h,e);
    otherwise
        "Invalid type of adaptive filter"
        return
end
hold on;
plot(x);
plot(i);
plot(e);
plot(s);

abs(snr(e,i)-snr(s,i))

% Frequency response of the signals
fft_samples = ceil(samples*0.1);
x_fft = abs(fft(x(samples-fft_samples:samples)));
y_fft = abs(fft(y(samples-fft_samples:samples)));
e_fft = abs(fft(e(samples-fft_samples:samples)));
h_fft = abs(fft(h,fft_samples+1));

% Plot the values of interest
figure;
subplot(4,1,1); plot((M+nD:samples),x(M+nD:samples)); title('Input Signal x[n]');
subplot(4,1,2); plot((M+nD:samples),y(M+nD:samples)); title('Estimated Interference Signal i[n]');
subplot(4,1,3); plot((M+nD:samples),e(M+nD:samples)); title('Error Signal e[n]');
subplot(4,1,4); plot((M+nD:samples),(s(M+nD:samples)-e(M+nD:samples)).^2); title('Square Error Between s[n] and e[n]');

figure;
subplot(4,1,1); plot(0:2/fft_samples:2,h_fft); title('Adaptive Filter H(\omega)'); xlabel('Angular Frequency (\pi rad/s)');
subplot(4,1,2); plot(0:2/fft_samples:2,x_fft); title('Input Signal X(\omega)'); xlabel('Angular Frequency (\pi rad/s)');
subplot(4,1,3); plot(0:2/fft_samples:2,y_fft); title('Estimated Interference I(\omega)'); xlabel('Angular Frequency (\pi rad/s)');
subplot(4,1,4); plot(0:2/fft_samples:2,e_fft); title('Output Signal E(\omega)'); xlabel('Angular Frequency (\pi rad/s)');
% ====================================================================================

% Report figures
figure;
subplot(2,1,1); plot((M+nD:samples),s(M+nD:samples)); title('Speech Signal s[n]');
subplot(2,1,2); plot((M+nD:samples),x(M+nD:samples)); title('Input Signal x[n]');
% 
% figure;
% plot(0:2/fft_samples:2,x_fft); title('Input Signal X(\omega)'); xlabel('Angular Frequency (\pi rad/s)');
% 
% figure; hold on;
% plot(0:2/fft_samples:2,x_fft);
% plot(0:2/fft_samples:2,e_fft); title('Frequency Domain Input and Output Signals'); xlabel('Angular Frequency (\pi rad/s)');
% legend('Input Signal X(\omega)','Output Signal E(\omega)');
% 
% figure;
% plot(0:2/fft_samples:2,h_fft); title('Adaptive Filter H(\omega)'); xlabel('Angular Frequency (\pi rad/s)');
% 
% figure;
% plot(0:2/fft_samples:2,y_fft); title('Estimated Interference I(\omega)'); xlabel('Angular Frequency (\pi rad/s)');