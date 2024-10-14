---
title: "Lab 3 Part 1: FIR Filter Design"
author: "Patrick Farmer 20331828"
date: "12-07-2024"
---

![](https://www.tcd.ie/media/tcd/site-assets/images/tcd-logo.png)

\clearpage


## Lab 3 - Part A: FIR Filter Design

### Overview
Lab 3 - Part A is part of your second graded lab. You are required to submit a lab report (for part A) that includes the following sections:
1. **What is the lab about**: Provide a brief description of the lab's objectives and goals.
2. **What did you do in the lab**: Summarize the tasks and experiments you performed.
3. **Descriptive parts as defined in the lab sheet**: Include detailed explanations and results as specified in the lab instructions.
4. **Reflections on the lab**: Share your thoughts and insights gained from the lab experience.

The report is due on the 19th of October, 2024 at 23:00. Additionally, you will also submit a zip file containing the Matlab files (see the details in the lab sheet). While the report is the primary content you will be marked on, the code will be tested against the details described in the report. Lab 3 - Part A is worth 10% of your overall module mark for 4C1/5M1.

### 4 Filtering a Noisy Audio File

#### 4.1 Problem Description
You will now design an FIR filter to filter out noise from a speech .wav file. You should be able to hear the noise when you listen to the sample (if not, please contact me). Either use the filterDesign Matlab tool or write a script to design an appropriate filter.

Everyone has been assigned a speech file with a slightly different tone. Do not assume that the quality of the filtered speech file for everyone will be the same. It will depend on exactly where your interfering tone is. Some people’s filter output will sound worse than others; you will be graded on your demonstrated understanding and application of filter design principles. You will need to decide what is reasonable for your speech file.

Please refer to the Appendix to see your assigned audio file.

#### 4.2 Instructions

**I. Identify the Noise**: First, you need to identify the frequency range you want to filter out. The Discrete Fourier Transform (DFT) allows you to examine the frequency content of the wavefile. The `fft()` function in Matlab is a fast implementation of the DFT. A pure tone has been added to each file at a different frequency which you will need to remove. You should read in and analyse the frequency content of the file in Matlab.

**Sample Code**:
```matlab
[x,Fs] = audioread('speech_0.wav'); % Read in audio file
% Plot to find out which frequency to remove from signal
nfft = 2^10;
X = fft(x, nfft);
fstep = Fs/nfft;
fvec = fstep*(0: nfft/2-1);
fresp = 2*abs(X(1:nfft/2));
plot(fvec,fresp)
title('Single-Sided Amplitude Spectrum of x(t)')
xlabel('Frequency (Hz)')
ylabel('|X(f)|')
```

This code will generate a figure showing the frequency content of the speech file. There should be a strong peak at a certain frequency. This is the noisy pure tone that was added. Write Matlab code to automatically capture the frequency of the tone and record this plot for your write-up (hint: `max` and `argmax` functions). Include this code in your Matlab script for submission with each line commented to demonstrate you understand its purpose.