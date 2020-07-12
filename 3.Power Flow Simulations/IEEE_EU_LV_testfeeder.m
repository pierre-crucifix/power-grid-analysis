function mpc = IEEE_EU_LV_testfeeder
load('./data/Grid_topology/formatedLinesDataAC.mat')
load('./data/Grid_topology/formatedBussesData.mat')


%% MATPOWER Case Format : Version 2
mpc.version = '2';

%% system MVA base
mpc.baseMVA = 0.2;

%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus=Busses;

%% generator data
%	bus	Pg	Qg	Qmax Qmin   Vg	mBase status	Pmax Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
mpc.gen=zeros(112,21);
for i=1:size(mpc.gen,1)
    mpc.gen(i,1)=i;    
%    mpc.gen(i,8)=1;
end
mpc.gen(1,:)= [1 0 0 1e10 -1e10 1 0.25 1 1e10 -1e10 0 0 0 0 0 0 0 0 0 0 0];

%% Line data
mpc.branch=Lines;

end