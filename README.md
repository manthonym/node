node_beta
=========

Introduction
------------

The first step to use this application is account creation: just go on `http://localhost:1234/` and follow indications.
You will be asked to choose a username, a mail adress and a password. 
All your information will be stored in the LevelDB database (key, value format) using SHA256 encryption algorithm. 
You will be log for 30 minutes

Now you can login by going again on `http://localhost:1234/` and create your first metric, by clicking on the Add metric button.
Again, information will be stored in the same database.
Please use a standard timestamp format (10 digits).

Now you can display your graph.

Note that multiple users can add different metrics with the same ID. Each of them will be able to display the graph.

Licence & copyright
===================
Copyright BenoitJARLIER, Guillaume MAMESSIER, Anthony MAROIS.