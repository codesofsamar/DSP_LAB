function [ref_out, accum_out, state_out] = pll(ref_in, state_in);

% [ref_out] = pll(ref_in, state_in);
%
% Does PLL tracking of the input waveform.  Operates on complete waveform.
%
% Inputs:
%	ref_in		Input reference
%	state_in	State and parameters
% Outputs:
%	ref_out		Output reference
%	accum_out	Output accumulator

% Get parameters

state = state_in;

f0 = state.f0;
K = state.K;
a = state.a;
b = state.b;

N = length(ref_in);
n_samples=N;
ref_out = zeros(N, 1);
accum_out = zeros(N, 1);
accum = state.accum;
%% Estimate amplitude of block
amp_est = mean(abs(ref_in))*(pi/2);

%%first step of processing
z(1) = state.ref_in_prev/amp_est*state.ref_out_prev;
y(1) = a*state.y_prev + b(1)*z(1) + b(2)*state.z_prev;
ref_out(1) = sin(2*pi*accum);

accum = accum + f0 - (K/(2*pi))* y(1);
accum = accum - floor(accum);
accum_out(1) = accum;
ref_out(1) = sin(2*pi*accum);
%%rest of the processing
for n =  2:n_samples
	z(n) = ref_in(n-1)/amp_est* ref_out(n - 1);
	y(n) = a*y(n - 1) + b(1)*z(n) + b(2)*z(n - 1);  
	accum = accum + f0 - (K/(2*pi))* y(n);
	accum = accum - floor(accum);
	ref_out(n) = sin(2*pi*accum);
    accum_out(n) = accum;
end
%%saving prev values
state.ref_out_prev = ref_out(n_samples);
state.y_prev = y(n_samples);
state.z_prev = z(n_samples);
state.ref_in_prev = ref_in(n_samples);
%% Put your PLL code here !!!  
%%error('You need to add code to pll.m.');
% Don't forget to use state variables properly!
state.accum = accum;
state.accum_old = accum;
state_out = state;
