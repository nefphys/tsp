%% 给定城市数据 生成ans_group 数据集
function stdstr = City2Group(Tity)
    ans_group = {};
    stdstr.inID = 0;
    stdstr.outID = 0;
    stdstr.set = 0;
    stdstr.isover = 1;
    stdstr.tsp = 0;
    stdstr.order = "";
    stdstr.gdist = 0;
    for i = 1:size(Tity, 1)
        stdstr(i).inID = i;
        stdstr(i).outID = i;
        stdstr(i).set = i;
        stdstr(i).isover = 1;
        stdstr(i).tsp = i;
        stdstr(i).order = "001001" + "002" + num2str(i, '%03d') + "003001";
        stdstr(i).gdist = 0;
    end
end