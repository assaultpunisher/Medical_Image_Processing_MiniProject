Img = imread('D:\Matlab\Project\Images\img.jpg');
Img1 = rgb2gray(Img);
Img2 = double(imresize(Img1,[4 4]));
Img3 = imresize(Img1,[4 4]);


n = 4; 
N = (n*(n-1))*2;
s=zeros(1,N);
t=zeros(1,N);
rows=zeros(1,n*n);
cols=zeros(1,n*n);
weights = zeros(1,N);

% s & t calculation
r=n;
c=n;
I=zeros(r,c);
x = 1; 
for i=1:r
    for j=1:c
        I(i,j) = x;
        rows(1,x)=i;
        cols(1,x)=j;
        x = x+1;
    end
end


% For Horizontal
si = 1;
for i=1:r
    for j=1:c-1
        if (((j+1)-j) == 1)
            s(1,si) = I(i,j);
            t(1,si) = I(i,j+1);
            si = si + 1;
        end    
    end
end

% For Verticle 
for i=1:r
    for j=1:c-1
        if (((j+1)-j) == 1)
            s(1,si) = I(j,i);
            t(1,si) = I(j+1,i);
            si = si + 1;
        end    
    end
end


% Weight Calculation
% For Horizontal Edges
[r,c] = size(Img2);
x = 1; 
for i=1:r
    for j=1:c-1
        I1 = (Img2(i,j) - 0)/(255 - 0);
        I2 = (Img2(i,j+1) - 0)/(255 - 0);
        w = 2 - (double(I1)+double(I2)) + 10.^(-5);
        weights(1,x) = w;
        x = x + 1;
    end
end

% For Verticle Edges
for i=1:r
    for j=1:c-1
        I1 = (Img2(j,i) - 0)/(255 - 0);
        I2 = (Img2(j+1,i) - 0)/(255 - 0);
        w = 2 - (double(I1)+double(I2)) + 10.^(-5);
        weights(1,x) = w;
        x = x + 1;
    end
end

G = digraph(s,t,weights);
path = shortestpath(G,1,n*n);
[psr psc] = size(path);
u=zeros(1,psc);
v=zeros(1,psc);


for i=1:psc
    y=path(i);
    u(1,i)=rows(1,y);
    v(1,i)=cols(1,y);
end

[ur uc] = size(u);
for i=1:uc
    a = u(1,i);
    b = v(1,i);
    Img3(a,b) = 255;
end

p = plot(G,'Layout','force','EdgeLabel',G.Edges.Weight);
highlight(p,path,'EdgeColor','r','NodeColor','r')
