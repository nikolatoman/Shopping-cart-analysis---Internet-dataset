data transactional_data;
set dm1.raw_data;

array n{*} _NUMERIC_;
    do i = 2 to dim(n);
    if (n{i}=1) then Sport = vname(n{i});
    if (n{i}=1) then output;
    end;
keep ID Sport;
run;