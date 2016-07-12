function [Ib, Qb, state_out, d] = ddc(x, state_in);

% [Ib, Qb, state_out, d] = ddc(x, state_in);
%
% Operates on a single block of data to generate I and Q outputs.
%
% Inputs:
%	x	Data
% Outputs:
%	Ib, Qb	Down-converted outputs
%	d	Debug information

state = state_in;

% BPF to isolate tone
[t1 state.bpf_state] = fir(x, state.bpf_state);

% Send tone to PLL to get reference

[t2 accum1 state.pll_state] = pll(t1, state.pll_state);
%plot([1:100],t2, [1:100],t1);
% Compensate for delay of BPF to get aligned carrier.

accum1 = accum1 + state.del;

% Generate sine and cosine waveforms.  Take multiple of frequency.

sin_sin = -sin(2*pi*accum1*state.fm);
cos_cos = cos(2*pi*accum1*state.fm);

% Do down-conversion (multiply by carrier)

input_lpf2 = sin_sin .* x;
input_lpf1 = cos_cos .* x;

% Matched filtering

[qa state.lpf1_state] = fir(input_lpf1, state.lpf1_state);
[im state.lpf2_state] = fir(input_lpf2, state.lpf2_state);

% Now you should output Ib and Qb which are the baseband I and Q samples

% !!! There is a bug!
Ib = im;
Qb = qa;

% Return debug information if desired
if (nargout >= 4),
  d.accum = accum1;
  d.cos1 = cos_cos;
  d.sin1 = sin_sin;
  d.ref = t2;
  d.t1 = t1;
end

state_out = state;
