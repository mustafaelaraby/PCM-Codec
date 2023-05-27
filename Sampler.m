function [sampled_signal, time_vector] = Sampler(signal, sampling_frequency)
    % Calculate the time step between samples
    original_fs = numel(signal);
    step = ceil(original_fs/sampling_frequency);

    % Generate the time vector
    time_vector = 0:step:(length(signal)-1);
    
    % Perform the sampling
    sampled_signal = signal(1:step:end);
end
