samplingFrequency = 20000;
passbandFrequency = 500;
stopbandFrequency = 400;
passbandRipple = 0.02;
stopbandAttenuation = 90;

frequencyVector = [0 stopbandFrequency passbandFrequency samplingFrequency/2] / (samplingFrequency/2);
amplitudeVector = [0 0 1 1];

filterCoefficients = firpm(50, frequencyVector, amplitudeVector);

quantizationLevels = [4, 8, 16];

[frequencyResponse, frequencyAxis] = freqz(filterCoefficients, 1, 1024, samplingFrequency);

figure;
subplot(length(quantizationLevels) + 2, 1, 1);
plot(frequencyAxis, 20*log10(abs(frequencyResponse)));
title('Magnitude Response - Full Precision');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');

[audioData, audioSamplingFrequency] = audioread('../AudioFiles/speech_11.wav');

[originalFrequencyResponse, originalFrequencyAxis] = freqz(audioData, 1, 1024, audioSamplingFrequency);
subplot(length(quantizationLevels) + 2, 1, 2);
plot(originalFrequencyAxis, 20*log10(abs(originalFrequencyResponse)));
title('Magnitude Response - Original Audio');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');

filteredAudioDataFullPrecision = filter(filterCoefficients, 1, audioData);
audiowrite('../AudioFiles/filtered_audio_full_precision.wav', filteredAudioDataFullPrecision, audioSamplingFrequency);

for i = 1:length(quantizationLevels)
    numBits = quantizationLevels(i);
    quantizedCoefficients = round(filterCoefficients * (2^(numBits-1))) / (2^(numBits-1));
    
    filteredAudioDataQuantized = filter(quantizedCoefficients, 1, audioData);
    audiowrite(['../AudioFiles/filtered_audio_', num2str(numBits), '_bits.wav'], filteredAudioDataQuantized, audioSamplingFrequency);
    
    [quantizedFrequencyResponse, quantizedFrequencyAxis] = freqz(filteredAudioDataQuantized, 1, 1024, audioSamplingFrequency);
    
    subplot(length(quantizationLevels) + 2, 1, i + 2);
    plot(quantizedFrequencyAxis, 20*log10(abs(quantizedFrequencyResponse)));
    title(['Magnitude Response - ', num2str(numBits), ' Bits']);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
end

saveas(gcf, '../Images/quantized_magnitude_response_comparison.png');

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
