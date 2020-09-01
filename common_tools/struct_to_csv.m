function struct_to_csv(filename, dat)

%STRUCT_TO_CSV - Stores a struct-array into a CSV file
%   STRUCT_TO_CSV(FILENAME, DAT)
%   
%   The struct array DAT needs to be "flat", i.e. the leaves need to be
%   atomic. The CSV file that is produced is meant to be RFC compliant.

% Etienne Gaudrain <etienne.gaudrain@cnrs.fr> - 2020-09-01

h = fieldnames(dat);

fd = fopen(filename, 'w');

r = strings(1,length(h));
for k=1:length(h)
    r(k) = format_str(h{k});
end
    
fprintf(fd, join(r, ",")+"\r\n");

for i=1:length(dat)
    r = strings(1,length(h));
    for k=1:length(h)
        key = h{k};
        r(k) = format(dat(i).(key));
    end
    fprintf(fd, join(r, ",")+"\r\n");
end

fclose(fd);

function sf = format(v)

if isnumeric(v)
    sf = string(num2str(v));
elseif islogical(v)
    if v
        sf = "true";
    else
        sf = "false";
    end
else
    sf = format_str(v);
end

function sf = format_str(s)

sf = """" + string(strrep(s, '"', '""')) + """";