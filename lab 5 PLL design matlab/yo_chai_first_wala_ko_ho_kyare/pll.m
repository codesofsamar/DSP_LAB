function[state_out,y] = pll(state_in,x)
% pll.m
%
% Script to set the PLL filter.
% Global parameters
s = state_in;
% Generate my input sin(2*pi*fi*n).
% input frequency
s = state_in;
N = length(x);
k = s.k;
a1 = s.a1;
b1 = s.b1;
b0 = s.b0;
f = s.f;
accum = s.accum;
z(1) = x(1) * s.y_out_old;
%Low pass filter
v(1) = a1 * s.v_old + b0 * z(1) + b1 * s.z_old;
%Compute accumulator
accum = accum + f - k/2/pi*v(1);
accum = accum - floor(accum);
%Get y_out sinusodal
y(1) = sin (2*pi*accum);
for n = 2:N,
%Multiply input x with y
z(n) = x(n) * y(n-1);
%Low pass filter
v(n) = a1 * v(n - 1) + b0 * z(n) + b1 * z(n - 1);
%Compute accumulator
accum = accum + f - k/2/pi*v(n);
accum = accum - floor(accum);
%Get y_out sinusodal
y(n) = sin (2*pi*accum);
end
%Save old values
s.accum = accum;
s.x_in_old = x(n);
s.y_out_old = y(n);
s.v_old = v(n);
s.z_old = z(n);
state_out = s;