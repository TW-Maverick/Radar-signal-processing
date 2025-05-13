function [Freq, fftamp, Amp] = noncint(Data, G1_data, channel, Gate, noncint_num, fN, control, filenum)

if control == 0
    fftamp = ones([4,fN]);
    for i = 1:noncint_num   % Number of Non-Coherent Integrations
        fTs = Data(1).Time_res;
        fT = fN*fTs-fTs;
        rFreq = 1/fT;
        nFreq = Data(1).nfreq;
        Freq = (-nFreq:rFreq:nFreq)-rFreq/2;
    
        fftamp(i,:) = abs(fftshift(fft(G1_data(Gate-1,1+fN*(i-1):fN+fN*(i-1)), fN)))/fN;
        [~, col] = find(max(fftamp(i,:)) == fftamp(i,:));
        fftamp(i,col) = (fftamp(i,col-1) + fftamp(i,col+1))/2;   % Eliminate DC power
    
        f = figure;
        f.Position = [150,100,1100,500];
    
        plot(Freq, fftamp(i,:), 'LineWidth',2)
        xlabel('Frequency (Hz)')
        ylabel('Power')
        titlename = {datestr(Data.Reciver_time);['Channel ',num2str(channel),'   Range ',...
            num2str(1.7 + 0.3 * Gate),'~',num2str(2 + 0.3 * Gate),'km  ',' fN = ',num2str(fN), '   ', num2str(i)]};
        title(titlename,'FontSize',14)
    
        % save figure
        mkdir FFT_Plot
        frame = getframe(f);
        im=frame2im(frame);
        filename = ['File',num2str(filenum),' Channel ',num2str(channel),' Gate ',num2str(Gate),'  ', num2str(i),' FFT.png'];
        path = [cd,'\FFT_Plot\'];
        Merge = [path,filename];
        
        imwrite(im,Merge)
    end
    
    Amp = fftamp(1,:) + fftamp(2,:) + fftamp(3,:) + fftamp(4,:);
    plot(Freq, Amp, 'LineWidth',2)
    xlabel('Frequency (Hz)')
    ylabel('Power')
    titlename = {datestr(Data.Reciver_time);['Channel ',num2str(channel),'   Range ',...
        num2str(1.7 + 0.3 * Gate),'~',num2str(2 + 0.3 * Gate),'km  ',' fN = ',num2str(fN)]};
    title(titlename,'FontSize',14)
    
    % save figure
    mkdir FFT_Plot_noncint
    frame = getframe(f);
    im=frame2im(frame);
    filename = ['File',num2str(filenum),' Channel ',num2str(channel),' Gate ',num2str(Gate),' FFT_noncint.png'];
    path = [cd,'\FFT_Plot_noncint\'];
    Merge = [path,filename];
    
    imwrite(im,Merge)

else
    fftamp = ones([4,fN]);
    for i = 1:noncint_num   % Number of Non-Coherent Integrations
        fTs = Data(1).Time_res;
        fT = fN*fTs-fTs;
        rFreq = 1/fT;
        nFreq = Data(1).nfreq;
        Freq = (-nFreq:rFreq:nFreq)-rFreq/2;
    
        fftamp(i,:) = abs(fftshift(fft(G1_data(Gate-1,1+fN*(i-1):fN+fN*(i-1)), fN)))/fN;
        [~, col] = find(max(fftamp(i,:)) == fftamp(i,:));
        fftamp(i,col) = (fftamp(i,col-1) + fftamp(i,col+1))/2;   % Eliminate DC power
    end
    
    f = figure;
    f.Position = [150,100,1100,500];
    Amp = fftamp(1,:) + fftamp(2,:) + fftamp(3,:) + fftamp(4,:);
    Amp_nonoise = Amp - control;
    for i = 1:length(Amp_nonoise)
        if Amp_nonoise(i) < 0
            Amp_nonoise(i) = 0;
        end
    end
    plot(Freq, Amp_nonoise, 'LineWidth',2)
    xlabel('Frequency (Hz)')
    ylabel('Power')
    titlename = {datestr(Data.Reciver_time);['Channel ',num2str(channel),'   Range ',...
        num2str(1.7 + 0.3 * Gate),'~',num2str(2 + 0.3 * Gate),'km  ',' fN = ',num2str(fN),'  no noise']};
    title(titlename,'FontSize',14)
    
    % save figure
    mkdir FFT_Plot_noncint
    frame = getframe(f);
    im=frame2im(frame);
    filename = ['File',num2str(filenum),' Channel ',num2str(channel),' Gate ',num2str(Gate),' FFT_noncint_nonoise.png'];
    path = [cd,'\FFT_Plot_noncint\'];
    Merge = [path,filename];
    
    imwrite(im,Merge)
end
