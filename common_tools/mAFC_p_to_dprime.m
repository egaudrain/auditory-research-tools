function dprime = mAFC_p_to_dprime(p, m)

%DPRIME = MAFC_P_TO_DPRIME(P, M)
%   Calculates DPRIME value from proportion correct P and number of possible
%   alernatives M in an M-alternative-forced-choise experiment.
%
%   From Hacker and Ratcliff, 1979, Perception and Psychophysics and 
%   Smith, 1982, Perception and Psychophysics.
%
%   See also MAFC_DPRIME_TO_P

% E. Gaudrain <egaudrain@gmail.com> - 2014-06-20
% University of Groningen - University Medical Center Groningen
% Department of Otorhinolaryngology, Groningen, NL



if p==0
    dprime = -Inf;
elseif p==1
    dprime = +Inf;
elseif p<0 || p>1
    error(sprintf('Probability must be between 0 and 1 (%f given).', p));
else
    f = @(x) abs(mAFC_dprime_to_p(x, m)-p);
    x0 = (0.86-0.085*log(m-1)) * log((m-1)*p/(1-p));
    dprime = fminsearch(f, x0);
end