#DATA CLEANING

show databases;

use hotel;
describe hotel_reservations;
select * from hotel_reservations;

#Adding and updating Month_name column by using condition 

	alter table hotel_reservations add column Month_name varchar(10);

	update hotel_reservations
		set Month_name= "January" where Arrival_Month =1;
	update hotel_reservations
		set Month_name= "February" where Arrival_Month =2;
	update hotel_reservations
		set Month_name= "March" where Arrival_Month =3;
	update hotel_reservations
		set Month_name= "April" where Arrival_Month =4;
	update hotel_reservations
		set Month_name= "May" where Arrival_Month =5;
	update hotel_reservations
		set Month_name= "June" where Arrival_Month =6;
	update hotel_reservations
		set Month_name= "July" where Arrival_Month =7;
	update hotel_reservations
		set Month_name= "August" where Arrival_Month =8;
	update hotel_reservations
		set Month_name= "September" where Arrival_Month =9;
	update hotel_reservations
		set Month_name= "October" where Arrival_Month =10;
	update hotel_reservations
		set Month_name= "November" where Arrival_Month =11;
	update hotel_reservations
		set Month_name= "December" where Arrival_Month =12;   

#Setting the Average price per room into Categories 
    
	Select Average_Price_per_Room ,
	   CASE When Average_Price_per_Room < 100 then "Room Price is below 100"
			When Average_Price_per_Room < 200 then "Room Price is below 200"
			When Average_Price_per_Room < 300 then "Room Price is below 300"
			When Average_Price_per_Room < 400 then "Room Price is below 400"
			When Average_Price_per_Room < 500 then "Room Price is below 500"
			When Average_Price_per_Room >= 500 then "Room Price is below 200" "Room Price is equal to or greater than 500"
			END as Price_Range
     from hotel_reservations ;  
     
	alter table hotel_reservations add Column Price_Range varchar (100);    

	update hotel_reservations 
		set Price_Range = CASE When Average_Price_per_Room < 100 then "Room Price is below 100"
			When Average_Price_per_Room < 200 then "Room Price is below 200"
			When Average_Price_per_Room < 300 then "Room Price is below 300"
			When Average_Price_per_Room < 400 then "Room Price is below 400"
			When Average_Price_per_Room < 500 then "Room Price is below 500"
			When Average_Price_per_Room >= 500 then "Room Price is below 200" "Room Price is equal to or greater than 500"
			END 
        
	
	alter table hotel_reservations Add column Total_guest int;
		update hotel_reservations
			set Total_guest = Adults_count + Children_count;
        
     
	Select distinct(Meal_Plan_Type) , count(Meal_Plan_Type) 
		from hotel_reservations
			Group by Meal_Plan_Type
				Order by 2;
            
	select distinct(Market_Segment_Type), count(Market_Segment_Type)
		from Hotel_reservations
			group by Market_Segment_Type
				Order by 2;
            
	Select * from hotel_info;     
	describe hotel_info;
	select Address from hotel_info;  


#Extracting only contact_no from Address column and not the pincode

	alter table hotel_info add column PH_no_unclean varchar(10);

	Select Address, 
		SUBSTRING_INDEX( Address, ' ', -1 ) as Phone_no
			from hotel_info;

	update hotel_info
		set PH_no_unclean = SUBSTRING_INDEX( Address, ' ', -1 ) ;  
    
	alter table hotel_info add column P_Position int;

	Select Address, PH_no_unclean,
		char_length(PH_no_unclean) as len
			from hotel_info;
        
	update hotel_info
		set P_Position = char_length(PH_no_unclean);

	alter table hotel_info add column Contact_no varchar(12);
	
	update hotel_info
		set Contact_no = PH_no_unclean where P_Position = 10;


#Extracting Number of reviews so it can be further used for comparison and analysis

	Alter table hotel_info add column Review_count int (10);
 
	select Reviews ,
		SUBSTRING_INDEX( Reviews, ' ', 1 ) as Review_count
			from hotel_info;
    
	Update hotel_info
		set Review_Count = Substring_index(Reviews, ' ', 1);   


#Extracting State Postal code from Address Column

	Alter table hotel_info add column State Varchar(3);

	select Address, 
		Substring( SUBSTRING_INDEX( Address, ' ', -2 ), 1, 2)
			from hotel_info;

	update Hotel_info
		set State = Substring( SUBSTRING_INDEX( Address, ' ', -2 ), 1, 2);

    
#Extracting Cities from Address Column

	Alter table hotel_info add column City varchar(25);

	Select Address, 
		Substring_index(SUBSTRING_INDEX( Address, ',', -2 ) ,',',1)
			from Hotel_info;

	Update hotel_info
		set City = Substring_index(SUBSTRING_INDEX( Address, ',', -2 ) ,',',1);
        

	alter table hotel_info
		drop column MyUnknownColumn;

	update hotel_info
		set Rating= NULL where Rating= "NA";
    
	update hotel_info
		set Review_Count = NULL where Review_Count= "NA";
    
    
	select i.`Hotel Name`, i.City, i.Rating, i.Review_Count, r.Average_Price_per_Room, r.Price_Range
		from Hotel_info i
			join hotel_reservations r
				on i.Booking_ID = r.Booking_ID
					order by Rating desc;

