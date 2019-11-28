close all;
clear all;

% User Modifyable Parameters
type = 'LMS';               % Type of adaptive filter to use (LMS or RLS)
M = 50;                     % Memory of the adaptive filter
nD = 100;                   % Delay of the input signal x[n]
f=0.1;                      % frequency of the interference sine wave ]0,0.5[

env = 'non-stationary';     % Determine environment to use
switch env
    case 'stationary'
        samples = 10000;
        s = randn(size(i));         % wideband signal s[n]
    case 'non-stationary'
        src_file = "48k/CA/CA01_01.wav";    % audio file to use as wideband signal s[n]
        [v, Fs] = audioread(src_file);
        samples = length(v);
        s = v'; 
end
n = 1:samples;    
i = sin(pi*f*n);            % narrowband interference signal i[n]
x = s+i;                    % input signal x[n]
d = x;                      % Desired signal d[n]

mu =0.0001;                 % Learning rate/step-size of the convergence to the optimal system
lambda = 0.999;             % Forgetting rate of the convergence to the optimal system

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
%====================================================================================
