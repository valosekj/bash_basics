function parse_SliceTiming_from_json(input_json_file)
%
% Function for parsion of SliceTiming from .json file to .txt file
% .txt file is then used for --slspec flag of eddy, see here:
%	https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/eddy/Faq#How_should_my_--slspec_file_look.3F
%
% .json file can be obtained by dcm2niix conversion tool
%
% Usage from shell CLI:
%	run_matlab "addpath('/usr/local/bin/'),parse_SliceTiming_from_json('dti.json'),exit"
%
% Jan Valosek, fMRI lab, Olomouc
%

    sprintf('Reading input file %s', input_json_file)
    fp = fopen(input_json_file,'r');
    fcont = fread(fp);
    fclose(fp);
    cfcont = char(fcont');
    i1 = strfind(cfcont,'SliceTiming');
    i2 = strfind(cfcont(i1:end),'[');
    i3 = strfind(cfcont((i1+i2):end),']');
    cslicetimes = cfcont((i1+i2+1):(i1+i2+i3-2));
    slicetimes = textscan(cslicetimes,'%f','Delimiter',',');
    [sortedslicetimes,sindx] = sort(slicetimes{1});
    mb = length(sortedslicetimes)/(sum(diff(sortedslicetimes)~=0)+1);
    slspec = reshape(sindx,[mb length(sindx)/mb])'-1;
    output_filename='slspec_eddy.txt';
    dlmwrite(output_filename,slspec,'delimiter',' ','precision','%3d');
    sprintf('Created %s', output_filename)

end

