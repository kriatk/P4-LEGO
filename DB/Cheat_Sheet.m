for set_id of box_id
SELECT set_id FROM legop4.set_of_box WHERE box_id=%d;


%for set_parameters of set_id:
SELECT * FROM legop4.parameters_of_set WHERE set_id=%d

%to insert 0 for all bricks before update:
collumn_names="box_id"
for i=1:length(label_library)
collumn_names=collumn_names+', '+label_library(i)
end

INSERT INTO legop4.parameters_of_box (box_id, brickname1, brickname2, ...) VALUES (box_id, 0, 0, ...);

%to update amount of bricks in DB
used_bricks=[]
for i=1:length(predictor)
if sum(ismember(used_bricks,predictor(i))) == 0
amount_of_bricks=sum(ismember(predictor,predictor(i)))
used_bricks=[used_bricks,predictor(i)]
used_bricks

'UPDATE legop4.parameters_of_box SET %s = %d WHERE box_id = %d';

end

end