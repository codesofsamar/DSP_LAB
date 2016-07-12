function [param] = system_param;

% [param] = system_param;
%
% Get system parameters.

% Sample rate
fs = 96000;
% Nominal frequency of carrier
f0 = 24000;
% Nominal frequency of tone
ft = 8000;
% Symbol rate
fc = 16000;
% Cycles per symbol
cps = f0/fc;

% Store global parameters
param.fs = fs;
param.f0 = f0;
param.ft = ft;
param.fc = fc;
param.cps = cps;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DDC Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
%% Filter to isolate tone

fmin = 5000;
fmax = 11000;

% Need a band-pass filter centered at 8kHz +- 2 kHz.

% Length of the filter
N = 32;

% Do a hamming window
wtype = 1;
p.x1 = fmin/fs; p.x2 = fmin/fs; p.x3 = fmax/fs; p.x4 = fmax/fs;
[h_bp, f_bp, Ha_bp, Hi_bp, w] = win_method('pw_lin', p, 1.0, 1, N, wtype);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLL params for locking to tone

K = 2;
T = 500;
xi = 1;
[a b tau1 tau2 K p] = loop_filter1(T, xi, K);

%%%%%%%%%%%%%%%%%%%%%%%%%
%% Filter after mix-down

fmin = 0;
fmax = 12000;

% Length of the filter
N = 32;

% Do a hamming window
wtype = 1;
p.x1 = fmin/fs; p.x2 = fmin/fs; p.x3 = fmax/fs; p.x4 = fmax/fs;
[h_lp, f_lp, Ha_lp, Hi_lp, w] = win_method('pw_lin', p, 1.0, 1, N, wtype);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Store needed parameters

param.ddc.h_lp = h_lp;
param.ddc.Ha_lp = Ha_lp;
param.ddc.f_lp = f_lp;
param.ddc.h_bp = h_bp;
param.ddc.f0 = f0/fs;
param.ddc.ft = ft/fs;
param.ddc.a = a;
param.ddc.b = b;
param.ddc.K = K;
param.ddc.fm = f0/ft;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Symbol timing recovery
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Loop filter
K = 2;
T = 200*fs/fc;  % Number of samples for pll time constant (400 symbols)
xi = 1;
[a b tau1 tau2 K p] = loop_filter1(T, xi, K);

param.str.a = a;
param.str.b = b;
param.str.Tc = 1/(fc/fs);
param.str.K = K;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Signal Generation parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Rectangular pulses (easier to visualize)
sps = round(fs/f0*cps);
param.h_ps = ones(sps,1);

% Matched filtering
%param.h_ps = param.ddc.h_lp;

% Frame sync symbol
param.frame.sync = [0 1 2 3];
param.frame.N    = 32;

