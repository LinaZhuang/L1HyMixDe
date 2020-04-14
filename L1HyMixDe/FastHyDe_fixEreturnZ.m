function [eigen_Y_bm3d ] = FastHyDe_fixEreturnZ(img_ori, E, Rw_ori )
addpath('BM3D');


% Input: -----------
% img_ori        hyperspectral data set with (Lines x Columns x B),
%                where Lines, Columns, and B are the number of rows,
%                columns, and bands, respectively.
%
% E              signal subspace
% Rw_ori         Noise covariance matrix
% Output: -----------
% eigen_Y_bm3d   Denoised subspace coefficients
%
%
% ---------------------------- -------------------------------------------
% See more details in papers:
%   [1] L. Zhuang and J. M. Bioucas-Dias, 
%       "Fast hyperspectral image denoising based on low rank and sparse 
%       representations,” in 2016 IEEE International Geoscience and Remote
%       Sensing Symposium (IGARSS 2016), 2016.
%
%   [2] L. Zhuang and J. M. Bioucas-Dias, 
%       "Fast hyperspectral image denoising and inpainting based on low rank 
%       and sparse representations,” Submitted to IEEE Journal of Selected
%       Topics in Applied Earth Observations and Remote Sensing, 2017.
%       URL: http://www.lx.it.pt/~bioucas/files/submitted_ieee_jstars_2017.pdf
%
%% -------------------------------------------------------------------------
%
% Copyright (July, 2017):        
%             Lina Zhuang (lina.zhuang@lx.it.pt)
%             &
%             José Bioucas-Dias (bioucas@lx.it.pt)
%            
%
% FastHyDe is distributed under the terms of
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




t1=clock;
% addpath('BM3D');
[Lines, Columns, B] = size(img_ori);
N=Lines*Columns;



 

Y = reshape(img_ori, N, B)';
k_subspace =  size(E,2);
eigen_Y = E'*Y;


%% --------------------------Eigen-image denoising ------------------------------------

eigen_Y_bm3d=[];
for i=1:k_subspace
    % produce eigen-image
    eigen_im = eigen_Y(i,:);
    min_x = min(eigen_im);
    max_x = max(eigen_im);
    eigen_im = eigen_im - min_x;
    scale = max_x-min_x;
    
    %scale to [0,1]
    eigen_im = reshape(eigen_im, Lines, Columns)/scale;
    
    
    %estimate noise from Rw
    sigma = sqrt(E(:,i)'*Rw_ori*E(:,i))/scale;
    %     sigma = 0.05/scale;
    % denoise  with BM3D
    if exist('BM3D.m','file') == 0 %Check existence of  function BM3D
        errordlg({'Function BM3D.m not found! ','Download from http://www.cs.tut.fi/~foi/GCF-BM3D and install it in the folder .../BM3D'});
        error('Function BM3D.m not found!  Download from http://www.cs.tut.fi/~foi/GCF-BM3D and install it in the folder .../BM3D');
        
    else
        if sigma>0

                    [~, filt_eigen_im] = BM3D(1,eigen_im, sigma*255);

        else
            filt_eigen_im = eigen_im;
        end
    end
    eigen_Y_bm3d(i,:) = reshape(filt_eigen_im*scale + min_x, 1,N);

    eigen_im_pre = eigen_im;
    filt_eigen_im_pre =filt_eigen_im;
end

% reconstruct data using denoising engin images
Y_reconst = E*eigen_Y_bm3d;

 
end