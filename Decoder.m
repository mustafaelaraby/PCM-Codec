function [constructed,time] = Decoder(encoded,bit_dur,Levels,num_levels,decoding_criteria)
    step= bit_dur*log2(num_levels);
    shr= calculateAverages(encoded);
    num_bits = log2(num_levels);
    switch decoding_criteria
        case 'Manchester'
            decoded = decode_manchester_code(shr);
            level_indecise = [];
            level_indecise = separate_and_convert(decoded,num_bits);
            constructed = [];
            for i =1:numel(level_indecise)
               constructed(i) = Levels(level_indecise(i));
            end
        case 'AMI'
            decoded = decode_ami_code(shr,5);
            level_indecise = [];
            level_indecise = separate_and_convert(decoded,num_bits);
            constructed = [];
            for i =1:numel(level_indecise)
               constructed(i) = Levels(level_indecise(i));
            end            
        otherwise
            error('Invalid Decoding type. Choose ''Manchester'' or ''AMI''.');
    end
    time = 0:step:(numel(constructed)-1)*step;
end

function bits = decode_manchester_code(manchester_code)
    bits = [];
    for i = 1:2:length(manchester_code)
        if manchester_code(i) >=0 && manchester_code(i+1) <0
            bits = [bits, 0];
        elseif manchester_code(i) <=0 && manchester_code(i+1) >0
            bits = [bits, 1];
        elseif manchester_code(i) >=0 && manchester_code(i+1)>=0
            bits = [bits,1];
        elseif manchester_code(i) < 0 && manchester_code(i+1) < 0
            bits = [bits,0];
        else
            error('Invalid Manchester code sequence.');
        end
    end
end



function bits = decode_ami_code(signal, A)
    threshold = A/2;
    neg_threshold = -A/2;
    bits = [];
    for i = 1:length(signal)
        if(signal(i)>0)
            if signal(i) < threshold
                bits = [bits, 0];
            elseif signal(i) >=threshold
                bits = [bits, 1];
            else
                error('Invalid AMI signal sequence.');
            end

        elseif (signal(i)==0)
            bits = [bits, 0];
        else
            if signal(i) > neg_threshold
                bits = [bits, 0];
            elseif signal(i) <=neg_threshold
                bits = [bits, 1];
            else
                error('Invalid AMI signal sequence.');
            end
        end

    end
end

%% Helpers

function result = shrinkRepetitions(array, repetitions)
    % Initialize the result array
    result = [];
    
    % Loop over the array
    group_count = 0;
    for i = 1:numel(array)
        if group_count == 0
            current_value = array(i);
            group_count = group_count + 1;
        elseif array(i) == current_value
            group_count = group_count + 1;
        else
            result = [result current_value];
            group_count = 1;
            current_value = array(i);
        end
        
        % Check if the specified number of repetitions is completed
        if group_count == repetitions
            result = [result current_value];
            group_count = 0;
        end
    end
end

function decimal_values = separate_and_convert(binary_vector,num_bits)
    decimal_values = [];
    for i = 1:num_bits:length(binary_vector)
        binary_group = binary_vector(i:i+(num_bits-1));
        decimal_value = bin2dec(num2str(binary_group));
        decimal_values = [decimal_values (decimal_value+1)];
    end
end

function averages = calculateAverages(arr)
    averages = [];
    len = length(arr);
    
    for i = 1:5:len
        chunk = arr(i:min(i+4, len));
        average = mean(chunk);
        averages = [averages, average];
    end
end
