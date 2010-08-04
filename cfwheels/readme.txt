1) Copy the config, controllers, models, and views over a fresh install of CFWheels http://cfwheels.org/
2) Move the \litepost\assets\images and \litepost\assets\css into their appropriate wheels locations
3) Copy \litepost\config\litepost-services.xml into the wheels' config folder
4) Download the Ioc Interface plugin http://cfwheels.org/plugins/listing/22 (and place the zip in wheels' plugin folder)
5) Download ColdSpring from http://coldspringframework.org/ (and put it in your wheels' miscellaneous folder along with create a /coldspring mapping to it).
6) Create a MySQL database and run litepost/db/blogTables.sql to set up your tables.
7) Configure a datasource called litepost pointing to your new database.