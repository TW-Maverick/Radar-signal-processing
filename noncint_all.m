function [All_amp_plus, All_amp, All_amp_1, Freq] = noncint_all(Data, G1_data, Gate, noncint_num, fN)
Gate_num = length(Gate);
All_amp = ones([Gate_num, fN * noncint_num]);  % 做完FFT 組合起來
All_amp_1 = ones([Gate_num, fN * noncint_num]);

fTs = Data(1).Time_res;
fN1 = fN * noncint_num;
fT = fN1*fTs-fTs;
rFreq = 1/fT;
nFreq = Data(1).nfreq;
Freq = (-nFreq:rFreq:nFreq)-rFreq/2;  % Frequency corresponding to 1024-point FFT

for i = 1:Gate_num   % Number of Range Gate
    for i1 = 1:noncint_num   % Number of Non-Coherent Integrations
        All_amp(i,1+fN*(i1-1):fN+fN*(i1-1)) = abs(fftshift(fft(G1_data(i,1+fN*(i1-1):fN+fN*(i1-1)), fN)))/fN;
        [~, col] = find(max(All_amp(i,1+fN*(i1-1):fN+fN*(i1-1))) == All_amp(i,1+fN*(i1-1):fN+fN*(i1-1)));
        All_amp(i,fN*(i1-1) + col) = (All_amp(i,fN*(i1-1) + col-1) + All_amp(i,fN*(i1-1) + col+1))/2;   % Eliminate DC power
    end 
    All_amp_1(i, :) = abs(fftshift(fft(G1_data(i,:), fN * noncint_num)))/(fN * noncint_num);  % 用1024 FFT
    [~, col] = find(max(All_amp_1(i,:)) == All_amp_1(i,:));
    All_amp_1(i,col) = (All_amp_1(i,col-1) + All_amp_1(i,col+1))/2;   % Eliminate DC power
end
All_amp_plus = All_amp(:,1:256) + All_amp(:,257:512) + All_amp(:,513:768) + All_amp(:,769:1024);  % Signals are summed after applying the FFT

end
