function [y, e, h] = RLS(x, d, M, nD, lambda);
%=================================================
% Adaptive Filter using the Recursive Least-Square algorithm
% 
% Parameters
% x : 1xn line vector/matrix 
%   Input signal of the system
% d : 1xn line vector/matrix
%   Desired output signal of the system
% M : scalar
%   Order of the system h
% nD : scalar
%   Delay to the input signal to uncorrelate the signal
% lambda : scalar
%   Forgetting rate of the filter 
%
% Returns
% y : 1xn line vector/matrix
%   output signal of the adaptive filter h
% h : 1xM line vector/matrix
%   coefficients of the system function index 1 
%   for h[n] all the way to index M for h[n-M-1] 
% e : 1xn line vector/matrix
%   posteriori error signal of the adaptive filter h
%
%=================================================

samples = length(x);

h = zeros(M,1);             % System function
e = zeros(1,samples);       % Error signal
y = zeros(1,samples);       % Output estimate signal

delta = 1;                  % Inverse input signal power estimate

Sd = delta*eye(M);          % Inverse deterministic correlation matrix
                            % of the input signal
pd = zeros(M,1);            % deterministic cross-correlation vector
                            % between the input and the desired signals
for k = M+nD:samples
    Sd = (Sd - Sd*x(k-M-nD+1:k-nD)'*x(k-M-nD+1:k-nD)*Sd/(lambda+x(k-M-nD+1:k-nD)*Sd*x(k-M-nD+1:k-nD)'))/lambda;
    pd = lambda*pd+d(k)*x(k-M-nD+1:k-nD)';
    h = Sd*pd;
    y(k) = x(k-M-nD+1:k-nD)*h;
    e(k) = d(k)-y(k);
end

end
