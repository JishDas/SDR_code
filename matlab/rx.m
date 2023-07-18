%% Initialization and setup

SamplesPerFrame = 1e4;
barkerLength = 26;
samplesPerSymbol = 4; decimation = 4;
FrameLength = barkerLength+SamplesPerFrame;
rcv = sdrrx('Pluto', 'RadioID', 'usb:0', 'SamplesPerFrame', SamplesPerFrame, ...
            'OutputDataType', 'double');
rcv.CenterFrequency = 2.4e9;
rcv.SamplesPerFrame = 120312;
rcrFilt = comm.RaisedCosineReceiveFilter( ...
    'InputSamplesPerSymbol',  samplesPerSymbol, ...
    'DecimationFactor',       decimation);

%% Frame synchronization

for i=1:numFrames
interim = rcrFilt(rcv());
hBCode = comm.BarkerCode('Length',7,'SamplesPerFrame', barkerLength/2);
seq = step(hBCode);
estDelay = finddelay(interim, seq);
% L = length(corr);
% [v,i] = max(corr);  % i reperesents the x starting point of the frame

%% Demodulation

data_frame = data1(x+barkerLength:end,1);
qpskdemod = comm.BPSKDemodulator;
data2 = qpskdemod(data_frame);

%% Visualization tools

cd = comm.ConstellationDiagram;
cd(data1);
plot(data2);

%% Release the radio

release(rcv);