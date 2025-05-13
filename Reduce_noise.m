function [Amp_nonoise, noise_level] = Reduce_noise(Amp, probability)
Amp_ravel = reshape(Amp,[1,size(Amp,1)*size(Amp,2)]);
Amp_ravel_1 = sort(Amp_ravel);
noise_level = mean(Amp_ravel_1(1:floor(length(Amp_ravel)*probability)));

Amp_nonoise = Amp_ravel - noise_level;

for i = 1:length(Amp_nonoise)
    if Amp_nonoise(i) < 0
        Amp_nonoise(i) = 0;
    end
end
Amp_nonoise = reshape(Amp_nonoise,[size(Amp,1),size(Amp,2)]);
end