clc
clear all
% test_pll.m
%
% Script to test the PLL.
% Global parameters
Nb = 10; % Number of buffers
Ns = 100; % Samples in each buffer
%n = 0:1:Nb*Ns-1;
%x = sin(2*pi*0.9*n);
%load('ref_800hz.mat');
load('ref_stepf.mat');
x = ref_in;
n = length(x);
%x = 10000*sin(2*pi*0.11*[1:1000]);
x1 = reshape(x, 100, 10);
state = pll_init(0.1, 1.0, 1.0,2*pi/100);
state.amp_est = 1;
for i=1:Nb,
[state,y_out] = pll(state,x1(:,i));
state.amp_est
output(:,i) = y_out';
end
y1 = output(:);
m=1:n;
plot(m,y1,'r',m,x)
%plot(m(400:500),y1(400:500),'r',m(400:500),ref_in(400:500),'b')