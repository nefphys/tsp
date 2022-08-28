%ans_mean
ans_mean.length = 0;
ans_mean.time = 0;
ans_mean.Imp = 0;

for i = 1:length(ans_str)
    ans_mean(i).length = mean(ans_str(i).length, 2);
    ans_mean(i).time = mean(ans_str(i).time, 2);
    ans_mean(i).Imp = mean(ans_str(i).Imp, 2);
end

ans_length = zeros(8,15);
for i = 1:15
    ans_length(:,i) = ans_mean(i).length;
end

for i = 1:8
    ans_length(i,:) = (ans_length(i,:) - min(ans_length(i,:))) / ...
        (max(ans_length(i,:)) - min(ans_length(i,:)));
end



ans_Imp = zeros(8,15);
for i = 1:15
    ans_Imp(:,i) = ans_mean(i).Imp;
end

for i = 1:8
    ans_Imp(i,:) = (ans_Imp(i,:) - min(ans_Imp(i,:))) / ...
        (max(ans_Imp(i,:)) - min(ans_Imp(i,:)));
end



ans_Time = zeros(8,15);
for i = 1:15
    ans_Time(:,i) = ans_mean(i).time;
end

for i = 1:8
    ans_Time(i,:) = (ans_Time(i,:) - min(ans_Time(i,:))) / ...
        (max(ans_Time(i,:)) - min(ans_Time(i,:)));
end

