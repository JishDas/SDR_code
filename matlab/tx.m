clear all;
clc;
%% Pluto SDR initialization
trx = sdrtx('Pluto', 'Gain', -10);
samplesPerSymbol = 4;
trx.CenterFrequency = 2.4e9;
%% Data to be transmitted
sine = dsp.SineWave(1, 10, 0);
sine.SamplesPerFrame = 2e4;
data = sine();
% quantization
for i = 1:length(data)
if data(i) < 0
    data(i) = 0;
else
        data(i) = 1;
end
end

%% modulation
bpskmod = comm.BPSKModulator;
moddata = bpskmod(data);
rctFilt = comm.RaisedCosineTransmitFilter( ...
    'OutputSamplesPerSymbol', samplesPerSymbol);

%% barker bits- for frame sync
barkerLength = 26;
hBCode = comm.BarkerCode('Length',7,'SamplesPerFrame', barkerLength/2);
barker = hBCode()>0; frame=[barker;barker;moddata];frameSize = length(frame);
transmit = rctFilt(frame);
eyeDiagram(transmit);
trx.transmitRepeat(transmit);

%% Visualization tools
plot(data);
Fs = 30;  % Sample rate
scope = spectrumAnalyzer(SampleRate=Fs,AveragingMethod="exponential",...
    PlotAsTwoSidedSpectrum=true,...
    RBWSource="auto",SpectrumUnits="dBW");
scope(transmit);
cd = comm.ConstellationDiagram;
cd(moddata);