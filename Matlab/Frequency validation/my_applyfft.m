data_struct = load_mat;
N = length(data_struct);

for i = 1:N
    data = data_struct(i).data;

    time = data(1,:);
    input = data(2,:);          %extracting data
    output = data(3,:);         %Choose output, 3 for base, 4 for tip
    dt = 0.002;

    x_max = 5;                  %plot x axis limit

    N = length(input);          %FFT input
    NFFT = 2^nextpow2(N);
    u_freq = fft(input,NFFT)/N;
    Sx = abs(u_freq);
    Pin = 2*Sx(1:NFFT/2);

    N = length(output);         %FFT output
    NFFT = 2^nextpow2(N);
    y_freq = fft(output,NFFT)/N;
    Sx = abs(y_freq);
    Pout = 2*Sx(1:NFFT/2);

    fs =1/dt;
    f = fs/2*linspace(0,1,NFFT/2);


    %figure(1)                   %Plot input in time domain
    %plot(data(1,:),data(2,:));

    %figure(2)                   %Plot input in freq domain
    %plot(f,Pin);
    %xlim([0,x_max]);

    %figure(3)                   %Plot output in freq domain
    %plot(f,Pout);
    %xlim([0,x_max]);

    %figure(4)
    %semilogx(f, G);
    %xlim([0,x_max]);

    [u_max(i), index] = max(Pin);  %Find amplitude and index of input principal component
    y_max(i) = Pout(index);
    omega(i) = 2*pi*f(index);

    %phase(i) = angle(y_freq(index))*180/pi;        %TODO
    
end

G = 20*log10(abs(y_max ./u_max));

figure(1)
semilogx(omega,G);
    
%figure(2)                  %TODO
%semilogx(omega,phase);

%clear all