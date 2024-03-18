function [quantizedSignal,quantizedBits,Levels, err ] = quantizer(t,inputSignal, L, mp, quantizationType)

% Quantize the input signal
switch quantizationType
    case 'mid-rise'
        [quantizedSignal,quantizedBits,Levels,err] = midrise_quantizer(inputSignal,L,mp);
    case 'mid-tread'
        [quantizedSignal,quantizedBits,Levels,err] = midtread_quantizer(inputSignal,L,mp);
    otherwise
        error('Invalid quantization type. Choose ''mid-rise'' or ''mid-tread''.');
end

% Calculate the mean square quantization error
disp(['Mean Square Quantization Error: ' num2str(err)]);
% Plot the input signal and quantized signal
figure;
hold on;
plot(t, inputSignal, 'b', 'DisplayName', 'Input Signal');
plot(t, quantizedSignal, 'r', 'DisplayName', 'Quantized Signal');
hold off;
xlabel('Time');
ylabel('Amplitude');
title('Input Signal vs Quantized Signal');
legend('Input Signal', 'Quantized Signal');
end

function [quantized_signal,bit_Quantized_signal,Levels,error] =  midrise_quantizer(signal, L,mp)


step = ((2*mp)/L);
Levels = (-L/2):1:((L/2)-1);

Levels = (Levels.*step)+(0.5*step);

numBits = ceil(log2(L));                                                % Calculate the number of bits required
binaryArray = dec2bin(0:L-1, numBits);                                  % Generate the ordered binary array
[quantized_signal,err,index] = findNearestValue(Levels,signal);
for i=1:numel(signal)
    bit_signal(i,:)= binaryArray(index(i),:);
end
bit_Quantized_signal_char = join(reshape(bit_signal', 1, []));
bit_Quantized_signal = double(bit_Quantized_signal_char)-'0';
error = mean(err.^2);
end

function [quantized_signal,bit_Quantized_signal,Levels,error] =  midtread_quantizer(signal, L,mp)

step = ((2*mp)/L);
Levels = ((-L/2)+1):1:((L/2));
disp(numel(Levels));

Levels = (Levels.*step);

numBits = ceil(log2(L));                                                % Calculate the number of bits required
binaryArray = dec2bin(0:L-1, numBits);                                  % Generate the ordered binary array
[quantized_signal,err,index] = findNearestValue(Levels,signal);
for i=1:numel(signal)
    bit_signal(i,:)= binaryArray(index(i),:);
end
bit_Quantized_signal_char = join(reshape(bit_signal', 1, []));
bit_Quantized_signal = double(bit_Quantized_signal_char)-'0';
error = mean(err.^2);
end


%% Helper Functions.

function [resultArray, errorArray, indexArray] = findNearestValue(referenceArray, sampleArray)
resultArray = zeros(size(sampleArray));  % Initialize the result array
errorArray = zeros(size(sampleArray));   % Initialize the error array
indexArray = zeros(size(sampleArray));   % Initialize the index array

for i = 1:numel(sampleArray)
    sampleValue = sampleArray(i);
    
    % Find the index of the nearest value in the reference array
    [~, index] = min(abs(referenceArray - sampleValue));
    
    % Assign the nearest value to the result array
    resultArray(i) = referenceArray(index);
    
    % Calculate the error
    errorArray(i) = sampleValue - resultArray(i);
    
    % Store the index of the matching reference value
    indexArray(i) = index;
end
end
