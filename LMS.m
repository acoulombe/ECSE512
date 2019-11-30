function [y, e, h] = LMS(x, d, M, nD, mu);
    %=================================================
    % Adaptive Filter using the Least-mean square algorithm
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
    % mu : scalar
    %   Step-size/Learning rate of the filter 
    %
    % Returns
    % y : 1xn line vector/matrix
    %   output signal of the adaptive filter h
    % h : 1xM line vector/matrix
    %   coefficients of the system function index 1 
    %   for h[n] all the way to index M for h[n-M-1] 
    % e : 1xn line vector/matrix
    %   priori error signal of the adaptive filter h
    %
    %=================================================
    
    samples = length(x);

    h = zeros(M,1);             % System function
    e = zeros(1,samples);       % Error signal
    y = zeros(1,samples);       % Output estimate signal
    
    for j = nD+M:samples 
        y(j) = x(j-M-nD+1:j-nD)*h;
        e(j) = d(j)-y(j);
        h = h + mu*e(j)*x(j-M-nD+1:j-nD)';
    end
        
    end
    