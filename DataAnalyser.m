clear all;
close all;

% Parameters
M = 30;
nD = 100;
f = 0.1;

% Prepare holders
x = [];
s = [];
i = [];
e = [];
h = [];
y = [];
idx = [];

% Search for Data that matches conditions
conditions = sprintf('_M%d_nD%d_f%f',M,nD,f);
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

% Plot data
samples = length(x(1).x);
hold on;
for set = 1:length(x)
    s_ = s(set).s;
    e_ = e(set).e;
    plot((M+nD:samples),(s_(M+nD:samples)-e_(M+nD:samples)));
end
legend(replace({ls(idx).name}, '_','/'));
hold off;