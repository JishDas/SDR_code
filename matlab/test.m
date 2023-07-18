clear; clc;
qpskmod = comm.QPSKModulator('BitInput',true);
txData = ((0:1:1e6)./2)';
moddata = qpskmod(txData);