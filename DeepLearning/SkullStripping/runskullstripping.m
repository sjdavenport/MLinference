skulldir = '/Users/sdavenport/Documents/Data/SkullStripping/NFBS_Dataset/';
skullnames = filesindir(skulldir);

for I = 3:length(skullnames)
    cd([skulldir, skullnames{I}]);
    extract_brain(['./sub-', skullnames{I}, '_ses-NFB3_T1w.nii.gz'])
end