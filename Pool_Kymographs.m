%% Prepare Structure.
clear; clc;
Strain = 'JM221';
currentPath = pwd;
files = dir;
files(ismember( {files.name}, {'.', '..'})) = [];
dirFlags = [files.isdir];
subFolders = files(dirFlags);
dates = [];
for idx = 1:3; %To the number of subfolders with data
    dates{idx} = subFolders(idx).name(1:8);
end

%%%%%%%%%%%%%% STRUCTURE NAME %%%%%%%%%%%%%%%%
IndKymo = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

w = 0;
for idxa = 1:size(dates,2)
    subfiles = dir([subFolders(idxa).name]);
    subfiles(ismember( {subfiles.name}, {'.', '..'})) = [];
    subdirFlags = [subfiles.isdir];
    subsubFolders = subfiles(subdirFlags);
    for idxb = 1:length(subsubFolders)
        nametemp = subsubFolders(idxb).name;
        if strcmp(nametemp,'Kymo')
           KymoFlag = idxb; 
        end
    end
    pathname = [subsubFolders(end).folder '/' subsubFolders(KymoFlag).name];
    slashes = find(pathname == '/');
    FileDate = pathname(slashes(end-1)+1 : slashes(end-1)+8);
    KymoFolder = dir(pathname);
    isMatch = ~cellfun('isempty', strfind({KymoFolder.name}, '.tif'));
    KymoFolder = KymoFolder(isMatch);
    for idxc = 1:length(KymoFolder)
       w = w+1;
       kymo_temp = imread([KymoFolder(1).folder '/' KymoFolder(idxc).name]);
       IndKymo(w).Strain = Strain;
       IndKymo(w).Kymo = kymo_temp;
       IndKymo(w).Date = dates{idxa};
       IndKymo(w).Name = KymoFolder(idxc).name;
       IndKymo(w).Folder = KymoFolder(idxc).folder;
    end
end
save([Strain '.mat'],'IndKymo');