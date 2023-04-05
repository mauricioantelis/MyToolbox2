function [ acc, tp, fp, tn, fn, confu, f1score, kappa, ALL] = Compute_ClassificationMetrics2Classes(YTest,YEsti)

% % --------------------------------------------
% % verificar que ambos vectores tengan el mismo numero de clases
% if length(unique(YTest)) ~= length(unique(YEsti))
%     error('PILAS: no hay el mismo numero de clases')
% end


% --------------------------------------------
% Verificar que ambos vectores tengan el mismo nombre para las clases
currentlabels  = unique(YTest);
Nclasses       = length(currentlabels);

if Nclasses==2
    Ind1         = YTest==currentlabels(1);
    Ind2         = YTest==currentlabels(2);
    YTest(Ind1)  = 1;
    YTest(Ind2)  = 2;
    
    Ind1         = YEsti==currentlabels(1);
    Ind2         = YEsti==currentlabels(2);
    YEsti(Ind1)  = 1;
    YEsti(Ind2)  = 2;
    
    classes = [1 2];
    confu = zeros(2,2);
else
    error('PILAS: ONLY TWO CLASSES ARE SUPORTED IN THIS FUNCTION')
end
clear ans currentlabels


% --------------------------------------------
% Compute classification accuracy
acc = 1*sum((YTest-YEsti)==0)/length(YTest);


% --------------------------------------------
% Compute confusion matrix [YTest YEsti]
Ind_Class1 = (YTest==classes(1));
Ind_Class2 = (YTest==classes(2));

confu(1,1) = sum(YEsti(Ind_Class1)==1);
confu(1,2) = sum(YEsti(Ind_Class1)==2);
confu(1,:) = confu(1,:)/sum(Ind_Class1);

confu(2,1) = sum(YEsti(Ind_Class2)==1);
confu(2,2) = sum(YEsti(Ind_Class2)==2);
confu(2,:) = confu(2,:)/sum(Ind_Class2);

tn         = 1*confu(1,1);
tp         = 1*confu(2,2);
fp         = 1*confu(1,2);
fn         = 1*confu(2,1);
f1score    = 2 *  tp ./ (2 * tp + fp + fn);

kappa      = (acc-0.5)/(1-0.5);

% --------------------------------------------
% All results
ALL.ACC = acc;
ALL.TPR = tp;
ALL.FPR = fp;
ALL.TNR = tn;
ALL.FNR = fn;
ALL.CM  = confu;
ALL.F1  = f1score;
ALL.KP  = kappa;

% --------------------------------------------
% Example
% % YTest  = [1 1 1 1 1 2 2 2 2 2 2]';
% % YEsti  = [1 1 1 1 2 2 2 2 2 2 2]';
% % 
% % N: number of 0's or 1's in YTest
% % P: number of 1's or 2's in YTest
% % N+P: total number of 0's and 1's i YTest
% % 
% % TNR = 0's predicted as 0's
% % TPR = 1's predicted as 1's
% % FPR = 0's predicted as 1's
% % FNR = 1's predicted as 0's
% % 
% %           |  Estimated
% %           |    class
% %           |   0     1
% % ------------------------
% %  Real   0 |  TNR   FPR
% %  class  1 |  FNR   TPR
% % 