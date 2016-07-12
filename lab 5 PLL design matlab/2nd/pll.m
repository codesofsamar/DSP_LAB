function [s_out, y] = pll(s_in, x)
 
 s = s_in;
 N_period = length(x);
  
 ref_in = x;
 %s.accum = s.accum + s.freq - (s.damping_ratio/(2*pi))* v(1);
 %s.accum = s.accum - floor(s.accum);
 ref_out(1) = sin(2*pi*s.accum);
 amp = 0;
 
for sample_idx = 1:N_period,
  
 amp = amp + abs(ref_in(sample_idx));
 ref_in(sample_idx) = ref_in(sample_idx)/s.amp_est;

end  



for ii= 2:(N_period),
  
 z(ii) = ref_in(ii) * ref_out(ii - 1);
 v(ii) = s.a1*s.vprev + s.b0*z(ii) + s.b1*s.zprev;  
 s.accum = s.accum + s.freq - (s.damping_ratio/(2*pi))* v(ii);
 s.accum = s.accum - floor(s.accum);
 ref_out(ii) = sin(2*pi*s.accum);
 s.vprev = v(ii-1);
 s.zprev = z(ii-1);
 
end

s.amp_est = amp/N_period/(2/pi);
y = ref_out;
s_out = s;
