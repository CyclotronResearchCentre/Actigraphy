% to load mat file easily simply type: lmat
% at the Matlab prompt. 

% Which version of SPM is on the path ?
v = spm('Ver');
vSPM = str2double(v(4));

if vSPM>=5
    P_lmat = cellstr(spm_select(Inf,'mat','mat files to load'));
else
    P_lmat = cellstr(spm_get(Inf,'*.mat','mat files to load'));
end
nfile_lmat = numel(P_lmat) ;
if nfile_lmat>0 & ~isempty(P_lmat{1})
    for i_lmat=1:nfile_lmat
        load( deblank(P_lmat{i_lmat} )) ;
    end
end
clear i_lmat nfile_lmat v vSPM
