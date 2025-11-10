drop table if exists dim_vehicle cascade;
create table dim_vehicle (
    vehicle_id serial primary key,
    vehicle_type text,
    model text,
    plate_no text
  );


drop table if exists dim_driver cascade;
create table dim_driver (
    driver_id serial primary key,
    driver_name text,
    born date
  );  

  
drop table if exists dim_street cascade;
create table dim_street (
    street_id serial primary key,
    street_name text,
    distance float
  );

  
drop table if exists dim_location cascade;
create table dim_location (
    location_id serial primary key,
    location_name text,
    latitude float,
    longitude float,
    street_id int,
    foreign key (street_id) references dim_street(street_id)
  );


drop table if exists fact_trip cascade;
create table fact_trip (
    trip_id serial primary key,
    vehicle_id int,        
    foreign key (vehicle_id) references dim_vehicle(vehicle_id),
    driver_id int, 
    foreign key (driver_id) references dim_driver(driver_id),
    location_id int,
    foreign key (location_id) references dim_location(location_id),
    speed float,
    ts timestamp
);


drop table if exists fact_city_map cascade;
create table fact_city_map (
    map_id serial primary key,
    street1 int,
    foreign key (street1) references dim_street(street_id),
    street2 int,
    foreign key (street2) references dim_street(street_id)
);

