%%Queueing Theory
%% M/M/1/\inffy
%Exponential Distribution Create: exprnd
ClientArriveSpeed = 1.0;
ServerDealSpeed = 3.0;
SimulateNum = 1000000;

ClientArriveInterval = exprnd(1/ClientArriveSpeed,SimulateNum,1);%Client(i) Arrive time - Client(i-1) Arrive time
ClientArriveTime = cumsum( ClientArriveInterval );
ServerFinishInterval = exprnd(1/ServerDealSpeed,SimulateNum,1);% Client(i) in Service time

Time = zeros(2*SimulateNum,1);
InService = Time;
FinishService = Time;
Record = struct('time',Time,'Queue',InService,'FinNum',FinishService);

Record.time(1) = ClientArriveTime(1);
Record.Queue(1) = 1;
Record.FinNum(1) = 0;
NextFinTime = ClientArriveTime(1)+ServerFinishInterval(1);

m=1;
while( Record.FinNum(m) < SimulateNum )
	m = m+1;
	LastFinishNum = Record.FinNum(m-1);
	LastQueueNum = Record.Queue(m-1);
	NextInNum = LastFinishNum + LastQueueNum +1;
	if LastQueueNum == 0
		Record.time(m) = ClientArriveTime(LastFinishNum+1);
		Record.Queue(m) = 1;
		Record.FinNum(m) = Record.FinNum(m-1);
		NextFinTime = Record.time(m) + ServerFinishInterval(LastFinishNum+1);
	else
		if (NextInNum > SimulateNum) || (NextFinTime < ClientArriveTime(NextInNum))
			Record.time(m) = NextFinTime;
			Record.Queue(m) = Record.Queue(m-1)-1;
			Record.FinNum(m) = Record.FinNum(m-1)+1;
			if Record.Queue(m) ~=0
				NextFinTime = Record.time(m)+ServerFinishInterval(Record.FinNum(m)+1);
			end
		else
			Record.time(m) = ClientArriveTime(NextInNum);
			Record.Queue(m) = Record.Queue(m-1)+1;
			Record.FinNum(m) = Record.FinNum(m-1);
		end
	end
end

FinTime = ClientArriveTime(SimulateNum-10);
fin = find( Record.time > FinTime,1 );
NewRecord = struct('time',Record.time(1:fin),'Queue',Record.Queue(1:fin),'FinNum',Record.FinNum(1:fin));
Interval = Record.time(2:(fin+1))-Record.time(1:fin);
Length = sum(Interval .* NewRecord.Queue)/Record.time(fin);

ClientServiceStart = ClientArriveTime;
num=1;
for m = 1:SimulateNum*2
    if (Record.FinNum(m) == num-1) && (Record.Queue(m) > 0)
        ClientServiceStart(num) = Record.time(m);
        num = num+1;
    end
end
WaitTime = ClientServiceStart(1:SimulateNum) - ClientArriveTime;
WaitMean = mean(WaitTime);

%% M/M/c/m
