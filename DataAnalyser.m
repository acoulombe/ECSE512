clear all;
close all;

% User Modifyable Parameters
variable = 'r';                     % Variable to analyse effect on output [M,nD,f,r]
M = 50;                             % Order of the filter
nD = 50;                           % Delay of the input signal to the filter
f = 0.1;                            % frequency of the interference sine wave ]0,0.5[
r = 0.001;                         % Learning/Forgetting rate of the convergence to the optimal system
env = 'stationary';                 % Stationary or none stationary environment

%====================================================================================
%                       Main Runnable Script (do not modify)
%====================================================================================

% Prepare holders
x = [];
s = [];
i = [];
e = [];
h = [];
y = [];
idx = [];

% Search for Data that matches conditions
switch variable
    case 'r'
        conditions = sprintf("_M%d_nD%d_f%f",M,nD,f);
    case 'M'
        conditions = sprintf("_nD%d_f%f_r%f",nD,f,r);
    case 'f'
        conditions = [sprintf("_M%d_nD%d",M,nD), sprintf("_r%f",r)];
    case 'nD'
        conditions = [sprintf("_M%d",M), sprintf("_f%f_r%f",f,r)];
end

ls = dir(sprintf('TestData/%s',env));

for set = 1:length(ls)
   valid = false;
   for seg = 1:length(conditions)
       if(contains(ls(set).name,conditions(seg)))
           valid = true;
       else
           valid = false;
           break
       end
   end
   if(valid)
       idx = [idx set];
       x = [x, load(sprintf('TestData/%s/%s/x.mat',env,ls(set).name))];
       s = [s, load(sprintf('TestData/%s/%s/s.mat',env,ls(set).name))];
       i = [i, load(sprintf('TestData/%s/%s/i.mat',env,ls(set).name))];
       e = [e, load(sprintf('TestData/%s/%s/e.mat',env,ls(set).name))];
       h = [h, load(sprintf('TestData/%s/%s/h.mat',env,ls(set).name))];
       y = [y, load(sprintf('TestData/%s/%s/y.mat',env,ls(set).name))];
   end
end

if(isempty(x))
    "No data set matching selected parameters"
    return
end

% Plot Error
hold on;
samples = length(x(1).x);
order = 500;
for set = 1:length(x)
    s_ = s(set).s;
    e_ = e(set).e;
    mse = MovingAverage(abs(s_-e_).^2,order);
    plot(mse);
end
title('Mean Square Error Between s[n] and e[n]');
xlabel('Sample n');
ylabel(sprintf('%s (moving average of %d samples)', 'Mean Square Error', order));
legend(replace({ls(idx).name}, '_','/'),'Location', 'northeast');
hold off;

% Plot Converged Filter system function H
figure;
hold on;
fft_samples = ceil(samples*0.1);
for set = 1:length(h)
    % Frequency response of the signals
    h_ = h(set).h;
    h_fft = abs(fft(h_,fft_samples+1));
    plot(0:2/fft_samples:2,h_fft);
end
title('Adaptive filter H(\omega)');
xlabel('Angular Frequency (\pi rad/s)');
ylabel('Amplitude');
legend(replace({ls(idx).name}, '_','/'),'Location', 'north');
hold off;