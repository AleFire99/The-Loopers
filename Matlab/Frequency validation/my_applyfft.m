close all
clear all

data_struct = load_mat;
N_datastruct = length(data_struct);
load('sysest4.mat')

for i = 1:N_datastruct
    data = data_struct(i).data;
    Numb_freq = length(data);
    time = data(1,2500:Numb_freq);
    input = data(2,2500:Numb_freq);          %extracting data
    output_base = data(3,2500:Numb_freq);         %Choose output, 3 for base, 4 for tip
    output_tip = data(4,2500:Numb_freq);         %Choose output, 3 for base, 4 for tip
    
    dt = 0.002;

    N = length(input);          %FFT input
    NFFT = 2^nextpow2(N);
    u_freq = fft(input,NFFT)/N;
    Sx = abs(u_freq);
    Pin = 2*Sx(1:NFFT/2);

    N = length(output_base);         %FFT output_base
    NFFT = 2^nextpow2(N);
    y1_freq = fft(output_base,NFFT)/N;
    Sx = abs(y1_freq);
    Pout_1 = 2*Sx(1:NFFT/2);
    
    N = length(output_tip);         %FFT output_tip
    NFFT = 2^nextpow2(N);
    y2_freq = fft(output_tip,NFFT)/N;
    Sx = abs(y2_freq);
    Pout_2 = 2*Sx(1:NFFT/2);
    

    fs =1/dt;
    f = fs/2*linspace(0,1,NFFT/2);


    %figure(1)                   %Plot input in time domain
    %plot(data(1,:),data(2,:));

    %x_max = 5;                  %plot x axis limit
    
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
    y1_max(i) = Pout_1(index);
    y2_max(i) = Pout_2(index);
    omega(i) = 2*pi*f(index);

    %phase(i) = angle(y_freq(index))*180/pi;        %TODO
    
end

[A B C D ]= sysest;

for freqs = 1:51
    %%
    states_nonlinear = initial;
    A23 = A(2,3);
    A43 = A(4,3);
    Tmodel1 = 0;
    Tmodel2 = 0;
    for i = 1:N_val-tstart
    alfa = states_nonlinear(3,i);
       % if abs(alfa)  0.1
            Tmodel1 = Ts*springcomp(alfa)/Jeq;
            Tmodel2 = -Ts*springcomp(alfa)*((Jeq+JL)/(JL*Jeq));
            A(2,3) = 0;
            A(4,3) = 0;
        %else
         %   A_cvx(4,3) = A23;
          %          A_cvx(4,3) = A43;

           % Tmodel =0;
            %Tmodel2 = 0;

    %    end
    states_nonlinear(:,i+1) = A * states_nonlinear(:,i) + B*Uvec_val(i) + [0 Tmodel1 0 Tmodel2 ]';
    %statess_est1(:,i+1) = A_cvx * statess_est1(:,i) + Ts*B_cvx*Uvec_val(i);

    end


    figure
    for i=1:4
    subplot(2,2,i)
    plot(tvec,statess_est(i,:),":r",tvec,states_val(i,:),"k", tvec, statess_phy(i,:),"b:", tvec, states_nonlinear(i,:),":x");

    title(ylab(i));

    end

end    


[mag,pha] = bode(sysest,omega);

%G_1 = 20*log10(abs(y1_max ./u_max)*(2*pi/4096));
G_1 = (abs(y1_max ./u_max)*(2*pi/4096));
magbase = mag(1,:,:);           %extraction of the mag of base, first dynamic
magbase = squeeze (magbase);
%magbase = 20*log10(magbase);

%G_2 = 20*log10(abs(y2_max ./u_max)*(2*pi/4096));
G_2 = (abs(y2_max ./u_max)*(2*pi/4096));
magtip = mag(2,:,:);           %extraction of the mag of tip, second dynamic
magtip = squeeze (magtip);
%magtip = 20*log10(magtip);

figure;
semilogx(omega,magbase,"r",omega,G_1,"xk");
figure;
semilogx(omega,magtip,"r",omega,G_2,"xk");
figure;
bode(sysest);


    
%figure(2)                  %TODO
%semilogx(omega,phase);

%clear all