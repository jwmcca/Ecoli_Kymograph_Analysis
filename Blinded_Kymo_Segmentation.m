%% Prepare Structure.
clear; clc;
filesave = 'Blinded_Treadmilling2';
Strains = {'XY505', 'JM156', 'JM216', 'P8961','JM221'};

for idxa = 1:5
    str(idxa) = load(['DataSets/' Strains{idxa}]);
end

for idxa = 1:length(str)
    if isfield(str(idxa).IndKymo,'Leading')
        str(idxa).IndKymo = rmfield(str(idxa).IndKymo,{'Leading','Lagging'});
    end
    for idxb = 1:length(str(idxa).IndKymo)
       str(idxa).IndKymo(idxb).Strain = Strains{idxa}; 
    end
    if idxa == 1
        IndKymo = str(idxa).IndKymo;
    else
        IndKymo = [IndKymo, str(idxa).IndKymo];
    end
end
IndKymo = datasample(IndKymo,length(IndKymo),'Replace',false);
save('DataSets/BlindedKymos.mat','IndKymo');

%% Check the most recently segmented kymo.
clear; clc;
addpath('Functions');
trdml = dir('DataSets/BlindedKymos*');
load([trdml.folder '/' trdml.name]);
counter = 0;
for idxa = 1:length(IndKymo)
    if ~isempty(IndKymo(idxa).Leading)
        counter = counter + 1;
        SegCheck(counter,1) = idxa;
    end
end
if exist('SegCheck')
    disp(['The most recently segmented kymograph is number ' num2str(SegCheck(end)) '.']);
else
    disp('No kymographs have been segmented yet. Start with Index 1.');
end
%% Load Blinded Treadmilling Structure.
clear; clc;
trdml = dir('DataSets/BlindedKymos*');
load([trdml.folder '/' trdml.name])
filesave = 'BlindedKymos';

px_size = 100; %Answer in nm.
Exposure_Time = 0.2; %Answer in seconds.
Dark_Time = 0.5; %Answer in seconds.

Index = 542

filename = IndKymo(Index).Name;
figname = [IndKymo(Index).Date '-' IndKymo(Index).Name];

f = figure('Position',[100,100,1000,1000]); movegui(f,'center');
ax1 = subplot(1,2,2);
imshow(mat2gray(IndKymo(Index).Kymo),'InitialMagnification',600,'Border','Loose');
ax2 = subplot(1,2,1);
imshow(mat2gray(IndKymo(Index).Kymo),'InitialMagnification',600,'Colormap',jet,'Border','Loose');
set(gca,'Visible','On');
xlabel('X (px)');
ylabel('Time (Frame)');
hold on;

% start segmentation
IndKymo(Index).Leading = [];
IndKymo(Index).Lagging = [];
Leadingstate = 1; % state counter
Laggingstate = 1; % state counter
EndFlag = 1; % the flag to end the selection
time_pos = 5;
while EndFlag ~= 0
response=questdlg(['Select the ' num2str(Leadingstate+Laggingstate-1) 'state in the kymograph.'], ...
        'Select a state?', 'Yes' , 'No','Yes');
    if strcmp(response,'Yes')
        SelectFlag = 0;  % flag for saving one selection
        while SelectFlag == 0;
            FigSave = ['seg-' num2str(Index) '-' IndKymo(Index).Strain '-' IndKymo(Index).Date '-' filename(1:find(filename == '.')-1) '.png'];
            [X Y] = ginput(2);
            kl = plot(X,Y,'-k','LineWidth',3);

            time = abs(diff(Y)).*(Exposure_Time+Dark_Time);
            displacement = abs(diff(X)).*(px_size./4);
            speed = displacement./time;
            mean_time = mean(Y);
            mean_displacement = mean(X);
            displacement_scale = ((size(IndKymo(Index).Kymo,2)./5)+size(IndKymo(Index).Kymo,2))./size(IndKymo(Index).Kymo,2).*50;

            
            % ask whether it is okay to select this
            response=questdlg(['Is this selection okay?'], ...
                'Check', 'Yes' , 'No','Yes');
            if strcmp(response,'Yes')
                t1 = text(mean_displacement,mean_time+3,[num2str(Leadingstate+Laggingstate-1)],'FontWeight','Bold');
                t2 = text(displacement_scale,time_pos,[num2str(Leadingstate+Laggingstate-1) ': ' num2str(round(speed,1)) ' nm/s'],'FontSize',14,'FontWeight','Bold');
                strandorientation=questdlg(['Leading or Lagging?'], ...
                'Check', 'Leading' , 'Lagging','Leading');
                if strcmp(strandorientation,'Leading');
                    if 7 ~= exist('BlindedSegmentedKymos','dir');
                        mkdir('BlindedSegmentedKymos');
                    end
                    Leading(Leadingstate).Vx = speed;
                    Leading(Leadingstate).Displacement = displacement;
                    Leading(Leadingstate).Time = time;

                    Leadingstate = Leadingstate + 1;
                    IndKymo(Index).Leading = Leading;
                    SelectFlag = 1;
                    time_pos = time_pos + 5;
                elseif strcmp(strandorientation,'Lagging');
                    t1 = text(mean_displacement,mean_time+3,[num2str(Leadingstate+Laggingstate-1)],'FontWeight','Bold');
                    t2 = text(displacement_scale,time_pos,[num2str(Leadingstate+Laggingstate-1) ': ' num2str(round(speed,1)) ' nm/s'],'FontSize',14,'FontWeight','Bold');
                    if 7 ~= exist('BlindedSegmentedKymos','dir');
                        mkdir('BlindedSegmentedKymos');
                    end
                    set(kl,'LineStyle',':');
                    Lagging(Laggingstate).Vx = speed;
                    Lagging(Laggingstate).Displacement = displacement;
                    Lagging(Laggingstate).Time = time;

                    Laggingstate = Laggingstate + 1;
                    IndKymo(Index).Lagging = Lagging;
                    SelectFlag = 1;
                    time_pos = time_pos + 5;
                end
            else
               delete(kl);
            end
        end
    else
        EndFlag = 0;
        if exist('FigSave');
            print(f,[pwd '/BlindedSegmentedKymos/' FigSave],'-dpng','-r300');
        end
    end
    save(['DataSets/' filesave '.mat'],'IndKymo');
end
close(f);
