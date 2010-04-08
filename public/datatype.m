function [type, dimord] = datatype(data, desired)

% DATATYPE determines the type of data represented in a FieldTrip data
% structure and returns a string with raw, freq, timelock source, comp,
% spike, source, volume, dip.
%
% Use as
%   [type, dimord] = datatype(data)
%   [type, dimord] = datatype(data, desired)
%
% See also CHANTYPE, FILETYPE, SENSTYPE, VOLTYPE

% Copyright (C) 2008, Robert Oostenveld
%
% Subversion does not use the Log keyword, use 'svn log <filename>' or 'svn -v log | less' to get detailled information

% determine the type of input data, this can be raw, freq, timelock, comp, spike, source, volume, dip
israw      = isfield(data, 'label') && isfield(data, 'time') && isa(data.time, 'cell') && isfield(data, 'trial') && isa(data.trial, 'cell');
isfreq     = (isfield(data, 'label') || isfield(data, 'labelcmb')) && isfield(data, 'freq'); %&& (isfield(data, 'powspctrm') || isfield(data, 'crsspctrm') || isfield(data, 'cohspctrm') || isfield(data, 'fourierspctrm') || isfield(data, 'powcovspctrm'));
istimelock = isfield(data, 'label') && isfield(data, 'time') && ~isfield(data, 'freq') && ((isfield(data, 'avg') && isnumeric(data.avg)) || (isfield(data, 'trial') && isnumeric(data.trial) || (isfield(data, 'cov') && isnumeric(data.cov))));
iscomp     = isfield(data, 'topo') || isfield(data, 'topolabel');
isspike    = isfield(data, 'label') && isfield(data, 'waveform') && isa(data.waveform, 'cell') && isfield(data, 'timestamp') && isa(data.timestamp, 'cell');
isvolume   = isfield(data, 'transform') && isfield(data, 'dim');
issource   = isfield(data, 'pos');
isdip      = isfield(data, 'dip');
ismvar     = isfield(data, 'dimord') && ~isempty(strfind(data.dimord, 'lag'));
isfreqmvar = isfield(data, 'freq') && isfield(data, 'transfer');

if iscomp
  type = 'comp';  
  %comp should conditionally go before raw, otherwise the returned datatype
  %will be raw
elseif isfreqmvar
  type = 'freqmvar';
  %freqmvar should conditionally go before freq, otherwise the returned datatype
  %will be freq in the case of frequency mvar data
elseif ismvar
  type = 'mvar';
elseif israw
  type = 'raw';
elseif isfreq
  type = 'freq';
elseif istimelock
  type = 'timelock';
elseif isspike
  type = 'spike';
elseif isvolume
  type = 'volume';
elseif issource
  type = 'source';
elseif isdip
  type = 'dip';
else
  type = 'unknown';
end

if nargin>1
  % return a boolean value
  type = strcmp(type, desired);
  return;
end

if nargout>1
  % also return the dimord of the input data
  if isfield(data, 'dimord')
    dimord = data.dimord;
  else
    dimord = 'unknown';
  end
end

