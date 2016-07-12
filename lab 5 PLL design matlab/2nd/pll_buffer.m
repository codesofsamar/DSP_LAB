function [ state_out, y ] = pll_buffer( s, ref_in, N_period )

y = zeros(1, N_period);
x = zeros(1, N_period);
v = zeros(1, N_period);

x(1) = s.x_init;
y(1) = s.y_init; 
v(1) = s.v_init;

s.accum = s.accum + s.freq - (s.damping_ratio/(2*pi))* v(1);
s.accum = s.accum - floor(s.accum);
y(1) = sin(2*pi*s.accum);

amp=0;
for a=1:N_period
amp=amp+abs(ref_in(a));
end;
amp_est=amp/N_period/(2/pi);


for n= 2:N_period
x(n) = ref_in(n)/amp_est* y(n - 1);
v(n) = s.a1*v(n - 1) + s.b0*x(n) + s.b1*x(n - 1); 
s.accum = s.accum + s.freq - (s.damping_ratio/(2*pi))* v(n);
s.accum = s.accum - floor(s.accum);
y(n) = s.sin_table(round(2000*s.accum)+1);
end

s.y_init=y(N_period);
s.v_init=v(N_period);
s.x_init=x(N_period);

state_out=s;
end