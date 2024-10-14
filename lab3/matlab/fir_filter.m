samplingFrequency = 20000;
passbandFrequency = 500;
stopbandFrequency = 400;
passbandRipple = 0.02;
stopbandAttenuation = 90;

frequencyVector = [0 stopbandFrequency passbandFrequency samplingFrequency/2] / (samplingFrequency/2);
amplitudeVector = [0 0 1 1];

filterCoefficients = firpm(50, frequencyVector, amplitudeVector);

quantizationLevels = [4, 8, 16];

[h, w] = freqz(filterCoefficients, 1, 1024, samplingFrequency);

figure;
subplot(length(quantizationLevels) + 1, 1, 1);
plot(w, 20*log10(abs(h)));
title('Magnitude Response - Full Precision');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');

for i = 1:length(quantizationLevels)
    numBits = quantizationLevels(i);
    quantizedCoefficients = round(filterCoefficients * (2^(numBits-1))) / (2^(numBits-1));
    
    [hQuantized, w] = freqz(quantizedCoefficients, 1, 1024, samplingFrequency);
    
    subplot(length(quantizationLevels) + 1, 1, i + 1);
    plot(w, 20*log10(abs(hQuantized)));
    title(['Magnitude Response - ', num2str(numBits), ' Bits']);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
end

saveas(gcf, '../quantized_magnitude_response.png');

[audioData, audioSamplingFrequency] = audioread('../speech_11.wav');

filteredAudioDataFullPrecision = filter(filterCoefficients, 1, audioData);
audiowrite('../filtered_audio_full_precision.wav', filteredAudioDataFullPrecision, audioSamplingFrequency);

for i = 1:length(quantizationLevels)
    numBits = quantizationLevels(i);
    quantizedCoefficients = round(filterCoefficients * (2^(numBits-1))) / (2^(numBits-1));
    
    filteredAudioDataQuantized = filter(quantizedCoefficients, 1, audioData);
    audiowrite(['../filtered_audio_', num2str(numBits), '_bits.wav'], filteredAudioDataQuantized, audioSamplingFrequency);
end
