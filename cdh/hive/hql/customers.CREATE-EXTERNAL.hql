CREATE EXTERNAL TABLE user(id INT, name STRING) ROW FORMAT
              DELIMITED FIELDS TERMINATED BY ','
              LINES TERMINATED BY '\n' 
              STORED AS TEXTFILE
              LOCATION '/dev/customers/customers.csv';
