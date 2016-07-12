f=figure;
a=axes;
set(a,'color','white')
cross= zeros(500,500);
cross(240:260,250)=1;
cross(250,240:260)=1;
imagesc(cross)
set(a,'position',[0 0 1 1])
pause(5)
close(f)