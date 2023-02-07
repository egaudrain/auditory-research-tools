function str = struct_to_literal(tree, varname, tab)

if nargin < 2 || isempty(varname)
    str = sprintf('struct(');
else
    str = sprintf('%s = struct(', varname);
end

if nargin < 3
    tab ='';
end

k = fieldnames(tree);

for i=1:length(k)
    branch = tree.(k{i});
    if isstruct(branch)
        str = [str, sprintf('''%s'', ', k{i}), struct_to_literal(branch, [], [tab, '    '])];
    else
        str = [str, sprintf('''%s'', ', k{i}), var2str(branch, [tab, '    '])];
    end
    if i==length(k)
        str = [str, ')'];
    else
        str = [str, ',', sprintf(' ...\n%s', tab)];
    end
end

%==========================================================================

function str = var2str(v, tab)

if nargin<2
    tab = '';
end

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
                str = [str, ' ;', sprintf(' ...\n%s', tab)];
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
    
            
            