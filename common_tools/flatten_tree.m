function str = flatten_tree(tree, basename, sep)
%STR = FLATTEN_TREE(TREE)
%   Transforms a struct-array into a long string.
%
%STR = FLATTEN_TREE(TREE, BASENAME)
%   Adds the prefix BASENAME in from of field names. Default is ''.
%
%STR = FLATTEN_TREE(TREE, BASENAME, SEP)
%   Uses SEP as a separator between entries. Default is '\n'.

% E. Gaudrain <egaudrain@gmail.com> - 2014-06-20
% University of Groningen - University Medical Center Groningen
% Department of Otorhinolaryngology, Groningen, NL

if nargin==1
    %basename = '';
    basenamed = '';
else
    basenamed = [basename '.'];
end

if nargin<3
    sep = '\n';
end

k = fieldnames(tree);

str = '';
for i=1:length(k)
    branch = tree.(k{i});
    if isstruct(branch)
        str = sprintf('%s%s%s%s', str, flatten_tree(branch, [basenamed k{i}]), sep);
    else
        str = sprintf('%s%s%s=%s%s', str, basenamed, k{i}, var2str(branch), sep);
    end
end

%==========================================================================

function str = var2str(v)

str = '';

if isnumeric(v)
    if numel(v)>1
        str = '[';
        for i=1:size(v,1)
            for j=1:size(v,2)
                if j~=size(v,2)
                    str = [str num2str(v(i,j)) ', '];
                else
                    str = [str num2str(v(i,j))];
                end
            end
            if i~=size(v,1) 
                str = [str, ' ; '];
            end
        end
        str = [str ']'];
    else
        str = num2str(v);
    end
elseif ischar(v)
    str = ['''' v ''''];
else
    v
    warning('Unhandled type.');
    str = '!! UNHANDLED TYPE !!';
end
    
            
            