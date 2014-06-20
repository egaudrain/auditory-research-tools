function p = mAFC_dprime_to_p(dprime, m)

%P = MAFC_DPRIME_TO_P(DPRIME, M)
%   Calculates proportion correct P from DPRIME value and number of possible
%   alernatives M in an M-alternative-forced-choise experiment.
%
%   From Hacker and Ratcliff, 1979, Perception and Psychophysics and 
%   Smith, 1982, Perception and Psychophysics.
%
%   See also MAFC_P_TO_DPRIME

% E. Gaudrain <egaudrain@gmail.com> - 2014-06-20
% University of Groningen - University Medical Center Groningen
% Department of Otorhinolaryngology, Groningen, NL

f = @(x) likelihood(x, dprime, m);
p = quadgk(f, -Inf, Inf);

%----------------------------------
function y = likelihood(x, dprime, m)

y = normpdf(x-dprime, 0, 1) .* normcdf(x, 0, 1).^(m-1);
