% Do initialization like in the DDC test script above!

% Initialize DDC and STR blocks
ddc_state = ddc_init(param.ddc);
str_state = str_init(param.str);

% Process blocks
for ii=1:Nb,
  % Get a single block
  x = sb(:, ii);

  % Digital down converter
  [Ib Qb ddc_state ddc_debug] = ddc(x, ddc_state);

  % Symbol timing recovery / decision
  [si str_state str_debug] = str(Ib, Qb, str_state);
  
  % Do a plot showing where the waveform is sampled.  Should see that
  % samples occur nearly at peaks (not at transitions).  May take a few
  % blocks before PLLs track.
  sil = logical(si);
  plot(n, Ib, 'b', n, Qb, 'g', n(sil), Ib(sil), 'b*', n(sil), Qb(sil), 'g*');

  pause;

end