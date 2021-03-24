function t = filetime(fname)

if isfolder(fname)

    lst = dir(fname);
    for i=1:length(lst)
        if strcmp(lst(i).name, '.')
            t = lst(i).datenum;
            break
        end
    end
else
    lst = dir(fname);
    if length(lst)<1
        error('File "%s" was not found.', fname);
    end
    t = lst(1).datenum;
end