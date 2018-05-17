clear, clc,close all;


basic_set = ["blue_6x2";"blue_2x1";"blue_car";"gray_26";"green_4x4";"red_8x4";"red_8x1";"white2x2";"yellow_10x1";"yellow_round"];
extended_set = ["beige_4x2";"beige_8x1";"orange_4x2";"orange_round";"Prop";"red_4x2";"red_round";"violet_4x2";"white_4x2";"yellow_4x2"];
label_library = [basic_set;extended_set];

lego_box_id= "1101";
lego_set_id ="1";
collumn_names_set="set_id";
ones=string(lego_set_id);
for i=1:length(label_library)
collumn_names_set=collumn_names_set+", "+label_library(i);
ones=ones +", 1";
end


prefs = setdbprefs('DataReturnFormat'); % Set preferences
setdbprefs('DataReturnFormat','table'); % Set preferences
conn = database('mysql-p4:europe-west1:lego-p4-db','root',''); % Make connection to database

sqlquery_fill_lego_set_id=sprintf('INSERT INTO legop4.lego_set_id_of_box_id(%s) VALUES (%s)','box_id, set_id','1101,1');
sqlquery_lego_set_parameters_of_set_id=sprintf('INSERT INTO legop4.lego_set_parameters_of_set_id(%s) VALUES (%s)',collumn_names_set,ones);


% curs = exec(conn,sqlquery_fill_lego_set_id)
curs = exec(conn,sqlquery_lego_set_parameters_of_set_id)
close(curs)
% ---------close----------------
close(conn) % Close connection to database
setdbprefs('DataReturnFormat',prefs) % Restore preferences
clear prefs conn curs % Clear variables