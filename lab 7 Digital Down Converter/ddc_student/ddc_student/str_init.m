function [str_state] = str_init(p) 
str_state.pll_state = pll_init(p.ft, p.T, p.xi, p.K);
str_state.delay_state = delay_init(1000,(p.Tc/2));

str_state.accum_prev = 0;
str_state.ft = p.ft;
