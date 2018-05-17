% input: lego_set_id
% output: parameters_of_set

function parameters_of_set = parameters_of_set_id(lego_set_id)

prefs = setdbprefs('DataReturnFormat'); % Set preferences
setdbprefs('DataReturnFormat','table'); % Set preferences
conn = database('mysql-p4:europe-west1:lego-p4-db','root',''); % Make connection to database

% lego_set_id_of_box_id
sqlquery_lego_set_id_of_box_id=sprintf('SELECT * FROM legop4.parameters_of_set WHERE set_id=%d',lego_set_id)
curs = exec(conn,sqlquery_lego_set_id_of_box_id);

curs = fetch(curs);
parameters_of_set = curs.Data;
close(curs)
% ---------close----------------
close(conn) % Close connection to database
setdbprefs('DataReturnFormat',prefs) % Restore preferences
clear prefs conn curs % Clear variables
end