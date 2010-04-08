classdef lrgauss_adf < classifier
%Posterior for a Gaussian prior and a logistic likelihood
%
%   Options:
%   'prior' : the prior Gaussian distribution in the format
%              prior = struct('mean',mean_vector,'cov',cov_matix)
%           : bias term should be added at the end of the prior
%
%   EXAMPLE:
%    p=struct('mean',zeros(153,1),'cov',0.1*eye(153));
%   [a,b,c] = test_procedure({standardizer lrgauss_adf('prior',p)},0.8);
%
%   SEE ALSO:
%   lrgauss_lap
%
%   Copyright (c) 2010, Adriana Birlutiu

    properties

      prior;
        
    end

    methods
      
       function obj = lrgauss_adf(varargin)
                  
           obj = obj@classifier(varargin{:});
                      
       end
       
       function p = estimate(obj,X,Y)
        
         if obj.nunique(Y) ~= 2, error('LRGAUSS_ADF only accepts binary class problems'); end

         targets = Y(:,1);
         targets(targets == 1) = -1;
         targets(targets == 2) = 1;
         
         if isempty(obj.prior)
           pr = priorstandard(size(X,2)+1,1);
         else
           pr = obj.prior;
         end
         
         % training mode
         pr = logisticgauss_adf(pr, [X ones(size(X,1),1)], targets);
         p.model = [  -pr.mean'; pr.mean'];

       end
       
       function Y = map(obj,X)
         
         Y = slr_classify([X ones(size(X,1),1)], obj.params.model);
         
       end
       
    end
end
