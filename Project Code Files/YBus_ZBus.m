clc
close all;
filepath= input('Please type the source folder!\n','s');
path=convertCharsToStrings(filepath);
data_line= readmatrix(path,'sheet','line');
data_bus= readmatrix(path,'sheet','bus');


FromBus = data_line(:,1);
ToBus= data_line(:,2);
Sres = data_line(:,3);               %series resistance
Srec = 1i.*data_line(:,4);           %series reactance
y=1./(Sres+Srec);                    %series admittance   
B = 1i.*(data_line(:,5)./2);         %half of the total charging admittance   
tap = data_line(:,6);                %tap ratio    

Shuntcon = data_bus(:,2);            %shant conductance
Shuntsus = 1i.*data_bus(:,3);        %shunt susceptance
ShuntAdm = Shuntcon + Shuntsus;      %shunt admittance

bus=length(data_bus(:,1));
line=length(FromBus);
Ybus=zeros(bus,bus);

for k=1:line
    p=FromBus(k);
    q=ToBus(k);
    if tap(k)==1
       Ybus(p,p)=Ybus(p,p)+y(k)+B(k);
       Ybus(q,q)=Ybus(q,q)+y(k)+B(k);
       Ybus(p,q)=Ybus(p,q)-y(k);
       Ybus(q,p)=Ybus(p,q);
    else                                    %considering tap changing                    
       Ybus(p,p)=Ybus(p,p)+y(k)/(tap(k)^2)+B(k);
       Ybus(q,q)=Ybus(q,q)+y(k)+B(k);
       Ybus(p,q)=Ybus(p,q)-y(k)/tap(k);
       Ybus(q,p)=Ybus(p,q);    
    end
end

for l=1:bus
    Ybus(l,l)=Ybus(l,l)+ShuntAdm(l);     %addition of shunt admittance to diagonals
end


[L,U]=LUfactorization(Ybus);  %LU factorization function called

b=eye(bus);                %creating an identity matrix  
x=zeros(bus,bus);

for n=1:bus
   x(:,n)= ForwardSub(L,b(:,n));  %forward substitution function called
end

Zbus=zeros(bus,bus);
for s=1:bus
   Zbus(:,s)=BackwardSub(U,x(:,s));  %backward substitution function called
end

%outputs
disp('nonzero entries of the 26th column')
for m=1:bus
    if Ybus(m,26)~=0
       disp(Ybus(m,26))      %displaying nonzero entries of the 26th column
    end
end
disp('first 5 entries of the 26th row')
disp(Zbus(26,1:5))    %%displaying first 5 entries of the 26th row
spy(Ybus)
