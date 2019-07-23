Use CarRentalDatabase;
/*
Eric Wedemire, Kellan St. Louis, Jonathan Ismail, Kunpeng Yin
Group Project; table generation
CMPT 291-OP01
Spring 2019
*/
drop table [Returns];	
drop table Rental_Transaction;
drop table Employee;
drop table Vehicle;
drop table Vehicle_type;
drop table Customer;
drop table Membership;
drop table Branch;

create table Branch (
	branch_id char(3) not null primary key,
	building_num varchar(10),
	street_name varchar(20),
	street_type varchar(10),
	city varchar(20),
	province varchar(2),
	post_code char(6),
	phone_num char(10)
	);

create table Employee (
	emp_id char(4) not null primary key,
	f_name varchar(20),
	l_name varchar(20),
	position char(15),
	hire_date date,
	hourly_wage int,
	branch_id char(3) foreign key references Branch(branch_id),
	branch_date date --date an employee moved to their current branch
	);

create table Vehicle_Type (
	[type_id] varchar(10) not null primary key,
	rental_fee money not null, --daily fee to rent type of vehicle
	return_fee money not null, --fee for return of vehicle to a different branch
	late_fee money not null, --fee for returning a vehicle late
	);

create table Vehicle (
	plate_num varchar(9) not null primary key,
	kms int,
	make varchar(15),
	model varchar(15),
	[year] int,
	colour varchar(15),
	condition int,
	/*
	 *condition of car from 1-5; 1=poor, 5=new. 
	 * SPECIAL CASES:
	 * 0 = "retired", vehicle has been removed from inventory
	 * 6 = "currently on rental"
	 */
	[type_id] varchar(10) foreign key references Vehicle_Type([type_id]),
	branch_id char(3) foreign key references Branch(branch_id)
	);

create table Membership (
	status_id varchar(10) not null primary key,
	pays_return_fee bit not null, --rule if return fees apply to a customer
	pays_late_fee bit not null --rule if late fees apply to a customer
	);

create table Customer (
	driver_num varchar(20) not null primary key,
	status_id varchar(10) foreign key references Membership(status_id),
	f_name varchar(20),
	l_name varchar(20),
	building_num varchar(10),
	street_name varchar(20),
	street_type varchar(10),
	city varchar(20),
	province varchar(2),
	post_code char(6),
	phone_num char(10),
	membership_date date, --date at which a customer gained their status
	join_date date --date on which a customer was added to the database
	);

create table Rental_Transaction (
	transaction_id char(10) not null primary key,
	/* 
	 * costs are stored as a contract between the customer and business to prevent issues if
	 * late or wrong branch return fees change after the time a customer picks up the car, to
	 * when they return it
	 */
	base_cost money not null, --cost for rental where [rental fee*days of rental]
	late_cost money not null, --possible fees for late vehicle return
	return_cost money not null, --possible fees for vehicle return to different branch
	check_out_date date not null,
	expected_return date not null,
	branch_id char(3) foreign key references Branch(branch_id),
	emp_id char(4) foreign key references Employee(emp_id),
	plate_num varchar(9) foreign key references Vehicle(plate_num),
	driver_num varchar(20) foreign key references Customer(driver_num)
	);

create table [Returns] (
	transaction_id char(10) not null primary key,
	emp_id char(4) foreign key references Employee(emp_id),
	branch_id char(3) foreign key references Branch(branch_id),
	return_date date not null,
	fees_paid money not null, --combination of late and return fees paid
	foreign key (transaction_id) references Rental_Transaction(transaction_id)
	);


/*--- Inserting Test Values ---*/

/*-Branches-*/
insert into Branch values ('001', '34', 'Pine', 'Drive', 'Edmonton', 'AB', 'T6J9G4', '7801234567');
insert into Branch values ('002', '1', 'Wellington', 'Street', 'Ottawa', 'ON', 'K1A0A9', '6134686368');
insert into Branch values ('003', '160', 'Hastings', 'Street', 'Vancounver', 'BC', 'V6A1N4', '6046817435');

/*-Employees-*/
insert into Employee values ('0001', 'Jimmy', 'Woods', 'Manager', TRY_CONVERT(DATE, '1998-02-15'), 25, '003', TRY_CONVERT(DATE, '1998.02.15') );
insert into Employee values ('0002', 'Hubert', 'Granville', 'Manager', TRY_CONVERT(DATE, '2001-07-27'), 26, '002', TRY_CONVERT(DATE, '2005-03-19') );
insert into Employee values ('0003', 'Michael', 'Colahan', 'Assist. Man', TRY_CONVERT(DATE, '2001-10-22'), 32, '001', TRY_CONVERT(DATE, '2002-01-01') );
insert into Employee values ('0004', 'Katelyn', 'White', 'Assist. Man', TRY_CONVERT(DATE, '2003-12-24'), 26, '003', TRY_CONVERT(DATE, '2009-06-19') );
insert into Employee values ('0005', 'Caitlyn', 'Black', 'Sales Assoc.', TRY_CONVERT(DATE, '2006-11-01'), 19, '002', TRY_CONVERT(DATE, '2006-11-01') );
insert into Employee values ('0006', 'Kellan', 'St. Louis', 'Sales Assoc.', TRY_CONVERT(DATE, '2006-11-02'), 19, '001', TRY_CONVERT(DATE, '2014-10-09') );
insert into Employee values ('0007', 'Eric', 'Wedemire', 'Sales Assoc.', TRY_CONVERT(DATE, '2007-07-07'), 18, '001', TRY_CONVERT(DATE, '2007-07-07') );
insert into Employee values ('0008', 'Jonathan', 'Ismail', 'Sales Assoc.', TRY_CONVERT(DATE, '2007-08-08'), 19, '001', TRY_CONVERT(DATE, '2010-11-12') );
insert into Employee values ('0009', 'Yusef', 'Mohammad', 'Assist. Man', TRY_CONVERT(DATE, '2010-09-21'), 25, '002', TRY_CONVERT(DATE, '2017-02-02') );
insert into Employee values ('0010', 'Kunpeng', 'Yin', 'Manager', TRY_CONVERT(DATE, '2012-12-12'), 33, '001', TRY_CONVERT(DATE, '2019-04-01') );
insert into Employee values ('0011', 'Jennifer', 'Smith', 'Sales Assoc.', TRY_CONVERT(DATE, '2013-10-14'), 19, '003', TRY_CONVERT(DATE, '2013-10-14') );
insert into Employee values ('0012', 'Gregory', 'Greenview', 'Sales Assoc.', TRY_CONVERT(DATE, '2014-03-26'), 18, '002', TRY_CONVERT(DATE, '2014-03-26') );
insert into Employee values ('0013', 'Tina', 'Kronk', 'Sales Assoc.', TRY_CONVERT(DATE, '2015-05-15'), 19, '002', TRY_CONVERT(DATE, '2015-05-15') );
insert into Employee values ('0014', 'Ghulam', 'Abbas', 'Sales Assoc.', TRY_CONVERT(DATE, '2018-07-27'), 19, '002', TRY_CONVERT(DATE, '2018-07-27') );
insert into Employee values ('0015', 'Pepper', 'Blackburn', 'Sales Assoc.', TRY_CONVERT(DATE, '2018-01-30'), 18, '003', TRY_CONVERT(DATE, '2019-01-30') );

/*-Membership-*/
insert into Membership values('GOLD', 'False', 'False');
insert into Membership values('BRONZE', 'True', 'True');

/*-Customers-*/
insert into Customer values('049230076', 'BRONZE', 'Emma', 'Morgan', null, null, null, null, null, 'T9K2Y1', null, null, null);
insert into Customer values('748282072', 'BRONZE', null, null, null, null, null, null, null, 'T9K2Y2', null, null, null);
insert into Customer values('464157071', 'BRONZE', null, null, null, null, null, null, null, 'T9K2Y3', null, null, null);
insert into Customer values('105643607', 'BRONZE', null, null, null, null, null, null, null, 'T9K2Y4', null, null, null);
insert into Customer values('876604387', 'BRONZE', null, null, null, null, null, null, null, 'T9K2Y5', null, null, null);
insert into Customer values('055656235', 'BRONZE', null, null, null, null, null, null, null, 'T9K2Y6', null, null, null);
insert into Customer values('957367921', 'GOLD', null, null, null, null, null, null, null, 'T9K2Y7', null, null, null);
insert into Customer values('121367896', 'GOLD', null, null, null, null, null, null, null, 'T9K2Y1', null, null, null);
insert into Customer values('937743227', 'BRONZE', null, null, null, null, null, null, null, 'T9H2Y2', null, null, null);
insert into Customer values('117114861', 'BRONZE', null, null, null, null, null, null, null, 'T9H2Y3', null, null, null);
insert into Customer values('267285610', 'BRONZE', null, null, null, null, null, null, null, 'T9H2Y4', null, null, null);
insert into Customer values('436950582', 'BRONZE', null, null, null, null, null, null, null, 'T9H2Y5', null, null, null);
insert into Customer values('913716688', 'BRONZE', null, null, null, null, null, null, null, 'T9H2Y6', null, null, null);
insert into Customer values('344696433', 'BRONZE', null, null, null, null, null, null, null, 'T9H2Y7', null, null, null);
insert into Customer values('979761945', 'GOLD', null, null, null, null, null, null, null, 'C9H2Y8', null, null, null);
insert into Customer values('367170395', 'BRONZE', null, null, null, null, null, null, null, 'C9H2Y9', null, null, null);
insert into Customer values('418178343', 'BRONZE', null, null, null, null, null, null, null, 'C9K2Y1', null, null, null);
insert into Customer values('972786909', 'BRONZE', null, null, null, null, null, null, null, 'C9K2Y2', null, null, null);
insert into Customer values('986178588', 'BRONZE', null, null, null, null, null, null, null, 'C9K2Y3', null, null, null);
insert into Customer values('682064765', 'BRONZE', null, null, null, null, null, null, null, 'C9K2Y4', null, null, null);
insert into Customer values('959759006', 'BRONZE', null, null, null, null, null, null, null, 'C9K2Y5', null, null, null);
insert into Customer values('857708371', 'BRONZE', null, null, null, null, null, null, null, 'C9K2Y6', null, null, null);
insert into Customer values('111111111', 'BRONZE', null, null, null, null, null, null, null, 'C9K2Y7', null, null, null);
insert into Customer values('222222222', 'BRONZE', null, null, null, null, null, null, null, 'C9K2Y8', null, null, null);
insert into Customer values('333333333', 'BRONZE', null, null, null, null, null, null, null, 'V5Y4S1', null, null, null);
insert into Customer values('444444444', 'BRONZE', null, null, null, null, null, null, null, 'V5Y4S2', null, null, null);
insert into Customer values('555555555', 'BRONZE', null, null, null, null, null, null, null, 'V5Y4S3', null, null, null);
insert into Customer values('666666666', 'GOLD', null, null, null, null, null, null, null, 'V5Y4S4', null, null, null);
insert into Customer values('777777777', 'BRONZE', null, null, null, null, null, null, null, 'V5Y4S5', null, null, null);
insert into Customer values('888888888', 'BRONZE', null, null, null, null, null, null, null, 'V5Y4S6', null, null, null);
insert into Customer values('999999999', 'BRONZE', null, null, null, null, null, null, null, 'V5Y4S7', null, null, null);
insert into Customer values('000000000', 'BRONZE', null, null, null, null, null, null, null, 'V5Y4S8', null, null, null);

/*-Vehicle Types-*/
insert into Vehicle_Type values('COMPACT', 50, 50, 45);
insert into Vehicle_Type values('MIDSIZE', 65, 55, 50);
insert into Vehicle_Type values('FULLSIZE', 75, 60, 55);

/*-Vehicles-*/
insert into Vehicle values('BGY6789', 100000, 'toyota', 'yaris', 2011, 'white', 5, 'COMPACT', '001');
insert into Vehicle values('YRA9910', 85000, 'honda', 'civic', 2012, 'grey', 4, 'MIDSIZE', '001');
insert into Vehicle values('GRE1303', 90000, 'chevy', 'silverado', 2013, 'blue', 4, 'FULLSIZE', '001');
insert into Vehicle values('RTH7743', 97000, 'toyota', 'yaris', 2010, 'red', 5, 'COMPACT', '002');
insert into Vehicle values('FFJ1234', 50000, 'honda', 'civic', 2014, 'white', 4, 'MIDSIZE', '002');
insert into Vehicle values('BAD9999', 75000, 'chevy', 'silverado', 2013, 'black', 5, 'FULLSIZE', '002');
insert into Vehicle values('QWE1209', 100000, 'toyota', 'yaris', 2009, 'yellow', 5, 'COMPACT', '003');
insert into Vehicle values('DOI7865', 67000, 'honda', 'civic', 2014, 'black', 4, 'MIDSIZE', '003');
insert into Vehicle values('EDC3196', 14000, 'chevy', 'silverado', 2019, 'grey', 5, 'FULLSIZE', '003');

insert into Rental_Transaction values ('0000000000',20,10,10,TRY_CONVERT(DATE, '2018-01-30'),TRY_CONVERT(DATE, '2018-01-31'),'001','0001','YRA9910','682064765');
insert into Rental_Transaction values ('0000000001',20,10,10,TRY_CONVERT(DATE, '2018-01-30'),TRY_CONVERT(DATE, '2018-01-31'),'001','0001','YRA9910','999999999');
insert into Rental_Transaction values ('0000000002',20,10,10,TRY_CONVERT(DATE, '2018-01-30'),TRY_CONVERT(DATE, '2018-01-31'),'001','0001','YRA9910','999999999');
insert into Rental_Transaction values ('0000000003',20,10,10,TRY_CONVERT(DATE, '2018-01-30'),TRY_CONVERT(DATE, '2018-01-31'),'001','0001','YRA9910','999999999');
insert into Rental_Transaction values ('0000000004',20,10,10,TRY_CONVERT(DATE, '2018-01-30'),TRY_CONVERT(DATE, '2018-01-31'),'001','0001','YRA9910','000000000');
insert into Rental_Transaction values ('0000000005',20,10,10,TRY_CONVERT(DATE, '2018-01-30'),TRY_CONVERT(DATE, '2018-01-31'),'001','0001','YRA9910','000000000');

insert into [Returns] values ('0000000001','0001','001',TRY_CONVERT(DATE, '2018-01-31'),10);
insert into [Returns] values ('0000000002','0001','001',TRY_CONVERT(DATE, '2018-01-31'),10);

--select * from Rental_Transaction RT left join [Returns] R on RT.transaction_id=R.transaction_id;

--select * from Customer where status_id = 'BRONZE' 
--customers acquired in certain time frame as of at least one reservation