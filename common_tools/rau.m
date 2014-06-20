function x = rau(p, N)
% R = RAU(P, N)
%   Transform proportion-correct P (0<P<1) obtained over N repetitions,
%   into rationalized arcsine units.
%
%   P can be a vector.
%
%   See Studebaker, 1985, J. Speech Hear. Res. 28:455?462.

% E. Gaudrain <egaudrain@gmail.com> - 2014-06-20
% University of Groningen - University Medical Center Groningen
% Department of Otorhinolaryngology, Groningen, NL

if any(P>1) || any(P<0)
    warning('Some values of P are smaller than zero or greater than one.');
end

T = asin(sqrt(p*N/(N+1))) + asin(sqrt((p*N+1)/(N+1)));
x = 1.46*(31.83098861*T-50)+50;