# DBMS
Lab 1

Create a C# Windows Forms application that uses ADO.NET to interact
with the database you developed in the 1st semester. The application
must contain a form allowing the user to manipulate data in 2 tables that
are in a 1:n relationship (parent table and child table). The application
must provide the following functionalities:
- display all the records in the parent table;
- display the child records for a specific (i.e., selected) parent record;
- add / remove / update child records for a specific parent record.
You must use the DataSet and SqlDataAdapter classes. You are free to
use any controls on the form.

Lab 3

-create a stored procedure that inserts data in tables that are in a m:n relationship; if one insert fails, all the operations performed by the procedure must be rolled back (grade 3);
-create a stored procedure that inserts data in tables that are in a m:n relationship; if an insert fails, try to recover as much as possible from the entire operation: for example, if the user wants to add a book and its authors, succeeds creating the authors, but fails with the book, the authors should remain in the database (grade 5);
-create 4 scenarios that reproduce the following concurrency issues under pessimistic isolation levels: dirty reads, non-repeatable reads, phantom reads, and a deadlock; you can use stored procedures and / or stand-alone queries; find solutions to solve / workaround the concurrency issues (grade 9);
-create a scenario that reproduces the update conflict under an optimistic isolation level (grade 10).
