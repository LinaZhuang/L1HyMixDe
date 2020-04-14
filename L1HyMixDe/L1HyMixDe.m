function img_denoised = L1HyMixDe(img_ori, k_subspace, p)
% Input: ------------------------------------------------------------ 
% img_ori        hyperspectral data set of size (row x column x band)
%
% k_subspace     signal subspace dimension
%
% p              the percentage of elements corrupted by impulse noise and
%                stripes (default value is 5%)
%
% Output: ------------------------------------------------------------
% img_denoised Denoised hyperspectral data with (row x column x band)
%
% ---------------------------- -------------------------------------------
% See more details in the paper:
%   [1] L. Zhuang and Michael K. Ng, 
%       "Hyperspectral Mixed Noise Removal By1-Norm-Based Subspace 
%        Representation,” in IEEE Journal of Selected Topics in Applied 
%       Earth Observations and Remote Sensing, 2020.
%       URL: https://sites.google.com/hkbu.edu.hk/linazhuang/home
%
%
%% -----------------------------------------------------------------------
%
% Copyright (April, 2020):        
%             Lina Zhuang (linazhuang@qq.com)
%            
%
% L1HyMixDe is distributed under the terms of
% the GNU General Public License 2.0.
%
% Permission to use, copy, modify, and distribute this software for
% any purpose without fee is hereby granted, provided that this entire
% notice is included in all copies of any software which is or includes
% a copy or modification of this software and in all copies of the
% supporting documentation for such software.
% This software is being provided "as is", without any express or
% implied warranty.  In particular, the authors do not make any
% representation or warranty of any kind concerning the merchantability
% of this software or its fitness for any particular purpose."
% ---------------------------------------------------------------------






[row, column, band] = size(img_ori);
N=row*column;
Y_ori = reshape(img_ori, N, band)';

%% -------------Subspace Learning Against Mixed Noise---------------------
%An adaptive median filter is applied to noisy image to remove the bulk of
%impulse noise and stripes
for ib=1:band
    img_median(:,:,ib) = adpmedian(img_ori(:,:,ib), 21);
end
Y_median = reshape(img_median, N, band)';

%detect pixel indexes of impulse noise and stripes
img_dif =  abs(img_ori-img_median) ;


 mask_outlier =(img_dif>p); 

 img_remove_outlier = img_ori;
img_remove_outlier(mask_outlier) = img_median(mask_outlier);
Y_remove_outlier = reshape(img_remove_outlier, N, band)';

[w Rw] = estNoise(Y_remove_outlier,'additive');
Rw_ori = Rw;
%data whitening so that noise variances of each band are same
Y_ori = inv(sqrt(Rw))*Y_ori;
img_ori = reshape(Y_ori', row, column, band);
Y_median = inv(sqrt(Rw))*Y_median;
img_median = reshape(Y_median', row, column, band);
Y_remove_outlier= inv(sqrt(Rw))*Y_remove_outlier;

%Subspace learning from the coarse image without stripes and impulse noise
[E,S,~] = svd(Y_remove_outlier*Y_remove_outlier'/N);
E = E(:,1:k_subspace);


%% --------------------------L1HyMixDe-------------------------------------
%Initialization
Z = E'*Y_median;
img_dif =  img_ori-img_median ;
V = reshape(img_dif, N, band)';
D = zeros(band,N);
mu = 1;


for ite = 1:40
    
    %% Updating Z: Z_{k+1} = argmin_Z lambda*phi(Z) + mu/2 || Y-EZ-V_k-D_k||_F^2
    %Equivlance: Z_{k+1} = argmin_Z lambda/mu*phi(Z) +  1/2 || Y-EZ-V_k-D_k||_F^2
    
    Y_aux = Y_ori-V+D;
    img_aux = reshape( Y_aux', row, column, band);
    %FastHyDe
    Rw_fasthyde =  eye(band); %Noise covariance matrix Rw_fasthyde is identity matrix because
    %the image has been whitened.
    Z = FastHyDe_fixEreturnZ(img_aux, E, Rw_fasthyde);
    
    
    %% Updating V: V_{k+1} = argmin_V ||V||_1 + mu/2 || Y-EZ_{k+1}-V-D_k||_F^2
    
    V_aux = Y_ori-E*Z+D;
    par =   1;
    V = sign(V_aux).*max(abs(V_aux)-par,0);
    
    
    %% Updating D: D_{k+1} = D_k - (Y-EZ_{k+1}-V_{k+1})
    D =  D+  ( Y_ori-E*Z-V );
    
    
    
    if ite>1
        criterion(ite) =  norm(Z-Z_old,'fro')/norm(Z_old,'fro');
        if criterion(ite)<0.001
            break;
        end
    end
    
    Z_old = Z;
end

figure; plot(criterion,'-o');
Y_denoised = E*Z;
Y_denoised = sqrt(Rw_ori)*Y_denoised;
img_denoised = reshape(Y_denoised', row, column, band);
end
