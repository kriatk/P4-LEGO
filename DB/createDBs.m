clc,clear all, close all;
basic_set = ["blue_6x2";"blue_2x1";"blue_car";"gray_26";"green_4x4";"red_8x4";"red_8x1";"white2x2";"yellow_10x1";"yellow_round"];
extended_set = ["beige_4x2";"beige_8x1";"orange_4x2";"orange_round";"Prop";"red_4x2";"red_round";"violet_4x2";"white_4x2";"yellow_4x2"];
label_library = [basic_set;extended_set];

collumn_names_box="box_id int"
for i=1:length(label_library)
collumn_names_box=collumn_names_box +", "+label_library(i)+" int";
end


collumn_names_set="set_id int"
for i=1:length(label_library)
collumn_names_set=collumn_names_set+", "+label_library(i)+" int";
end

%% create DBs
% Truth table
prefs = setdbprefs('DataReturnFormat'); % Set preferences
setdbprefs('DataReturnFormat','table'); % Set preferences
conn = database('mysql-p4:europe-west1:lego-p4-db','root',''); % Make connection to database

% lego_set_id_of_box_id
sqlquery_lego_set_id_of_box_id='CREATE TABLE if not exists legop4.lego_set_id_of_box_id(box_id bigint,set_id int)';
% lego_set_parameters_of_set_id
sqlquery_lego_set_parameters_of_set_id=sprintf('CREATE TABLE if not exists legop4.lego_set_parameters_of_set_id(%s)',collumn_names_set);
sqlquery_lego_box_status=sprintf('CREATE TABLE if not exists legop4.lego_box_status(%s)',collumn_names_box);


% curs = exec(conn,sqlquery_lego_set_id_of_box_id)
curs = exec(conn,sqlquery_lego_set_parameters_of_set_id);
% curs = exec(conn,sqlquery_lego_box_status);

% curs = fetch(curs);
% DATA = curs.Data;


% curs = exec(conn,'DROP TABLE legop4.lego_set_id_of_box_id');
% curs = exec(conn,'DROP TABLE legop4.lego_set_parameters_of_set_id');
% curs = exec(conn,'DROP TABLE legop4.lego_box_status');

close(curs)
dbmeta = dmd(conn)
t = tables(dbmeta,'legop4')


close(conn) % Close connection to database
setdbprefs('DataReturnFormat',prefs) % Restore preferences
clear prefs conn curs % Clear variables

%%