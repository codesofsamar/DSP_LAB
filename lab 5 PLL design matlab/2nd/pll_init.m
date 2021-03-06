function [s] = pll_init(Ns, freq, damping_ratio, loop_gain, loop_corner_freq);

% [state] = fir_init(h, Ns);
%
% Creates a new FIR filter.
%
% Inputs:
%	h		Filter taps
%	Ns		Number of samples processed per block
% Outputs:
%	state		Initial state

%% 1. Save parameters
s.Ns = Ns;
s.accum = 0.0;
s.freq = freq;
s.damping_ratio = damping_ratio;
s.amp_est = 1.0;

s.tau_1 = loop_gain/(loop_corner_freq)^2;
s.tau_2 = (2*damping_ratio)/loop_corner_freq - 1/loop_gain; 
s.a1 = -(1 - 2*s.tau_1)/(1 + 2*s.tau_1);
s.b0 = (1 + 2*s.tau_2)/(1 + 2*s.tau_1);
s.b1 = (1 - 2*s.tau_2)/(1 + 2*s.tau_1);

%% 2. Create state variables

% Make buffer big enough to hold Ns+Nh coefficients.  Make it an integer power
% of 2 so we can do simple circular indexing.
s.vprev = zeros(Ns-1);
s.zprev = zeros(Ns-1);
