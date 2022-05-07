-- Write a query to find what is the total business done by each store.

select st.store_id, sum(p.amount) as total_amount
from staff st
left join payment p
on p.staff_id = st.staff_id
group by store_id;


-- Use a stored procedure to execute the query.
DELIMITER //
create procedure store_income(in storeid int, out total_b float)
begin
#declare total_amount float default 0.0;

select st.store_id, sum(p.amount) as total_amount
from staff st
left join payment p
on p.staff_id = st.staff_id
where st.store_id = storeid;

select total_amount into total_b;
end;
//
delimiter ;

call store_income (2, @total_b);


-- Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). Call the stored procedure and print the results.
DELIMITER //
create procedure store_income2(in storeid int, out total_b float)
begin
declare total_sales_value float default 0.0;

select st.store_id, sum(p.amount) as total_amount
from staff st
left join payment p
on p.staff_id = st.staff_id
where st.store_id = storeid;

#select total_amount into total_b;
set total_sales_value = total_b;
end;
//
delimiter ;

call store_income2 (2, @total_b);

-- In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.
drop procedure if exists store_income4;
DELIMITER //
create procedure store_income4(in storeid int, out total_b float, out par3 varchar(20))
begin
-- declare total_sales_value float default 0.0;
declare flag varchar(20) default "";

select sum(p.amount) INTO total_b
from staff st
left join payment p
on p.staff_id = st.staff_id
where st.store_id = storeid;

if total_b > 30.000
	then set flag ='green_flag';
else 
	set flag = 'red flag';
 end if;

 select flag into par3;
 
end;
//
delimiter ;

call store_income4 (2, @total_b, @par3);

select @total_b, @par3;