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

ref_out = zeros(N, 1);
accum_out = zeros(N, 1);

%% Estimate amplitude of block
amp_est = mean(abs(ref_in))*(pi/2);

%% Get accumulator
accum = state.accum;

%% Put your PLL code here !!! 

%% comparing the phase
y(1) = state.ref_in_prev/amp_est*state.ref_out_prev;

%% loop filter
z(1) = a(1)*state.z_prev + b(1)*y(1) + b(2)*state.y_prev;

%% VCO
accum = accum + f0 - K * z(1)/(2*pi);
accum = accum - floor(accum);

for n = 2:N
    y(n) = ref_in(n-1).*ref_out(n-1)/amp_est;
    z(n) = a(1)*z(n-1) + b(1)*y(n) + b(2)*y(n-1);
    
    accum = accum + f0 - K * z(n)/(2*pi);
    accum = accum - floor(accum);
    
    accum_out(n) = accum;
    ref_out(n) = sin(2*pi*accum);
end

%% storing values 

state.ref_in_prev = ref_in(n);
state.ref_out_prev = ref_out(n);
state.y_prev = y(n);
state.z_prev = z(n);
state.accum = accum;

%% error('You need to add code to pll.m.');
% Don't forget to use state variables properly!

state_out = state;
