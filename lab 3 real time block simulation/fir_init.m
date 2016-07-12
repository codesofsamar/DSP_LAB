function [state] = fir_init(h, Ns);

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
state.h = h;

%% 2. Create state variables
% Make buffer big enough to hold Ns+Nh coefficients.  Make it an integer power
% of 2 so we can do simple circular indexing.
state.L = 2^(ceil(log2(Ns+length(state.h))+1));

% Temporary storage for circular buffer
state.Lmask = state.L-1;
state.buff = zeros(state.L, 1);

% Set initial tail pointer and temp pointer (see pseudocode)
state.n_h = 0;
state.n_p = 0;
