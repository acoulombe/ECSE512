function SaveData(env,type,M,nD,f,r,x,s,i,y,h,e);
    %=================================================
    % Saves the collected data into .mat files for later analysis
    % 
    % Parameters
    % env : string
    %   environment of the filter
    % type : string
    %   type of filter data being saved (LMS/RLS)
    % M : scalar
    %   Order of the system h
    % nD : scalar
    %   Delay to the input signal to uncorrelate the signal
    % f : scalar
    %   Frequency of the sine wave interference (w/pi)
    % r : scalar
    %   Rate of the filter (learning/forgetting rate) 
    % x : 1xn line vector/matrix 
    %   Input signal of the system
    % s : 1xn line vector/matrix
    %   Wideband signal of the system
    % i : 1xn line vector/matrix
    %   Narrowband signal of the system
    % y : 1xn line vector/matrix
    %   output signal of the adaptive filter h
    % h : 1xM line vector/matrix
    %   coefficients of the system function index 1 
    %   for h[n] all the way to index M for h[n-M-1] 
    % e : 1xn line vector/matrix
    %   error signal of the adaptive filter h
    %
    %=================================================

    folder = sprintf('TestData/%s/%s_M%d_nD%d_f%f_r%f',env,type,M,nD,f,r);
    mkdir(folder);
    save(sprintf('%s%s',folder,'/x.mat'),'x');
    save(sprintf('%s%s',folder,'/s.mat'),'s');
    save(sprintf('%s%s',folder,'/i.mat'),'i');
    save(sprintf('%s%s',folder,'/y.mat'),'y');
    save(sprintf('%s%s',folder,'/h.mat'),'h');
    save(sprintf('%s%s',folder,'/e.mat'),'e');
    
    if(strcmp(env,'non-stationary'))
        audiowrite(sprintf('%s%s',folder,'/x.wav'),x,48000);
        audiowrite(sprintf('%s%s',folder,'/s.wav'),s,48000);
        audiowrite(sprintf('%s%s',folder,'/i.wav'),i,48000);
        audiowrite(sprintf('%s%s',folder,'/y.wav'),y,48000);
        audiowrite(sprintf('%s%s',folder,'/e.wav'),e,48000);
    end
end