%input lego_box_id
%output lego_set_id
function lego_set_id = read_set_id(lego_box_id)

prefs = setdbprefs('DataReturnFormat'); % Set preferences
setdbprefs('DataReturnFormat','table'); % Set preferences
conn = database('mysql-p4:europe-west1:lego-p4-db','root',''); % Make connection to database

% lego_set_id_of_box_id
sqlquery_lego_set_id_of_box_id=sprintf('SELECT set_id FROM legop4.lego_set_id_of_box_id WHERE box_id=%d',lego_box_id)
curs = exec(conn,sqlquery_lego_set_id_of_box_id);

curs = fetch(curs);
lego_set_id = table2array(curs.Data);
close(curs)
% ---------close----------------
close(conn) % Close connection to database
setdbprefs('DataReturnFormat',prefs) % Restore preferences
clear prefs conn curs % Clear variables
end