CREATE TABLE City(
	cityid int PRIMARY KEY,
	name varchar(50)
);

CREATE TABLE Area(
	areaid int PRIMARY KEY,
	name varchar(50),
	cityid int FOREIGN KEY REFERENCES City(cityid)
);

CREATE TABLE Customer(
	customerid int PRIMARY KEY,
	name varchar(50),
	phonenumber varchar(50),
	address varchar(50),
	areaid int FOREIGN KEY REFERENCES Area(areaid)

);

CREATE TABLE Restaurant(
	restaurantid int PRIMARY KEY,
	name varchar(50)
);

CREATE TABLE Menu(
	menuid int PRIMARY KEY,
	name varchar(50),
	price int,
	restaurantid int FOREIGN KEY REFERENCES Restaurant(restaurantid)
);

CREATE TABLE DeliveryCompany(
	companyid int PRIMARY KEY,
	name varchar(50)
);

CREATE TABLE Contract(
	restaurantid int FOREIGN KEY REFERENCES Restaurant(restaurantid),
	companyid int FOREIGN KEY REFERENCES DeliveryCompany(companyid)
);

CREATE TABLE Vehicle(
	vehicleid int PRIMARY KEY,
	nameplate varchar(50)
);

CREATE TABLE Driver(
	driverid int PRIMARY KEY,
	name varchar(50),
	companyid int FOREIGN KEY REFERENCES DeliveryCompany(companyid),
	vehicleid int FOREIGN KEY REFERENCES Vehicle(vehicleid)
	
)

CREATE TABLE Orders(
	orderid int PRIMARY KEY,
	items varchar(200),
	restaurantid int FOREIGN KEY REFERENCES Restaurant(restaurantid),
	customerid int FOREIGN KEY REFERENCES Customer(customerid),
	driverid int FOREIGN KEY REFERENCES Driver(driverid)
);

ALTER TABLE Restaurant
ADD Postalcode int 

ALTER TABLE DeliveryCompany
ADD Postalcode int

INSERT INTO Vehicle VALUES(1,'CJ-60-DSD'),(2,'B-345-FJG'),(3,'CJ-54-FDF');
INSERT INTO DeliveryCompany VALUES('Glovo',34994),('FoodPanda',4343);
SELECT * FROM DeliveryCompany
INSERT INTO Driver VALUES(1,'Matei',4,1),(2,'Vlad',5,3);