---
title: "Lab 3 Part 1: FIR Filter Design"
author: "Patrick Farmer 20331828"
date: "12-07-2024"
---

![](https://www.tcd.ie/media/tcd/site-assets/images/tcd-logo.png)

\clearpage


## Lab 3 - Part A: FIR Filter Design
### Lab / Problem Description
In this lab I was given an audio file that had a woman talking but in the background a constant tone. The objective was to remove this background tone. This was done by first identifying the frequency range that the tone was in and then designing an FIR filter to remove this tone. 
### Filter Designer Tool
The Filter Designer Tool inside matlab was used to create an FIR Filter to the following specifications:
* Stopband attenuation > 90dB
* Passband ripple < 0.02 dB
* Passband edge frequency 3.375 kHz
* Stopband edge frequency 5.625 kHz
* Sampling frequency 20 kHz
This filter was then exported and tested against the audio file. This filter was however designed to remove the low-mid range frequencies which was not where our constant tone was so it simply muffled the voice we wanted to keep. In order to design for the correct frequency range we needed to identify the frequency of the tone.
### Filter Design
To then design the filter that filters the correct frequencies out there were 3 main steps:
#### Identifying the Noise
The first step was to identify the frequency of the noise. This was done in two ways. THe first of which was to plot the frequency response of the audio file across all frequencies. From observing this plot we could see that the tone was around 200hz.\
The second way was to use the FFT function in matlab to find the frequency of the noise. This was done by taking the FFT of the audio file and then finding the frequency with the highest amplitude, this gave use the frequency of the tone which was then printed to terminal.
#### Designing the FIR Filter
After using the FIR filter designer tool in the previous step I decided to instead use the firpm function in matlab to design the filter after changing the specifications of the filter instead as this gave me the ability to iterate on the filter design much quicker. This also gave me the ability to take the identified tone frequency as a parameter in the calculation of the FIR filter specifications which would benefit code re-usability if ever repurposed. The final filter was designed with the following specifications:
* samplingFrequency = 20000;
* passbandFrequency = 2 * identifiedNoiseFrequency;
* stopbandFrequency = identifiedNoiseFrequency + ( identifiedNoiseFrequency / 3) ;
* passbandRipple = 0.02;
* stopbandAttenuation = 90;
#### Quantising the Filter
### Reflections