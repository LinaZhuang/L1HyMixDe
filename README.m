%%  The code and data herein distributed reproduces the results published in the paper 
%
%  L. Zhuang and Michael K. Ng, 
%       "Hyperspectral Mixed Noise Removal By1-Norm-Based Subspace 
%        Representation,” in IEEE Journal of Selected Topics in Applied 
%       Earth Observations and Remote Sensing, 2020.
%  
%  URL: URL: https://sites.google.com/hkbu.edu.hk/linazhuang/home
%
%%  Notes:
%
%   1) Package instalation: unzip the files to a directory and run the
%   script "runL1HyMixDe.m", which reproduce the 
%    results of L1HyMixDe reported in above paper.
%
%
%   2) The script L1HyMixDe.m  uses the package BM3D 
%      (v2 (30 January 2014))to implement the denoising algorithm BM3D 
%      introduced in 
%
%      K. Dabov, A. Foi, V. Katkovnik, and K. Egiazarian, "Image denoising by
%      sparse 3D transform-domain collaborative filtering," IEEE Trans. 
%      Image Process., vol. 16, no. 8, pp. 2080-2095, August 2007.
%
%      The BM3D package  is available at the 
%      BM3D web page:  http://www.cs.tut.fi/~foi/GCF-BM3D
%
%      Download this package and install it is the folder /BM3D
%
%
%   3)  L1HyMixDe.m  script  implents the respective algorithms.
%      
%% ACKNOWLEDGMENTS
%
% The authors acknowledge the following individuals and organisations:
%
%
%   - Prof. Paolo Gamba from Pavia university, 
%     for making the Pavia Centre data set available to the community.
%
%   - Prof. David Landgrebe and Larry Biehl from Purdue University, 
%     for making the Washington DC Mall data set available to the community.
%
%   - Authors of BM3D method (Dr. Kostadin Dabov, Prof. Alessandro Foi, 
%     Prof. Vladimir Katkovnik, and Prof. Karen Egiazarian) from Tampere 
%     University of Technology, for making the BM3D demo software available 
%     to the community.
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Author: Lina Zhuang, April 2020
%

