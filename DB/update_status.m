%input: label_library predictor lego_box_id parameters_of_set
%output: status_of_set

function status_of_set = update_status(label_library,predictor,lego_box_id,parameters_of_set)

basic_set = ["blue_6x2";"blue_2x1";"blue_car";"gray_26";"green_4x4";"red_8x4";"red_8x1";"white2x2";"yellow_10x1";"yellow_round"];
extended_set = ["beige_4x2";"beige_8x1";"orange_4x2";"orange_round";"Prop";"red_4x2";"red_round";"violet_4x2";"white_4x2";"yellow_4x2"];
label_library = [basic_set;extended_set];

collumn_names_set="box_id"
zeros=string(lego_box_id);
for i=1:length(label_library)
collumn_names_set=collumn_names_set+", "+label_library(i);
zeros=zeros +", 0";
end

prefs = setdbprefs('DataReturnFormat'); % Set preferences
setdbprefs('DataReturnFormat','table'); % Set preferences
conn = database('mysql-p4:europe-west1:lego-p4-db','root',''); % Make connection to database

sqlquery_prepare_status=sprintf('INSERT INTO legop4.lego_box_status(%s) VALUES (%s)',collumn_names_set,zeros);
curs = exec(conn,sqlquery_prepare_status);

close(curs)
% ---------close----------------
close(conn) % Close connection to database
setdbprefs('DataReturnFormat',prefs) % Restore preferences
clear prefs conn curs % Clear variables


status_of_set=parameters_of_set;
used_bricks=[];
for i=1:length(predictor)
if sum(ismember(used_bricks,predictor(i))) == 0
amount_of_bricks=sum(ismember(predictor,predictor(i)));
used_bricks=[used_bricks,predictor(i)];
status_of_set(predictor(i))=amount_of_bricks-status_of_set(predictor(i));



prefs = setdbprefs('DataReturnFormat'); % Set preferences
setdbprefs('DataReturnFormat','table'); % Set preferences
conn = database('mysql-p4:europe-west1:lego-p4-db','root',''); % Make connection to database

sqlquery_update_status=sprintf('UPDATE legop4.lego_box_status SET %s = %d WHERE box_id = %d',label_library(predictor(i)),amount_of_bricks,lego_box_id);
curs = exec(conn,sqlquery_update_status);

close(curs)
% ---------close----------------
close(conn) % Close connection to database
setdbprefs('DataReturnFormat',prefs) % Restore preferences
clear prefs conn curs % Clear variables
end

end
end