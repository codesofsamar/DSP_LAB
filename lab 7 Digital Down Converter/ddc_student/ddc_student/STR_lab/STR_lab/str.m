function [si str_state str_debug] = str (Ib,Qb, param, str_state_in)

str_state = str_state_in;

[str_state.delay_state, y_str] = delay (str_state.delay_state, Ib);
        input_pll = y_str.* Ib;
        
str_param = param;
[out_pll acc1 str_state.pll_state] = pll(input_pll, str_state.pll_state);
si = zeros(1,length(acc1));

acc2_prev = str_state.accum_old + 1/param.Tc;
acc2 = acc1 + 1/param.Tc;

if (acc2_prev < 0.75) & (acc2(1) >= 0.75)
        si(1) = 1;
end

for ii=2:length(acc1)
    if (acc2(ii-1) < 0.75) & (acc2(ii) >= 0.75)
        si(ii) = 1;
    end
    
end

    
str_state.accum_old = acc1(end);


str_debug = 1;
%str_state = state;


%[t2 acc1 state.pll_state] = PLL(t1, state.pll_state, p);