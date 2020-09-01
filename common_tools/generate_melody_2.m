function [x, fs] = generate_melody(varargin)

% GENERATE_MELODY - Builds a sound signal from a melody
%   [x, fs] = generate_melody(str,fs,callback)
%       Build a melody from a melody string.
%
%   [x, fs] = generate_melody(notes,durations,fs,callback)
%       Build a melody from notes and durations arrays. The notes can be
%       either a vector of frequencies, or a cell-array of note labels.
%
%       In both cases, fs is used for the sampling rate. And callback is
%       the function that produces the sound of a note. The callback
%       function can be passed as string name or handle.
%       Callback must have the following form: 
%           function x = callback(frequency,duration,fs,params)
%       Additionnal parameters can be provided to the callback function
%       invoking:
%           generate_melody(notes,durations,fs,callback,params)
%
%   [x, fs] = generate_melody(notes, durations, onsets, fs, callback)
%   [x, fs] = generate_melody(notes, durations, onsets, fs, callback, params)
%       Specifies the onsets (in seconds) for each note from the beginning of
%       the melody.
%
%   Example:
%       [notes, durations] = parse_melody('a3:1,a#3:1,b3:1, :1,c#4:1,g3:4');
%       notes = note_transpose(notes,4);
%       durations = durations*.5;
%       [x, fs] = generate_melody(notes, durations, 44100, 'GM_puretone'); 
%       sound(x,fs)
%
%   See also NOTE_TO_FREQ, NOTE_TRANSPOSE, PARSE_MELODY, GM_PURETONE

%--------------------------------------------------------------------------
% Etienne Gaudrain (egaudrain@olfac.univ-lyon1.fr) - 2007-07-18
% CNRS, Université Lyon 1 - UMR 5020
% $Revision: 1.2 $ $Date: 2007-07-18 13:38:54 $
%--------------------------------------------------------------------------

if nargin==3 % str,fs,callback
    [notes, durations] = parse_melody(varargin{1});
    fs = varargin{2};
    callback = varargin{3};
    params = struct();
    onsets = [];
elseif nargin==4
    if iscell(varargin{1}) || isnumeric(varargin{1}) % notes,durations,fs,callback
        notes = varargin{1};
        durations = varargin{2};
        fs = varargin{3};
        callback = varargin{4};
        params = struct();
        onsets = [];
    else            % str,fs,callback,params
        [notes, durations] = parse_melody(varargin{1});
        fs = varargin{2};
        callback = varargin{3};
        params = varargin{4};
        onsets = [];
    end
elseif nargin==5      % notes,durations,fs,callback,params
    notes = varargin{1};
    durations = varargin{2};
    if length(varargin{3})==1
        fs = varargin{3};
        callback = varargin{4};
        params = varargin{5};
        onsets = [];
    else
        onsets = varargin{3};
        fs = varargin{4};
        callback = varargin{5};
        params = struct();
    end
elseif nargin==6
    notes = varargin{1};
    durations = varargin{2};
    onsets = varargin{3};
    fs = varargin{4};
    callback = varargin{5};
    params = varargin{6};    
end

if ischar(callback)
    callback = str2func(callback);
end

if iscell(notes)
    notes = note_to_freq(notes);
end

notes = notes(:)';
durations = durations(:)';

durations = round(durations*500)/500;

if isempty(onsets)
    onsets = cumsum(durations);
    onsets = [0, onsets(1:end-1)];
end

onsets = onsets(:)';

% Find sounds to create
[ndu, ix, jx] = unique([notes(:), durations(:)], 'rows');
fprintf('%d sounds to build...\n', length(ix));

% Create those sounds
sounds = {};
ii = 0;
for i=1:length(ix)
    if notes(ix(i))==-1
        sounds{i} = zeros(floor(fs*durations(ix(i))), 1);
    else
        ii = ii + 1;
        params.callnumber = ii;
        sounds{i} = callback(notes(ix(i)),durations(ix(i)),fs,params);
    end
end

% Melody construction
%{
% EG, 2015-09-29
x = [];
for i=1:length(jx)
    s = sounds{jx(i)};
    x = [x ; s(:)];
end
%}

fprintf('Putting sounds together...\n');

% Calculate total duration
d = onsets(end)+durations(end)+1;

x = zeros(round((d+1)*fs),1);
max_i = 0;
for i=1:length(jx)
    s = sounds{jx(i)};
    k = round(onsets(i)*fs)+1;
    while k+length(s)-1>length(x)
        x = [x; zeros(fs,1)];
    end
    x(k:k+length(s)-1) = x(k:k+length(s)-1) + s;
    max_i = max(max_i, k+length(s)-1);
end

x = x(1:max_i);

fprintf('Done.\n');
