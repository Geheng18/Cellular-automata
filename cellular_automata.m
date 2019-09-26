clc
clear
close all

%cellular size
a=1000;b=1000;c=5;

%parameter
alpha=0.01;   %suggest(0,0.2)
beta=0.7;    %suggest(0,0.9399)
p=0.1;        %suggest(0-0.997)
delta1=0.01;  %suggest(0-0.997)
delta21=0.001;%suggest(0-0.997)
delta22=0.1;  %suggest(0-0.997)
mu=0.000025;  %suggest(0-0.01)
k=0.3;        %suggest(0-0.997)

%initialization cellular--CA matrix
temp=zeros(a,b);
temp(1,1)=2;temp(5,5)=2;temp(8:9,1:2)=2;temp(9,9)=2;
temp(4,2)=3;temp(6,1)=1;temp(8,2)=4;
% temp(1:50:1000,1:50:1000)=2;
% temp(850:3:900,25:3:75)=2;
% temp(250:2:300,950:2:1000)=2;
% temp(950:3:1000,950:2:1000)=2;
% temp(1:700,1:200)=c;
CA=cat(3,temp,temp);

%plot
imh=imagesc(CA(:,:,1));
colorbar
colormap(jet)

%run cellular
for t=2:2100
    CA(:,:,t)=CA(:,:,t-1);
    for i=1:a
        for j=1:b
            %forbidden area
            if CA(i,j,t)~=c
                %randomly become a drug addict
                if rand<mu
                    CA(i,j,t)=4;
                else
                    %natural death
                    if CA(i,j,t)==0&&rand<alpha
                        CA(i,j,t)=1;
                    else
                        %detoxification
                        if CA(i,j,t)==3
                            %detoxification->death
                            if rand<delta21
                                CA(i,j,t)=4;
                            else
                                %detoxification->drug
                                if rand<k
                                    CA(i,j,t)=2;
                                else
                                    %detoxification->normal
                                    if rand<delta22
                                        CA(i,j,t)=0;
                                    end
                                end
                            end
                        end
                        %drug
                        if CA(i,j,t)==2
                            %drug->detoxification
                            if rand<p
                                CA(i,j,t)=3;
                            else
                                %drug->death
                                if rand<delta1
                                    CA(i,j,t)=3;
                                else
                                    %people near drug users random drug use
                                    %neighbor (i-1,j-1)
                                    if i>1&&j>1
                                        if CA(i-1,j-1,t)==1&&rand<beta
                                            CA(i-1,j-1,t)=2;
                                        end
                                    end
                                    %neighbor (i-1,j)
                                    if i>1
                                        if CA(i-1,j,t)==1&&rand<beta
                                            CA(i-1,j,t)=2;
                                        end
                                    end
                                    %neighbor (i-1,j+1)
                                    if i>1&&j<b
                                        if CA(i-1,j+1,t)==1&&rand<beta
                                            CA(i-1,j+1,t)=2;
                                        end
                                    end
                                    %neighbor (i-1,j-1)
                                    if j>1
                                        if CA(i,j-1,t)==1&&rand<beta
                                            CA(i,j-1,t)=2;
                                        end
                                    end
                                    %neighbor (i,j+1)
                                    if j<b
                                        if CA(i,j+1,t)==1&&rand<beta
                                            CA(i,j+1,t)=2;
                                        end
                                    end
                                    %neighbor (i+1,j-1)
                                    if i<a&&j>1
                                        if CA(i+1,j-1,t)==1&&rand<beta
                                            CA(i+1,j-1,t)=2;
                                        end
                                    end
                                    %neighbor(i+1,j)
                                    if i<a
                                        if CA(i+1,j,t)==1&&rand<beta
                                            CA(i+1,j,t)=2;
                                        end
                                    end
                                    %neighbor(i+1,j+1)
                                    if i<a&&j<b
                                        if CA(i+1,j+1,t)==1&&rand<beta
                                            CA(i+1,j+1,t)=2;
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    set(imh,'CData',CA(:,:,t))
    xlabel(sprintf('Time = %5i',t))
    colorbar
    drawnow
end

