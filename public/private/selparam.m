function param = selparam(data)

% SELPARAM

dim = dimlength(data);
ndim = length(dim);
%remove all 1's at the right side of dim
for i=ndim:-1:3
  if dim(i)==1,
    dim(i) = [];
    ndim   = ndim-1;
  else
    break
  end
end

fn = fieldnames(data);
sel = false(size(fn));
for i=1:length(fn)
  siz    = size(data.(fn{i}));
  nsiz   = length(siz);
  sel(i) = (nsiz==ndim) && all(siz==dim);
end
param = fn(sel);

% some fields should be excluded
param = setdiff(param, {'time', 'freq', 'channel','inside'});
