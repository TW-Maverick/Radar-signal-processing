function [noise_level] = Get_mean_noise(Amp_data, percentage)
Data_length = size(Amp_data,1)*size(Amp_data,2);
amp = reshape(Amp_data, [1,Data_length]);
amp = sort(amp);
noise_level = mean(amp(1:floor(Data_length*percentage)));  % Taking the average amplitude as the noise level
end