srcFiles = dir('./SMAI2013StudentsDataset/*.bmp');  % the folder in which ur images exists
k=40;

MeanImage = (zeros(6400,1));

dataset = [];
labels = [];
totalimg = length(srcFiles);

%Store all the images
for i = 1 : totalimg
    filename = strcat('./SMAI2013StudentsDataset/',srcFiles(i).name);
    labels = [labels str2num(filename(27:35))];
    X = (imread(filename));
    Y = imresize(X,[80,80]);
    Z = reshape(Y,6400,1);
    dataset = [dataset double(Z)];
end

roclabels = [];
scores=[];
cnt1=0;
cnt2=0;

for i=1 : totalimg
    for j=1 : totalimg
        if i~=j
            if labels(i)==labels(j) & cnt1 < 500
                f=norm(double(dataset(:,i)) - double(dataset(:,j)));
                scores = [scores f];
                roclabels = [roclabels 0];
                cnt1=cnt1+1;
            else if labels(i)~=labels(j) & cnt2 < 500
                f=norm(double(dataset(:,i))-double(dataset(:,j)));
                scores = [scores f];
                roclabels = [roclabels 1];
                cnt2=cnt2+1;
                end
            end
        end
        if cnt1==500 & cnt2==500
            break
        end
    end
    if cnt1==500 & cnt2==500
        break
    end
end

roclabels;
size(scores);
size(roclabels);
[x1, y1, t1, k1, opt] = perfcurve(roclabels,scores,1);
plot(x1,y1)
title('ROC Curve');
xlabel('False Positive Rates');
ylabel('True Positive Rates');
return
