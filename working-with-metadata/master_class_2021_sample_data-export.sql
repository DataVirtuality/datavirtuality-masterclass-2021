/* Data Virtuality exported objects */
/* Created: 08.06.21  14:19:11.808 */
/* Server version: 2.4.6 */
/* Build: ce8ff20 */
/* Build date: 2021-05-28 */
/* Exported by Studio ver.2.4.6 (rev.cb1b700). Build date is 2021-05-28. */
/* Please set statement separator to ;; before importing */




/* Exported virtual schemas */
EXEC SYSADMIN.createVirtualSchema("name" => 'master_class_2021_sample_data') ;;

EXEC SYSADMIN.importView("text" => 'CREATE VIEW "master_class_2021_sample_data"."HumanResources_vEmployee" 
AS 
SELECT 
    e.BusinessEntityID
    ,p.Title
    ,p.FirstName
    ,p.MiddleName
    ,p.LastName
    ,p.Suffix
    ,e.JobTitle  
    ,pp.PhoneNumber
    ,pnt.Name AS PhoneNumberType
    ,ea.EmailAddress
    ,p.EmailPromotion
    ,a.AddressLine1
    ,a.AddressLine2
    ,a.City
    ,sp.Name AS StateProvinceName 
    ,a.PostalCode
    ,cr.Name AS CountryRegionName 
    ,p.AdditionalContactInfo
FROM mssql_advworks_2019.AdventureWorks2019.HumanResources.Employee e
	INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.Person p
	ON p.BusinessEntityID = e.BusinessEntityID
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.BusinessEntityAddress bea 
    ON bea.BusinessEntityID = e.BusinessEntityID 
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.Address a 
    ON a.AddressID = bea.AddressID
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.StateProvince sp 
    ON sp.StateProvinceID = a.StateProvinceID
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.CountryRegion cr 
    ON cr.CountryRegionCode = sp.CountryRegionCode
    LEFT OUTER JOIN mssql_advworks_2019.AdventureWorks2019.Person.PersonPhone pp
    ON pp.BusinessEntityID = p.BusinessEntityID
    LEFT OUTER JOIN mssql_advworks_2019.AdventureWorks2019.Person.PhoneNumberType pnt
    ON pp.PhoneNumberTypeID = pnt.PhoneNumberTypeID
    LEFT OUTER JOIN mssql_advworks_2019.AdventureWorks2019.Person.EmailAddress ea
    ON p.BusinessEntityID = ea.BusinessEntityID') ;;

EXEC SYSADMIN.importView("text" => 'CREATE VIEW "master_class_2021_sample_data"."HumanResources_vEmployeeDepartment" 
AS 
SELECT 
    e.BusinessEntityID 
    ,p.Title 
    ,p.FirstName 
    ,p.MiddleName 
    ,p.LastName 
    ,p.Suffix 
    ,e.JobTitle
    ,d.Name AS Department 
    ,d.GroupName 
    ,edh.StartDate 
FROM mssql_advworks_2019.AdventureWorks2019.HumanResources.Employee e
	INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.Person p
	ON p.BusinessEntityID = e.BusinessEntityID
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.HumanResources.EmployeeDepartmentHistory edh 
    ON e.BusinessEntityID = edh.BusinessEntityID 
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.HumanResources.Department d 
    ON edh.DepartmentID = d.DepartmentID 
WHERE edh.EndDate IS NULL') ;;

EXEC SYSADMIN.importView("text" => 'CREATE VIEW "master_class_2021_sample_data"."HumanResources_vEmployeeDepartmentHistory" 
AS 
SELECT 
    e.BusinessEntityID 
    ,p.Title 
    ,p.FirstName 
    ,p.MiddleName 
    ,p.LastName 
    ,p.Suffix 
    ,s.Name AS Shift
    ,d.Name AS Department 
    ,d.GroupName 
    ,edh.StartDate 
    ,edh.EndDate
FROM mssql_advworks_2019.AdventureWorks2019.HumanResources.Employee e
	INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.Person p
	ON p.BusinessEntityID = e.BusinessEntityID
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.HumanResources.EmployeeDepartmentHistory edh 
    ON e.BusinessEntityID = edh.BusinessEntityID 
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.HumanResources.Department d 
    ON edh.DepartmentID = d.DepartmentID 
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.HumanResources.Shift s
    ON s.ShiftID = edh.ShiftID') ;;

EXEC SYSADMIN.importView("text" => 'CREATE VIEW "master_class_2021_sample_data"."Person_vStateProvinceCountryRegion" 
AS 
SELECT 
    sp.StateProvinceID 
    ,sp.StateProvinceCode 
    ,sp.IsOnlyStateProvinceFlag 
    ,sp.Name AS StateProvinceName 
    ,sp.TerritoryID 
    ,cr.CountryRegionCode 
    ,cr.Name AS CountryRegionName
FROM mssql_advworks_2019.AdventureWorks2019.Person.StateProvince sp 
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.CountryRegion cr 
    ON sp.CountryRegionCode = cr.CountryRegionCode') ;;

EXEC SYSADMIN.importView("text" => 'CREATE VIEW "master_class_2021_sample_data"."Production_vProductAndDescription" 
AS 
SELECT 
    p.ProductID 
    ,p.Name 
    ,pm.Name AS ProductModel 
    ,pmx.CultureID 
    ,pd.Description 
FROM mssql_advworks_2019.AdventureWorks2019.Production.Product p 
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Production.ProductModel pm 
    ON p.ProductModelID = pm.ProductModelID 
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Production.ProductModelProductDescriptionCulture pmx 
    ON pm.ProductModelID = pmx.ProductModelID 
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Production.ProductDescription pd 
    ON pmx.ProductDescriptionID = pd.ProductDescriptionID') ;;

EXEC SYSADMIN.importView("text" => 'CREATE VIEW "master_class_2021_sample_data"."Purchasing_vVendorWithAddresses" AS 
SELECT 
    v.BusinessEntityID
    ,v.Name
    ,at.Name AS AddressType
    ,a.AddressLine1 
    ,a.AddressLine2 
    ,a.City 
    ,sp.Name AS StateProvinceName 
    ,a.PostalCode 
    ,cr.Name AS CountryRegionName 
FROM mssql_advworks_2019.AdventureWorks2019.Purchasing.Vendor v
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.BusinessEntityAddress bea 
    ON bea.BusinessEntityID = v.BusinessEntityID 
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.Address a 
    ON a.AddressID = bea.AddressID
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.StateProvince sp 
    ON sp.StateProvinceID = a.StateProvinceID
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.CountryRegion cr 
    ON cr.CountryRegionCode = sp.CountryRegionCode
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.AddressType at 
    ON at.AddressTypeID = bea.AddressTypeID') ;;

EXEC SYSADMIN.importView("text" => 'CREATE VIEW "master_class_2021_sample_data"."Purchasing_vVendorWithContacts" AS 
SELECT 
    v.BusinessEntityID
    ,v.Name
    ,ct.Name AS ContactType 
    ,p.Title 
    ,p.FirstName 
    ,p.MiddleName 
    ,p.LastName 
    ,p.Suffix 
    ,pp.PhoneNumber 
	,pnt.Name AS PhoneNumberType
    ,ea.EmailAddress 
    ,p.EmailPromotion 
FROM mssql_advworks_2019.AdventureWorks2019.Purchasing.Vendor v
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.BusinessEntityContact bec 
    ON bec.BusinessEntityID = v.BusinessEntityID
	INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.ContactType ct
	ON ct.ContactTypeID = bec.ContactTypeID
	INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.Person p
	ON p.BusinessEntityID = bec.PersonID
	LEFT OUTER JOIN mssql_advworks_2019.AdventureWorks2019.Person.EmailAddress ea
	ON ea.BusinessEntityID = p.BusinessEntityID
	LEFT OUTER JOIN mssql_advworks_2019.AdventureWorks2019.Person.PersonPhone pp
	ON pp.BusinessEntityID = p.BusinessEntityID
	LEFT OUTER JOIN mssql_advworks_2019.AdventureWorks2019.Person.PhoneNumberType pnt
	ON pnt.PhoneNumberTypeID = pp.PhoneNumberTypeID') ;;

EXEC SYSADMIN.importView("text" => 'CREATE VIEW "master_class_2021_sample_data"."Sales_vIndividualCustomer" 
AS 
SELECT 
    p.BusinessEntityID
    ,p.Title
    ,p.FirstName
    ,p.MiddleName
    ,p.LastName
    ,p.Suffix
    ,pp.PhoneNumber
	,pnt.Name AS PhoneNumberType
    ,ea.EmailAddress
    ,p.EmailPromotion
    ,at.Name AS AddressType
    ,a.AddressLine1
    ,a.AddressLine2
    ,a.City
    ,sp.Name as StateProvinceName
    ,a.PostalCode
    ,cr.Name as CountryRegionName
    ,p.Demographics
FROM mssql_advworks_2019.AdventureWorks2019.Person.Person p
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.BusinessEntityAddress bea 
    ON bea.BusinessEntityID = p.BusinessEntityID 
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.Address a 
    ON a.AddressID = bea.AddressID
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.StateProvince sp 
    ON sp.StateProvinceID = a.StateProvinceID
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.CountryRegion cr 
    ON cr.CountryRegionCode = sp.CountryRegionCode
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.AddressType at 
    ON at.AddressTypeID = bea.AddressTypeID
	INNER JOIN mssql_advworks_2019.AdventureWorks2019.Sales.Customer c
	ON c.PersonID = p.BusinessEntityID
	LEFT OUTER JOIN mssql_advworks_2019.AdventureWorks2019.Person.EmailAddress ea
	ON ea.BusinessEntityID = p.BusinessEntityID
	LEFT OUTER JOIN mssql_advworks_2019.AdventureWorks2019.Person.PersonPhone pp
	ON pp.BusinessEntityID = p.BusinessEntityID
	LEFT OUTER JOIN mssql_advworks_2019.AdventureWorks2019.Person.PhoneNumberType pnt
	ON pnt.PhoneNumberTypeID = pp.PhoneNumberTypeID
WHERE c.StoreID IS NULL') ;;

EXEC SYSADMIN.importView("text" => 'CREATE VIEW "master_class_2021_sample_data"."Sales_vSalesPerson" 
AS 
SELECT 
    s.BusinessEntityID
    ,p.Title
    ,p.FirstName
    ,p.MiddleName
    ,p.LastName
    ,p.Suffix
    ,e.JobTitle
    ,pp.PhoneNumber
	,pnt.Name AS PhoneNumberType
    ,ea.EmailAddress
    ,p.EmailPromotion
    ,a.AddressLine1
    ,a.AddressLine2
    ,a.City
    ,sp.Name as StateProvinceName
    ,a.PostalCode
    ,cr.Name as CountryRegionName
    ,st.Name as TerritoryName
    ,st.Group as TerritoryGroup
    ,s.SalesQuota
    ,s.SalesYTD
    ,s.SalesLastYear
FROM mssql_advworks_2019.AdventureWorks2019.Sales.SalesPerson s
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.HumanResources.Employee e 
    ON e.BusinessEntityID = s.BusinessEntityID
	INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.Person p
	ON p.BusinessEntityID = s.BusinessEntityID
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.BusinessEntityAddress bea 
    ON bea.BusinessEntityID = s.BusinessEntityID 
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.Address a 
    ON a.AddressID = bea.AddressID
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.StateProvince sp 
    ON sp.StateProvinceID = a.StateProvinceID
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.CountryRegion cr 
    ON cr.CountryRegionCode = sp.CountryRegionCode
    LEFT OUTER JOIN mssql_advworks_2019.AdventureWorks2019.Sales.SalesTerritory st 
    ON st.TerritoryID = s.TerritoryID
	LEFT OUTER JOIN mssql_advworks_2019.AdventureWorks2019.Person.EmailAddress ea
	ON ea.BusinessEntityID = p.BusinessEntityID
	LEFT OUTER JOIN mssql_advworks_2019.AdventureWorks2019.Person.PersonPhone pp
	ON pp.BusinessEntityID = p.BusinessEntityID
	LEFT OUTER JOIN mssql_advworks_2019.AdventureWorks2019.Person.PhoneNumberType pnt
	ON pnt.PhoneNumberTypeID = pp.PhoneNumberTypeID') ;;

EXEC SYSADMIN.importView("text" => 'CREATE VIEW "master_class_2021_sample_data"."Sales_vStoreWithAddresses" AS 
SELECT 
    s.BusinessEntityID 
    ,s.Name 
    ,at.Name AS AddressType
    ,a.AddressLine1 
    ,a.AddressLine2 
    ,a.City 
    ,sp.Name AS StateProvinceName 
    ,a.PostalCode 
    ,cr.Name AS CountryRegionName 
FROM mssql_advworks_2019.AdventureWorks2019.Sales.Store s
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.BusinessEntityAddress bea 
    ON bea.BusinessEntityID = s.BusinessEntityID 
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.Address a 
    ON a.AddressID = bea.AddressID
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.StateProvince sp 
    ON sp.StateProvinceID = a.StateProvinceID
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.CountryRegion cr 
    ON cr.CountryRegionCode = sp.CountryRegionCode
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.AddressType at 
    ON at.AddressTypeID = bea.AddressTypeID') ;;

EXEC SYSADMIN.importView("text" => 'CREATE VIEW "master_class_2021_sample_data"."Sales_vStoreWithContacts" AS 
SELECT 
    s.BusinessEntityID 
    ,s.Name 
    ,ct.Name AS ContactType 
    ,p.Title 
    ,p.FirstName 
    ,p.MiddleName 
    ,p.LastName 
    ,p.Suffix 
    ,pp.PhoneNumber 
	,pnt.Name AS PhoneNumberType
    ,ea.EmailAddress 
    ,p.EmailPromotion 
FROM mssql_advworks_2019.AdventureWorks2019.Sales.Store s
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.BusinessEntityContact bec 
    ON bec.BusinessEntityID = s.BusinessEntityID
	INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.ContactType ct
	ON ct.ContactTypeID = bec.ContactTypeID
	INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.Person p
	ON p.BusinessEntityID = bec.PersonID
	LEFT OUTER JOIN mssql_advworks_2019.AdventureWorks2019.Person.EmailAddress ea
	ON ea.BusinessEntityID = p.BusinessEntityID
	LEFT OUTER JOIN mssql_advworks_2019.AdventureWorks2019.Person.PersonPhone pp
	ON pp.BusinessEntityID = p.BusinessEntityID
	LEFT OUTER JOIN mssql_advworks_2019.AdventureWorks2019.Person.PhoneNumberType pnt
	ON pnt.PhoneNumberTypeID = pp.PhoneNumberTypeID') ;;

EXEC SYSADMIN.importView("text" => 'create VIEW "master_class_2021_sample_data"."nested_SalesPerson" 
AS 
SELECT 
    s.BusinessEntityID
    ,s.SalesQuota
    ,s.SalesYTD
    ,s.SalesLastYear
FROM 
	mssql_advworks_2019.AdventureWorks2019.Sales.SalesPerson s') ;;

EXEC SYSADMIN.importView("text" => 'CREATE VIEW "master_class_2021_sample_data"."nested_SalesPerson_Employee"
AS 
SELECT 
    s.BusinessEntityID
    ,s.SalesQuota
    ,s.SalesYTD
    ,s.SalesLastYear
    ,e.JobTitle
FROM master_class_2021_sample_data.nested_SalesPerson s
    INNER JOIN mssql_advworks_2019.AdventureWorks2019.HumanResources.Employee e
    ON e.BusinessEntityID = s.BusinessEntityID') ;;

EXEC SYSADMIN.importView("text" => 'CREATE VIEW "master_class_2021_sample_data"."nested_SalesPerson_Employee_Person" 
AS 
SELECT 
    s.BusinessEntityID
    ,p.Title
    ,p.FirstName
    ,p.MiddleName
    ,p.LastName
    ,p.Suffix
    ,s.JobTitle
    ,p.EmailPromotion
    ,s.SalesQuota
    ,s.SalesYTD
    ,s.SalesLastYear
FROM master_class_2021_sample_data.nested_SalesPerson_Employee s
	INNER JOIN mssql_advworks_2019.AdventureWorks2019.Person.Person p
	ON p.BusinessEntityID = s.BusinessEntityID') ;;








