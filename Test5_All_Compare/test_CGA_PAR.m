tarTsp = dir("data");
tarTsp = tarTsp(3:end);

%CGA 参数
tpath = tarTsp(47).folder;
tspData = [tpath '\' tarTsp(47).name];
[Distance,City] = readfile(tspData,1);


Ctime = [];
parfor i = 1:20
    i
    %City = rand(i*10,2);
    varargin = struct('xy',City, 'popSize', 100, 'numIter', 1e2);
    CGA_TSP_Solve_Struct = CGA_Solver(varargin);
    Ctime(i) = CGA_TSP_Solve_Struct.time;
end
x1 = (1:20) * 10;
y1 = Ctime;


x = 1000
p1 =   2.722e-06 
p2 =    0.000886 
p3 =      0.0219 
p4 =     0.09357 
p1*x^3 + p2*x^2 + p3*x + p4

varargin = struct('xy',City, 'popSize', 100, 'numIter', 1e2);
CGA_TSP_Solve_Struct = CGA_Solver(varargin);