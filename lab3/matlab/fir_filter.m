% Read the audio file 
[audioData, audioSamplingFrequency] = audioread('../AudioFiles/speech_11.wav');

% Compute the FFT using the provided code and then plot the frequency response
nfft = 2^10;
audioDataFFT = fft(audioData, nfft);
frequencyStep = audioSamplingFrequency / nfft;
frequencyVector = frequencyStep * (0:nfft/2-1);
frequencyResponse = 2 * abs(audioDataFFT(1:nfft/2));
figure;
plot(frequencyVector, frequencyResponse);
title('Single-Sided Amplitude Spectrum of x(t)');
xlabel('Frequency (Hz)');
ylabel('|X(f)|');

% Identify the noise frequency and print it
[~, maxFrequencyIndex] = max(frequencyResponse);
identifiedNoiseFrequency = frequencyVector(maxFrequencyIndex);
disp(['Identified noise frequency: ', num2str(identifiedNoiseFrequency), ' Hz']);

% Set the FIR filter parameters
samplingFrequency = 20000;
passbandFrequency = 2 * identifiedNoiseFrequency;
stopbandFrequency = identifiedNoiseFrequency + ( identifiedNoiseFrequency / 3) ;
passbandRipple = 0.02;
stopbandAttenuation = 90;

% Convert the filter parameters to the format required by the firpm function
frequencyVector = [0 stopbandFrequency passbandFrequency samplingFrequency/2] / (samplingFrequency/2);
amplitudeVector = [0 0 1 1];

filterCoefficients = firpm(50, frequencyVector, amplitudeVector);

% Set the different levels of quantisation to be used
quantisationLevels = [2, 4, 8, 16];

% Add the magnitude response of the filter to the plot
[frequencyResponse, frequencyAxis] = freqz(filterCoefficients, 1, 1024, samplingFrequency);
figure;
subplot(length(quantisationLevels) + 2, 1, 1);
plot(frequencyAxis, 20*log10(abs(frequencyResponse)));
title('Magnitude Response - Full Precision');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');

% Add the magnitude response of the original audio to the plot
[audioData, audioSamplingFrequency] = audioread('../AudioFiles/speech_11.wav');
[originalFrequencyResponse, originalFrequencyAxis] = freqz(audioData, 1, 1024, audioSamplingFrequency);
subplot(length(quantisationLevels) + 2, 1, 2);
plot(originalFrequencyAxis, 20*log10(abs(originalFrequencyResponse)));
title('Magnitude Response - Original Audio');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');

% Filter the audio using the filter and save the audio file
filteredAudioDataFullPrecision = filter(filterCoefficients, 1, audioData);
audiowrite('../AudioFiles/filtered_audio_full_precision.wav', filteredAudioDataFullPrecision, audioSamplingFrequency);

% Quantise the filter coefficients and filter the audio with them
for i = 1:length(quantisationLevels)
    % Get quantised filter coefficients
    numBits = quantisationLevels(i);
    quantisedCoefficients = round(filterCoefficients * (2^(numBits-1))) / (2^(numBits-1));
    
    % Add the magnitude response of the quantised filter to the plot and write the audio file
    filteredAudioDataQuantised = filter(quantisedCoefficients, 1, audioData);
    audiowrite(['../AudioFiles/filtered_audio_', num2str(numBits), '_bits.wav'], filteredAudioDataQuantised, audioSamplingFrequency);
    
    [quantisedFrequencyResponse, quantisedFrequencyAxis] = freqz(filteredAudioDataQuantised, 1, 1024, audioSamplingFrequency);
    
    subplot(length(quantisationLevels) + 2, 1, i + 2);
    plot(quantisedFrequencyAxis, 20*log10(abs(quantisedFrequencyResponse)));
    title(['Magnitude Response - ', num2str(numBits), ' Bits']);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
end

% Save all the graphs from the plot to one image
saveas(gcf, '../Images/quantised_magnitude_response_comparison.png');

% Plot the frequency spectrum of the original and filtered audio
originalAudioFFT = abs(fft(audioData));
filteredAudioFFT = abs(fft(filteredAudioDataFullPrecision));
frequencyAxisFFT = linspace(0, audioSamplingFrequency, length(originalAudioFFT));

figure;
subplot(2,1,1);
plot(frequencyAxisFFT, originalAudioFFT);
title('Frequency Spectrum of Original Audio');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(2,1,2);
plot(frequencyAxisFFT, filteredAudioFFT);
title('Frequency Spectrum of Filtered Audio');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
saveas(gcf, '../Images/frequency_spectrum_comparison.png');
