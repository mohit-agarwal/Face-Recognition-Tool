srcFiles = dir('./SMAI2013StudentsDataset/*.bmp');  % the folder in which ur images exists

k=100;



dataset = [];
labels = [];
totalimg = length(srcFiles);

%Store all the images
for i = 1 : totalimg
    filename = strcat('./SMAI2013StudentsDataset/',srcFiles(i).name);
    %str2num(filename(6:7))
    labels = [labels str2num(filename(27:35))];
    X = (imread(filename));
    %X=im2double(X);
    %Y = imresize(X,[80,80]);
    Z = reshape(X,6400,1);
    %Z = abs(Z);
    dataset = [dataset double(Z)];
end

setsize = totalimg/4

%return;

%imtool(reshape(Z,80,80))

%return
%size(dataset)

trainsize = totalimg -1;
testsize = 1;
correct= 0;

for i = 1: totalimg
    testset = [];
    testlabel = [];
    trainlabel = [];
    trainset = [];
    testset = [testset dataset(:,i)];
    testlabel = [ testlabel labels(:,i)];
    MeanImage = (zeros(6400,1));
    for j = 1 : totalimg
        
        if j~=i
            trainset = [trainset dataset(:,j) ];
            trainlabel = [trainlabel labels(:,j) ];
            MeanImage=(MeanImage)+(dataset(:,j));
        end
    end
   
    %MeanImage
    MeanImage=(MeanImage/trainsize);
    MeanImage = (MeanImage);
    MeanImage = MeanImage/max(max(MeanImage));
    %imtool((reshape(MeanImage,80,80)));
    
    %MeanImage
    mean2D=[];
    for ii = 1: trainsize
        mean2D = [mean2D MeanImage];
    end
    
    %size(mean2D)
    
    A = trainset - mean2D;
    %size(A)
    iA = transpose(A);
    %size(iA)
    
    mulA= iA * A;
    cov_A=mulA;
    display('yippee');
    size(cov_A)
    
    [V,D]=eig(cov_A);
    
    pca_array=[];
    for ii = 1: trainsize
        pca_array=[pca_array D(ii,ii)];
    end
    
    pca_array=sort(pca_array,'descend');
    %pca_array
    
    pca=pca_array(1:k);
    
    eigenfaces=[];
    
    %Compute k eigenfaces
    for ii = 1: trainsize
        for jj = 1:k
            if D(ii,ii) == pca(jj)
                eigenfaces=[eigenfaces normc(A * V(:,ii))];
                break
            end
        end
    end
    
    
    %size(A)
    %size(V(:,1))
    %size(eigenfaces)
    
    reducedA=[];
    
    
    %Project all training images on eigenfaces and store weight vectors in Matrix
    for ii = 1:trainsize
        reducedI=[];
        for jj = 1:k
            %size(transpose(A(:,i)))
            %size(eigenfaces(:,j))
            reducedI = [reducedI transpose(A(:,ii))*eigenfaces(:,jj)];
        end
        reducedA=[reducedA;reducedI];
    end
    
    %reducedA
    
    %size(reducedA)
    
    %Verification
    %correct = 0;
    
    
    Z = testset(:,1);
    Z = double(Z) - double(MeanImage);
    reducedZ = [];
    for jj = 1:k
        reducedZ = [reducedZ double(transpose(Z))*eigenfaces(:,jj)];
    end
    %reducedZ
    %size(reducedZ)
    minf=Inf;
    minvec=[];
    minid=-1;
    for jj = 1:trainsize
        f=norm(double(reducedZ)-double(reducedA(jj,:)));
        if f < minf
            minf = f;
            minvec = reducedA(jj,:);
            minid = jj;
        end
    end
    
    display('--------')
    testlabel(1)
    trainlabel(minid)
    display('--------')
    
    if trainlabel(minid) == testlabel(1)
        correct=correct+1;
    end
    
    %Reconstruction of Image
    img=zeros(6400,1);
    for jj = 1:k
        img = img + double(minvec(jj))*double(eigenfaces(:,jj));
    end
    img = img/max(max(img));
    X = reshape(img,80,80);
    
    
end

    
    %imtool(X)
    %break;
    %imtool(Y)
    %figure, imshow(I);    

    
%labels
%size(labels)
%size(V)
correct
