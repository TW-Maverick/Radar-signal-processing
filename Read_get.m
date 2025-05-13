function [IQ, Data] = Read_get(path, in)

filenamelist=dir(path);                                                 % Path of data
nn=erase(filenamelist(in).name,'raw.chungli52.');                       % Read the Number in file
infile=[path,'\raw.chungli52.',nn,''];                                  % Path of raw data

ghead_52_radar1;                                                        % This .m file should be placed in the same directory as this file
fC = 3*10^8;                                                            % Speed of light
m=nch*nrg1;
n=ntrial;
fFreq = 52*10^6;
IQ(1:m,1:n)=fread(fid,[m,n],'short');                                   % This is the IQ channel data of radar echoes

% Struct the data
Data.Freq = fFreq;
Data.Reciver_time = datetime(time1+3600*8,'TimeZone','Asia/Taipei','ConvertFrom','epochtime', ...
    'Format','eeee,dd-MMM-yyyy HH:mm:ss.SSS Z');                        % Start time of signal reception

Data.ACQ_TIME = str2double(s2(10:11));
Data.Range_res = str2double(s32(12:14));                                % Spatial resolution (m)
Data.PRF = str2double(s19(5:8));
Data.Time_res = ipp * cint;                                             % Temporal resolution (sec)
Data.datanum = Data.ACQ_TIME/Data.Time_res;                             % Number of data points per gate
Data.nfreq = 1/(2*Data.Time_res);                                       % Cutoff frequency (Hz)
Data.min_range = str2double(s28(7:10));                                 % Meter
Data.Range_gate = str2double(s11(7:8));                                 % Range Gate
Data.max_range = Data.min_range + Data.Range_gate * Data.Range_res;     % Meter
Data.max_doppler_velocity = Data.nfreq * (fC/Data.Freq) / 2;            % Maximum resolvable Doppler velocity (m/s)

%       cint = Number of in-phase coherence; fFreq = Transmission frequency; ipp = Inter-pulse period;  min_range = Minimum range(km);
%       nch = Number of CHANNELS(I+Q); nrg1 = Number of range gate; ntrial = Number of time intervals (Total duration / Temporal resolution);
%       pw = Pulse width; year_date_time = Date of signal reception;
end
