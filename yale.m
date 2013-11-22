srcFiles = dir('./dataset_yale/*.pgm');  % the folder in which ur images exists

k=40;

MeanImage = (zeros(6400,1));

dataset = [];
labels = [];
totalimg = length(srcFiles);

%Store all the images
for i = 1 : totalimg
    filename = strcat('./dataset_yale/',srcFiles(i).name);
    %str2num(filename(6:7))
    labels = [labels str2num(filename(21:22))];
    X = (imread(filename));
    %X=im2double(X);
    Y = imresize(X,[80,80]);
    Z = reshape(Y,6400,1);
    %Z = abs(Z);
    dataset = [dataset double(Z)];
end

set1 = [];
set2 = [];
set3 = [];
set4 = [];
l1 = [];
l2 = [];
l3 = [];
l4 = [];

for i = 1:4:totalimg
    set1 =[ set1 dataset(:,i) ];
    l1 = [l1 labels(:,i)];
 end

for i = 2:4:totalimg
    set2 =[ set2 dataset(:,i) ];
    l2 = [l2 labels(:,i)];
end

for i = 3:4:totalimg
    set3 =[ set3 dataset(:,i) ];
    l3 = [l3 labels(:,i)];
end

for i = 4:4:totalimg
    set4 =[ set4 dataset(:,i) ];
    l4 = [l4 labels(:,i)];
end

size(set1)
size(set2)
size(set3)
size(set4)

setsize = totalimg/4;
%return;

%imtool(reshape(Z,80,80))

%return 
%size(dataset)

trainsize = setsize*3;
testsize = setsize;

%trainsize
%testsize

trainset = [];
testset = [];
trainlabel = [];
testlabel = [];


for i = 1 : setsize
    trainset = [trainset set2(:,i)];
    trainlabel = [trainlabel l2(:,i)];
    MeanImage=(MeanImage)+(set2(:,i));  
end

% Compute Training Set and Mean Image
for i = 1 : setsize
    trainset = [trainset set3(:,i)];
    trainlabel = [trainlabel l3(:,i)];
    MeanImage=(MeanImage)+(set3(:,i));  
end

for i = 1 : setsize
    trainset = [trainset set4(:,i)];
    trainlabel = [trainlabel l4(:,i)];
    MeanImage=(MeanImage)+(set4(:,i));
end

for i = 1 : setsize
    testset = [testset set1(:,i)];
    testlabel = [testlabel l1(:,i)];
end


%MeanImage
MeanImage=(MeanImage/trainsize);
MeanImage = (MeanImage);
MeanImage = MeanImage/max(max(MeanImage));
%imtool((reshape(MeanImage,80,80)));

%MeanImage
mean2D=[];
for i = 1: trainsize
    mean2D = [mean2D MeanImage];
end

%size(mean2D)

A = trainset - mean2D;
%size(A)

iA = transpose(A);
%size(iA)

mulA= iA * A;
%cov_A=cov(mulA);
cov_A = mulA;
%size(cov_A)

[V,D]=eig(cov_A);

pca_array=[];
for i = 1: trainsize
    pca_array=[pca_array D(i,i)];
end

pca_array=sort(pca_array,'descend');
%pca_array

pca=pca_array(1:k);

eigenfaces=[];

%Compute k eigenfaces
for i = 1: trainsize
    for j = 1:k
        if D(i,i) == pca(j)
            eigenfaces=[eigenfaces normc(A * V(:,i))];
            break
        end
    end        
end


%size(A)
%size(V(:,1))
%size(eigenfaces)

reducedA=[];


%Project all training images on eigenfaces and store weight vectors in Matrix
for i = 1:trainsize
    reducedI=[];
    for j = 1:k    
        %size(transpose(A(:,i)))
        %size(eigenfaces(:,j))
        reducedI = [reducedI transpose(A(:,i))*eigenfaces(:,j)];
    end
    reducedA=[reducedA;reducedI];
end

%reducedA

%size(reducedA)

%Verification
correct = 0;

for i = 1 : setsize
    Z = testset(:,i);
    Z = double(Z) - double(MeanImage);
    reducedZ = [];
    for j = 1:k    
        reducedZ = [reducedZ double(transpose(Z))*eigenfaces(:,j)];
    end
    %reducedZ
    %size(reducedZ)
    minf=Inf;
    minvec=[];
    minid=-1;
    for j = 1:trainsize
        f=norm(double(reducedZ)-double(reducedA(j,:)));
        if f < minf
            minf = f;
            minvec = reducedA(j,:);
            minid = j;
        end
    end
    
    display('--------')
    testlabel(i)
    trainlabel(minid)
    display('--------')
    
    if trainlabel(minid) == testlabel(i)
        correct=correct+1;
    end
          
    %Reconstruction of Image
    img=zeros(6400,1);
    for j = 1:k
        img = img + double(minvec(j))*double(eigenfaces(:,j));
    end
    img = img/max(max(img));    
    X = reshape(img,80,80);
    
    %imtool(X)
    %break;
    %imtool(Y)
    %figure, imshow(I);    
end
    
%labels
%size(labels)
%size(V)
correct
