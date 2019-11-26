function [y] = MovingAverage(x, M);
    %=================================================
    % Moving Average Filter algorithm
    % 
    % Parameters
    % x : 1xn line vector/matrix 
    %   Input signal of the system
    % M : scalar
    %   Order of the system h
    %
    %=================================================
    
    b = ones(M,1)/M;
    y = filter(b,1,x);
end