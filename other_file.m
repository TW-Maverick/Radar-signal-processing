clc;clear;close all

path = 'C:\Users\wayne\OneDrive\桌面\雷達課\期末專題\radars3';
in = 4;   % File number N
[IQ, Data] = Read_get(path, in);

%%
f1 = figure;
f1.Position = [150,100,1100,500];

[Channel_1_I, Channel_1_Q] =  GetIQ(IQ, 2, 87, 1);
Channel_1_amp = sqrt(Channel_1_I.^2 + Channel_1_Q.^2);
C1_noise = Get_mean_noise(Channel_1_amp, 0.3);  % The noise level is estimated by averaging the lowest 30% of the amplitude values
dB1 = 20 * log10(Channel_1_amp./C1_noise);

[Channel_2_I, Channel_2_Q] =  GetIQ(IQ, 2, 87, 2);
Channel_2_amp = sqrt(Channel_2_I.^2 + Channel_2_Q.^2);
C2_noise = Get_mean_noise(Channel_2_amp, 0.3);
dB2 = 20 * log10(Channel_2_amp./C2_noise);

[Channel_3_I, Channel_3_Q] =  GetIQ(IQ, 2, 87, 3);
Channel_3_amp = sqrt(Channel_3_I.^2 + Channel_3_Q.^2);
C3_noise = Get_mean_noise(Channel_3_amp, 0.3);
dB3 = 20 * log10(Channel_3_amp./C3_noise);

time = linspace(0.0512,Data.ACQ_TIME,Data.datanum);
range = linspace(Data.min_range + Data.Range_res, ...
    Data.max_range-300, Data.Range_gate-1)/1000;   % The last Range Gate is 27.8 ~ 28.1 km
                                                   % The second Range Gate is 2.3 ~ 2.6 km 

% RTI (Range-Time-Intensity)
imagesc(time, range, dB1)
ax = gca;
ax.YDir = 'normal';
colormap(jet)
c1 = colorbar;
c1.Label.String = 'dB';
caxis([15,30])
xlabel('time (s)')
ylabel('Range (km)')
title('File 4 Channel 1 RTI')

% save figure
mkdir RTI
frame1 = getframe(f1);
im1=frame2im(frame1);
filename1 = 'File4_RTI_Channel1.png';
path1 = [cd,'\RTI\'];
Merge1 = [path1,filename1];

imwrite(im1,Merge1)

%% Spectrum
noncint_num = 4;
fN = 256;
channel = 2;
C2_amp = Channel_2_amp(:,1:1024);
[All_amp_plus, ~, ~, ~] = noncint_all(Data, C2_amp, linspace(2,87,86), noncint_num, fN);
[All_amp_plus_nonoise, noise_level_plus] = Reduce_noise(All_amp_plus, 0.3);

[Freq, fftamp, Amp] = noncint(Data, Channel_2_amp, channel, 2, noncint_num, fN, noise_level_plus,4);

%% Gaussian fit
X = Freq(123:135);
Y = Amp(123:135);
m0 = trapz(X,Y);
m1 = trapz(X,X.*Y);
m2 = trapz(X,X.^2.*Y);
mu = m1/m0;
sigma = sqrt((m2/m0)-(m1/m0)^2);

f = figure;
f.Position = [150,100,1100,500];

G = (1/(sqrt(2*pi)*sigma)*exp(-((X-mu).^2)/(2*sigma^2)));
G1 = (1/(sqrt(2*pi)*sigma)*exp(-((X-mu).^2)/(2*sigma^2)))*(max(Y)/max(G));

plot(Freq,Amp, 'LineWidth',2)
hold on
plot(X,G1, 'LineWidth',2)
hold on
text1 = ('\mu1: '+string(mu));
text(4,110,text1,'FontSize',17)
text2 = ('\sigma1: '+string(sigma));
text(4,100,text2,'FontSize',17)

X = Freq(137:142);
Y = Amp(137:142);
m0 = trapz(X,Y);
m1 = trapz(X,X.*Y);
m2 = trapz(X,X.^2.*Y);
mu = m1/m0;
sigma = sqrt((m2/m0)-(m1/m0)^2);

G = (1/(sqrt(2*pi)*sigma)*exp(-((X-mu).^2)/(2*sigma^2)));
G1 = (1/(sqrt(2*pi)*sigma)*exp(-((X-mu).^2)/(2*sigma^2)))*(max(Y)/max(G));

plot(X,G1, 'LineWidth',2)
xlabel('Frequency (Hz)')
ylabel('Power')
text1 = ('\mu2: '+string(mu));
text(4,80,text1,'FontSize',17)
text2 = ('\sigma2: '+string(sigma));
text(4,70,text2,'FontSize',17)
legend('Signal','Gaussian fit 1','Gaussian fit 2')
titlename = {datestr(Data.Reciver_time);['Channel ',num2str(channel),'   Range ',...
        num2str(1.7 + 0.3 * 2),'~',num2str(2 + 0.3 * 2),'km  ',' fN = ',...
        num2str(fN)]};
title(titlename,'FontSize',14)

% save figure
mkdir Gaussian_fit
frame = getframe(f);
im = frame2im(frame);
filename = ['File',num2str(in),' Channel ',num2str(channel),' Gate ',num2str(5),' Gaussian fit.png'];
path = [cd,'\Gaussian_fit\'];
Merge = [path,filename];
        
imwrite(im,Merge)

