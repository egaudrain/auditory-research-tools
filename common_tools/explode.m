function array=explode(sep, str)
%EXPLODE - Splits a string into a cell array.
% ARRAY = EXPLODE(SEP, STR)
%     Returns a cell-array of strings extracted from STR and separated by
%     SEP. The separator is removed.
%     
%     This is similar to the PHP function explode.
%
%   See also IMPLODE

%------------------------------------------------
% Et. Gaudrain - 2006-03-31
% CNRS UMR-5020
% $Revision: 1.1 $ $Date: 2006-03-31 09:21:46 $
%------------------------------------------------

i=1;
rem = str;

while ~isempty(rem)
    [token, rem] = strtok(rem, sep);
    array{i} = token;
    i = i+1;
end