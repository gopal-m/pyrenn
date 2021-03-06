%%
%Read Example Data
file = 'example_data.xlsx';
num = xlsread(file,'narendra4');
%Inputs and outputs have to be matrices where columns=datapoints
%and rows=inputs
P = num(:,2).';
Y = num(:,3).';
Ptest = num(:,4).';
Ytest = num(:,5).';

%%
%Create NN

%create recurrent neural network with 1 input, 2 hidden layers with 
%3 neurons each and 1 output
%the NN uses the input data at timestep t-1 and t-2
%The NN has a recurrent connection with delay of 1,2 and 3 timesteps from the output
% to the first layer (and no recurrent connection of the hidden layers)
nn = [1 2 2 1];
dIn = [1,2];
dIntern=[];
dOut=[1,2,3];
net = CreateNN(nn,dIn,dIntern,dOut); %alternative: net = CreateNN([1,3,3,1],[1,2],[],[1,2,3]);

%%
%Train with LM-Algorithm
% Train NN with training data P=input and Y=target
% Set maximum number of iterations k_max to 200
% Set termination condition for Error E_stop to 1e-3
% The Training will stop after 200 iterations or when the Error <=E_stop
netLM = train_LM(P,Y,net,200,1e-3);
%Calculate Output of trained net (LM) for training and Test Data
y_LM = NNOut(P,netLM); 
ytest_LM = NNOut(Ptest,netLM); 

%%
%Train with BFGS-Algorithm
% Train NN with training data P=input and Y=target
% Set maximum number of iterations k_max to 400
% Set termination condition for Error E_stop to 1e-3
% The Training will stop after 400 iterations or when the Error <=E_stop
% measure time dt
netBFGS = train_BFGS(P,Y,net,400,1e-3);
%Calculate Output of trained net (LM) for training and Test Data
y_BFGS = NNOut(P,netBFGS); 
ytest_BFGS = NNOut(Ptest,netBFGS); 


%%
%Plot Results
fig = figure();
set(fig, 'Units', 'normalized', 'Position', [0.2, 0.1, 0.6, 0.6])
axis tight

subplot(311)
set(gca,'FontSize',16)
plot(Y,'r:','LineWidth',2)
hold on
grid on
plot(y_LM,'b','LineWidth',2)
plot(y_BFGS,'g','LineWidth',2)
l1 = legend('Train Data','LM output','BFGS output','Location','northwest');
set(l1,'FontSize',14)

subplot(312)
set(gca,'FontSize',16)
plot(Ytest,'r:','LineWidth',2)
hold on
grid on
plot(ytest_LM,'b','LineWidth',2)
plot(ytest_BFGS,'g','LineWidth',2)
l2 = legend('Test Data','LM output','BFGS output','Location','northwest');
set(l2,'FontSize',14)

subplot(313)
set(gca,'FontSize',16)
plot(netLM.ErrorHistory,'b','LineWidth',2)
hold on
grid on
plot(netBFGS.ErrorHistory,'g','LineWidth',2)
ylim([0,5])
l3 = legend('LM Error','BFGS Error','Location','northeast');
set(l3,'FontSize',14)