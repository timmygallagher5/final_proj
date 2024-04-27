function cci = get_CCI(filename)
% ************************************************************************
%                   PLEASE READ THE FOLLOWING NOTE
% ************************************************************************
% Unfortunately, CCI data is tough to come by. For the United States, CCI is
% calculated by 2 entities, the University of Michigan and the Conference
% board.
% The Conference Board hides its data behind a pay wall and there is no API.
% The University of Michigan provides data to download for free, but does
% not have an API.  Due to these factors, the data is downloaded from 
% https://data.sca.isr.umich.edu/data-archive/mine.php
% The webites above provides the University of Michigan Consumer Confidence
% Index.
% There is a default filename that will be included with the source code,
% but users can input a new CCI dataset in order to use different data.
% The data must be formatted in an excel file that follows this format:
%              |    Month     |    Year     |   Index    |
%              |  oldest mon  | oldest year | oldest val |
%              |  newest mon  | newest year | newest val |
% To summarize, the excel file must be a three column excel file that are
% named Month, Year and Index, respectively. The data, also, needs to be sorted
% from oldest to newest.
% ************************************************************************
%
% Description
%   This function reads in CCI data from an excel file and returns the newest
%   index.
% 
% Inputs: 
%    - filename: Use this input to override the default data set. Leave
%    blank to use the default.
%
% Outputs:
%    - cci: The most recent consumer confidence index from the file.
%
% ************************************************************************

    % Read in the raw data from the default file
    if( isempty(filename) )
        filename = 'raw_cci_data.csv';
    end
   
   % Read the CCI data
   cci_raw_data = readtable(filename);
   
   % Get the month and year of the data we are going to return
   data_curr_mon = cci_raw_data.Month(end);
   data_curr_yr  = cci_raw_data.Year(end);
   
   % Throw warning to user to alert the data might be out of date
   if( ( data_curr_mon ~= str2num(datestr(now, 'mm') ) ) & ...
       ( data_curr_mon + 1 ~= str2num(datestr(now, 'mm') ) ) )
       warning(['CCI Data is published at the end of every month, make sure your data is up to date.' ...
           'Check https://data.sca.isr.umich.edu/data-archive/mine.php for recent data']);
   end
   
   % Throw error is data is not from this year.
   if( data_curr_yr ~= str2num(datestr(now, 'yyyy')) )
       error('Data is not from this year. Go to https://data.sca.isr.umich.edu/data-archive/mine.php for recent data');
   end
   
   % Return the most recent CCI
   cci = cci_raw_data.Index(end);
    
end


