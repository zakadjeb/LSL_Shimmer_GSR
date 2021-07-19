function convertedOutput = xdftoledalab(xdffile, outpath, nameGSR, offset)
%Convert .xdf-files from LSL (LabRecorder) to .mat-files that can be opened
%(not imported!) by Ledalab
%
%   Usage:
%   convertedOutput = xdftoledalab(xdffile, outpath, nameGSR, offset)
%   
%   Inputs:
%   xdffile     - Input .xdf-file as loaded from xdfimporter to Matlab
%                 (xdf)
%   outpath     - Optional output path where the .mat-fil will land
%                 (string). If nothing added, it will output to current path.
%   nameGSR     - Optional name of the GSR stream in LSL (string). If
%                 nothing added, it will use "ShimmerGSR".
%   Offset      - Optional offset for time (double). If nothing added, 0 will be
%                 used.
%
%   Example:
%   
%   myXDF = load_xdf('C:\Users\MyUser\LabRecorder\Participant1.xdf');
%   outputPath = "C:\Users\MyUser\LabRecorder\GSRdata\Participant1.mat";
%   converted = xdftoledalab(myXDF, outputPath);
%
%   Author: Zak Djebbara

    if nargin < 2
        outpath = pwd + "\convertedXdfToLedalab.mat";
        disp('No output path set. Will save to ' + outpath);
    end    
    if nargin < 3
        nameGSR = "ShimmerGSR";
        disp('Looking for "' + nameGSR+ '".');
    end
    if nargin < 4
        offset = 0;
        disp('Offset set to 0');
    end
    
    % Looking up which of structs is GSR data
    for i = 1:length(xdffile)
       if xdffile{i}.info.name == nameGSR
          GSRindex = i;
       end
    end
    
    % Locating which is GSR Conductance (GSRcon)
    for i = 1:size(xdffile{GSRindex}.info.desc.channels.channel,2)
        if xdffile{GSRindex}.info.desc.channels.channel{1,i}.label == "GSR_CON"
            GSRconIndex = i;
        end
    end
    
    % Looking up which of structs holds the LSL markers
    for i = 1:length(xdffile)
       if xdffile{i}.info.type == "LSL_Marker_Strings"
          LSLmarkerIndex = i;
       end
       %if(exist(LSLmarkerIndex) == 0)
       %       error('LSL markers were not located');
       %end
    end
    
    % Setting the date
    fileInfo.version = 3.4800;
    format short g
    fileInfo.date = datevec(datetime('now'));
    fileInfo.log = [datestr(now,'HH:MM:SS') + ": Converted .xdf to .mat."];
    convertedOutput.fileinfo = fileInfo;
    
    % Creating the event
    nid=1;
    %timediff=xdffile{LSLmarkerIndex}.time_stamps(1);
    timediff=double(xdffile{GSRindex}.time_stamps(1));
    for i = 1:size(xdffile{LSLmarkerIndex}.time_stamps,2)
        event(i).time       = xdffile{LSLmarkerIndex}.time_stamps(i) - timediff;
        event(i).nid        = nid;
        event(i).name       = convertCharsToStrings(xdffile{LSLmarkerIndex}.time_series(i));
        event(i).userdata   = struct('duration',4.999999999881766e-04);
        nid=nid+1;
    end
    
    % Moving the data
    convertedOutput.data.conductance     = double(xdffile{GSRindex}.time_series(GSRconIndex,:));
    convertedOutput.data.time            = double(xdffile{GSRindex}.time_stamps - timediff);
    convertedOutput.data.timeoff         = double(offset);
    convertedOutput.data.event           = event;
   
   % Renaming
   fileinfo = convertedOutput.fileinfo;
   data = convertedOutput.data;
   
   % Saving the converted data
   save(convertStringsToChars(outpath), 'fileinfo', 'data');
   disp("Saved convertedOutput.mat file to " + outpath);
   disp('Converted successfully');
end