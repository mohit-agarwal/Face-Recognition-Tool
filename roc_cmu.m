load CMUPIEData

MeanImage = (zeros(6400,1));

dataset = [];
labels = [];
totalimg = 2856
d=1024

%Store all the images
for i = 1 : totalimg
    labels = [labels CMUPIEData(i).label];
    X = CMUPIEData(i).pixels;
    Z = transpose(X);
    %Z = abs(Z);
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
