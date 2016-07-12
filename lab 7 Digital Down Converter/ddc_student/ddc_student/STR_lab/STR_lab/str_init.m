function [str_state] = str_init(p);
% [ddc_state] = ddc_init(p);
%
% Initializes state of DDC according to parameters in ddc_param.
%
% Inputs:
%	p	Parameters of DDC.  
%		.h_bp	Coefficients of band-pass filter
%		.f0	Nominal center frequency (discrete)
%		.ft	Nominal center frequency of tone (discrete)
%		.a, .b	Coefficients of the IIR filter for PLL
%		.K	Loop gain of PLL
%		.fm	Frequency multiple (carrier relative to tone)

% Store required variables in ddc state
str_state.Tc = p.Tc;

% Get required shift of accumulator to compensate for delay of BPF
%str_state.del = param.ft*((length(param.h_bp)-1)/2);

% Create band-pass filter
str_state.delay_state = delay_init(1000, p.Tc/2);

% Create PLL for carrier recovery
str_state.pll_state = pll_init(p.ft, p.T, p.xi, p.K);

% Create matched filters
%ddc_state.lpf1_state = fir_init(param.h_lp);
%ddc_state.lpf2_state = fir_init(param.h_lp);

str_state.accum_old = 0;


