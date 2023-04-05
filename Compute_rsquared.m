function rsquared = Compute_rsquared(x1,x2,x3)
% Computes the r-squared values for 2D or 3D variables
%
% INPUT:
% x1, x2, x3 -> Data matrix [dim1 x dim2 x repetition]
%
% OUTPUT:
% rsquared -> r-squared values [ dim1 by dim2 ]
% 



%% INITIALIZE VARIABLES


if nargin==2
    
    % Dimension space
    [dim1x1, dim2x1, dim3x1] = size(x1);
    [dim1x2, dim2x2, dim3x2] = size(x2);
    
    % Comprobar que dim1 y dim2 sea igual en la dos condiciones
    if dim1x1~=dim1x2
        error('PILAS: dim1 is different in the conditions')
    else
        dim1 = dim1x1;
        clear dim1x1 dim1x2
    end
    if dim2x1~=dim2x2
        error('PILAS: dim2 is different in the conditions')
    else
        dim2 = dim2x1;
        clear dim2x1 dim2x2
    end
    
    % Create labels vector
    Labels = [ -1*ones(dim3x1,1) ; +1*ones(dim3x2,1) ];
    
elseif nargin==3
    
    % Dimension space
    [dim1x1, dim2x1, dim3x1] = size(x1);
    [dim1x2, dim2x2, dim3x2] = size(x2);
    [dim1x3, dim2x3, dim3x3] = size(x3);
    
    % Comprobar que dim1, dim2 y dim3 sea igual en la dos condiciones
    if numel(unique([dim1x1 dim1x2 dim1x3]))~=1
        error('PILAS: dim1 is different in the conditions')
    else
        dim1 = dim1x1;
        clear dim1x1 dim1x2 dim1x3
    end
    if numel(unique([dim2x1 dim2x2 dim2x3]))~=1
        error('PILAS: dim2 is different in the conditions')
    else
        dim2 = dim2x1;
        clear dim2x1 dim2x2 dim2x3
    end
    
    % Create labels vector
    Labels = [ -1*ones(dim3x1,1) ; 0*ones(dim3x2,1)  ; +1*ones(dim3x3,1)];
    
else
    error('PILAS: incorrect number of input variables')
end


% Initialize r2 matrix
rsquared = NaN(dim1,dim2);


%% COMPUTE R2

for i=1:dim2
    for j=1:dim1
        if nargin==2
            rsquared(j,i) = corr(Labels,[ squeeze(x1(j,i,:)) ; squeeze(x2(j,i,:)) ]).^2;
        elseif nargin==3
            rsquared(j,i) = corr(Labels,[ squeeze(x1(j,i,:)) ; squeeze(x2(j,i,:)) ; squeeze(x3(j,i,:))]).^2;
        end
    end
end
