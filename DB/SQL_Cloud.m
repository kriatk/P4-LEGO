clear all; close all; clc;

% ---------Install and do the following to use this script--------------
%You will need to login to GoogleCloud with: "root" , "lucais1234" and add
%your IP to the whitelist (AAU is already added)
%Install ODBC Data Sources (driver)
%Install "Database Explorer" => Configure ODBC data source
%User DSN => Add => MySQL ODBC 8.0 ANSI Driver
%Use: mysql-p4:europe-west1:lego-p4-db , 104.155.27.17 , 3306 ,root , lucais1234
%Now you should be able to run the script and fetch the data.
%database is called legop4 and cloud project is called lego-p4-db
%run in cmd to access database: mysql -uroot -plucais1234 -h104.155.27.17 -P3306 legop4

%% -------------Fetch tables---------------
% Truth table
prefs = setdbprefs('DataReturnFormat'); % Set preferences
setdbprefs('DataReturnFormat','table'); % Set preferences
conn = database('mysql-p4:europe-west1:lego-p4-db','root',''); % Make connection to database
%selectquery = 'SELECT * FROM legop4.lego_set_truth';
%deletequery = 'DELETE * FROM legop4.lego_set_truth WHERE set_id = ...';
curs = exec(conn,['SELECT * ' ...
    'FROM legop4.lego_set_truth']);

dbmeta = dmd(conn)
t = tables(dbmeta,'legop4')

curs = fetch(curs);
data_truth = curs.Data;
close(curs)
% Detected table
curs = exec(conn,['SELECT * ' ...
    'FROM legop4.lego_set_detected']);
curs = fetch(curs);
data_fetched = curs.Data;
close(curs)
% ---------close----------------
close(conn) % Close connection to database
setdbprefs('DataReturnFormat',prefs) % Restore preferences
clear prefs conn curs % Clear variables

%% ----------Update detected table with entries and compare------------
prefs = setdbprefs('DataReturnFormat'); % Set preferences
setdbprefs('DataReturnFormat','table'); % Set preferences
conn = database('mysql-p4:europe-west1:lego-p4-db','root','');
colnames = {'box_id','set_id','blue_med','blue_small','car','gray','green_plate',...
    'red','red_long','white','yellow_long','yellow_round','time_stamp'};
data = {1,1,1,1,1,1,1,1,1,1,1,1,'2018-05-18'};
tablename = 'legop4.lego_set_detected';
whereclause = {'WHERE ROWNUM == 0'};
update(conn,tablename,colnames,table(data),char(whereclause));
close(conn);

% ---------close---------------- DO THIS EVERYTIME
close(conn) % Close connection to database
setdbprefs('DataReturnFormat',prefs) % Restore preferences
clear prefs conn curs % Clear variables
