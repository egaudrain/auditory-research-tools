function s = format_elapsed_time(t)
%FORMAT_ELAPSED_TIME(T)
%   Displays time T in hour:minute:second format.
%
%S = FORMAT_ELAPSED_TIME(T)
%   Returns the formatted time string without displaying it.

% E. Gaudrain <egaudrain@gmail.com> - 2014-06-20
% University of Groningen - University Medical Center Groningen
% Department of Otorhinolaryngology, Groningen, NL

hh = floor(t/3600);
t = t-hh*3600;
mm = floor(t/60);
ss = t-mm*60;

s = sprintf('%02d:%02d:%04.1f', hh, mm, ss);

if nargout<1
    fprintf([s, '\n']);
end
