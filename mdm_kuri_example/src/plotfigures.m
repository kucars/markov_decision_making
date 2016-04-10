%----------------------Plot the joint beliefs----------------
%v3_3 classical 
Episode = [0 1 2 3 4 5 6 7 8]; 
Joint_Belief1=[1 0.955433 0.873915 0.803682 0.747376 0.705382 0.686528 0.774354 0.725652];
Joint_Rewards1=[-10.1956 99.6207 -10.0005 -10.078 -10.0005 -10.0002 -10.0002 98.4628 -10.0001];
accumlativeRewards1 = [-10.1956 89.425 79.425 69.347 59.346 49.346 39.346 137.81 127.81];

%using danger v1 
Joint_Belief2=[1 0.955433 0.873915 0.803682 0.736859 0.709205 0.697104 0.820446 0.74123];
Joint_Rewards2=[-15.4508 99.6629 -10.0171 -10.0772 -10.0028 -10.0021 -10.0007 98.463 -10.0003];
accumlativeRewards2= [-15.4508 84.212 74.195 64.118 54.115 44.113 34.112 132.58 122.57];

%using time and danger (with no priority of objectives) FASTparameters_v1 
Joint_Belief3=[1 0.955433 0.873915 0.800016 0.744006 0.702186 0.673901 0.820215 0.752565];
Joint_Rewards3=[-15.4508 99.6629 -1.79078 -1.88905 -3.06117 -2.12133 -1.61236 98.5476 -2.61171];
accumlativeRewards3 = [-15.4508 84.212 82.421 80.532 77.471 75.350 73.737 172.29 169.67];

%using time with classical v1
Joint_Belief4=[1 0.955433 0.873915 0.803682 0.747376 0.723411 0.82561 0.930436 0.840253];
Joint_Rewards4=[-1.02894 99.7014 -1.03232 -1.44027 -1.09349 -0.931223 -0.756536 98.5761 -0.595945];
accumlativeRewards4 = [-1.02894 98.67246 97.64014 96.19987 95.10638 94.175157 93.418621 191.994721 191.398776];

%priortiesObj_v1 (do the weights before generate the rewards) 
Episode1 = [0 1 2 3 4 5 6 7 8 9]; 
Joint_Belief5=[1 0.955433 0.878075 0.811495 0.749904 0.712859 0.689467 0.692254 0.795797 0.723151]
Joint_Rewards5= [-12.0231 84.4154 -3.01883 -1.37291 -1.92137 -3.06693 -2.96563 -1.87477 84.6836 -1.46718]
accumlativeRewards5= [-12.0231 -24.0462 -27.06503 -28.43794 -30.35931 -33.42624 -36.39187 -38.26664 -76.53328 -78.00046]


figure 
h= plot(Episode,Joint_Belief1, '--go',Episode,Joint_Belief2,'-.r*',Episode,Joint_Belief3,'-.xb',Episode,Joint_Belief4,'--+k',Episode1, Joint_Belief5,'-.po');
set (h, 'LineWidth', 2);
%plot(JointRewards1,':');
lngd=legend('Classical','Using Risk','Using Time and Risk','Time and Classical model','priortiesObj_v1');
grid on
title('Comparison between the joint-beliefs of the models')
xlabel('Episode');
ylabel('Joint Belief');
set(lngd,'Location','NorthEast');
set(lngd,'interpreter','latex','fontsize',8);

%----representing states for model 1---------------
state00 = '\leftarrow state b-b-f-c';
text(0,1,state00)

state01 = '\leftarrow state c-a-f-c';
text(1,0.955433,state01)

state02 = '\leftarrow state c-a-f-n';
text(2,0.873915,state02)

state03 = '\leftarrow state d-b-f-n';
text(3,0.803682,state03)

state04 = '\leftarrow state d-c-f-n';
text(4,0.747376,state04)

state05 = '\leftarrow state c-d-f-n';
text(5,0.705382,state05)

state06 = '\leftarrow state d-e-f-n';
text(6,0.686528,state06)

state07 = '\leftarrow state c-f-f-n';
text(7,0.774354,state07)

state08 = '\leftarrow state b-f-n-n';
text(8,0.725652,state08)

%----representing states for model 2---------------

state10 = '\leftarrow state b-b-f-c';
text(0,1,state10)

state11 = '\leftarrow state b-b-f-c';
text(1,0.955433,state11)

state12 = '\leftarrow state c-a-f-n';
text(2,0.873915,state12)

state13 = '\leftarrow state d-b-f-n';
text(3,0.803682,state13)

state14 = '\leftarrow state c-c-f-n';
text(4,0.736859,state14)

state15 = '\leftarrow state b-d-f-n';
text(5,0.709205,state15)

state16 = '\leftarrow state a-e-f-n';
text(6,0.697104,state16)

state17 = '\leftarrow state a-f-f-n';
text(7,0.820446,state17)

state18 = '\leftarrow state a-f-n-n';
text(8,0.74123,state18)

%----representing states for model 3---------------
state20 = '\leftarrow state b-b-f-c';
text(0,1,state20)

state21 = '\leftarrow state c-a-f-c';
text(1,0.955433,state21)

state22 = '\leftarrow state c-a-f-n';
text(2,0.873915,state22)

state23 = '\leftarrow state b-b-f-n';
text(3,0.800016,state23)

state24 = '\leftarrow state a-c-f-n';
text(4,0.744006,state24)

state25 = '\leftarrow state a-d-f-n';
text(5,0.702186,state25)

state26 = '\leftarrow state b-e-f-n';
text(6,0.673901,state26)

state27 = '\leftarrow state l-f-f-n';
text(7,0.820215,state27)

state28 = '\leftarrow state l-f-n-n';
text(8,0.752565,state28)
%----------------plot the rewards----------------
figure 
x= [0 1 2 3 4 5 6 7 8];
y= [-10.1956 -15.4508 -15.4508 -1.02894; 99.6207 99.6629 99.6629 99.7014; -10.0005 -10.0171 -1.79078 -1.03232; -10.078 -10.0772 -1.88905 -1.44027; -10.0005 -10.0028 -3.06117 -1.09349; -10.0002 -10.0021 -2.12133 -0.931223; -10.0002 -10.0007 -1.61236 -0.756536;98.4628 98.463 98.5476 98.5761; -10.0001 -10.0003  -2.61171 -0.595945];

c=plot(x,y);
set(c,'LineWidth',2);
legend('Classical','ByUsingDangerDistance','ByUsingTimeAndDangerDistance','Time with classical');
grid on
title('Comparison between the joint-rewards of the models');
xlabel('Episode');
ylabel('Joint Rewards');

%----------------plot the accumlative rewards --------

figure 
x1= [0 1 2 3 4 5 6 7 8];
y1= [-10.1956 -15.4508 -15.4508 -1.02894; 89.425 84.212 84.212 98.67246; 79.425 74.195 82.421 97.64014; 69.347 64.118 80.532 96.19987; 59.346 54.115 77.471 95.10638; 49.346 44.113 75.350 94.175157; 39.346 34.112 73.737 93.418621; 137.81 132.58 172.29 191.994721; 127.81 122.57 169.67 191.398776];

c1=plot(x1,y1);
set(c1,'LineWidth',2);
legend('Classical','ByUsingDangerDistance','ByUsingTimeAndDangerDistance','Time with Classical');
grid on
title('Comparison between the joint accumlated rewards of the models');
xlabel('Episode');
ylabel('Joint Accumlated Rewards');

clearDanger = '\leftarrow Clear Danger';
text(1,89.425,clearDanger);

extractvictim = '\leftarrow Extract Victim';
text(7,172.29,extractvictim);

%----------------plot of agents location -----------------
%********version classical *************************************
%position agent 1 
x=[0 1 2 3 4 5 6 7 8];
y=[2 3 3 4 4 3 4 3 2];
%position agent 2
x1=[0 1 2 3 4 5 6 7 8];
y1=[2 1 1 2 3 4 5 6 6];
%**********version using danger function ************************
%position of agent 1
a = [0 1 2 3 4 5 6 7 8]; 
b =[ 2 2 3 4 3 2 1 1 1];

% position of agent 2 
a1 = [0 1 2 3 4 5 6 7 8]; 
b1 = [2 2 1 2 3 4 5 6 6];
%******version using time and danger distance (FAST)**************
% position of agent 1 
k = [0 1 2 3 4 5 6 7 8]; 
l = [2 3 3 2 1 1 2 12 12];

% position of agent 2 
k1 = [0 1 2 3 4 5 6 7 8]; 
l1 = [2 1 1 2 3 4 5 6 6];

%******time with the classical**************
% position of agent 1 
h=[0 1 2 3 4 5 6 7 8];
j=[2 3 3 4 4 5 6 5 5];

% position of agent 2 
h1=[0 1 2 3 4 5 6 7 8];
j1=[2 1 1 2 3 4 5 6 6];

figure
p=plot(x,y,'go',x1,y1,'gx',a,b,'ro',a1,b1,'rx',k,l,'bo',k1,l1,'bx',h,j,'ko',h1,j1,'kx');
set(p,'LineWidth',2);

legend('Robot','Human');

grid on
title('Agents locations')
xlabel('Episode');
ylabel('Nodes');


%----------------plot bars test----------
figure 
%x_axis= ['clear_danger''extract_victim''dangerDistance''time'; 'clear_danger''extract_victim''dangerDistance''time'];

a2 = [ 2 3; 4 5 ];
b2 = [2 2; 2 3];

%set(gcf,'Color',[1,1,1]);
%hold on;  
bar(a2,'r');  
bar(b2,'g');  
%bar(c2,'r');
%bar(d2,'y');
legend('a', 'b');










