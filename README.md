node_beta
=========

Introduction
------------

Roadmap
-------
Account creation is working, just go on `http://localhost:1234/user/add`. 
The account will be stored in the database (LevelUP) in key, value format (key is the username, value is composed of the mail adress and the password). 

Password is encrypted using SHA256 algorithm.

------------------

Account login is working, `http://localhost:1234/login` interface will ask for a username and a password. If the authentication passes, the user is redirected to `http://localhost:1234/index`, otherwise he is redirected to an error page `http://localhost:1234/user/error`.

------------------

We can add some metrics using a form, `http://localhost:1234/data/add`.

------------------

Added bootstrap CSS to make it nicer.

------------------

Cookies are working !

------------------

The username is also saved when the user created a data.

------------------

Known issues:
The metrics module is disabled since it calls for the db module in addition to the use module. The application cannot start with this double request. 

Function access of metrics.coffee file is not working properly, only one result is pushed into the array, instead of several... This function returns a list of username based on a metric id.

Why timestamps have 13 digits in teachers example?

------------------

Licence & copyright
===================
Copyright Anthony MAROIS