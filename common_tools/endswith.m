function b = endswith(str, sub)

%ENDSWITH(STR, SUB) is True if STR ends with SUB
%   If STR is shorter than SUB, it returns False. This function has been
%   implemented in newer versions of Matlab.

%--------------------------------------------------------------------------
% Etienne Gaudrain <etienne.gaudrain@crns.fr> - 2018-04-30
% CNRS UMR5292, CRNL, Lyon, FR - RuG, UMCG, KNO, Groningen, NL
%--------------------------------------------------------------------------

if length(str)<length(sub)
    b = false;
elseif isempty(sub)
    b = true;
else
    b = strcmp(str(end-length(sub)+1:end), sub);
end