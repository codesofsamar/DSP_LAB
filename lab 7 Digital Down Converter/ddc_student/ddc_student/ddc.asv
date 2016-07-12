function [Ib, Qb, state_out, d] = ddc(x, param, state_in)

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
[pll_out, accum_out, state.pll_state] = pll(t1,state.pll_state);

% Compensate for delay of BPF to get aligned carrier.
accum_out = accum_out + state.del;

% Generate sine and cosine waveforms.  Take multiple of frequency.
accum1 = 2*pi*state.fm*accum_out;
sin1 = sin(accum1);
cos1 = cos(accum1);

% Do down-conversion (multiply by carrier)
x_q = x.*(-1).*sin1;
x_i = x.*cos1;

% Matched filtering
[q state.lpf1_state] = fir(x_q, state.lpf1_state);
[i state.lpf2_state] = fir(x_i, state.lpf2_state);

% Now you should output Ib and Qb which are the baseband I and Q samples
Qb = q;
Ib = i;

% Return debug information if desired
if (nargout >= 4),
  d.accum = accum1;
  d.cos1 = cos1;
  d.sin1 = sin1;
  d.ref = x;
  d.t1 = t1;
end

state_out = state;
