function y = cosgate(x, fs, d)
%COSGATE - gate a signal with a cosinus envelope
%   Y = COSGATE(X, FS, D) gates the X data at its extremities.
%   FS is the sample rate (in Hertz). D is the length of
%   each ramp, in seconds.
%
%   Note that X must be a vector, not a matrix.

% N. Grimault <ngrimault@olfac.univ-lyon1.fr>
% Laboratoire de Neurosciences et Systèmes Sensoriels,
% UMR-CNRS 5020, 50 av. Tony Garnier, 69366 LYON Cedex 07, FR
%
% E. Gaudrain <egaudrain@gmail.com>
% University of Groningen - University Medical Center Groningen
% Department of Otorhinolaryngology, Groningen, NL
%
% Changes :
%   EG (2005-04-21):
%       - The loop is replaced by a vetorized expression.
%   EG (2014-06-20):
%       - Apply the gate only to the samples where it is needed.
%   EG (2018-10-16):
%       - Allows two different values for D: onset and offset.

if length(size(x))>2 || all(size(x)~=1)
    error('Input has to be a row or column vector.');
end

if length(d)==1
    d = [d, d];
elseif length(d)>2
    error('The ramp duration argument can only be of length 1 or 2');
end


d = d*fs;

% Onset
k = 0:d(1)-1;
if size(x,2)==1 % Column vector
    k = k';
end
x(k+1) = x(k+1) .* (1 - ( 1+cos(k*pi/(d(1)-1)) ) / 2);

% Offset
k = 0:d(2)-1;
if size(x,2)==1 % Column vector
    k = k';
end
x(end-k) = x(end-k) .* (1 - ( 1+cos(k*pi/(d(2)-1)) ) / 2);

y = x;


