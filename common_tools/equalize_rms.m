function equalize_rms(filemask, target_folder, target_format, varargin)

%EQUALIZE_RMS(FILEMASK, TARGET_FOLDER, TARGET_FORMAT, ...)
%   Equalizses the RMS of all the files specified by FILEMASK.
%
%   If TARGET_FOLDER is not provided or empty, the files will be saved in
%   the same folder.
%
%   If TARGET_FOLDER is specified, the equalized files will be saved in
%   that folder.
%
%   If TARGET_FORMAT is specified, the file format will be changed to this.
%   It has to be entered including the dot (e.g. ".flac").
%
%   WARNING: If TARGET_FOLDER is empty and TARGET_FORMAT is not provided,
%   the original files will be OVERWRITTEN!
%
%   Extra arguments are passed to AUDIOWRITE, e.g. if you want to save the
%   files in 24-bit resolution.
%
%   The equalization is done in the following way: first the files are
%   normalized to 98% of full scale, then their RMS is calculated. The
%   minimum value of the RMS across all the files is then used as
%   reference, and all the files are equalized to that RMS and saved.
%
%   Example:
%   >> equalize_rms("../sounds/*.wav", "../sounds_equalized", ".flac", 'BitsPerSample', 24);
%

% Etienne Gaudrain <etienne.gaudrain@cnrs.fr> - 2026-03-19

% Ensure string
filemask = convertCharsToStrings(filemask);


[folder, ~] = fileparts(filemask);

if nargin<2 || isempty(target_folder)
    save_inplace = true;
else
    save_inplace = false;
    if contains(folder, "*/")
        error("If TARGET_FOLDER is specified, the FILEMASK cannot contain wildcards for folders");
        % TODO: replicate tree structure below the wildcard
    end
    target_folder = convertCharsToStrings(target_folder);
    if ~exist(target_folder, "dir")
        mkdir(target_folder);
    end
end

if nargin<3
    use_original_extension = true;
else
    use_original_extension = false;
    target_format = convertCharsToStrings(target_format);
end

RMSs = [];

lst = dir(filemask);
for k=1:length(lst)
    fname = fullfile(lst(k).folder, lst(k).name);
    %fprintf("Reading %s...\n", fname);
    [x, ~] = audioread(fname);
    x = .98 * x/max(abs(x), [], "all");
    RMSs = [RMSs, rms(x, "all")];
end

RMS_ref = min(RMSs);

fprintf("Scanned %d files. The target RMS will be %.3f\n\n", length(lst), RMS_ref);

for k=1:length(lst)
    fname = convertCharsToStrings(fullfile(lst(k).folder, lst(k).name));
    [x, fs] = audioread(fname);
    
    x = x / rms(x, "all") * RMS_ref;
    
    if save_inplace
        if ~use_original_extension
            [fname_folder, fname_name, ~] = fileparts(fname);
            target_fname = fullfile(fname_folder, fname_name + target_format);
        else
            target_fname = fname;
        end
    else
        [~, fname_name, fname_ext] = fileparts(fname);
        if ~use_original_extension
            fname_ext = target_format;
        end

        fname_ext = convertCharsToStrings(fname_ext);
        fname_name = convertCharsToStrings(fname_name);
        
        target_fname = fullfile(target_folder, fname_name + fname_ext);
    end
    fprintf("%s -> %s\n", fname, target_fname);
    audiowrite(target_fname, x, fs, varargin{:});
end

fprintf('\nEqualized %d files.\n', length(lst));