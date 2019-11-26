clear all;
close all;

% Parameters
M = 30;
nD = 100;
f = 0.1;
r = 0.0001;

% Prepare holders
x = [];
s = [];
i = [];
e = [];
h = [];
y = [];
idx = [];

% Search for Data that matches conditions
%conditions = sprintf('_M%d_nD%d_f%f',M,nD,f);
conditions = sprintf('_nD%d_f%f_r%f',nD,f,r);

ls = dir('TestData');

for set = 1:length(ls)
   if(contains(ls(set).name,conditions))
       idx = [idx set];
       x = [x, load(sprintf('TestData/%s/x.mat',ls(set).name))];
       s = [s, load(sprintf('TestData/%s/s.mat',ls(set).name))];
       i = [i, load(sprintf('TestData/%s/i.mat',ls(set).name))];
       e = [e, load(sprintf('TestData/%s/e.mat',ls(set).name))];
       h = [h, load(sprintf('TestData/%s/h.mat',ls(set).name))];
       y = [y, load(sprintf('TestData/%s/y.mat',ls(set).name))];
   end
end

% Plot Error
hold on;
samples = length(x(1).x);
order = 500;
for set = 1:length(x)
    s_ = s(set).s;
    e_ = e(set).e;
    err = MovingAverage(abs(s_(M+nD:samples)-e_(M+nD:samples)),order);
    plot((M+nD:samples),err);
end
title('Absolte error between s[n] and e[s]');
xlabel('sample n');
ylabel(sprintf('%s (mean of %d samples)', 'Mean error', order));
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
title('Adaptive filter H(w)');
xlabel('Angular Frequency (pi rad/s)');
legend(replace({ls(idx).name}, '_','/'),'Location', 'north');
hold off;