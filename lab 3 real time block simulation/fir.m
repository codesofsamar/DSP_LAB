function [state_out, y] = fir(state_in, x);

% [state_out, y] = fir(state_in, x);
%
% Executes the FIR block.
%
% Inputs:
%	state_in	Input state
%	x		Samples to process
% Outputs:
%	state_out	Output state
%	y		Processed samples

% Get state
s = state_in;

% Move samples into tail of buffer
for i =0: length(x)-1,
    s.buff(s.n_t+1) = x(i+1);
    s.n_t = bitand(s.n_t+1, s.Lmask);

% Filter samples and move into output
s.n_p = bitand(s.n_t + s.Lmask, s.Lmask);
sum =0.0;

for l=0: length(s.h)-1,
    sum = sum + s.buff(s.n_p+1);
    s.n_p = bitand(s.n_p + s.Lmask, s.Lmask);
end

end
for i=0:length(x)-1
    y(i+1) = sum;
end

% Return updated state
state_out = s;
You could use the following code to check your filter:

