node_beta
=========

Introduction
------------

Roadmap
-------
Account creation is working, just go on `http://localhost:1234/user/add`. 
The account will be stored in the database (LevelUP) in key, value format (key is the username, value is composed of the mail adress and the password). For now, the password is stored in clear text in the database.

------------------

Account login is working, `http://localhost:1234/login` interface will ask for a username and a password. If the authentication passes, the user is redirected to `http://localhost:1234/index`, otherwise he is redirected to an error page `http://localhost:1234/user/error`.

------------------

Known issues:
The metrics module is disabled since it calls for the db module in addition to the use module. The application cannot start with this double request. 

------------------

Licence & copyright
===================
Copyright Anthony MAROIS