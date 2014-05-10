clear all
close all

addpath('../MRF/');
% addpath('../Chan-Vese/');
load('../data/prior/shapePriorShift.mat');loadDataFruitfly;
%generateData;

%Run MRF

edgeStruct = createImgStructure(X,nStates);
lambda = 1;
beta = 10;
Epsilon = 1;
prior_phis = Phi(:,:,1:2); 
no_ex = size(prior_phis,3);

% Compute kernel sigma
kernel_sigma = sum(get_Hdistance(circshift(prior_phis,[0 0 -1]),prior_phis,Epsilon));

% initialization
m = zeros(size(X,1),size(X,2));
m(10:size(X,1)-10,10:size(X,2)-10) = 1;
% m0 = prior_phis(:,:,30);
% m(m0>0.5) = 1;
% m(m0<=0.5) = 0;
phi = m(:);
MuEst = [0,1];
SigmaEst = [0.1,0.1];
%   
% for i = 1:10
%   expLambdaPhi = exp(lambda*phi);
%   probLogistic = 1./(expLambdaPhi + 1);
%   probA = [probLogistic, 1 - probLogistic];
%   
%   figure;
%   imagesc(reshape(probA(:,2),nRows,nCols));
%   title('prob(y_i|a_i)');
%   colorbar
%   %pause
% 
%   [MuEst,SigmaEst] = normalMixtureEM(MuEst,SigmaEst,X,edgeStruct,probA,5);
%   [nodePot,edgePot] = producePotentials(X,edgeStruct,MuEst,SigmaEst,probA);
%   [nodeBelMF,edgeBelMF,logZMF] = UGM_Infer_MeanField(nodePot,edgePot,edgeStruct);  
%   
%   %figure;
%   imagesc(reshape(nodeBelMF(:,2),nRows,nCols));
%   title('Mean Field Estimates of Marginals');  
%   colorbar
%   %pause
% 
%   EQ_M = lambda*(probLogistic.*nodeBelMF(:,2) - (1-probLogistic).*nodeBelMF(:,1));
%   EQ_M = reshape(EQ_M,size(X,1),size(X,2));
%   m = chanvese(X,m,100,0.1,beta*EQ_M,1,prior_phis, kernel_sigma, Epsilon); 
%   phi = m(:);
% 
%   %pause
% end

seg = chanvese(X,m,200,0.1,[],0,prior_phis, kernel_sigma, Epsilon); 
