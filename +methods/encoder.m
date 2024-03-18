function [encoded_signal,time] = encoder(bitstream, pulse_amplitude, bit_duration,signaling_type)
encoded_signal = [];
step = bit_duration/10;
time = 0:step:(((length(bitstream))*step*10)-step);
if strcmpi(signaling_type, 'Manchester')
    man_signal = generate_manchester_code(bitstream,pulse_amplitude);
    encoded_signal = repelem(man_signal,5);
elseif strcmpi(signaling_type, 'AMI')
    ami_signal = generate_ami_code(bitstream,pulse_amplitude);
    encoded_signal = repelem(ami_signal,5);
    
end

switch signaling_type
    
    case 'Manchester'
        % Plot the encoded signal versus time
        figure;
        plot(time, encoded_signal, 'b', 'LineWidth', 2);
        xlabel('Time (s)');
        ylabel('Amplitude');
        title('Encoded Signal');
        ylim([-pulse_amplitude-0.1 pulse_amplitude+0.1]);
        
        % Zoom in on the first bit of the encoded signal
        xlim([0 bit_duration*5]);
        
    case 'AMI'
        % Plot the encoded signal versus time
        time = 0:step:(((length(bitstream))*step*5)-step);
        figure;
        plot(time, encoded_signal, 'b', 'LineWidth', 2);
        xlabel('Time (s)');
        ylabel('Amplitude');
        title('Encoded Signal');
        ylim([-pulse_amplitude-0.1 pulse_amplitude+0.1]);
        
        % Zoom in on the first bit of the encoded signal
        xlim([0 bit_duration*5]);
end

end

function manchester_code = generate_manchester_code(bits,A)
manchester_code = [];
for i = 1:length(bits)
    if bits(i) == 0
        manchester_code = [manchester_code, A, -A];
    else
        manchester_code = [manchester_code, -A, A];
    end
end
end

function ami_code = generate_ami_code(bits,A)
ami_code = [];
previous_polarity = A;
for i = 1:length(bits)
    if bits(i) == 0
        ami_code = [ami_code, 0];
    else
        ami_code = [ami_code, previous_polarity];
        previous_polarity = -previous_polarity;
    end
end
end
