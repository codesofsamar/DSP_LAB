% test_ddc.m
%	Tests the digital down-converter using a known test
%	signal.

%% Block parameters
Ns = 100;	% Samples per block
n = [1:Ns];

%% System parameters
param = system_param;

%% Signal parameters

% Sample rate
fs = param.fs;
% Nominal Carrier frequency
f0 = param.f0;
% Tone frequency
ft = param.ft;
% Symbol rate
fc = param.fc;
% Cycles per symbol
cps = param.cps;

% Amplitude of signal and tone
as = 1;
at = 1;

% Do repeated pattern over and over
Nframe = 100;
symb1 = [0 0 0 0 1 2 2 3 1 2 2 0 1 2 2 3 1 2 2 0 1 2 2 3 1 2 2 0 1 2 2 3];
% Replicate this frame over and Nframe times
symb = kron(ones(1, Nframe), symb1);

% Generate signal from symbols
[s s_debug] = make_signal_4psk(fs, f0, ft, cps, param.h_ps, as, at, symb);

% Add noise (start without noise)
SNR = 1;
vs = sqrt(mean(abs(s).^2));
s = s + vs.*randn(length(s), 1)/10^(SNR/1);

% Compute number of blocks we have
Nb = floor(length(s)/Ns);

% Make signal into blocks
sb = reshape(s(1:Ns*Nb), Ns, Nb);

% DEBUG: Get components into blocks for debug.
% Tone signal alone
t_debug = reshape(s_debug.t(1:Ns*Nb), Ns, Nb);
% Carrier signal alone
c_debug = reshape(s_debug.c(1:Ns*Nb), Ns, Nb);
% Modulation signal alone
m_debug = reshape(s_debug.mod(1:Ns*Nb), Ns, Nb);

% DEBUG: Plot modulated signal
%for ii=1:Nb,
%  plot([1:Ns], real(m_debug(:, ii)), [1:Ns], imag(m_debug(:, ii)));
%  pause;
%end

% DEBUG: Reference design (ideal non-block operations)
%bb_ideal = conv(s.*conj(s_debug.c), param.ddc.h_lp);
%I_ideal = real(bb_ideal); I_ideal_b = reshape(I_ideal(1:Ns*Nb), Ns, Nb);
%Q_ideal = imag(bb_ideal); Q_ideal_b = reshape(Q_ideal(1:Ns*Nb), Ns, Nb);


% Process blocks
ddc_state = ddc_init(param.ddc);
str_state = str_init(param.str);

for ii=1:Nb,
  % Get a single block
  x = sb(:, ii);

  % Digital down converter
   [Ib Qb ddc_state ddc_debug] = ddc(x, ddc_state);

  % Symbol timing recovery / decision
  [si, str_state, str_debug] = str(Ib, Qb, param.str, str_state);
  
  % Do a plot showing where the waveform is sampled.  Should see that
  % samples occur nearly at peaks (not at transitions).  May take a few
  % blocks before PLLs track.
  sil = logical(si);
  plot(n, Ib, 'b', n, Qb, 'g', n(sil), Ib(sil), 'b*', n(sil), Qb(sil), 'g*');

  pause;

end
