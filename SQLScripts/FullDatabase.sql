USE [master]
GO
/****** Object:  Database [SolutiaCMS]    Script Date: 6/29/2015 2:46:38 PM ******/
CREATE DATABASE [SolutiaCMS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PracticeDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\PracticeDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'PracticeDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\PracticeDB_log.ldf' , SIZE = 5184KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [SolutiaCMS] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SolutiaCMS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SolutiaCMS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SolutiaCMS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SolutiaCMS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SolutiaCMS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SolutiaCMS] SET ARITHABORT OFF 
GO
ALTER DATABASE [SolutiaCMS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SolutiaCMS] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [SolutiaCMS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SolutiaCMS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SolutiaCMS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SolutiaCMS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SolutiaCMS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SolutiaCMS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SolutiaCMS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SolutiaCMS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SolutiaCMS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SolutiaCMS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SolutiaCMS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SolutiaCMS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SolutiaCMS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SolutiaCMS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SolutiaCMS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SolutiaCMS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SolutiaCMS] SET RECOVERY FULL 
GO
ALTER DATABASE [SolutiaCMS] SET  MULTI_USER 
GO
ALTER DATABASE [SolutiaCMS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SolutiaCMS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SolutiaCMS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SolutiaCMS] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [SolutiaCMS]
GO
/****** Object:  StoredProcedure [dbo].[sp_CompaniesWithProjects]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Cory Arneson
-- Create date: 6/14/15
-- Description:	Find all companies who have projects
-- =============================================
CREATE PROCEDURE [dbo].[sp_CompaniesWithProjects] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT DISTINCT company.Name FROM Company, Project
	WHERE Company.CompanyId = Project.CompanyId

END

GO
/****** Object:  StoredProcedure [dbo].[sp_CompanyAddPerson]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tony Spears
-- Create date: 6/23/2015
-- Description:	Add a person to a company
-- =============================================
CREATE PROCEDURE [dbo].[sp_CompanyAddPerson]
	@companyId int,
	@personId int
	AS
BEGIN
	
	SET NOCOUNT ON;

	--Check to see if the person is already an employee.
	IF(NOT EXISTS(SELECT PersonId FROM Employee WHERE PersonId = @personId))
		INSERT INTO Employee (CompanyId, PersonId) VALUES (@companyId, @personId)

	DECLARE @employeeId int = SCOPE_IDENTITY()

	SELECT Person.PersonId, Person.FirstName, Person.MiddleName, Person.LastName, Employee.CompanyId, 
	Employee.EmployeeId 
	FROM Employee INNER JOIN Person ON Employee.PersonId = Person.PersonId
		WHERE EmployeeId = @employeeId
END

GO
/****** Object:  StoredProcedure [dbo].[sp_CompanyCreate]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tony Spears
-- Create date: 6/20/2015
-- Description:	Creates a Company
-- =============================================
CREATE PROCEDURE [dbo].[sp_CompanyCreate] 
	@name nvarchar(50), 
	@address1 nvarchar(50), 
	@address2 nvarchar(50), 
	@city nvarchar(50), 
	@stateId nvarchar(50), 
	@zip nvarchar(50),
	@phoneNumber nvarchar(10)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO Company (Name, Address1, Address2, City, StateId, Zip, PhoneNumber)
	VALUES (@name, @address1, @address2, @city, @stateId, @zip, @phoneNumber)

	DECLARE @companyId int = SCOPE_IDENTITY()

	SELECT * FROM Company WHERE CompanyId = @companyId
END

GO
/****** Object:  StoredProcedure [dbo].[sp_CompanyRemoveEmployee]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tony Spears
-- Create date: 6/23/2015
-- Description:	Removes an Employee from a company.
-- =============================================
CREATE PROCEDURE [dbo].[sp_CompanyRemoveEmployee] 
	@employeeId int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM Employee WHERE EmployeeId = @employeeId

END

GO
/****** Object:  StoredProcedure [dbo].[sp_CompanyRetrieveById]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tony Spears
-- Create date: 6/20/2015
-- Description:	Retrieves a company by Id
-- =============================================
CREATE PROCEDURE [dbo].[sp_CompanyRetrieveById] 
	@companyId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM Company WHERE CompanyId = @companyId;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_CompanyRetrieveEmployees]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tony Spears
-- Create date: 6/26/2015
-- Description:	Retrieves all Employees in a Company
-- =============================================
CREATE PROCEDURE [dbo].[sp_CompanyRetrieveEmployees]
	@companyId int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT Person.PersonId, Person.FirstName, Person.MiddleName, Person.LastName,
	Employee.EmployeeId, Employee.CompanyId
	FROM Company INNER JOIN Employee ON Company.CompanyId = Employee.CompanyId 
	INNER JOIN Person ON Employee.PersonId = Person.PersonId
	WHERE Company.CompanyId = @companyId
	ORDER BY Person.LastName, Person.FirstName, Person.MiddleName

END

GO
/****** Object:  StoredProcedure [dbo].[sp_CompanySearch]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tony Spears
-- Create date: 6/20/2015
-- Description:	Search for a Company
-- =============================================
CREATE PROCEDURE [dbo].[sp_CompanySearch] 
	@companyName nvarchar(50) = N'',
	@address1 nvarchar(50) = N'', 
	@city nvarchar(50) = N'',
	@stateId nvarchar(2) = N'',
	@zip nvarchar(9) = N'',
	@phoneNumber nvarchar(10) = N''
AS
BEGIN
	SET NOCOUNT ON;

	SELECT CompanyId, Name, Address1, Address2, City, StateId, Zip, PhoneNumber
	FROM Company
	WHERE 
	1 = 1 AND
		(@companyName IS NULL OR Name LIKE  @companyName + '%') AND
		(@address1 IS NULL OR Address1 LIKE '%' + @address1 + '%') AND
		(@city IS NULL OR City LIKE @city + '%') AND
		(@stateId IS NULL OR StateId LIKE @stateId + '%') AND 
		(@phoneNumber IS NULL OR PhoneNumber LIKE @phoneNumber + '%')

	ORDER BY Name, StateId, Zip

END

GO
/****** Object:  StoredProcedure [dbo].[sp_CompanyUpdate]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tony Spears
-- Create date: 6/20/2015
-- Description:	Updates a Company
-- =============================================
CREATE PROCEDURE [dbo].[sp_CompanyUpdate] 
	@companyId int,
	@name nvarchar(50), 
	@address1 nvarchar(50), 
	@address2 nvarchar(50), 
	@city nvarchar(50), 
	@stateId nvarchar(50), 
	@zip nvarchar(50),
	@phoneNumber nvarchar(10)
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE Company 
	SET Name = @name,
	Address1 = @address1,
	Address2 = @address2,
	City = @city,
	StateId = @stateId,
	Zip = @zip,
	PhoneNumber = @phoneNumber 
	WHERE CompanyId = @companyId

END

GO
/****** Object:  StoredProcedure [dbo].[sp_EmployeeCompaniesWorkedFor]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Cory Arneson
-- Create date: 6/12/15
-- Description:	Find which companies an employee has worked for
-- =============================================
CREATE PROCEDURE [dbo].[sp_EmployeeCompaniesWorkedFor]
	@PersonId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
			SELECT Company.Name FROM Company, Employee
			WHERE Employee.PersonId = @PersonId
			AND Employee.CompanyId = Company.CompanyId
   
END

GO
/****** Object:  StoredProcedure [dbo].[sp_EmployeeRetrieveById]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tony Spears
-- Create date: 6/23/2015
-- Description:	Retrieves an Employee by ID
-- =============================================
CREATE PROCEDURE [dbo].[sp_EmployeeRetrieveById] 
	@employeeId int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM Employee WHERE EmployeeId = @employeeId
END

GO
/****** Object:  StoredProcedure [dbo].[sp_PersonCreate]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Cory Arneson
-- Create date: 6/12/15
-- Description:	Create Person
-- =============================================
CREATE PROCEDURE [dbo].[sp_PersonCreate]
	-- Add the parameters for the stored procedure here
	@FirstName nvarchar(50),
	@MiddleName nvarchar(50),
	@LastName nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO Person (FirstName, MiddleName, LastName)
	VALUES (@FirstName, @MiddleName, @LastName)

	DECLARE @PersonId int = SCOPE_IDENTITY()

	SELECT * FROM Person WHERE PersonId = @PersonId
END

GO
/****** Object:  StoredProcedure [dbo].[sp_PersonDelete]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Cory Arneson
-- Create date: 6/12/15
-- Description:	Update Person
-- =============================================
CREATE PROCEDURE [dbo].[sp_PersonDelete]
	@PersonId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DELETE FROM Person
	WHERE @PersonId = PersonId
END

GO
/****** Object:  StoredProcedure [dbo].[sp_PersonRetrieveAll]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Cory Arneson
-- Create date: 6/12/2015
-- Description:	Retrieves all Persons
-- =============================================
CREATE PROCEDURE [dbo].[sp_PersonRetrieveAll]  
	-- Add the parameters for the stored procedure here
	--@fooParam int = 1
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM Person ORDER BY LastName
END

GO
/****** Object:  StoredProcedure [dbo].[sp_PersonRetrieveById]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tony Spears
-- Create date: 6/20/2015
-- Description:	Retrieve a Person by Id
-- =============================================
CREATE PROCEDURE [dbo].[sp_PersonRetrieveById] 
	@personId int
	AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM Person WHERE PersonId = @personId
END

GO
/****** Object:  StoredProcedure [dbo].[sp_PersonSearch]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tony Spears
-- Create date: 6/17/2015
-- Description:	Performs a dynamic search on the Person table.
-- =============================================
CREATE PROCEDURE [dbo].[sp_PersonSearch]
	@firstName nvarchar(50) = N'',
	@middleName nvarchar(50) = N'', 
	@lastName nvarchar(50) = N''
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT PersonId, FirstName, MiddleName, LastName
	FROM Person
	WHERE 
	1 = 1 AND
		(@firstName IS NULL OR FirstName LIKE  @firstName + '%') AND
		(@middleName IS NULL OR MiddleName LIKE @middleName + '%') AND
		(@lastName IS NULL OR LastName LIKE @lastName + '%')
	ORDER BY LastName, FirstName, MiddleName

END

GO
/****** Object:  StoredProcedure [dbo].[sp_PersonUpdate]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Cory Arneson
-- Create date: 6/12/15
-- Description:	Update Person
-- =============================================
CREATE PROCEDURE [dbo].[sp_PersonUpdate]
	-- Add the parameters for the stored procedure here
	@PersonId int,
	@FirstName nvarchar(50),
	@MiddleName nvarchar(50),
	@LastName nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    UPDATE Person
	SET FirstName = @FirstName, MiddleName = @MiddleName, LastName = @LastName
	WHERE PersonId = @PersonId
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ProjectAddEmployee]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Cory Arneson
-- Create date: 6/12/15
-- Description:	Adding an Employee to a Project
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProjectAddEmployee]
	@EmployeeId int,
	@ProjectId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorMsg nvarchar(255)
	DECLARE	@return_value int

	EXEC @return_value = [dbo].[sp_ProjectCanUpdateAssignment]
		@ProjectId = @ProjectId
	
	IF @return_value = 1
		BEGIN
		    INSERT INTO Assignment (EmployeeId, ProjectId)
			VALUES (@EmployeeId, @ProjectId)
		END
	ELSE
		BEGIN
			SET @ErrorMsg = 'Project ID ' + CAST(@ProjectId AS VARCHAR(50)) + ' was not found. Or this project was already closed.'
			RAISERROR(@ErrorMsg,11,1)
		END



END

GO
/****** Object:  StoredProcedure [dbo].[sp_ProjectCanUpdateAssignment]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Cory Arneson
-- Create date: 6/12/15
-- Description:	Determine whether an Employee can be added or removed from a project
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProjectCanUpdateAssignment] 
	@ProjectId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @ErrorMsg nvarchar(255)

	IF EXISTS(SELECT * FROM Project WHERE ProjectId = @ProjectId AND StatusId <> 1)
		BEGIN
			RETURN 1
		END
	ELSE
		BEGIN
			RETURN 0
		END
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ProjectClose]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Cory Arneson
-- Create date: 6/12/15
-- Description:	Close a Project
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProjectClose] 
	@ProjectId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   DECLARE @ErrorMsg nvarchar(255)

	IF EXISTS(SELECT * FROM Project WHERE ProjectId = @ProjectId AND StatusId <> 1)
		BEGIN
			UPDATE Project
			SET EndDate = GETDATE(), StatusId = 1
			WHERE ProjectId = @ProjectId
		END
	ELSE
		BEGIN
		
			SET @ErrorMsg = 'Project ID ' + CAST(@ProjectId AS VARCHAR(50)) + ' was not found. Or this project was already closed.'
			RAISERROR(@ErrorMsg,11,1)
		END
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ProjectCreate]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Cory Arneson
-- Create date: 6/12/15
-- Description:	Create Project
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProjectCreate] 
	-- Add the parameters for the stored procedure here
	@Name nvarchar(50),
	@CompanyId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    INSERT INTO Project (StatusId, Name, StartDate, CompanyId)
	VALUES (3, @Name, GETDATE(), @CompanyId)

	DECLARE @ProjectId int = SCOPE_IDENTITY()

	SELECT * FROM Project WHERE ProjectId = @ProjectId
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ProjectDelete]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Cory Arneson
-- Create date: 6/12/15
-- Description:	Delete a Project
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProjectDelete]
	@ProjectId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   DECLARE @ErrorMsg nvarchar(255)

	IF EXISTS(SELECT * FROM Project WHERE ProjectId = @ProjectId)
		BEGIN
			DELETE FROM Project
			WHERE ProjectId = @ProjectId
		END
	ELSE
		BEGIN
			SET @ErrorMsg = 'Project ID ' + CAST(@ProjectId AS varchar(50)) + ' was not found.'
			RAISERROR(@ErrorMsg,11,1)
		END
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ProjectRemoveEmployee]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Cory Arneson
-- Create date: 6/12/15
-- Description:	Remove an employee from a project
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProjectRemoveEmployee]
	@ProjectId int,
	@EmployeeId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorMsg nvarchar(255)
	DECLARE	@return_value int

	EXEC @return_value = [dbo].[sp_ProjectCanUpdateAssignment]
		@ProjectId = @ProjectId
	
	IF @return_value = 1
		BEGIN
		    DELETE FROM Assignment
			WHERE ProjectId = @ProjectId 
			AND EmployeeId = @EmployeeId
		END
	ELSE
		BEGIN
			SET @ErrorMsg = 'Project ID ' + CAST(@ProjectId AS VARCHAR(50)) + ' was not found. Or this project was already closed.'
			RAISERROR(@ErrorMsg,11,1)
		END
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ProjectRetrieveById]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tony Spears
-- Create date: 6/26/2015
-- Description:	Retrieves a project by Id
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProjectRetrieveById]
	@projectId int
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM Project WHERE ProjectId = @projectId
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ProjectRetrieveEmployees]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Cory Arneson
-- Create date: 6/12/15
-- Description:	Find all employees who are assigned to a project
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProjectRetrieveEmployees]
	@ProjectId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT Person.PersonId, Person.FirstName, Person.LastName, Person.MiddleName, Employee.EmployeeId 
   FROM Person, Employee, Assignment
   WHERE Assignment.ProjectId = @ProjectId
   AND Employee.EmployeeId = Assignment.EmployeeId
   AND Employee.PersonId = Person.PersonId
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ProjectsCurrentlyOpen]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Cory Arneson
-- Create date: 6/12/15
-- Description:	Find all currently open projects
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProjectsCurrentlyOpen] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM Project WHERE StatusId = 2
	ORDER BY Name
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ProjectsRetrieveByCompanyId]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tony Spears
-- Create date: 6/26/2015
-- Description:	Retrieves projects for a company.
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProjectsRetrieveByCompanyId] 
	@companyId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from Project WHERE CompanyId = @companyId
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ProjectStart]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Cory Arneson
-- Create date: 6/12/15
-- Description:	Start a Project
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProjectStart]
	@ProjectId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorMsg nvarchar(255)

	IF EXISTS(SELECT * FROM Project WHERE ProjectId = @ProjectId AND StatusId <> 1)
		BEGIN
			UPDATE Project
			SET StatusId = 2
			WHERE ProjectId = @ProjectId
		END
	ELSE
		BEGIN
			SET @ErrorMsg = 'Project ID ' + CAST(@ProjectId AS varchar(50)) + ' was not found.'
			RAISERROR(@ErrorMsg,11,1)

		END

END

GO
/****** Object:  StoredProcedure [dbo].[sp_ProjectUpdate]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Cory Arneson
-- Create date: 6/12/15
-- Description:	Update Project
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProjectUpdate]
	@projectId int,
	@plannedStartDate Date = null,
	@plannedEndDate Date = null,
	@actualStartDate Date = null,
	@actualEndDate Date = null,
	@name nvarchar(50),
	@companyId int,
	@statusId int
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ErrorMsg nvarchar(255)

	IF EXISTS(SELECT * FROM Project WHERE ProjectId = @ProjectId)
		BEGIN
			UPDATE Project
			SET PlannedStartDate = @plannedStartDate, PlannedEndDate = @plannedEndDate,
			ActualStartDate = @actualStartDate, ActualEndDate = @actualEndDate,
			Name = @name, StatusId = @statusId
			WHERE ProjectId = @projectId
		END
	ELSE
		BEGIN
			SET @ErrorMsg = 'Project ID ' + CAST(@ProjectId AS varchar(50)) + ' was not found.'
			RAISERROR(@ErrorMsg,11,1)
		END
END

GO
/****** Object:  Table [dbo].[Assignment]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Assignment](
	[EmployeeId] [int] NOT NULL,
	[ProjectId] [int] NOT NULL,
 CONSTRAINT [PK_Assignment] PRIMARY KEY CLUSTERED 
(
	[EmployeeId] ASC,
	[ProjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Company]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Company](
	[CompanyId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Address1] [nvarchar](50) NULL,
	[Address2] [nvarchar](50) NULL,
	[City] [nvarchar](50) NULL,
	[Zip] [nvarchar](9) NULL,
	[PhoneNumber] [nvarchar](10) NULL,
	[StateId] [nvarchar](255) NULL,
 CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED 
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Employee]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[EmployeeId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [int] NULL,
	[PersonId] [int] NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[EmployeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MockCompanies]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MockCompanies](
	[id] [float] NULL,
	[Name] [nvarchar](255) NULL,
	[Address1] [nvarchar](255) NULL,
	[Address2] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[StateId] [nvarchar](255) NULL,
	[Zip] [float] NULL,
	[PhoneNumber] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MockPeople]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MockPeople](
	[id] [float] NULL,
	[first_name] [nvarchar](255) NULL,
	[last_name] [nvarchar](255) NULL,
	[email] [nvarchar](255) NULL,
	[address] [nvarchar](255) NULL,
	[city] [nvarchar](255) NULL,
	[stateCode] [nvarchar](255) NULL,
	[phone] [nvarchar](255) NULL,
	[zipCode] [float] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Person]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Person](
	[PersonId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[MiddleName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Person1] PRIMARY KEY CLUSTERED 
(
	[PersonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Project]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Project](
	[ProjectId] [int] IDENTITY(1,1) NOT NULL,
	[StatusId] [int] NULL,
	[Name] [nvarchar](50) NOT NULL,
	[PlannedStartDate] [date] NULL,
	[ActualStartDate] [date] NULL,
	[PlannedEndDate] [date] NULL,
	[ActualEndDate] [date] NULL,
	[CompanyId] [int] NULL,
 CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED 
(
	[ProjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Status]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Status](
	[StatusId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED 
(
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[USStates]    Script Date: 6/29/2015 2:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USStates](
	[name] [nvarchar](255) NULL,
	[abbreviation] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_USStates] PRIMARY KEY CLUSTERED 
(
	[abbreviation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
INSERT [dbo].[Assignment] ([EmployeeId], [ProjectId]) VALUES (5, 1)
GO
INSERT [dbo].[Assignment] ([EmployeeId], [ProjectId]) VALUES (5, 3)
GO
INSERT [dbo].[Assignment] ([EmployeeId], [ProjectId]) VALUES (6, 2)
GO
INSERT [dbo].[Assignment] ([EmployeeId], [ProjectId]) VALUES (7, 1)
GO
SET IDENTITY_INSERT [dbo].[Company] ON 

GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1, N'Stark Industries', N'123 4th St', N'', N'Hollywood', N'98765', N'1237654999', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (2, N'Dunder Mifflin', N'123 Grand Ave', N'Ste 103', N'Scranton', N'12334', N'6538827400', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (3, N'Milwaukee Brewers', N'999 Miller Park Way', N'', N'Milwaukee', N'55442', N'1286464691', N'WI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1004, N'Skyndu', N'62387 High Crossing Park', NULL, N'Huntsville', N'35805', N'1394262057', N'AL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1005, N'Avaveo', N'5 Randy Point', NULL, N'San Francisco', N'94159', N'7110402805', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1006, N'Twitterbeat', N'47335 Derek Plaza', NULL, N'Houston', N'77266', N'4405005810', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1007, N'Meetz', N'75 Monument Court', NULL, N'Evansville', N'47719', N'7967302760', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1008, N'Eimbee', N'96231 Cody Park', NULL, N'Zephyrhills', N'33543', N'0290900993', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1009, N'Eamia', N'19904 Westend Hill', NULL, N'London', N'40745', N'8053104014', N'KY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1010, N'Youfeed', N'9 Clyde Gallagher Pass', NULL, N'Montgomery', N'36104', N'7445140500', N'AL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1011, N'Cogibox', N'72 Kings Trail', NULL, N'New York City', N'10099', N'2506828942', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1012, N'Meeveo', N'3 Debs Parkway', NULL, N'Indianapolis', N'46216', N'9144243307', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1013, N'Skinix', N'554 Northport Avenue', NULL, N'Knoxville', N'37924', N'9294902118', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1014, N'Feedspan', N'1 Mosinee Terrace', NULL, N'Minneapolis', N'55436', N'1804202385', N'MN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1015, N'Kamba', N'5 Dovetail Road', NULL, N'Philadelphia', N'19196', N'7878067304', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1016, N'Wikibox', N'9521 Everett Court', NULL, N'Concord', N'94522', N'0499037719', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1017, N'Thoughtmix', N'98164 Old Gate Lane', NULL, N'Irving', N'75037', N'8229068136', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1018, N'Oloo', N'72 Killdeer Court', NULL, N'Cincinnati', N'45249', N'4024490194', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1019, N'Trupe', N'28 Center Trail', NULL, N'Sarasota', N'34276', N'4597628908', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1020, N'Devify', N'12246 Porter Point', NULL, N'San Antonio', N'78240', N'1154673483', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1021, N'Jaxspan', N'812 Dennis Park', NULL, N'Fairbanks', N'99709', N'6729388478', N'AK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1022, N'Yodel', N'414 Superior Park', NULL, N'Clearwater', N'33763', N'8906246277', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1023, N'Photobug', N'11 Anderson Parkway', NULL, N'Sacramento', N'94291', N'4407622417', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1024, N'Twitterworks', N'3635 Troy Way', NULL, N'Albuquerque', N'87190', N'2415748091', N'NM')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1025, N'Babbleset', N'1478 Sunnyside Junction', NULL, N'Des Moines', N'50310', N'0291119500', N'IA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1026, N'Vipe', N'794 Clyde Gallagher Drive', NULL, N'Oklahoma City', N'73109', N'7759543058', N'OK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1027, N'Shuffletag', N'905 Forest Avenue', NULL, N'Santa Ana', N'92725', N'6842148159', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1028, N'Edgeify', N'085 Annamark Plaza', NULL, N'Paterson', N'7505', N'0205032214', N'NJ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1029, N'Topicware', N'5936 Welch Avenue', NULL, N'North Hollywood', N'91606', N'3023821426', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1030, N'Photolist', N'7 Ohio Junction', NULL, N'Tyler', N'75799', N'6734306847', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1031, N'Leenti', N'74375 Nobel Street', NULL, N'Nashville', N'37240', N'1762667939', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1032, N'Skyvu', N'3 Westerfield Place', NULL, N'Springfield', N'62756', N'6413785084', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1033, N'Trunyx', N'15 Thierer Point', NULL, N'El Paso', N'79977', N'3366019454', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1034, N'Topicware', N'55 Continental Center', NULL, N'Fort Wayne', N'46825', N'3866227721', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1035, N'Plambee', N'91033 Derek Lane', NULL, N'Denver', N'80255', N'6601608032', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1036, N'Einti', N'6 Sullivan Avenue', NULL, N'South Bend', N'46620', N'2825663063', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1037, N'Latz', N'9 Rockefeller Junction', NULL, N'Vienna', N'22184', N'6777107783', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1038, N'Feedfire', N'743 Randy Place', NULL, N'Houston', N'77240', N'0801794720', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1039, N'Meembee', N'93604 Forest Parkway', NULL, N'Richmond', N'23285', N'7707702603', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1040, N'Yakitri', N'578 Pleasure Way', NULL, N'Gaithersburg', N'20883', N'5056619326', N'MD')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1041, N'Myworks', N'55338 Maywood Terrace', NULL, N'Charlotte', N'28299', N'8144964183', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1042, N'Voonyx', N'428 Erie Place', NULL, N'Dallas', N'75372', N'9999229238', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1043, N'DabZ', N'53009 Rusk Terrace', NULL, N'Springfield', N'65810', N'7225342433', N'MO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1044, N'Voonyx', N'6116 Quincy Pass', NULL, N'Dayton', N'45419', N'8949458718', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1045, N'Abatz', N'04486 Ridgeview Hill', NULL, N'Columbus', N'31904', N'7936381664', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1046, N'Zoomcast', N'6581 Old Shore Junction', NULL, N'Kansas City', N'64149', N'8217461486', N'MO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1047, N'Babblestorm', N'13 Trailsway Court', NULL, N'Jeffersonville', N'47134', N'7656826343', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1048, N'Realcube', N'47636 Stang Circle', NULL, N'San Angelo', N'76905', N'4624442113', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1049, N'Gigaclub', N'09116 Ridge Oak Drive', NULL, N'Kansas City', N'64114', N'1484261516', N'MO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1050, N'Meembee', N'81 Vernon Lane', NULL, N'Salt Lake City', N'84105', N'7804406534', N'UT')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1051, N'Divanoodle', N'07 Bluestem Parkway', NULL, N'Long Beach', N'90840', N'0628248276', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1052, N'Skilith', N'7730 Lakeland Drive', NULL, N'Denver', N'80223', N'8160831219', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1053, N'Tagfeed', N'705 Lotheville Center', NULL, N'Des Moines', N'50315', N'6940653744', N'IA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1054, N'Skinix', N'06721 Sundown Road', NULL, N'Pasadena', N'91131', N'3986044777', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1055, N'Wikizz', N'16983 Jenna Crossing', NULL, N'Racine', N'53405', N'3139394010', N'WI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1056, N'Zooxo', N'3198 Pawling Alley', NULL, N'Chicago', N'60604', N'5454330136', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1057, N'Katz', N'0042 Glendale Way', NULL, N'Columbia', N'29208', N'1389124332', N'SC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1058, N'Ntags', N'2 Boyd Lane', NULL, N'Gastonia', N'28055', N'0701372775', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1059, N'Tagcat', N'5 Sundown Pass', NULL, N'Los Angeles', N'90065', N'0084048910', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1060, N'Devcast', N'056 Pierstorff Street', NULL, N'Miami Beach', N'33141', N'4957631352', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1061, N'Topiclounge', N'78194 Graedel Hill', NULL, N'Baltimore', N'21275', N'7580932872', N'MD')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1062, N'Avamba', N'48 Drewry Street', NULL, N'Evansville', N'47719', N'4519072314', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1063, N'Topiczoom', N'7 Marquette Parkway', NULL, N'San Antonio', N'78296', N'0645135903', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1064, N'Dabshots', N'26550 Merry Park', NULL, N'Stockton', N'95298', N'3680472351', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1065, N'Skynoodle', N'03 Di Loreto Lane', NULL, N'Annapolis', N'21405', N'2914775646', N'MD')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1066, N'Kwimbee', N'8019 Cordelia Plaza', NULL, N'Orlando', N'32808', N'5201336254', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1067, N'Zoombeat', N'30 Kipling Court', NULL, N'Gulfport', N'39505', N'1797792909', N'MS')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1068, N'Zooveo', N'18 Birchwood Center', NULL, N'Rochester', N'14624', N'4082428471', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1069, N'Jetwire', N'10 Badeau Lane', NULL, N'Cleveland', N'44191', N'5790051815', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1070, N'Abata', N'46 Jenifer Avenue', N'', N'Monticello', N'55565', N'5906417037', N'MN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1071, N'Jatri', N'23624 Killdeer Road', NULL, N'Philadelphia', N'19104', N'4011687888', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1072, N'Rhynoodle', N'1 Melvin Point', NULL, N'Washington', N'20380', N'1147797294', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1073, N'Oloo', N'902 Sugar Pass', NULL, N'Stockton', N'95205', N'8385097134', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1074, N'Yadel', N'12291 Sutteridge Way', NULL, N'Worcester', N'1605', N'2093144119', N'MA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1075, N'Jetpulse', N'9 Glacier Hill Trail', NULL, N'Washington', N'20546', N'0567825907', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1076, N'Zooveo', N'0 Reinke Circle', NULL, N'Fairfax', N'22036', N'5325802678', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1077, N'Twitterbridge', N'83352 Mitchell Court', NULL, N'El Paso', N'88574', N'3936784845', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1078, N'Yakitri', N'3 Walton Pass', NULL, N'Milwaukee', N'53277', N'4145335118', N'WI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1079, N'Eidel', N'66 Redwing Lane', NULL, N'San Diego', N'92145', N'9868350032', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1080, N'Topicblab', N'66 Muir Parkway', NULL, N'Nashville', N'37210', N'9754443338', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1081, N'Eayo', N'108 High Crossing Court', NULL, N'Indianapolis', N'46295', N'3460466375', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1082, N'Mydo', N'5 Shopko Circle', NULL, N'New York City', N'10019', N'2867637906', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1083, N'Cogidoo', N'25 Bay Terrace', NULL, N'San Francisco', N'94105', N'4028599852', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1084, N'Flipbug', N'86 Prairie Rose Circle', NULL, N'Austin', N'78783', N'4691422972', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1085, N'Skyndu', N'211 Holy Cross Avenue', NULL, N'Bradenton', N'34282', N'2464137089', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1086, N'Skinix', N'03 Jenifer Road', NULL, N'Cincinnati', N'45233', N'7819989006', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1087, N'Nlounge', N'885 Dunning Plaza', NULL, N'Southfield', N'48076', N'3102948883', N'MI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1088, N'Dynabox', N'4356 Annamark Circle', NULL, N'Salt Lake City', N'84140', N'4186034617', N'UT')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1089, N'Zoombox', N'83 Holy Cross Court', NULL, N'Albany', N'12255', N'3460739379', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1090, N'Browsebug', N'5007 Arrowood Court', NULL, N'Birmingham', N'35279', N'1716814092', N'AL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1091, N'Abatz', N'4 Marcy Plaza', NULL, N'Chicago', N'60657', N'7821233585', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1092, N'Topicshots', N'351 Moulton Way', NULL, N'Roanoke', N'24034', N'8577053838', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1093, N'Fivebridge', N'7546 Pierstorff Street', NULL, N'Des Moines', N'50369', N'3085362657', N'IA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1094, N'Realblab', N'2 Granby Plaza', NULL, N'Sacramento', N'94263', N'0066081549', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1095, N'Oyoloo', N'1 Merchant Court', NULL, N'Houston', N'77255', N'6336080719', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1096, N'Yata', N'16904 Nobel Lane', NULL, N'San Diego', N'92105', N'2102327077', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1097, N'Skinte', N'49 Bluejay Crossing', NULL, N'Phoenix', N'85072', N'9185022604', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1098, N'Skajo', N'0 Randy Court', NULL, N'Fresno', N'93794', N'9913461617', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1099, N'Topiczoom', N'290 Sutherland Street', NULL, N'Springfield', N'45505', N'9662170006', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1100, N'Muxo', N'0833 Darwin Center', NULL, N'Charleston', N'29411', N'0027333117', N'SC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1101, N'Babbleblab', N'37 Dakota Point', NULL, N'Asheville', N'28815', N'4330567328', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1102, N'Vidoo', N'69458 Brown Point', NULL, N'Dallas', N'75358', N'9373750087', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1103, N'Camido', N'620 Florence Parkway', NULL, N'Littleton', N'80161', N'3182167706', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1104, N'Rhyzio', N'487 Little Fleur Plaza', NULL, N'Saint Petersburg', N'33742', N'0630964721', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1105, N'Kwilith', N'19 Arkansas Plaza', NULL, N'Fort Lauderdale', N'33325', N'5947148749', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1106, N'Devshare', N'3421 Washington Pass', NULL, N'San Francisco', N'94159', N'2921176995', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1107, N'Jabbercube', N'44584 Cordelia Park', NULL, N'Sacramento', N'95823', N'9081273533', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1108, N'Youspan', N'31860 Manley Center', NULL, N'Tucson', N'85710', N'0314970480', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1109, N'Pixope', N'13780 Heath Street', NULL, N'Orlando', N'32808', N'9180382331', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1110, N'Livetube', N'2 Kenwood Plaza', NULL, N'Melbourne', N'32941', N'6769306212', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1111, N'Kwilith', N'53 Miller Street', NULL, N'Greensboro', N'27415', N'5813477731', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1112, N'Mynte', N'9841 Mandrake Drive', NULL, N'Norwalk', N'6859', N'7305247466', N'CT')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1113, N'Roomm', N'2 Carpenter Center', NULL, N'Baton Rouge', N'70815', N'9455090760', N'LA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1114, N'Browsecat', N'066 Dorton Trail', NULL, N'Los Angeles', N'90081', N'5460476913', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1115, N'Yabox', N'3 Hanover Lane', NULL, N'Memphis', N'38109', N'8199258667', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1116, N'Topiczoom', N'3828 Comanche Alley', NULL, N'Canton', N'44705', N'2132412247', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1117, N'Skivee', N'645 Bunker Hill Road', NULL, N'Bronx', N'10459', N'1384004224', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1118, N'Jabbercube', N'98 Atwood Lane', NULL, N'Boca Raton', N'33487', N'2994119996', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1119, N'Topicshots', N'0030 Debs Junction', NULL, N'Cincinnati', N'45213', N'4802312163', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1120, N'Tavu', N'10 Fieldstone Junction', NULL, N'Charlotte', N'28242', N'2643148165', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1121, N'Brightdog', N'08 Mallard Point', NULL, N'New Haven', N'6520', N'6548131109', N'CT')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1122, N'Blogtag', N'558 Atwood Plaza', NULL, N'Lexington', N'40581', N'5593813752', N'KY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1123, N'Ooba', N'4 School Way', NULL, N'Las Vegas', N'89160', N'6681017272', N'NV')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1124, N'Yacero', N'80 Dapin Road', NULL, N'Fresno', N'93786', N'4733575579', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1125, N'Riffwire', N'9 Cardinal Park', NULL, N'Sacramento', N'95828', N'9963650300', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1126, N'Browsebug', N'0 5th Lane', NULL, N'Spokane', N'99252', N'6643866359', N'WA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1127, N'Yata', N'565 Helena Pass', NULL, N'Syracuse', N'13224', N'2329040749', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1128, N'Lajo', N'319 Kingsford Parkway', NULL, N'Fort Lauderdale', N'33330', N'8724297021', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1129, N'Zoovu', N'4316 Browning Park', NULL, N'Los Angeles', N'90076', N'5783281784', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1130, N'Ozu', N'00701 Carioca Road', NULL, N'Saint Paul', N'55172', N'5017954656', N'MN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1131, N'Avamba', N'2 Toban Junction', NULL, N'Hattiesburg', N'39404', N'5687984308', N'MS')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1132, N'Reallinks', N'94785 Union Court', NULL, N'Melbourne', N'32919', N'3903223251', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1133, N'Jabberbean', N'1 Buell Road', NULL, N'Tucson', N'85725', N'3737997440', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1134, N'Dabfeed', N'6947 Summerview Avenue', NULL, N'Alexandria', N'22333', N'2627470428', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1135, N'Eamia', N'61 Glacier Hill Crossing', NULL, N'Oakland', N'94616', N'3617790406', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1136, N'Skyble', N'5 Main Crossing', NULL, N'San Diego', N'92137', N'9615874650', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1137, N'Flashpoint', N'3836 Maryland Circle', NULL, N'Trenton', N'8608', N'7340012598', N'NJ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1138, N'Fivebridge', N'0 Jackson Road', NULL, N'Cincinnati', N'45218', N'4541651290', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1139, N'Meetz', N'45142 Clarendon Street', NULL, N'Crawfordsville', N'47937', N'1261039141', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1140, N'Yacero', N'2 Saint Paul Parkway', NULL, N'Salem', N'97306', N'2289049044', N'OR')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1141, N'Babbleopia', N'45252 Vera Alley', NULL, N'Springfield', N'62756', N'9939348633', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1142, N'Twimbo', N'5997 Susan Junction', NULL, N'Indianapolis', N'46202', N'2881521043', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1143, N'Skipfire', N'165 Independence Parkway', NULL, N'Winston Salem', N'27150', N'8471859994', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1144, N'Yambee', N'6757 Messerschmidt Junction', NULL, N'Springfield', N'62764', N'6936034498', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1145, N'Oyoloo', N'890 Eliot Parkway', NULL, N'Lancaster', N'93584', N'9208309730', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1146, N'Dabvine', N'89116 Artisan Crossing', NULL, N'Arlington', N'22212', N'8637767651', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1147, N'Browseblab', N'31672 1st Park', NULL, N'Las Vegas', N'89140', N'3773439605', N'NV')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1148, N'Livetube', N'27374 Eastlawn Pass', NULL, N'Washington', N'20205', N'7139878319', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1149, N'Wordware', N'24132 Utah Crossing', NULL, N'Washington', N'20310', N'4407530531', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1150, N'Quinu', N'6 Ramsey Drive', NULL, N'Washington', N'20046', N'0095038844', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1151, N'Eidel', N'1 Shoshone Plaza', NULL, N'Houston', N'77271', N'6280656803', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1152, N'Photobug', N'0 Blackbird Point', NULL, N'Los Angeles', N'90020', N'7537269702', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1153, N'Photobug', N'6 Truax Plaza', NULL, N'Levittown', N'19058', N'1514417916', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1154, N'Photobug', N'352 Redwing Center', NULL, N'Washington', N'20244', N'6274104612', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1155, N'Browsebug', N'14 Randy Court', NULL, N'San Francisco', N'94164', N'3673803018', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1156, N'Yacero', N'31010 Arrowood Junction', NULL, N'Lees Summit', N'64082', N'9920162904', N'MO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1157, N'Jaloo', N'7864 Sauthoff Center', NULL, N'Oxnard', N'93034', N'1245585561', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1158, N'Zoomzone', N'5875 Kim Circle', NULL, N'Denton', N'76205', N'0482602646', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1159, N'Trudoo', N'66 Continental Alley', NULL, N'Aurora', N'80045', N'2561095705', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1160, N'Browsetype', N'940 American Ash Circle', NULL, N'Portsmouth', N'23705', N'9126940785', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1161, N'Skibox', N'023 Grim Junction', NULL, N'Seattle', N'98109', N'3679373244', N'WA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1162, N'Mudo', N'6783 Bobwhite Way', NULL, N'Little Rock', N'72231', N'0252568204', N'AR')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1163, N'Fanoodle', N'3 3rd Place', NULL, N'Tulsa', N'74170', N'3849050073', N'OK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1164, N'Jetpulse', N'09935 Commercial Avenue', NULL, N'New Orleans', N'70142', N'4514408174', N'LA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1165, N'Demizz', N'711 Melby Place', NULL, N'Tampa', N'33694', N'6699035842', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1166, N'Aivee', N'397 Eggendart Street', NULL, N'Temple', N'76505', N'5290170986', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1167, N'Riffpath', N'8 Burrows Circle', NULL, N'Tampa', N'33625', N'7284848322', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1168, N'Chatterbridge', N'1 Hayes Circle', NULL, N'Albuquerque', N'87140', N'1690043577', N'NM')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1169, N'Brainverse', N'96 Duke Park', NULL, N'Lake Charles', N'70607', N'3855035403', N'LA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1170, N'Plambee', N'674 Autumn Leaf Place', NULL, N'Abilene', N'79699', N'3859590228', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1171, N'Voonix', N'15 Hooker Road', NULL, N'Tampa', N'33661', N'1796955073', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1172, N'Skaboo', N'9563 Golden Leaf Road', NULL, N'New York City', N'10115', N'0653694147', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1173, N'Fiveclub', N'80 Troy Park', NULL, N'Austin', N'78749', N'6347701879', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1174, N'Twitterbeat', N'7 Warbler Avenue', NULL, N'Aurora', N'80015', N'9809771620', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1175, N'Jayo', N'1195 Donald Avenue', NULL, N'Ogden', N'84409', N'3391199277', N'UT')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1176, N'Twitterwire', N'7 Marquette Junction', NULL, N'Richmond', N'23225', N'1091155171', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1177, N'Oyondu', N'22798 Bartelt Avenue', NULL, N'Denver', N'80243', N'0395036814', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1178, N'Zoomcast', N'561 Rusk Place', NULL, N'Atlanta', N'30375', N'9474583431', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1179, N'Rhyloo', N'247 Clarendon Parkway', NULL, N'Memphis', N'38150', N'7198279710', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1180, N'Quimba', N'5 Anhalt Place', NULL, N'Athens', N'30605', N'3212086184', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1181, N'Tazzy', N'61 Burrows Way', NULL, N'Valdosta', N'31605', N'7706870846', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1182, N'Kazio', N'9321 Gerald Avenue', NULL, N'Santa Barbara', N'93111', N'5886510500', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1183, N'Rhynoodle', N'4 Mccormick Pass', NULL, N'New Haven', N'6520', N'7163434062', N'CT')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1184, N'Agivu', N'4 Homewood Pass', NULL, N'Decatur', N'62525', N'3992436791', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1185, N'Roodel', N'8 Shoshone Alley', NULL, N'Peoria', N'61656', N'5396572950', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1186, N'Zava', N'40132 Emmet Point', NULL, N'Birmingham', N'35236', N'2193118309', N'AL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1187, N'Photobug', N'75 Gerald Circle', NULL, N'Richmond', N'23293', N'6674445216', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1188, N'Fanoodle', N'09238 Calypso Junction', NULL, N'Frederick', N'21705', N'1200573742', N'MD')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1189, N'Einti', N'53294 Kinsman Pass', NULL, N'Albuquerque', N'87180', N'7094713016', N'NM')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1190, N'Photofeed', N'4 Carpenter Street', NULL, N'Des Moines', N'50393', N'6489742763', N'IA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1191, N'Mymm', N'15 Clyde Gallagher Crossing', NULL, N'Baton Rouge', N'70805', N'4486441681', N'LA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1192, N'Trilith', N'1490 Saint Paul Avenue', NULL, N'Fresno', N'93704', N'1608567082', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1193, N'InnoZ', N'76 Barnett Plaza', NULL, N'Charlotte', N'28256', N'5140983557', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1194, N'LiveZ', N'764 Portage Junction', NULL, N'Bryan', N'77806', N'0143113630', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1195, N'Dabtype', N'1484 Namekagon Avenue', NULL, N'Phoenix', N'85077', N'2667739936', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1196, N'Oodoo', N'67 Meadow Valley Point', NULL, N'Anaheim', N'92812', N'5737591995', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1197, N'Oyonder', N'621 Ruskin Drive', NULL, N'Athens', N'30605', N'5692219389', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1198, N'Skivee', N'76 Heath Parkway', NULL, N'Phoenix', N'85072', N'7501426175', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1199, N'Kamba', N'4676 Anhalt Place', NULL, N'Santa Ana', N'92725', N'8578255236', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1200, N'Skibox', N'93219 Sunbrook Avenue', NULL, N'Knoxville', N'37931', N'6855088337', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1201, N'Quaxo', N'70256 Onsgard Road', NULL, N'Oklahoma City', N'73147', N'1615108403', N'OK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1202, N'Eadel', N'244 Algoma Alley', NULL, N'Gatesville', N'76598', N'0143726734', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1203, N'Vinte', N'8 Anhalt Park', NULL, N'Mount Vernon', N'10557', N'9880352171', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1204, N'Fatz', N'0 Almo Avenue', NULL, N'Atlanta', N'30328', N'4829720797', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1205, N'Flashspan', N'2 Surrey Pass', NULL, N'Stockton', N'95219', N'3740908099', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1206, N'Rhycero', N'662 Ronald Regan Center', NULL, N'Washington', N'20260', N'7604078023', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1207, N'Zoonoodle', N'43 Hanson Circle', NULL, N'Tucson', N'85705', N'4715822296', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1208, N'Wikivu', N'26658 Eastlawn Parkway', NULL, N'Dallas', N'75342', N'3610849678', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1209, N'Roombo', N'2918 Lillian Terrace', NULL, N'Tallahassee', N'32399', N'4617450075', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1210, N'Ainyx', N'87585 Texas Terrace', NULL, N'San Bernardino', N'92410', N'6243400574', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1211, N'Photofeed', N'04 Village Parkway', NULL, N'Akron', N'44305', N'5636407114', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1212, N'Browseblab', N'12 Karstens Street', NULL, N'Santa Fe', N'87505', N'1891226600', N'NM')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1213, N'Mydeo', N'065 Anderson Terrace', NULL, N'Valley Forge', N'19495', N'9029058428', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1214, N'Eare', N'99546 Haas Junction', NULL, N'Los Angeles', N'90060', N'6029723982', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1215, N'Gigaclub', N'27889 Spaight Junction', NULL, N'Boise', N'83711', N'2203747572', N'ID')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1216, N'Skipstorm', N'704 Dapin Place', NULL, N'Schenectady', N'12325', N'2492612334', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1217, N'Lajo', N'24 Lakewood Gardens Alley', NULL, N'Saginaw', N'48604', N'7240755879', N'MI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1218, N'Kwideo', N'3 Eagan Pass', NULL, N'Metairie', N'70005', N'2362122034', N'LA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1219, N'Yombu', N'280 Acker Drive', NULL, N'Mesquite', N'75185', N'5225726206', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1220, N'Youfeed', N'1 Washington Junction', NULL, N'Austin', N'78710', N'9053649560', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1221, N'Wikibox', N'55657 Vera Circle', NULL, N'Houston', N'77015', N'3998192875', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1222, N'Wikizz', N'5856 Almo Drive', NULL, N'Anaheim', N'92825', N'2083572860', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1223, N'Tagfeed', N'5730 Linden Hill', NULL, N'Jefferson City', N'65105', N'2090263688', N'MO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1224, N'Tagfeed', N'2 Clarendon Point', NULL, N'Elmira', N'14905', N'6626006758', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1225, N'Edgetag', N'96 Parkside Alley', NULL, N'Saint Paul', N'55115', N'6343988506', N'MN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1226, N'Devcast', N'0411 Northland Lane', NULL, N'Oklahoma City', N'73152', N'2133031491', N'OK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1227, N'Skipstorm', N'2880 Everett Court', NULL, N'Jamaica', N'11499', N'0072142227', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1228, N'Kwimbee', N'895 Sullivan Hill', NULL, N'Miami', N'33233', N'5586005561', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1229, N'Shufflebeat', N'81968 Annamark Park', NULL, N'Providence', N'2912', N'1719246670', N'RI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1230, N'Feedfire', N'3087 Utah Point', NULL, N'Corpus Christi', N'78470', N'3674076120', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1231, N'Edgeify', N'6 Karstens Way', NULL, N'Saint Augustine', N'32092', N'9752699507', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1232, N'Bubblebox', N'117 Vernon Trail', NULL, N'Saint Paul', N'55108', N'2684671204', N'MN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1233, N'Feedmix', N'2837 Aberg Avenue', NULL, N'Richmond', N'23225', N'2912315439', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1234, N'Agimba', N'35 Raven Pass', NULL, N'Charleston', N'29416', N'6556639836', N'SC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1235, N'Bubblebox', N'9447 Miller Court', NULL, N'Jacksonville', N'32255', N'2239196914', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1236, N'Yodo', N'73509 Onsgard Circle', NULL, N'Rochester', N'14646', N'0613897347', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1237, N'Buzzbean', N'87460 Talisman Lane', NULL, N'Bellevue', N'98008', N'7411071364', N'WA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1238, N'Janyx', N'95986 Pierstorff Street', NULL, N'Louisville', N'40215', N'0488565707', N'KY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1239, N'Twinte', N'898 Macpherson Crossing', NULL, N'Phoenix', N'85025', N'6679576737', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1240, N'Lajo', N'1639 Sullivan Circle', NULL, N'Milwaukee', N'53285', N'9624394794', N'WI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1241, N'Twitterbeat', N'5676 Bobwhite Avenue', NULL, N'Columbus', N'43204', N'3403251145', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1242, N'Skimia', N'2 Brickson Park Center', NULL, N'Miami', N'33245', N'8523054176', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1243, N'Jetpulse', N'1 Dunning Point', NULL, N'Cleveland', N'44177', N'6166402095', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1244, N'Avavee', N'44616 Donald Center', NULL, N'Sacramento', N'95833', N'8056628839', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1245, N'Vimbo', N'64492 8th Place', NULL, N'Killeen', N'76544', N'1807876079', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1246, N'Centizu', N'97 Saint Paul Place', NULL, N'Greenville', N'29615', N'6014909516', N'SC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1247, N'Yacero', N'7 Bartelt Crossing', NULL, N'Phoenix', N'85045', N'7441354438', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1248, N'Thoughtstorm', N'7 Oak Court', NULL, N'Madison', N'53705', N'6069905808', N'WI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1249, N'Thoughtbridge', N'7773 Colorado Street', NULL, N'Seattle', N'98115', N'9322311674', N'WA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1250, N'Aimbo', N'39652 Towne Lane', NULL, N'Lynchburg', N'24503', N'9076399885', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1251, N'Gabcube', N'277 Schlimgen Junction', NULL, N'Pittsburgh', N'15250', N'7111075136', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1252, N'Ainyx', N'88 Haas Way', NULL, N'Minneapolis', N'55441', N'0670733129', N'MN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1253, N'Vipe', N'7 Maple Wood Center', NULL, N'Pensacola', N'32590', N'2044903751', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1254, N'Yata', N'94271 Golf View Lane', NULL, N'Largo', N'34643', N'3099272342', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1255, N'Yozio', N'2 Crownhardt Place', NULL, N'Northridge', N'91328', N'8277700667', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1256, N'Agivu', N'481 Arkansas Terrace', NULL, N'Atlanta', N'31106', N'5918272174', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1257, N'Zoombox', N'2937 Superior Court', NULL, N'Tampa', N'33673', N'1723641421', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1258, N'Viva', N'2 Blaine Crossing', NULL, N'Carol Stream', N'60158', N'3663701561', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1259, N'Skimia', N'2000 Mallard Trail', NULL, N'Greensboro', N'27404', N'2267317263', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1260, N'Skiptube', N'01 Forster Terrace', NULL, N'Buffalo', N'14225', N'1433628905', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1261, N'Teklist', N'0194 Brown Terrace', NULL, N'Palm Bay', N'32909', N'3256033780', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1262, N'Eabox', N'92571 Macpherson Hill', NULL, N'Baton Rouge', N'70883', N'3579600750', N'LA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1263, N'Myworks', N'6654 Hazelcrest Alley', NULL, N'Daytona Beach', N'32118', N'6759849202', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1264, N'Bubblemix', N'314 Thackeray Avenue', NULL, N'Cincinnati', N'45238', N'7155702286', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1265, N'Skippad', N'5 Service Way', NULL, N'Round Rock', N'78682', N'6910746957', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1266, N'Ailane', N'8048 Mifflin Court', NULL, N'San Bernardino', N'92424', N'5561138927', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1267, N'Skyvu', N'39457 Weeping Birch Junction', NULL, N'Johnson City', N'37605', N'9154995763', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1268, N'Oozz', N'100 Valley Edge Court', NULL, N'Bradenton', N'34205', N'1189407763', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1269, N'Pixope', N'374 Lakewood Parkway', NULL, N'Joliet', N'60435', N'9997272378', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1270, N'Rhynyx', N'866 Reinke Street', NULL, N'Richmond', N'23203', N'1989645115', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1271, N'Dabjam', N'29 5th Road', NULL, N'Topeka', N'66667', N'3292264920', N'KS')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1272, N'Avamm', N'0284 Old Gate Street', NULL, N'Sacramento', N'95894', N'2445148796', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1273, N'Lajo', N'2 Schmedeman Parkway', NULL, N'Tyler', N'75710', N'6902475825', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1274, N'Kwimbee', N'83 Susan Plaza', NULL, N'Philadelphia', N'19109', N'8677492133', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1275, N'Quinu', N'64 Dunning Alley', NULL, N'Des Moines', N'50320', N'5007861624', N'IA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1276, N'Babblestorm', N'6285 Farmco Street', NULL, N'Tulsa', N'74108', N'3721103985', N'OK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1277, N'Buzzster', N'764 Farragut Lane', NULL, N'Portland', N'97255', N'9250671879', N'OR')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1278, N'Quatz', N'293 Hintze Way', NULL, N'Knoxville', N'37931', N'7838520439', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1279, N'Skimia', N'32328 Browning Road', NULL, N'West Palm Beach', N'33416', N'6129539667', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1280, N'Mudo', N'458 Riverside Parkway', NULL, N'Colorado Springs', N'80930', N'1049910283', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1281, N'Centidel', N'51256 Duke Center', NULL, N'North Little Rock', N'72118', N'4110473089', N'AR')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1282, N'Cogidoo', N'36730 Duke Circle', NULL, N'Louisville', N'40266', N'5038941114', N'KY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1283, N'Devpoint', N'747 Cherokee Court', NULL, N'Jeffersonville', N'47134', N'1956810299', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1284, N'Livepath', N'8 Melby Park', NULL, N'San Diego', N'92121', N'3626689597', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1285, N'Reallinks', N'5 Jenifer Avenue', NULL, N'Johnstown', N'15906', N'4261701721', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1286, N'Mynte', N'56435 Bunker Hill Street', NULL, N'Roanoke', N'24020', N'8769710495', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1287, N'Divavu', N'7 Mosinee Point', NULL, N'Wilmington', N'19805', N'2222491530', N'DE')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1288, N'Zoonoodle', N'60689 Alpine Parkway', NULL, N'Atlanta', N'31119', N'9284331441', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1289, N'Thoughtsphere', N'184 Cordelia Junction', NULL, N'Tucson', N'85715', N'0358252443', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1290, N'Voonix', N'90 New Castle Avenue', NULL, N'Cleveland', N'44185', N'2806891755', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1291, N'Kayveo', N'44 Aberg Plaza', NULL, N'Atlanta', N'30386', N'8387134408', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1292, N'Quinu', N'5 Nancy Parkway', NULL, N'Brockton', N'2405', N'6397974083', N'MA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1293, N'Yoveo', N'771 7th Crossing', NULL, N'Bethlehem', N'18018', N'7502032250', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1294, N'Meemm', N'49 Crowley Street', NULL, N'Dallas', N'75210', N'4803207265', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1295, N'Photolist', N'680 Westport Way', NULL, N'Visalia', N'93291', N'2710127604', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1296, N'Jaxbean', N'58 Muir Plaza', NULL, N'Chicago', N'60669', N'1921908183', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1297, N'Demivee', N'52061 Luster Lane', NULL, N'Omaha', N'68144', N'5379729367', N'NE')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1298, N'Skalith', N'297 New Castle Park', NULL, N'Mesa', N'85215', N'9245867486', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1299, N'Snaptags', N'2615 Russell Drive', NULL, N'Richmond', N'23293', N'7554542959', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1300, N'Linktype', N'9756 Glendale Junction', NULL, N'Fort Wayne', N'46805', N'0206764469', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1301, N'Jaxbean', N'8927 Sunnyside Center', NULL, N'Anchorage', N'99512', N'4297300395', N'AK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1302, N'Flashset', N'0 Orin Trail', NULL, N'Houston', N'77035', N'1955127781', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1303, N'Blognation', N'7 Bartelt Crossing', NULL, N'Bronx', N'10474', N'6495832271', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1304, N'Yodo', N'6708 Sunnyside Drive', NULL, N'Frederick', N'21705', N'2883832388', N'MD')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1305, N'Reallinks', N'1 Moulton Terrace', NULL, N'Sunnyvale', N'94089', N'7867259910', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1306, N'Meembee', N'6300 Victoria Alley', NULL, N'Knoxville', N'37939', N'2464180853', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1307, N'Kimia', N'2 Rockefeller Pass', NULL, N'Peoria', N'85383', N'0701705880', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1308, N'Skinder', N'455 Roth Court', NULL, N'Houston', N'77075', N'8222021354', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1309, N'Ailane', N'93 Scofield Circle', NULL, N'Detroit', N'48211', N'1225552771', N'MI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1310, N'Skyvu', N'09 Canary Street', NULL, N'Washington', N'20067', N'2522129512', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1311, N'Brainbox', N'4 Vahlen Crossing', NULL, N'Buffalo', N'14269', N'6622600646', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1312, N'Jaxworks', N'97 Prairieview Park', NULL, N'Richmond', N'23293', N'7767344564', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1313, N'Pixonyx', N'232 Bellgrove Parkway', NULL, N'Dallas', N'75287', N'8371050068', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1314, N'Linkbridge', N'19686 Blackbird Circle', NULL, N'Hialeah', N'33013', N'3378516091', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1315, N'Browsezoom', N'991 Nelson Lane', NULL, N'Orlando', N'32859', N'1257808772', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1316, N'Roombo', N'61 3rd Lane', NULL, N'Mobile', N'36641', N'5011980637', N'AL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1317, N'Einti', N'9835 Mallard Trail', NULL, N'Memphis', N'38119', N'0378891977', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1318, N'Skyble', N'926 Cordelia Park', NULL, N'Peoria', N'61605', N'0674903342', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1319, N'Zooveo', N'27 Melby Plaza', NULL, N'Austin', N'78789', N'4933005421', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1320, N'Babbleset', N'8 Bobwhite Terrace', NULL, N'Palmdale', N'93591', N'7648208989', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1321, N'Topiczoom', N'67 Algoma Circle', NULL, N'Nashville', N'37210', N'0572173769', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1322, N'Tagtune', N'6 Darwin Terrace', NULL, N'Charlotte', N'28225', N'4782499282', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1323, N'Zoonder', N'35 Moulton Center', NULL, N'Wilmington', N'19892', N'4773208198', N'DE')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1324, N'Kamba', N'76378 Lakewood Gardens Junction', NULL, N'Tyler', N'75705', N'2611104149', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1325, N'Edgeclub', N'05860 Dayton Plaza', NULL, N'Atlanta', N'30392', N'0862922971', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1326, N'Camimbo', N'50897 Memorial Circle', NULL, N'Hartford', N'6120', N'9281544245', N'CT')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1327, N'Browsedrive', N'6 Bunting Court', NULL, N'Las Vegas', N'89193', N'5237994733', N'NV')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1328, N'Twitterwire', N'09551 Melrose Terrace', NULL, N'Austin', N'78721', N'7688979649', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1329, N'Wikizz', N'31 Lunder Hill', NULL, N'Tyler', N'75710', N'2789170783', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1330, N'Dabfeed', N'599 Summer Ridge Avenue', NULL, N'Pueblo', N'81015', N'2125067250', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1331, N'Eadel', N'7570 Sunnyside Pass', NULL, N'Lees Summit', N'64082', N'5223944831', N'MO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1332, N'Katz', N'455 Buena Vista Court', NULL, N'Homestead', N'33034', N'0897601028', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1333, N'BlogXS', N'370 Armistice Place', NULL, N'Hamilton', N'45020', N'5493577796', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1334, N'Gabtype', N'359 Duke Terrace', NULL, N'Santa Rosa', N'95405', N'8750414878', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1335, N'Skinder', N'8 Utah Circle', NULL, N'Orlando', N'32868', N'1206111445', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1336, N'Rhyloo', N'30 Reindahl Parkway', NULL, N'Fort Collins', N'80525', N'5877597588', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1337, N'Centidel', N'08 Veith Terrace', NULL, N'Roanoke', N'24014', N'2537111144', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1338, N'Quinu', N'13280 Meadow Valley Lane', NULL, N'West Palm Beach', N'33421', N'4712779207', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1339, N'Skidoo', N'81670 Melody Terrace', NULL, N'Wichita', N'67220', N'4418824142', N'KS')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1340, N'Avaveo', N'973 Di Loreto Pass', NULL, N'Knoxville', N'37919', N'2729893832', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1341, N'Miboo', N'9 Green Ridge Point', NULL, N'Pinellas Park', N'34665', N'3156494258', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1342, N'Meezzy', N'5 Corben Drive', NULL, N'Tucson', N'85705', N'7833775875', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1343, N'Blogspan', N'0 Brentwood Street', NULL, N'Jamaica', N'11407', N'8855087742', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1344, N'Cogidoo', N'001 Sachtjen Crossing', NULL, N'High Point', N'27264', N'9683597958', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1345, N'Muxo', N'15 Garrison Lane', NULL, N'Columbus', N'39705', N'7206004469', N'MS')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1346, N'Digitube', N'900 Prentice Terrace', NULL, N'Fairbanks', N'99709', N'0240972607', N'AK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1347, N'Wordify', N'34651 Hollow Ridge Place', NULL, N'El Paso', N'79989', N'3923965093', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1348, N'Quimba', N'692 8th Drive', NULL, N'Saint Louis', N'63143', N'9294569554', N'MO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1349, N'Vitz', N'49 Dixon Point', NULL, N'Trenton', N'8638', N'8042659206', N'NJ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1350, N'Dabshots', N'103 Fremont Trail', NULL, N'Milwaukee', N'53215', N'6707017380', N'WI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1351, N'Bubblebox', N'800 Upham Crossing', NULL, N'Las Vegas', N'89120', N'3417648270', N'NV')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1352, N'Livetube', N'6 Sycamore Crossing', NULL, N'Peoria', N'61651', N'1677246196', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1353, N'Ainyx', N'522 Sommers Drive', NULL, N'Houston', N'77040', N'4704298507', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1354, N'Aimbo', N'231 Ryan Alley', NULL, N'Gastonia', N'28055', N'7677001802', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1355, N'Jaxbean', N'49772 Manley Terrace', NULL, N'Memphis', N'38181', N'7507379832', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1356, N'Layo', N'64 6th Park', NULL, N'Pittsburgh', N'15205', N'4162325814', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1357, N'Skyvu', N'788 Sloan Street', NULL, N'Pittsburgh', N'15205', N'4190700681', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1358, N'Zooxo', N'2 Erie Avenue', NULL, N'Jackson', N'39210', N'2041938419', N'MS')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1359, N'Divavu', N'3 Elka Center', NULL, N'Rochester', N'14639', N'4045686851', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1360, N'Twinder', N'89231 Walton Alley', NULL, N'Winston Salem', N'27150', N'3584676155', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1361, N'Jaxworks', N'22 Morrow Pass', NULL, N'Roanoke', N'24034', N'6959913715', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1362, N'Bluezoom', N'957 Rieder Point', NULL, N'Sterling', N'20167', N'7590941747', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1363, N'Trunyx', N'76 Evergreen Trail', NULL, N'Washington', N'20238', N'2614893823', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1364, N'Realfire', N'03 Dixon Center', NULL, N'Fort Pierce', N'34981', N'0295407795', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1365, N'Wordify', N'9 Maple Wood Trail', NULL, N'North Hollywood', N'91606', N'6852398307', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1366, N'Photobug', N'294 Victoria Way', NULL, N'Seattle', N'98185', N'0191429675', N'WA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1367, N'Devify', N'6 Continental Terrace', NULL, N'Saint Petersburg', N'33737', N'7939691752', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1368, N'Fadeo', N'8969 Cascade Park', NULL, N'Minneapolis', N'55423', N'5967597996', N'MN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1369, N'Twinder', N'3345 Holmberg Avenue', NULL, N'Augusta', N'30911', N'1641881831', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1370, N'Yakitri', N'60023 Lakewood Drive', NULL, N'Indianapolis', N'46254', N'9792622967', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1371, N'Gabtune', N'677 Monterey Parkway', NULL, N'Jamaica', N'11431', N'9712299185', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1372, N'Trudoo', N'6 Forest Place', NULL, N'Tulsa', N'74116', N'7124261102', N'OK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1373, N'Shufflebeat', N'4915 Jenifer Avenue', NULL, N'Pittsburgh', N'15235', N'1655471057', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1374, N'Meembee', N'2280 Maryland Center', NULL, N'Atlanta', N'30311', N'3379462828', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1375, N'Cogilith', N'8 Village Green Hill', NULL, N'Albany', N'12237', N'9658424902', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1376, N'Realbuzz', N'50909 Katie Street', NULL, N'Bakersfield', N'93305', N'8336056503', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1377, N'Thoughtstorm', N'06 Clove Court', NULL, N'Dallas', N'75241', N'0811162945', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1378, N'Fadeo', N'094 Moland Trail', NULL, N'Louisville', N'40215', N'0827931942', N'KY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1379, N'Edgepulse', N'4 Rutledge Way', NULL, N'Orlando', N'32885', N'7368785851', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1380, N'Flashspan', N'87249 Arizona Park', NULL, N'Clearwater', N'33763', N'1094462081', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1381, N'Skippad', N'26378 Gale Terrace', NULL, N'Indianapolis', N'46295', N'6149031203', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1382, N'Yambee', N'75462 Merchant Street', NULL, N'Long Beach', N'90831', N'0797002359', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1383, N'Trilith', N'069 Hanover Park', NULL, N'Austin', N'78710', N'6512702836', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1384, N'Leenti', N'69037 Colorado Pass', NULL, N'Anchorage', N'99517', N'5540867052', N'AK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1385, N'Tanoodle', N'64 Esch Avenue', NULL, N'El Paso', N'88563', N'6115536547', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1386, N'Podcat', N'171 Mallory Crossing', NULL, N'Indianapolis', N'46226', N'5842024734', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1387, N'Quinu', N'52679 1st Junction', NULL, N'Dayton', N'45470', N'6551096756', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1388, N'Buzzbean', N'24473 Stoughton Pass', NULL, N'Baltimore', N'21239', N'8219859026', N'MD')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1389, N'Photofeed', N'4717 Becker Center', NULL, N'Birmingham', N'35210', N'6153165121', N'AL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1390, N'Jabberstorm', N'4 Orin Hill', NULL, N'Houston', N'77030', N'8011841375', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1391, N'Zoonoodle', N'0740 Vera Point', NULL, N'Greensboro', N'27404', N'7869422868', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1392, N'Devshare', N'0433 Ridgeway Trail', NULL, N'Suffolk', N'23436', N'5803279107', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1393, N'Voonder', N'234 Hovde Center', NULL, N'Corpus Christi', N'78405', N'7798122572', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1394, N'Jaloo', N'6684 Ridge Oak Drive', NULL, N'Huntington', N'25711', N'2510887431', N'WV')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1395, N'Ntag', N'7085 Morning Crossing', NULL, N'Richmond', N'23272', N'3159976488', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1396, N'Linktype', N'569 Hollow Ridge Place', NULL, N'Brea', N'92822', N'3887949148', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1397, N'Voonyx', N'9 Oneill Crossing', NULL, N'Washington', N'20260', N'2263970352', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1398, N'Divanoodle', N'988 Roth Circle', NULL, N'Saint Louis', N'63116', N'7123115183', N'MO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1399, N'Kazio', N'3 Haas Point', NULL, N'San Diego', N'92132', N'3842677751', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1400, N'Skibox', N'38 New Castle Terrace', NULL, N'Little Rock', N'72209', N'1351328700', N'AR')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1401, N'Realmix', N'0371 Meadow Valley Parkway', NULL, N'Washington', N'20041', N'6941843876', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1402, N'Skyvu', N'0673 Mallard Junction', NULL, N'Oakland', N'94616', N'1932643892', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1403, N'Jetpulse', N'9 Northridge Terrace', NULL, N'Washington', N'20557', N'5823098476', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1404, N'Tazzy', N'7778 Dryden Plaza', NULL, N'Philadelphia', N'19196', N'8176010813', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1405, N'Vidoo', N'710 Coolidge Avenue', NULL, N'Sacramento', N'94297', N'2704924881', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1406, N'Shufflester', N'34683 Fuller Hill', NULL, N'Pittsburgh', N'15274', N'2143486392', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1407, N'Fliptune', N'53 1st Parkway', NULL, N'Inglewood', N'90398', N'3087256833', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1408, N'Photofeed', N'578 Kinsman Point', NULL, N'South Bend', N'46620', N'3271112939', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1409, N'Skinder', N'69158 Blaine Plaza', NULL, N'Raleigh', N'27605', N'4770031802', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1410, N'Bubbletube', N'45511 Porter Pass', NULL, N'Chicago', N'60636', N'6769392971', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1411, N'Mymm', N'43 Harbort Center', NULL, N'San Antonio', N'78278', N'1689178857', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1412, N'Twitterbeat', N'62987 South Circle', NULL, N'Flint', N'48555', N'1024091395', N'MI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1413, N'Yadel', N'2822 Village Green Junction', NULL, N'Kansas City', N'64101', N'5815991145', N'MO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1414, N'Midel', N'0 Maywood Center', NULL, N'San Luis Obispo', N'93407', N'9130767501', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1415, N'Eazzy', N'066 Dahle Alley', NULL, N'Chicago', N'60636', N'3874853716', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1416, N'Pixope', N'49 Green Street', NULL, N'Tulsa', N'74193', N'6037705236', N'OK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1417, N'Topdrive', N'3 Jenna Avenue', NULL, N'Flint', N'48550', N'3727119608', N'MI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1418, N'Twitterworks', N'3 Maryland Place', NULL, N'Des Moines', N'50347', N'9774581538', N'IA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1419, N'Kaymbo', N'17036 North Park', NULL, N'Midland', N'79705', N'3844374415', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1420, N'Fadeo', N'85176 Atwood Parkway', NULL, N'Des Moines', N'50320', N'5153179806', N'IA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1421, N'Janyx', N'972 Farragut Way', NULL, N'Washington', N'20337', N'9537406074', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1422, N'Oyoba', N'747 Merry Trail', NULL, N'Sioux City', N'51110', N'6441008051', N'IA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1423, N'Kayveo', N'48325 Village Green Alley', NULL, N'Littleton', N'80127', N'5461200887', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1424, N'Eabox', N'9720 Spenser Terrace', NULL, N'Milwaukee', N'53215', N'9716657913', N'WI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1425, N'Browsecat', N'53337 North Terrace', NULL, N'Wilkes Barre', N'18768', N'1550024536', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1426, N'Mymm', N'654 Veith Way', NULL, N'Erie', N'16534', N'1979548303', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1427, N'Jamia', N'1993 Superior Street', NULL, N'Topeka', N'66642', N'9637459433', N'KS')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1428, N'Skinix', N'667 Cardinal Court', NULL, N'Denver', N'80223', N'6125003283', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1429, N'Rhycero', N'50088 Warrior Way', NULL, N'Boston', N'2203', N'3907270916', N'MA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1430, N'Quamba', N'9737 Elka Crossing', NULL, N'Saint Louis', N'63136', N'7036169217', N'MO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1431, N'Zoomdog', N'1738 Morningstar Point', NULL, N'Boulder', N'80328', N'9081917966', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1432, N'Eamia', N'137 Roxbury Point', NULL, N'Miami', N'33245', N'7112038922', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1433, N'Devbug', N'85 Kenwood Road', NULL, N'Birmingham', N'35220', N'3728773321', N'AL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1434, N'Demizz', N'7102 Springview Avenue', NULL, N'Dallas', N'75392', N'5264197081', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1435, N'Babblestorm', N'2937 Sycamore Road', NULL, N'San Mateo', N'94405', N'5737371371', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1436, N'Mymm', N'8924 Di Loreto Road', NULL, N'Youngstown', N'44505', N'1164062423', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1437, N'Skipfire', N'09 Truax Junction', NULL, N'Washington', N'20503', N'1087101323', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1438, N'Mymm', N'98843 Schurz Center', NULL, N'Louisville', N'40225', N'3318644396', N'KY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1439, N'Fanoodle', N'5771 Duke Center', NULL, N'El Paso', N'88569', N'0945507013', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1440, N'Buzzshare', N'926 Hazelcrest Junction', NULL, N'Pensacola', N'32590', N'7186076923', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1441, N'Skalith', N'20016 Eastlawn Park', NULL, N'Detroit', N'48232', N'2247477733', N'MI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1442, N'Oodoo', N'0677 Forest Parkway', NULL, N'Bethesda', N'20816', N'9728584603', N'MD')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1443, N'Podcat', N'11 Twin Pines Place', NULL, N'Spokane', N'99210', N'0445365252', N'WA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1444, N'Browseblab', N'19 Thierer Point', NULL, N'College Station', N'77844', N'2434998916', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1445, N'Vinder', N'80 Debs Point', NULL, N'Los Angeles', N'90020', N'2326383632', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1446, N'Flipbug', N'24547 Oakridge Way', NULL, N'Trenton', N'8695', N'0005630323', N'NJ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1447, N'Twitterworks', N'96515 Melby Court', NULL, N'Toledo', N'43635', N'1581895427', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1448, N'Oyonder', N'60 Nevada Center', NULL, N'Raleigh', N'27621', N'3503447755', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1449, N'Quinu', N'3 Warner Junction', NULL, N'Houston', N'77240', N'7070187175', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1450, N'Browsebug', N'7 Paget Plaza', NULL, N'Philadelphia', N'19125', N'6832266720', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1451, N'Skiptube', N'304 Burning Wood Drive', NULL, N'Amarillo', N'79171', N'4726095015', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1452, N'Vinder', N'242 Summerview Plaza', NULL, N'Washington', N'20046', N'3359577358', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1453, N'Gigazoom', N'7110 Gateway Circle', NULL, N'Young America', N'55551', N'6275397270', N'MN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1454, N'Yodoo', N'9462 Colorado Court', NULL, N'Myrtle Beach', N'29579', N'4162541113', N'SC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1455, N'Jetwire', N'832 Memorial Plaza', NULL, N'Riverside', N'92519', N'0028658289', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1456, N'Yotz', N'5 Birchwood Trail', NULL, N'Fort Worth', N'76121', N'9324822764', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1457, N'Photobug', N'78 Dixon Parkway', NULL, N'Akron', N'44329', N'7113346706', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1458, N'Realpoint', N'73362 Hintze Circle', NULL, N'Brockton', N'2405', N'6713969807', N'MA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1459, N'InnoZ', N'0744 Acker Crossing', NULL, N'Charleston', N'25336', N'7324840323', N'WV')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1460, N'Eare', N'73016 Porter Avenue', NULL, N'Wichita', N'67236', N'7951442661', N'KS')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1461, N'Devcast', N'05022 Muir Center', NULL, N'Chico', N'95973', N'3684423633', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1462, N'Edgeblab', N'5 6th Crossing', NULL, N'Tampa', N'33615', N'2622873753', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1463, N'Yadel', N'3 Luster Place', NULL, N'Trenton', N'8650', N'8080753423', N'NJ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1464, N'Jabberstorm', N'41 International Hill', NULL, N'Cincinnati', N'45254', N'3209298210', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1465, N'Voonix', N'84 Grover Junction', NULL, N'Austin', N'78737', N'9651230244', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1466, N'Npath', N'3 Cardinal Junction', NULL, N'Toledo', N'43656', N'8360203777', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1467, N'Tagchat', N'9 Moulton Place', NULL, N'Saint Cloud', N'56398', N'4976836684', N'MN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1468, N'Trilith', N'3 Northview Pass', NULL, N'Erie', N'16505', N'0863137421', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1469, N'Zoonder', N'16 Drewry Court', NULL, N'Buffalo', N'14220', N'5746906303', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1470, N'Jabberstorm', N'790 Golf View Crossing', NULL, N'Brockton', N'2305', N'5396682067', N'MA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1471, N'Gigazoom', N'35844 Starling Center', NULL, N'Meridian', N'39305', N'8513367467', N'MS')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1472, N'Linklinks', N'0386 Boyd Parkway', NULL, N'Chicago', N'60636', N'3587853041', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1473, N'Skinte', N'0586 Manufacturers Plaza', NULL, N'Albuquerque', N'87180', N'7106830177', N'NM')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1474, N'Browseblab', N'95785 Hansons Hill', NULL, N'Miami', N'33142', N'9558655365', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1475, N'Blognation', N'426 Roth Trail', NULL, N'Oakland', N'94611', N'1331129633', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1476, N'Dynazzy', N'0864 Bultman Point', NULL, N'Dallas', N'75210', N'2863895999', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1477, N'Voonyx', N'14505 Jana Parkway', NULL, N'Arlington', N'76011', N'0846530214', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1478, N'LiveZ', N'3 Parkside Parkway', NULL, N'Biloxi', N'39534', N'9530478858', N'MS')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1479, N'Avavee', N'3472 Magdeline Trail', NULL, N'Des Moines', N'50335', N'7494159243', N'IA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1480, N'Voomm', N'570 Starling Pass', NULL, N'Buffalo', N'14210', N'1001951160', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1481, N'Riffwire', N'011 Helena Circle', NULL, N'Pittsburgh', N'15210', N'1707133577', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1482, N'Meedoo', N'25 Dunning Trail', NULL, N'Miami', N'33142', N'5596396138', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1483, N'Ntags', N'02 Morning Parkway', NULL, N'Bakersfield', N'93399', N'4552366569', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1484, N'Thoughtmix', N'92 Canary Crossing', NULL, N'Boise', N'83757', N'3280426741', N'ID')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1485, N'Kimia', N'23 Spohn Street', NULL, N'Newark', N'7104', N'5444493603', N'NJ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1486, N'Feedfire', N'3897 Sheridan Hill', NULL, N'Cincinnati', N'45271', N'3772028729', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1487, N'Tagopia', N'593 Laurel Point', NULL, N'Orlando', N'32885', N'5421190908', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1488, N'Centidel', N'1251 7th Way', NULL, N'Charlotte', N'28225', N'2165676411', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1489, N'Pixoboo', N'315 Farragut Street', NULL, N'Memphis', N'38104', N'1012805715', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1490, N'Demizz', N'426 Knutson Place', NULL, N'Tucson', N'85732', N'1931244592', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1491, N'Thoughtblab', N'490 Mcguire Lane', NULL, N'Cincinnati', N'45254', N'2191029266', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1492, N'Gigabox', N'43 Donald Lane', NULL, N'Huntsville', N'77343', N'4463638701', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1493, N'Fadeo', N'66 Bunting Crossing', NULL, N'Little Rock', N'72209', N'3676578746', N'AR')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1494, N'Trupe', N'95 Towne Park', NULL, N'New York City', N'10099', N'1386792159', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1495, N'Brainsphere', N'2 Comanche Terrace', NULL, N'Naperville', N'60567', N'6511968935', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1496, N'Wikibox', N'2 Monument Pass', NULL, N'Shawnee Mission', N'66220', N'2923932879', N'KS')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1497, N'Oozz', N'11944 Hansons Avenue', NULL, N'Schenectady', N'12325', N'5185792075', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1498, N'Zava', N'3 Petterle Court', NULL, N'Saint Paul', N'55123', N'2144857874', N'MN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1499, N'Trilith', N'167 Old Gate Center', NULL, N'Rochester', N'55905', N'7068350916', N'MN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1500, N'Dazzlesphere', N'2 Autumn Leaf Alley', NULL, N'Santa Ana', N'92705', N'3989629033', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1501, N'Tagchat', N'3644 Burning Wood Court', NULL, N'Fort Myers', N'33913', N'3871077915', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1502, N'Edgewire', N'5 Pankratz Pass', NULL, N'Anderson', N'46015', N'6458697502', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1503, N'Agimba', N'24 Larry Drive', NULL, N'Washington', N'20503', N'2957529723', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1504, N'Jaloo', N'7 Esker Trail', NULL, N'Sacramento', N'95828', N'7298053686', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1505, N'Skinix', N'34063 Parkside Alley', NULL, N'Lancaster', N'93584', N'5268467291', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1506, N'Tanoodle', N'070 Sherman Drive', NULL, N'Detroit', N'48232', N'1131639614', N'MI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1507, N'Zoomcast', N'23 Moose Junction', NULL, N'Toledo', N'43656', N'7374256879', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1508, N'Voonder', N'9925 Ruskin Pass', NULL, N'Lexington', N'40546', N'4507301355', N'KY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1509, N'Skibox', N'5 Clyde Gallagher Street', NULL, N'College Station', N'77844', N'5682517374', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1510, N'Zoomdog', N'7 International Alley', NULL, N'Washington', N'20404', N'2102198575', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1511, N'Minyx', N'0129 Truax Lane', NULL, N'Minneapolis', N'55458', N'8021340554', N'MN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1512, N'Mita', N'404 Graceland Alley', NULL, N'Sacramento', N'94207', N'5677979939', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1513, N'Zoomdog', N'740 Trailsway Point', NULL, N'Austin', N'78744', N'8737746250', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1514, N'Fivespan', N'18 Anthes Point', NULL, N'Nashville', N'37250', N'7829609778', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1515, N'Gigazoom', N'62 Annamark Lane', NULL, N'Phoenix', N'85099', N'9335435119', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1516, N'Mydeo', N'715 Paget Hill', NULL, N'Gainesville', N'32627', N'7474700880', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1517, N'Skynoodle', N'25465 Brown Way', NULL, N'New Orleans', N'70124', N'6800173144', N'LA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1518, N'Skajo', N'9 Maple Wood Avenue', NULL, N'Nashville', N'37235', N'2426166432', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1519, N'Quatz', N'583 Mallard Lane', NULL, N'Baton Rouge', N'70836', N'5038820366', N'LA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1520, N'Gabtype', N'76 Carberry Lane', NULL, N'Port Charlotte', N'33954', N'2107571701', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1521, N'Avamba', N'58295 Magdeline Drive', NULL, N'Pueblo', N'81005', N'2264280282', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1522, N'Oodoo', N'30 Manley Pass', NULL, N'Evansville', N'47712', N'9565150404', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1523, N'Devify', N'96 Truax Trail', NULL, N'Shreveport', N'71161', N'0107800039', N'LA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1524, N'Tambee', N'937 Golf Point', NULL, N'Mc Keesport', N'15134', N'0617489630', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1525, N'Dabtype', N'0 Mesta Lane', NULL, N'New Brunswick', N'8922', N'0449579835', N'NJ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1526, N'Snaptags', N'40 Loftsgordon Avenue', NULL, N'Tampa', N'33625', N'7533070627', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1527, N'Gabtype', N'192 Hoard Circle', NULL, N'Washington', N'20099', N'0044442356', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1528, N'Yacero', N'1743 Nobel Parkway', NULL, N'Midland', N'79710', N'9880303593', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1529, N'Avaveo', N'89953 Nobel Circle', NULL, N'Springfield', N'62705', N'9304038404', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1530, N'Thoughtmix', N'5 Schiller Place', NULL, N'Scottsdale', N'85271', N'7837580908', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1531, N'Zoomdog', N'40443 Loomis Center', NULL, N'Little Rock', N'72204', N'1469113956', N'AR')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1532, N'Latz', N'924 Main Circle', NULL, N'Greensboro', N'27425', N'8078785214', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1533, N'Shufflester', N'29 Fisk Park', NULL, N'Syracuse', N'13251', N'6842074119', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1534, N'Youspan', N'05 Lighthouse Bay Street', NULL, N'Louisville', N'40293', N'9465998715', N'KY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1535, N'Buzzster', N'8 Loomis Parkway', NULL, N'Topeka', N'66617', N'4956053167', N'KS')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1536, N'Kayveo', N'235 Crownhardt Drive', NULL, N'Metairie', N'70033', N'3240708843', N'LA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1537, N'Devpulse', N'6259 Cambridge Crossing', NULL, N'Birmingham', N'35220', N'9573626338', N'AL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1538, N'Zoozzy', N'1023 Johnson Point', NULL, N'San Jose', N'95138', N'8773289125', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1539, N'Agivu', N'84 Rieder Alley', NULL, N'Birmingham', N'35254', N'9885163384', N'AL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1540, N'Topicstorm', N'34 3rd Way', NULL, N'Aurora', N'80015', N'9841814987', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1541, N'Topicstorm', N'7 Canary Lane', NULL, N'Dallas', N'75397', N'7535878969', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1542, N'Tagtune', N'31552 Vahlen Terrace', NULL, N'Brooklyn', N'11220', N'6151480567', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1543, N'Livepath', N'6 Armistice Center', NULL, N'Los Angeles', N'90094', N'6883050906', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1544, N'BlogXS', N'005 Sullivan Terrace', NULL, N'Lexington', N'40596', N'6170010653', N'KY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1545, N'Dynabox', N'3668 Sloan Street', NULL, N'Fresno', N'93704', N'3013875339', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1546, N'Innotype', N'2267 Kensington Trail', NULL, N'Anchorage', N'99512', N'9970694442', N'AK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1547, N'Buzzshare', N'414 Springs Court', NULL, N'Washington', N'20370', N'4357103022', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1548, N'Voonder', N'70239 Lerdahl Trail', NULL, N'San Antonio', N'78245', N'4842554753', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1549, N'Riffwire', N'56 Chive Junction', NULL, N'Boston', N'2114', N'4078475403', N'MA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1550, N'Dynava', N'6136 Vahlen Avenue', NULL, N'Stockton', N'95298', N'9458183198', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1551, N'Meemm', N'855 Kipling Alley', NULL, N'San Diego', N'92160', N'7601720057', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1552, N'Zoombeat', N'1898 Roth Street', NULL, N'Birmingham', N'35231', N'9276659277', N'AL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1553, N'Rhycero', N'9506 Springs Place', NULL, N'Olympia', N'98506', N'6279370618', N'WA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1554, N'Jayo', N'7361 Dawn Lane', NULL, N'West Palm Beach', N'33405', N'7060611049', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1555, N'Realpoint', N'5356 Merrick Lane', NULL, N'Boca Raton', N'33432', N'3005201322', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1556, N'Jaxnation', N'5860 Petterle Place', NULL, N'Philadelphia', N'19125', N'4188860077', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1557, N'Eazzy', N'3495 Sunbrook Parkway', NULL, N'Des Moines', N'50936', N'1302629045', N'IA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1558, N'Yodel', N'511 Sachtjen Circle', NULL, N'Miami', N'33153', N'9345997091', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1559, N'Yadel', N'7758 Esker Hill', NULL, N'Rochester', N'14646', N'8964878869', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1560, N'Edgeify', N'6 Cordelia Crossing', NULL, N'New York City', N'10014', N'7643876504', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1561, N'Omba', N'91 Vidon Trail', NULL, N'Stamford', N'6905', N'6047293252', N'CT')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1562, N'Wordware', N'694 Bultman Center', NULL, N'Oakland', N'94616', N'0495688993', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1563, N'Tagtune', N'10996 Dwight Pass', NULL, N'Houston', N'77090', N'5349548843', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1564, N'Trupe', N'7582 Sommers Crossing', NULL, N'Lubbock', N'79405', N'4903588367', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1565, N'Twinder', N'3 Larry Hill', NULL, N'Seattle', N'98121', N'8627045825', N'WA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1566, N'Zoonoodle', N'52 Clove Place', NULL, N'Los Angeles', N'90040', N'0891394030', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1567, N'Browsetype', N'0 Sunbrook Street', NULL, N'Nashville', N'37220', N'4621181632', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1568, N'Avamm', N'883 Bartillon Way', NULL, N'Boise', N'83705', N'4764221657', N'ID')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1569, N'Eidel', N'441 Tennessee Point', NULL, N'Aurora', N'60505', N'2860806952', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1570, N'Babbleset', N'34 Algoma Avenue', NULL, N'Los Angeles', N'90081', N'3881354839', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1571, N'Jabberstorm', N'9 Duke Way', NULL, N'Durham', N'27710', N'2988298827', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1572, N'Thoughtmix', N'6 Jana Trail', NULL, N'Simi Valley', N'93094', N'3398173958', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1573, N'Agivu', N'80092 Shopko Lane', NULL, N'San Diego', N'92176', N'8984683756', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1574, N'Centizu', N'4410 Mariners Cove Lane', NULL, N'Cleveland', N'44111', N'6955752471', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1575, N'Voomm', N'72310 Sunbrook Pass', NULL, N'Washington', N'20238', N'9381754350', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1576, N'Photofeed', N'686 Mandrake Park', NULL, N'Greeley', N'80638', N'1362722349', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1577, N'Digitube', N'43 Oakridge Junction', NULL, N'Kent', N'98042', N'8987370354', N'WA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1578, N'Jabbercube', N'658 Oneill Hill', NULL, N'San Francisco', N'94164', N'7080438747', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1579, N'Trudeo', N'53 Sheridan Junction', NULL, N'Pittsburgh', N'15235', N'0502049996', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1580, N'Skynoodle', N'63361 Farmco Crossing', NULL, N'Portsmouth', N'23705', N'8136335213', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1581, N'Meembee', N'8849 Lakewood Gardens Terrace', NULL, N'Sacramento', N'95828', N'8822533550', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1582, N'Zoomzone', N'74644 Amoth Alley', NULL, N'New York City', N'10165', N'4305873275', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1583, N'Edgeclub', N'5767 Schurz Street', NULL, N'New Orleans', N'70165', N'0362857782', N'LA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1584, N'Vinder', N'664 Eagle Crest Drive', NULL, N'Lincoln', N'68583', N'1522037136', N'NE')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1585, N'Topicblab', N'4275 Hazelcrest Plaza', NULL, N'Schenectady', N'12325', N'4600627200', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1586, N'Topicware', N'7 Fordem Place', NULL, N'Albuquerque', N'87115', N'5141270484', N'NM')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1587, N'Kaymbo', N'30 Shasta Pass', NULL, N'Lynn', N'1905', N'1360850978', N'MA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1588, N'Kamba', N'0867 Mallory Street', NULL, N'Lafayette', N'70593', N'7283057420', N'LA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1589, N'Kwinu', N'19009 Clarendon Plaza', NULL, N'Amarillo', N'79165', N'4434781419', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1590, N'Kaymbo', N'2256 Bashford Junction', NULL, N'Washington', N'20319', N'3054797370', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1591, N'Jabberstorm', N'64742 Tony Plaza', NULL, N'El Paso', N'79916', N'8652434960', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1592, N'Lazzy', N'23372 Moulton Court', NULL, N'Baton Rouge', N'70894', N'4603357822', N'LA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1593, N'Tagopia', N'0160 Buhler Hill', NULL, N'New York City', N'10292', N'7503237261', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1594, N'Yambee', N'49 Eliot Plaza', NULL, N'Pasadena', N'91117', N'0961072965', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1595, N'Mudo', N'5 Commercial Lane', NULL, N'Colorado Springs', N'80995', N'7365422715', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1596, N'Jayo', N'932 Clove Court', NULL, N'Tulsa', N'74193', N'5613408058', N'OK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1597, N'Kimia', N'51274 Sunbrook Road', NULL, N'Des Moines', N'50320', N'0990062533', N'IA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1598, N'Twitterbridge', N'290 Almo Way', NULL, N'Gastonia', N'28055', N'2295922839', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1599, N'Dynabox', N'97 Lakeland Drive', NULL, N'Tampa', N'33620', N'8461880060', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1600, N'Bluejam', N'80451 Victoria Alley', NULL, N'Orange', N'92668', N'3435623058', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1601, N'Gigazoom', N'61 Ryan Street', NULL, N'Tampa', N'33680', N'4195937380', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1602, N'Dynabox', N'24 Fallview Alley', NULL, N'Trenton', N'8608', N'0009842335', N'NJ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1603, N'Zoonoodle', N'8648 Ohio Drive', NULL, N'Carlsbad', N'92013', N'2681177235', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1604, N'Photobean', N'5 Springs Junction', NULL, N'Baltimore', N'21265', N'3915252579', N'MD')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1605, N'Yambee', N'309 Dryden Park', NULL, N'Atlanta', N'31136', N'1794148936', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1606, N'Twinder', N'3299 Coleman Drive', NULL, N'San Antonio', N'78230', N'7124113692', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1607, N'Realpoint', N'8 Sundown Avenue', NULL, N'Las Vegas', N'89178', N'9239425925', N'NV')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1608, N'Kwinu', N'2 Prentice Trail', NULL, N'Buffalo', N'14225', N'5919686354', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1609, N'Lazzy', N'1 Parkside Point', NULL, N'Houston', N'77090', N'9827126517', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1610, N'Voolith', N'5 Forest Run Trail', NULL, N'Pittsburgh', N'15240', N'8873494412', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1611, N'Oba', N'232 Aberg Parkway', NULL, N'Greenville', N'29605', N'4497917868', N'SC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1612, N'Viva', N'6 Mandrake Place', NULL, N'Irvine', N'92710', N'3582383732', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1613, N'Browsecat', N'6195 Farragut Hill', NULL, N'Columbus', N'43240', N'4023914297', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1614, N'Agivu', N'17 Oak Valley Park', NULL, N'Columbus', N'43226', N'8029168700', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1615, N'Quamba', N'698 Birchwood Pass', NULL, N'Brooklyn', N'11236', N'6447771152', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1616, N'Meevee', N'0 Pearson Pass', NULL, N'Chattanooga', N'37416', N'5191921937', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1617, N'Browsezoom', N'1 Del Sol Place', NULL, N'New York City', N'10170', N'1256689083', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1618, N'Voolia', N'21070 Talmadge Crossing', NULL, N'Boise', N'83711', N'4128694031', N'ID')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1619, N'Demivee', N'68549 Barnett Circle', NULL, N'Charlotte', N'28230', N'7470059239', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1620, N'Twitterbridge', N'02191 Claremont Avenue', NULL, N'Bellevue', N'98008', N'0022489316', N'WA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1621, N'Edgeblab', N'6 Golf View Road', NULL, N'Duluth', N'30195', N'7894695197', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1622, N'Kazio', N'8 Meadow Vale Court', NULL, N'Houston', N'77206', N'8820663145', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1623, N'Gigashots', N'64 Dayton Court', NULL, N'Springfield', N'22156', N'3089866692', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1624, N'Ntags', N'5 Sommers Place', NULL, N'Atlanta', N'30316', N'8077376007', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1625, N'Browseblab', N'55315 Katie Park', NULL, N'San Jose', N'95113', N'3227292624', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1626, N'Mydo', N'07233 Barby Court', NULL, N'Decatur', N'30089', N'4403848891', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1627, N'Jabberbean', N'729 Hollow Ridge Drive', NULL, N'Seattle', N'98175', N'2564530808', N'WA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1628, N'Kwilith', N'968 Fuller Road', NULL, N'Minneapolis', N'55417', N'9556289556', N'MN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1629, N'Youbridge', N'1896 Fordem Road', NULL, N'Southfield', N'48076', N'2599337918', N'MI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1630, N'Voonix', N'78 Schlimgen Place', NULL, N'Hamilton', N'45020', N'2598391952', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1631, N'Abatz', N'0 Ramsey Road', NULL, N'Detroit', N'48242', N'4129410002', N'MI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1632, N'Youspan', N'5 Manley Terrace', NULL, N'Olympia', N'98516', N'1736235543', N'WA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1633, N'Latz', N'5485 Montana Place', NULL, N'Clearwater', N'33763', N'9834281357', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1634, N'Browsetype', N'35 Jana Avenue', NULL, N'Marietta', N'30066', N'6888620228', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1635, N'Skimia', N'844 Forest Dale Street', NULL, N'Hartford', N'6152', N'3021320358', N'CT')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1636, N'Skippad', N'0792 Vermont Avenue', NULL, N'Lynn', N'1905', N'4064339472', N'MA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1637, N'Miboo', N'0 Porter Way', NULL, N'San Francisco', N'94159', N'0371223547', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1638, N'Realblab', N'4 Reinke Park', NULL, N'Washington', N'20238', N'5224407498', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1639, N'Yamia', N'4 Wayridge Plaza', NULL, N'Trenton', N'8603', N'3054318651', N'NJ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1640, N'Topicware', N'16 Golf Plaza', NULL, N'Sioux Falls', N'57188', N'1582499254', N'SD')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1641, N'Skyble', N'7888 Monument Center', NULL, N'Richmond', N'23228', N'5327453740', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1642, N'LiveZ', N'6466 Towne Court', NULL, N'Philadelphia', N'19178', N'3807397240', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1643, N'Jabbersphere', N'5402 Corry Court', NULL, N'Boca Raton', N'33432', N'0658306475', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1644, N'Jabbercube', N'6135 Sullivan Way', NULL, N'Columbia', N'29215', N'5084594328', N'SC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1645, N'Kazu', N'525 Raven Parkway', NULL, N'Salt Lake City', N'84125', N'3595277622', N'UT')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1646, N'Flashset', N'1 Basil Court', NULL, N'Shreveport', N'71115', N'2725921102', N'LA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1647, N'Yakitri', N'894 Morningstar Crossing', NULL, N'Paterson', N'7544', N'7831944459', N'NJ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1648, N'Mybuzz', N'6790 Mandrake Circle', NULL, N'Los Angeles', N'90025', N'4263206150', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1649, N'Blogtags', N'9649 Gulseth Plaza', NULL, N'Gainesville', N'32627', N'7765405091', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1650, N'Buzzdog', N'094 Corscot Way', NULL, N'Saginaw', N'48604', N'9286530633', N'MI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1651, N'Thoughtsphere', N'36523 Almo Way', NULL, N'Glendale', N'85305', N'5995116340', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1652, N'Camimbo', N'04451 Mariners Cove Avenue', NULL, N'Lynchburg', N'24503', N'6618762009', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1653, N'Realpoint', N'856 Leroy Plaza', NULL, N'Birmingham', N'35231', N'5476957986', N'AL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1654, N'Gigazoom', N'78608 Armistice Trail', NULL, N'San Antonio', N'78285', N'7654498447', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1655, N'Tanoodle', N'92 1st Avenue', NULL, N'El Paso', N'88579', N'0921568470', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1656, N'Ntag', N'8580 Lakewood Gardens Circle', NULL, N'Houston', N'77276', N'4037611186', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1657, N'Voomm', N'3 Starling Place', NULL, N'San Diego', N'92132', N'8267857539', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1658, N'Realpoint', N'5456 Hanson Place', NULL, N'Baltimore', N'21239', N'0026692815', N'MD')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1659, N'Riffpedia', N'106 Mendota Way', NULL, N'Myrtle Beach', N'29579', N'3580251671', N'SC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1660, N'Tavu', N'4 Crescent Oaks Place', NULL, N'Denver', N'80235', N'0688791518', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1661, N'Livetube', N'4704 Sauthoff Place', NULL, N'Columbia', N'29225', N'9396578137', N'SC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1662, N'Fanoodle', N'74053 Leroy Plaza', NULL, N'Louisville', N'40205', N'6241001675', N'KY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1663, N'Edgeblab', N'0238 Waubesa Way', NULL, N'Washington', N'20088', N'4093641003', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1664, N'Flipbug', N'647 Bayside Way', NULL, N'Hartford', N'6140', N'4391040556', N'CT')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1665, N'Roomm', N'217 Saint Paul Center', NULL, N'El Paso', N'88563', N'7664270587', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1666, N'Abata', N'18938 Clarendon Pass', NULL, N'Kansas City', N'64125', N'5823439406', N'MO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1667, N'Kwilith', N'88 Gerald Circle', NULL, N'Fresno', N'93704', N'5189659326', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1668, N'Jabberbean', N'8841 Pond Street', NULL, N'Denver', N'80204', N'7514767474', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1669, N'Jaxspan', N'1316 Blaine Circle', NULL, N'Dayton', N'45454', N'7407046311', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1670, N'Pixoboo', N'537 Warbler Circle', NULL, N'Washington', N'20370', N'5268496681', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1671, N'Ntag', N'27 Hooker Street', NULL, N'Washington', N'20215', N'2447916765', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1672, N'Wordtune', N'634 Vidon Place', NULL, N'Columbia', N'29225', N'3149588215', N'SC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1673, N'Topiczoom', N'078 Division Street', NULL, N'Gaithersburg', N'20883', N'6440469238', N'MD')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1674, N'Kwilith', N'5 Hansons Hill', NULL, N'Milwaukee', N'53263', N'1766380566', N'WI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1675, N'Flashpoint', N'04 Forest Street', NULL, N'San Bernardino', N'92410', N'9078957883', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1676, N'Zoozzy', N'97088 Badeau Plaza', NULL, N'Sacramento', N'95828', N'6443091266', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1677, N'Jaxbean', N'31 Helena Hill', NULL, N'Rochester', N'14609', N'9211924668', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1678, N'Jaxworks', N'85242 Jenifer Pass', NULL, N'Sacramento', N'94250', N'6385053921', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1679, N'Livetube', N'545 Sage Hill', NULL, N'Denver', N'80249', N'4080731127', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1680, N'Youtags', N'658 Kensington Place', NULL, N'Sacramento', N'94297', N'4044092023', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1681, N'Mudo', N'0120 Donald Street', NULL, N'Saint Louis', N'63136', N'6884710716', N'MO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1682, N'Yata', N'0188 Mayfield Place', NULL, N'Fort Worth', N'76105', N'1062641951', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1683, N'Fadeo', N'6236 Warner Drive', NULL, N'Tyler', N'75799', N'8063576453', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1684, N'Quimba', N'571 Transport Junction', NULL, N'Oklahoma City', N'73104', N'7847453151', N'OK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1685, N'Thoughtmix', N'693 School Lane', NULL, N'Tyler', N'75710', N'7688953092', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1686, N'Topicshots', N'66 Spaight Way', NULL, N'Palatine', N'60078', N'6630615970', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1687, N'Leenti', N'2 Hallows Pass', NULL, N'Fort Worth', N'76105', N'0495142981', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1688, N'Mita', N'26269 Summer Ridge Parkway', NULL, N'Columbia', N'29208', N'1614942972', N'SC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1689, N'Yambee', N'1 Pine View Terrace', NULL, N'New York City', N'10270', N'6098401776', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1690, N'Mybuzz', N'26 Eliot Junction', NULL, N'Indianapolis', N'46239', N'5707195702', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1691, N'Tagfeed', N'4781 Welch Point', NULL, N'Fresno', N'93740', N'9962071182', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1692, N'Ainyx', N'5 Novick Avenue', NULL, N'Washington', N'20310', N'6753594438', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1693, N'Dabvine', N'8 Forster Lane', NULL, N'Dallas', N'75387', N'8389925466', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1694, N'Yambee', N'849 Springview Circle', NULL, N'Washington', N'20205', N'2535759854', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1695, N'Meetz', N'2 Claremont Junction', NULL, N'Columbia', N'29220', N'1469703597', N'SC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1696, N'Skaboo', N'7 Barnett Drive', NULL, N'El Paso', N'88563', N'7850504941', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1697, N'Viva', N'77392 Forest Dale Street', NULL, N'Corpus Christi', N'78465', N'7293329556', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1698, N'Oyoba', N'155 Marquette Place', NULL, N'Knoxville', N'37995', N'1363690467', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1699, N'Zoombeat', N'56420 Green Ridge Drive', NULL, N'Washington', N'20551', N'3793196091', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1700, N'Wikivu', N'7 Kenwood Point', NULL, N'Buffalo', N'14210', N'3455820098', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1701, N'Miboo', N'48 Randy Lane', NULL, N'Columbia', N'65211', N'2993670527', N'MO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1702, N'Babbleset', N'56397 Sycamore Junction', NULL, N'Montgomery', N'36119', N'3649809233', N'AL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1703, N'Devify', N'40 Dwight Terrace', NULL, N'Philadelphia', N'19109', N'4132809918', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1704, N'Brainbox', N'0309 Old Gate Junction', NULL, N'Washington', N'20226', N'2377361480', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1705, N'Ozu', N'8 Elgar Terrace', NULL, N'Phoenix', N'85072', N'0353773515', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1706, N'Dynabox', N'792 Shoshone Lane', NULL, N'Pasadena', N'91186', N'6982848730', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1707, N'Vimbo', N'62987 Duke Circle', NULL, N'Hamilton', N'45020', N'9120791204', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1708, N'Livepath', N'37291 Petterle Pass', NULL, N'Washington', N'20205', N'2623099895', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1709, N'Jatri', N'902 Reindahl Pass', NULL, N'New York City', N'10014', N'0147924655', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1710, N'Zoomdog', N'8 Elmside Court', NULL, N'Washington', N'20210', N'8761132502', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1711, N'Oyonder', N'0762 Myrtle Avenue', NULL, N'Charlotte', N'28205', N'3492955726', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1712, N'Reallinks', N'7 Gulseth Junction', NULL, N'Miami', N'33261', N'2879760321', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1713, N'Livetube', N'396 Menomonie Alley', NULL, N'Atlanta', N'31132', N'5851228863', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1714, N'Quatz', N'6 2nd Court', NULL, N'Odessa', N'79764', N'9474670246', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1715, N'Skivee', N'55739 Del Sol Pass', NULL, N'Pittsburgh', N'15279', N'7404176579', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1716, N'Pixonyx', N'248 Haas Circle', NULL, N'Everett', N'98206', N'9951150339', N'WA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1717, N'Talane', N'42 Crownhardt Street', NULL, N'Knoxville', N'37914', N'3609301558', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1718, N'Skipstorm', N'4811 Darwin Road', NULL, N'Montpelier', N'5609', N'7508755838', N'VT')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1719, N'Tekfly', N'44 Rockefeller Crossing', NULL, N'Topeka', N'66699', N'1871530334', N'KS')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1720, N'Rhycero', N'99 Shelley Avenue', NULL, N'New York City', N'10120', N'1204261996', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1721, N'Jaloo', N'21 Crownhardt Park', NULL, N'Kansas City', N'64153', N'5627413843', N'MO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1722, N'Twitterwire', N'7760 Moose Park', NULL, N'Schenectady', N'12325', N'5157459150', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1723, N'Skyble', N'233 Hoffman Lane', NULL, N'El Paso', N'88569', N'5860264505', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1724, N'Tagfeed', N'172 Charing Cross Trail', NULL, N'San Antonio', N'78291', N'7321677545', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1725, N'Tagtune', N'0 Lake View Park', NULL, N'Greensboro', N'27415', N'0881577912', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1726, N'Quatz', N'47304 Dixon Plaza', NULL, N'Saint Petersburg', N'33731', N'0642954696', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1727, N'Eazzy', N'009 Paget Drive', NULL, N'Syracuse', N'13251', N'1135711276', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1728, N'Flipopia', N'894 Saint Paul Place', NULL, N'Flushing', N'11355', N'5928215191', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1729, N'Youfeed', N'1 Mariners Cove Trail', NULL, N'Garland', N'75049', N'2082647537', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1730, N'Wikibox', N'3802 Sutherland Place', NULL, N'Saint Louis', N'63104', N'6183796538', N'MO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1731, N'Zoomlounge', N'9 Oak Valley Trail', NULL, N'Saint Louis', N'63143', N'8386875685', N'MO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1732, N'Youtags', N'22 Eastwood Drive', NULL, N'Trenton', N'8608', N'8361363254', N'NJ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1733, N'Abata', N'564 Ronald Regan Trail', NULL, N'Memphis', N'38131', N'9444141590', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1734, N'Jabbersphere', N'4106 Continental Hill', NULL, N'Birmingham', N'35290', N'7012467889', N'AL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1735, N'Eire', N'9395 Talisman Place', NULL, N'Santa Fe', N'87505', N'0961995998', N'NM')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1736, N'Twitterworks', N'58092 Bonner Center', NULL, N'Dayton', N'45414', N'3130388637', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1737, N'Tagcat', N'0500 Sauthoff Center', NULL, N'Fort Worth', N'76198', N'3279577389', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1738, N'Eazzy', N'8 Vera Circle', NULL, N'Norman', N'73071', N'0368148123', N'OK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1739, N'Eadel', N'0 Hoffman Hill', NULL, N'Washington', N'20591', N'6432990497', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1740, N'Jabbercube', N'11 Prentice Road', NULL, N'Detroit', N'48242', N'6208358649', N'MI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1741, N'Rhyzio', N'5 Sauthoff Circle', NULL, N'Fresno', N'93773', N'2932371207', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1742, N'Divavu', N'8868 Grover Road', NULL, N'Dallas', N'75210', N'9240602055', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1743, N'InnoZ', N'85 Springs Alley', NULL, N'Los Angeles', N'90087', N'1712286925', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1744, N'Babbleblab', N'07 Londonderry Drive', NULL, N'Pasadena', N'91109', N'1678552753', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1745, N'Tagpad', N'41571 Sutteridge Plaza', NULL, N'Orlando', N'32835', N'3577131903', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1746, N'Eamia', N'1 Maywood Circle', NULL, N'Topeka', N'66667', N'1511490229', N'KS')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1747, N'Zoomzone', N'64 Waubesa Circle', NULL, N'High Point', N'27264', N'7508857175', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1748, N'Meemm', N'19 Hayes Avenue', NULL, N'Huntington', N'25770', N'6746342879', N'WV')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1749, N'Oyoyo', N'4 Melrose Place', NULL, N'Salt Lake City', N'84152', N'6425963461', N'UT')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1750, N'Bluezoom', N'01550 Summit Circle', NULL, N'Sacramento', N'95865', N'2788142185', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1751, N'Skyba', N'0 Goodland Avenue', NULL, N'Evansville', N'47712', N'1368549408', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1752, N'Jazzy', N'9 Harper Circle', NULL, N'Seattle', N'98133', N'1153339927', N'WA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1753, N'Voolia', N'07877 Mcguire Pass', NULL, N'Phoenix', N'85020', N'3972866668', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1754, N'Skalith', N'3 Russell Place', NULL, N'Mobile', N'36610', N'7182100381', N'AL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1755, N'Bluezoom', N'0 Cambridge Point', NULL, N'Reno', N'89550', N'7432645712', N'NV')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1756, N'Oyoloo', N'60933 Myrtle Drive', NULL, N'Kansas City', N'64114', N'5362086036', N'MO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1757, N'Kwimbee', N'8461 Cherokee Street', NULL, N'Minneapolis', N'55470', N'5621940189', N'MN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1758, N'Fivechat', N'37 Morrow Lane', NULL, N'Torrance', N'90505', N'9656937007', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1759, N'Talane', N'91353 Bluejay Hill', NULL, N'Wilmington', N'19892', N'7430683954', N'DE')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1760, N'Quinu', N'6 Butterfield Point', NULL, N'Fort Worth', N'76198', N'9329694645', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1761, N'Jabbersphere', N'20186 Petterle Junction', NULL, N'San Antonio', N'78235', N'6211328036', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1762, N'JumpXS', N'413 Carioca Crossing', NULL, N'Birmingham', N'35263', N'0061134065', N'AL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1763, N'Thoughtsphere', N'5547 Heffernan Way', NULL, N'Springfield', N'62794', N'7106021245', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1764, N'Twitterbridge', N'28 Mifflin Terrace', NULL, N'Duluth', N'30195', N'5541630222', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1765, N'Lazzy', N'25427 Canary Lane', NULL, N'Evansville', N'47725', N'8945316578', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1766, N'Quaxo', N'9 Marquette Point', NULL, N'Dallas', N'75205', N'5223318418', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1767, N'Tambee', N'4 Harbort Place', NULL, N'Irvine', N'92619', N'8416209229', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1768, N'Flashspan', N'1 Victoria Pass', NULL, N'Lafayette', N'47905', N'3738798309', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1769, N'Blogtag', N'8601 Merchant Court', NULL, N'Pueblo', N'81010', N'9531367888', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1770, N'Shuffletag', N'8607 Evergreen Trail', NULL, N'Topeka', N'66622', N'2158018559', N'KS')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1771, N'Feedspan', N'271 Spenser Drive', NULL, N'Washington', N'20557', N'8411193266', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1772, N'Devcast', N'775 Messerschmidt Parkway', NULL, N'Dayton', N'45432', N'8292201332', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1773, N'Twitterlist', N'618 Knutson Road', NULL, N'New Orleans', N'70183', N'9500218917', N'LA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1774, N'Quimm', N'1822 Macpherson Lane', NULL, N'Saint Paul', N'55166', N'2931536711', N'MN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1775, N'Mynte', N'10 Magdeline Hill', NULL, N'White Plains', N'10633', N'9282831046', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1776, N'Flipstorm', N'16483 Warrior Drive', NULL, N'El Paso', N'79928', N'6343355210', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1777, N'Fanoodle', N'941 Calypso Court', NULL, N'Raleigh', N'27690', N'7654097429', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1778, N'Gabtype', N'20 Coolidge Center', NULL, N'Kansas City', N'64190', N'8354184195', N'MO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1779, N'Blogspan', N'5 Stone Corner Trail', NULL, N'Port Saint Lucie', N'34985', N'1059895293', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1780, N'Realmix', N'155 Maywood Point', NULL, N'Buffalo', N'14210', N'1034923348', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1781, N'Voolia', N'4 Coleman Pass', NULL, N'Cincinnati', N'45238', N'2719303812', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1782, N'Edgeblab', N'3174 Hayes Parkway', NULL, N'Henderson', N'89012', N'5057385032', N'NV')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1783, N'Flashdog', N'76 Tennessee Terrace', NULL, N'Tulsa', N'74193', N'2266561448', N'OK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1784, N'Meetz', N'44 Armistice Road', NULL, N'Birmingham', N'35295', N'0083823024', N'AL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1785, N'Youopia', N'0977 Kedzie Avenue', NULL, N'Boston', N'2124', N'4244936893', N'MA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1786, N'Yakitri', N'8139 South Plaza', NULL, N'Irvine', N'92717', N'1943496734', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1787, N'Wikivu', N'49386 Summit Terrace', NULL, N'Anchorage', N'99507', N'6409729077', N'AK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1788, N'Vinte', N'2 Homewood Street', NULL, N'Evansville', N'47712', N'8113129330', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1789, N'Zoonder', N'452 Park Meadow Way', NULL, N'Round Rock', N'78682', N'1787571328', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1790, N'Skyvu', N'575 Manufacturers Parkway', NULL, N'Macon', N'31296', N'2298675743', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1791, N'Nlounge', N'354 Old Shore Avenue', NULL, N'Richmond', N'23272', N'0509217363', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1792, N'Midel', N'25314 Butternut Parkway', NULL, N'New Orleans', N'70174', N'9025468545', N'LA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1793, N'Teklist', N'68 Reindahl Terrace', NULL, N'Des Moines', N'50347', N'2605641699', N'IA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1794, N'Kimia', N'82760 Riverside Lane', NULL, N'Gainesville', N'32605', N'4779342691', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1795, N'Dabshots', N'7903 Hauk Alley', NULL, N'Phoenix', N'85010', N'7806776452', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1796, N'Tagfeed', N'60 Holy Cross Terrace', NULL, N'Chicago', N'60674', N'8210775455', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1797, N'Mymm', N'2165 Talisman Plaza', NULL, N'Saint Petersburg', N'33705', N'3854793596', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1798, N'Vinder', N'42730 Florence Road', NULL, N'Chesapeake', N'23324', N'9143721349', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1799, N'Snaptags', N'511 Rowland Avenue', NULL, N'Fort Worth', N'76178', N'4984600503', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1800, N'Linktype', N'73919 Kennedy Center', NULL, N'Sacramento', N'94273', N'0137792723', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1801, N'Layo', N'1814 Longview Junction', NULL, N'Fort Lauderdale', N'33315', N'5661380050', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1802, N'Bubblemix', N'416 Kennedy Street', NULL, N'Hollywood', N'33028', N'3137955560', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1803, N'Camimbo', N'78159 Rieder Terrace', NULL, N'Houston', N'77085', N'3744635597', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1804, N'Buzzshare', N'00 Glacier Hill Circle', NULL, N'Houston', N'77234', N'3747670415', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1805, N'Zoombox', N'20 Florence Center', NULL, N'Washington', N'20099', N'2347427348', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1806, N'Roodel', N'32418 Eagan Lane', NULL, N'Miami', N'33164', N'5733830206', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1807, N'Wordware', N'81422 Morning Road', NULL, N'San Antonio', N'78255', N'3192168133', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1808, N'Chatterpoint', N'32 Lunder Circle', NULL, N'Washington', N'20205', N'5411006327', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1809, N'Realcube', N'564 Westerfield Place', NULL, N'Cincinnati', N'45223', N'8782060720', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1810, N'Quinu', N'349 Schurz Lane', NULL, N'Omaha', N'68134', N'8357083040', N'NE')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1811, N'Viva', N'37 Harper Junction', NULL, N'Kansas City', N'64160', N'8678062374', N'MO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1812, N'Demimbu', N'77179 Gina Drive', NULL, N'Rochester', N'14609', N'7720041423', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1813, N'Mynte', N'131 Texas Road', NULL, N'Huntington', N'25705', N'2040656118', N'WV')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1814, N'Quire', N'56 Cascade Street', NULL, N'Fort Worth', N'76105', N'2831229818', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1815, N'Janyx', N'8964 Nevada Avenue', NULL, N'Phoenix', N'85072', N'2713792292', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1816, N'Browsezoom', N'3 Anniversary Parkway', NULL, N'Yakima', N'98907', N'3081711238', N'WA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1817, N'Quinu', N'0336 Alpine Junction', NULL, N'Paterson', N'7544', N'1578433526', N'NJ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1818, N'Gabspot', N'98 Hagan Pass', NULL, N'Garden Grove', N'92844', N'9434745890', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1819, N'Demizz', N'472 Paget Lane', NULL, N'Springfield', N'62756', N'5572615073', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1820, N'Ooba', N'5695 Lukken Terrace', NULL, N'Albuquerque', N'87190', N'6127003689', N'NM')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1821, N'Zoonoodle', N'44158 Sachtjen Terrace', NULL, N'Tucson', N'85754', N'4308548856', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1822, N'Viva', N'0 Merry Street', NULL, N'Berkeley', N'94712', N'1919566261', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1823, N'Mynte', N'853 Swallow Avenue', NULL, N'Hartford', N'6120', N'3249869924', N'CT')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1824, N'Zoonoodle', N'174 Anzinger Plaza', NULL, N'Shawnee Mission', N'66220', N'7953192856', N'KS')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1825, N'Skaboo', N'726 Northridge Way', NULL, N'Des Moines', N'50330', N'7236560215', N'IA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1826, N'Roodel', N'3747 Twin Pines Road', NULL, N'Carson City', N'89706', N'2276547954', N'NV')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1827, N'Zoomzone', N'5 Homewood Plaza', NULL, N'Brooklyn', N'11205', N'6154236152', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1828, N'Shufflester', N'51721 Main Place', NULL, N'Orlando', N'32830', N'2869350875', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1829, N'Twitterbeat', N'27 Eggendart Avenue', NULL, N'Lakeland', N'33811', N'4389558401', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1830, N'Ooba', N'261 Loomis Circle', NULL, N'Salt Lake City', N'84105', N'2844712208', N'UT')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1831, N'Flashdog', N'92 Tennessee Point', NULL, N'Amarillo', N'79171', N'6613044599', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1832, N'Twitternation', N'1425 Basil Trail', NULL, N'Asheville', N'28805', N'9653437495', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1833, N'Tagopia', N'349 Colorado Trail', NULL, N'Trenton', N'8608', N'0341602805', N'NJ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1834, N'Mymm', N'47 Union Point', NULL, N'Oakland', N'94660', N'4792487980', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1835, N'Wordware', N'0 Independence Avenue', NULL, N'Pasadena', N'91125', N'7025274576', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1836, N'Trilith', N'8 Mifflin Terrace', NULL, N'Anchorage', N'99599', N'0467685365', N'AK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1837, N'Lazz', N'1695 Gulseth Avenue', NULL, N'Tallahassee', N'32314', N'0805027872', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1838, N'Viva', N'32259 Anhalt Terrace', NULL, N'Milwaukee', N'53263', N'3493743500', N'WI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1839, N'Yozio', N'934 Sheridan Plaza', NULL, N'Bronx', N'10469', N'9203068396', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1840, N'Topiclounge', N'580 Prairieview Park', NULL, N'Toledo', N'43699', N'7085504084', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1841, N'Chatterbridge', N'5579 Kinsman Hill', NULL, N'Naples', N'34102', N'0518098276', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1842, N'Skyvu', N'4214 Westport Way', NULL, N'Albuquerque', N'87110', N'8719355173', N'NM')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1843, N'Ntag', N'67 Tennessee Avenue', NULL, N'Anaheim', N'92812', N'7945206718', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1844, N'Voonder', N'93 Corscot Road', NULL, N'El Paso', N'79928', N'6874473688', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1845, N'Shuffledrive', N'4337 Bowman Parkway', NULL, N'Hicksville', N'11854', N'7113858528', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1846, N'Wikizz', N'0824 Raven Park', NULL, N'Los Angeles', N'90005', N'6432741475', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1847, N'Avamm', N'18785 Thompson Drive', NULL, N'Fort Worth', N'76134', N'1342033238', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1848, N'Bubbletube', N'8780 Del Mar Center', NULL, N'Albuquerque', N'87105', N'1720816701', N'NM')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1849, N'Rhyzio', N'7504 Eastlawn Pass', NULL, N'Springfield', N'65810', N'9930451014', N'MO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1850, N'Demimbu', N'59 Bay Park', NULL, N'Atlanta', N'31190', N'3803593152', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1851, N'Vinder', N'905 Hooker Avenue', NULL, N'Honolulu', N'96845', N'6460771091', N'HI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1852, N'Vinder', N'3 Towne Drive', NULL, N'Omaha', N'68124', N'9956734388', N'NE')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1853, N'Yadel', N'50402 Farragut Junction', NULL, N'Chattanooga', N'37410', N'3919324177', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1854, N'Aivee', N'184 Thierer Junction', NULL, N'Atlanta', N'30311', N'9908177448', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1855, N'Gigabox', N'31 Susan Court', NULL, N'Providence', N'2912', N'5474880073', N'RI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1856, N'Dablist', N'2 Graedel Court', NULL, N'Dallas', N'75241', N'9506528114', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1857, N'Twiyo', N'6314 Granby Place', NULL, N'Nashville', N'37250', N'8741565827', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1858, N'Tagcat', N'8 Sunnyside Point', NULL, N'Knoxville', N'37919', N'3860507061', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1859, N'Realcube', N'63788 Southridge Junction', NULL, N'Milwaukee', N'53285', N'1865361672', N'WI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1860, N'Oyoyo', N'51 Green Terrace', NULL, N'Tampa', N'33620', N'6073173448', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1861, N'Voonyx', N'6 Merry Circle', NULL, N'Columbus', N'43215', N'2800829789', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1862, N'Youopia', N'827 Moland Hill', NULL, N'Pittsburgh', N'15266', N'8663615964', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1863, N'Voonix', N'214 Mccormick Place', NULL, N'Portsmouth', N'3804', N'2348833649', N'NH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1864, N'Buzzbean', N'6615 Alpine Terrace', NULL, N'Birmingham', N'35225', N'5085492728', N'AL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1865, N'Twitterbeat', N'18788 Center Hill', NULL, N'White Plains', N'10606', N'8154891404', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1866, N'Youfeed', N'4 Rusk Park', NULL, N'Salt Lake City', N'84110', N'5432324146', N'UT')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1867, N'Tanoodle', N'30198 Oak Valley Park', NULL, N'Colorado Springs', N'80995', N'7381994879', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1868, N'Jabbersphere', N'553 Farmco Terrace', NULL, N'Mountain View', N'94042', N'7652072507', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1869, N'Livetube', N'09 Trailsway Park', NULL, N'Albuquerque', N'87195', N'1298311564', N'NM')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1870, N'Dabfeed', N'0 Prairieview Drive', NULL, N'Washington', N'20409', N'8801175706', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1871, N'Brainbox', N'13176 Elmside Park', NULL, N'Seattle', N'98185', N'1801511654', N'WA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1872, N'Tekfly', N'75561 Pennsylvania Center', NULL, N'Louisville', N'40225', N'7839273045', N'KY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1873, N'Shuffletag', N'6717 Hintze Circle', NULL, N'Youngstown', N'44505', N'8305573231', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1874, N'Dabvine', N'61 Butternut Junction', NULL, N'Birmingham', N'35254', N'2393264305', N'AL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1875, N'Linktype', N'96 Jay Junction', NULL, N'San Francisco', N'94126', N'9315783624', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1876, N'Skipstorm', N'258 Sunbrook Road', NULL, N'Fresno', N'93773', N'3921544994', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1877, N'Latz', N'3 Mallard Street', NULL, N'Tampa', N'33620', N'9194273126', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1878, N'Photojam', N'59 Trailsway Court', NULL, N'Washington', N'20397', N'3910829760', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1879, N'Ailane', N'334 Scoville Point', NULL, N'Philadelphia', N'19125', N'2189267646', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1880, N'Yacero', N'313 Kenwood Park', NULL, N'Detroit', N'48217', N'7323509296', N'MI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1881, N'Oloo', N'23 Welch Lane', NULL, N'Clearwater', N'33763', N'9204312140', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1882, N'Twiyo', N'9180 Saint Paul Street', NULL, N'Orlando', N'32854', N'3254836314', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1883, N'JumpXS', N'795 Lillian Pass', NULL, N'Fresno', N'93740', N'1952937167', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1884, N'Jaloo', N'82 Carey Plaza', NULL, N'Jackson', N'39296', N'0074966401', N'MS')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1885, N'Tanoodle', N'872 Kropf Point', NULL, N'Amarillo', N'79116', N'8663420498', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1886, N'Jaxworks', N'17 Quincy Way', NULL, N'Waterbury', N'6721', N'9149256335', N'CT')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1887, N'Yacero', N'4983 Jenna Alley', NULL, N'Charlotte', N'28247', N'6397160241', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1888, N'Npath', N'6140 Golden Leaf Alley', NULL, N'Chicago', N'60609', N'1566789129', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1889, N'Snaptags', N'4 Reindahl Crossing', NULL, N'North Little Rock', N'72199', N'9824624765', N'AR')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1890, N'Dynava', N'35758 Mayfield Trail', NULL, N'Fort Worth', N'76115', N'7297884884', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1891, N'Livetube', N'66 Melvin Drive', NULL, N'Saint Paul', N'55127', N'3839320316', N'MN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1892, N'Yodel', N'59894 Sommers Place', NULL, N'New Haven', N'6505', N'8524540865', N'CT')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1893, N'Jaxbean', N'279 Utah Parkway', NULL, N'Buffalo', N'14276', N'3364117648', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1894, N'Vinder', N'1313 Maywood Parkway', NULL, N'Saginaw', N'48604', N'8326923569', N'MI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1895, N'Pixoboo', N'7542 Dexter Plaza', NULL, N'Dallas', N'75323', N'8729817953', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1896, N'Linklinks', N'9161 Warrior Center', NULL, N'New Orleans', N'70124', N'5071827402', N'LA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1897, N'Zava', N'7771 Hoard Street', NULL, N'Birmingham', N'35210', N'5384529578', N'AL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1898, N'Quaxo', N'55 Ruskin Plaza', NULL, N'San Jose', N'95123', N'1240420123', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1899, N'Yacero', N'781 Springview Junction', NULL, N'Topeka', N'66629', N'1798477343', N'KS')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1900, N'Fatz', N'73 Hanover Junction', NULL, N'Louisville', N'40293', N'3028186799', N'KY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1901, N'Roodel', N'261 Oak Alley', NULL, N'New York City', N'10019', N'9251694091', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1902, N'Skajo', N'92 Rieder Point', NULL, N'Houston', N'77020', N'6754063865', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1903, N'Innojam', N'77885 Leroy Alley', NULL, N'Peoria', N'61629', N'5177118638', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1904, N'Quatz', N'3689 American Plaza', NULL, N'Washington', N'20057', N'7518353264', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1905, N'Photospace', N'7872 Scott Parkway', NULL, N'Knoxville', N'37924', N'7432627917', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1906, N'Wikizz', N'643 Lakewood Circle', NULL, N'Fayetteville', N'28305', N'6998475083', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1907, N'Jetpulse', N'77029 Fallview Court', NULL, N'Tacoma', N'98442', N'2889245365', N'WA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1908, N'Voolith', N'856 Hayes Center', NULL, N'Harrisburg', N'17110', N'6863216182', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1909, N'Blognation', N'3 Cottonwood Plaza', NULL, N'Arlington', N'76011', N'9081573892', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1910, N'Devshare', N'811 Esker Hill', NULL, N'Appleton', N'54915', N'2861871774', N'WI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1911, N'Kwilith', N'8 Holy Cross Place', NULL, N'Omaha', N'68110', N'0069798846', N'NE')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1912, N'Rhyzio', N'6 Mallard Terrace', NULL, N'Pensacola', N'32511', N'8660720300', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1913, N'Yodoo', N'620 Oak Street', NULL, N'Fort Worth', N'76198', N'6390074653', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1914, N'Tagcat', N'899 Anthes Alley', NULL, N'Tulsa', N'74170', N'0790585879', N'OK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1915, N'Skibox', N'0422 Schurz Court', NULL, N'Denver', N'80235', N'2501325464', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1916, N'Skaboo', N'4641 Hanson Plaza', NULL, N'New York City', N'10280', N'8405782767', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1917, N'Kwinu', N'368 Kipling Junction', NULL, N'Lansing', N'48956', N'9470755832', N'MI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1918, N'Riffwire', N'37928 8th Trail', NULL, N'Salt Lake City', N'84199', N'1660401345', N'UT')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1919, N'Photolist', N'4598 Esker Pass', NULL, N'Jacksonville', N'32255', N'1495841493', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1920, N'Vipe', N'62 Havey Center', NULL, N'San Diego', N'92132', N'5604836233', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1921, N'Centidel', N'62 Logan Lane', NULL, N'Hicksville', N'11854', N'4996573089', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1922, N'Abatz', N'396 Pepper Wood Place', NULL, N'Erie', N'16534', N'1429486196', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1923, N'Realcube', N'7 Messerschmidt Circle', NULL, N'Memphis', N'38104', N'8770484846', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1924, N'Kayveo', N'4661 Roth Crossing', NULL, N'Las Vegas', N'89150', N'3980937344', N'NV')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1925, N'Snaptags', N'5 Morningstar Park', NULL, N'Brockton', N'2305', N'7429218927', N'MA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1926, N'Trunyx', N'91703 Mitchell Drive', NULL, N'Nashville', N'37245', N'5227898087', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1927, N'Oyonder', N'35538 Dakota Circle', NULL, N'Washington', N'20067', N'1285882815', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1928, N'Photobug', N'12774 Mayer Park', NULL, N'Bismarck', N'58505', N'4360399371', N'ND')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1929, N'Rhynyx', N'8 Warner Place', NULL, N'Norwalk', N'6859', N'6801173665', N'CT')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1930, N'Yamia', N'767 Hermina Pass', NULL, N'Albany', N'12242', N'1402987686', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1931, N'Skippad', N'9 Clyde Gallagher Road', NULL, N'Odessa', N'79769', N'9093776653', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1932, N'Zoovu', N'41366 Crowley Place', NULL, N'Raleigh', N'27610', N'5688915082', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1933, N'Dabjam', N'936 Carpenter Plaza', NULL, N'San Jose', N'95150', N'2752485524', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1934, N'Photospace', N'58429 Lyons Avenue', NULL, N'Anchorage', N'99517', N'3692390139', N'AK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1935, N'Thoughtblab', N'266 Pierstorff Trail', NULL, N'Newton', N'2458', N'7724609582', N'MA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1936, N'Fivespan', N'9591 Bartelt Alley', NULL, N'Houston', N'77055', N'0539089320', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1937, N'Twinte', N'7719 Larry Parkway', NULL, N'Peoria', N'85383', N'4924902097', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1938, N'Twinte', N'4934 Dexter Center', NULL, N'Pittsburgh', N'15286', N'3931241215', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1939, N'Tekfly', N'63028 Red Cloud Way', NULL, N'Crawfordsville', N'47937', N'9659770553', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1940, N'Aimbo', N'98772 Artisan Place', NULL, N'Tulsa', N'74184', N'2516405125', N'OK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1941, N'Tavu', N'792 Beilfuss Junction', NULL, N'San Diego', N'92153', N'7993056784', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1942, N'Wikizz', N'9 Kingsford Hill', NULL, N'Pensacola', N'32505', N'7672266279', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1943, N'Kwideo', N'5851 Sachs Junction', NULL, N'Nashville', N'37228', N'2991498675', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1944, N'Blogspan', N'84787 Logan Pass', NULL, N'Washington', N'20470', N'3154919047', N'DC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1945, N'Skinix', N'09913 Hovde Crossing', NULL, N'Macon', N'31296', N'5095865968', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1946, N'Photobug', N'26 Old Gate Hill', NULL, N'Des Moines', N'50369', N'3712962986', N'IA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1947, N'Edgepulse', N'48 Nancy Pass', NULL, N'Greensboro', N'27404', N'8784067517', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1948, N'Edgetag', N'524 Namekagon Trail', NULL, N'Alexandria', N'22313', N'4950960815', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1949, N'Quimba', N'521 Troy Circle', NULL, N'Mesa', N'85215', N'9194573111', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1950, N'Yata', N'53413 Lindbergh Way', NULL, N'Memphis', N'38126', N'1497075268', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1951, N'Bubbletube', N'163 Cody Center', NULL, N'Salt Lake City', N'84152', N'5432137323', N'UT')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1952, N'Wikivu', N'7 Village Terrace', NULL, N'Memphis', N'38197', N'3223782226', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1953, N'Oyonder', N'9 Sommers Junction', NULL, N'Boston', N'2104', N'3634129993', N'MA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1954, N'Voonix', N'5510 Brentwood Avenue', NULL, N'New York City', N'10024', N'2232183438', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1955, N'Mudo', N'22 Hauk Place', NULL, N'Miami', N'33175', N'2198189091', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1956, N'Photofeed', N'13 Grover Plaza', NULL, N'Muncie', N'47306', N'6392632920', N'IN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1957, N'Jayo', N'6836 Maywood Center', NULL, N'Houston', N'77055', N'0792299030', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1958, N'Yotz', N'9 Karstens Trail', NULL, N'Gilbert', N'85297', N'1138079351', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1959, N'Jabbersphere', N'048 Jackson Terrace', NULL, N'Atlanta', N'30336', N'9755771802', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1960, N'Feedbug', N'0 Mallard Court', NULL, N'Charleston', N'25331', N'4967391674', N'WV')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1961, N'Avamba', N'38 Toban Avenue', NULL, N'El Paso', N'88563', N'5391122304', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1962, N'Thoughtstorm', N'65 Grasskamp Pass', NULL, N'Tampa', N'33625', N'2994535867', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1963, N'Talane', N'06713 Maywood Alley', NULL, N'Spokane', N'99215', N'5327506322', N'WA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1964, N'Blogspan', N'382 Colorado Terrace', NULL, N'Dayton', N'45403', N'7013266294', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1965, N'Oozz', N'57 Sundown Crossing', NULL, N'Tulsa', N'74170', N'9686212803', N'OK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1966, N'Mynte', N'82 Welch Trail', NULL, N'San Antonio', N'78215', N'0641349154', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1967, N'Realmix', N'9 Harper Pass', NULL, N'Troy', N'48098', N'7721923099', N'MI')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1968, N'Ooba', N'8754 Boyd Park', NULL, N'New Orleans', N'70165', N'7835212568', N'LA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1969, N'Voomm', N'46880 Heath Plaza', NULL, N'Chattanooga', N'37410', N'9274870253', N'TN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1970, N'Skibox', N'5 Eastlawn Place', NULL, N'San Antonio', N'78225', N'3478680049', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1971, N'Yombu', N'35 Bunting Crossing', NULL, N'Cincinnati', N'45999', N'0873713005', N'OH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1972, N'Tagtune', N'42261 Florence Lane', NULL, N'Springfield', N'1105', N'0945189318', N'MA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1973, N'Gabvine', N'78 Esch Crossing', NULL, N'Katy', N'77493', N'0594206928', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1974, N'Omba', N'2 Artisan Terrace', NULL, N'Littleton', N'80161', N'2958495122', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1975, N'Podcat', N'03 Marquette Way', NULL, N'Midland', N'79710', N'7745115661', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1976, N'Npath', N'2835 Loeprich Circle', NULL, N'Davenport', N'52809', N'2746045547', N'IA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1977, N'Twimm', N'5669 Knutson Avenue', NULL, N'Duluth', N'55811', N'8222793408', N'MN')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1978, N'Topicshots', N'1 Dahle Street', NULL, N'Lake Worth', N'33462', N'5528739885', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1979, N'Skyba', N'3841 Harper Alley', NULL, N'Lake Worth', N'33462', N'4546508402', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1980, N'Mydo', N'34 Montana Drive', NULL, N'San Bernardino', N'92424', N'8571058692', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1981, N'Meembee', N'169 Prentice Crossing', NULL, N'Gatesville', N'76598', N'9989039027', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1982, N'Avamm', N'355 Delladonna Alley', NULL, N'Schenectady', N'12305', N'3368292522', N'NY')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1983, N'Devpoint', N'2 Nevada Way', NULL, N'Brooksville', N'34605', N'6470330578', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1984, N'Divavu', N'3650 Eliot Place', NULL, N'Baltimore', N'21216', N'0003558415', N'MD')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1985, N'Kazio', N'69 Northwestern Hill', NULL, N'Tulsa', N'74184', N'8277267822', N'OK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1986, N'Riffwire', N'81504 Southridge Road', NULL, N'Dallas', N'75210', N'0944594609', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1987, N'Innotype', N'21261 Walton Alley', NULL, N'Roanoke', N'24034', N'7932705008', N'VA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1988, N'Realcube', N'0795 Pleasure Pass', NULL, N'South Lake Tahoe', N'96154', N'6351568726', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1989, N'Topiczoom', N'555 Moland Hill', NULL, N'Irving', N'75037', N'0291623196', N'TX')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1990, N'Jabbersphere', N'8418 Upham Point', NULL, N'Phoenix', N'85067', N'3687886318', N'AZ')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1991, N'Wordify', N'38 Hudson Pass', NULL, N'Carlsbad', N'92013', N'8225248962', N'CA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1992, N'Flashpoint', N'6797 Katie Drive', NULL, N'Portsmouth', N'3804', N'9582058161', N'NH')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1993, N'Omba', N'741 Shoshone Court', NULL, N'Shawnee Mission', N'66220', N'9044593127', N'KS')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1994, N'Photobug', N'06 Schiller Hill', NULL, N'Boulder', N'80305', N'4151673727', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1995, N'Dabjam', N'239 Bluestem Crossing', NULL, N'Chicago', N'60636', N'9279823965', N'IL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1996, N'Meejo', N'6 Lillian Circle', NULL, N'Punta Gorda', N'33982', N'0020672619', N'FL')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1997, N'Talane', N'797 Nevada Way', NULL, N'Albuquerque', N'87105', N'7830913253', N'NM')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1998, N'Jabberbean', N'294 Basil Trail', NULL, N'Tulsa', N'74184', N'7888480764', N'OK')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (1999, N'Youspan', N'4160 Dottie Junction', NULL, N'Charlotte', N'28247', N'8779771992', N'NC')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (2000, N'Tambee', N'03 Corscot Street', NULL, N'Pittsburgh', N'15279', N'9815169253', N'PA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (2001, N'Flashspan', N'56 Vahlen Park', NULL, N'Littleton', N'80161', N'2807844433', N'CO')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (2002, N'Rhyzio', N'153 Onsgard Circle', NULL, N'Macon', N'31217', N'2399613534', N'GA')
GO
INSERT [dbo].[Company] ([CompanyId], [Name], [Address1], [Address2], [City], [Zip], [PhoneNumber], [StateId]) VALUES (2003, N'Voonte', N'13102 Lukken Lane', NULL, N'Atlanta', N'30340', N'3558559332', N'GA')
GO
SET IDENTITY_INSERT [dbo].[Company] OFF
GO
SET IDENTITY_INSERT [dbo].[Employee] ON 

GO
INSERT [dbo].[Employee] ([EmployeeId], [CompanyId], [PersonId]) VALUES (5, 2, 1)
GO
INSERT [dbo].[Employee] ([EmployeeId], [CompanyId], [PersonId]) VALUES (6, 3, 2)
GO
INSERT [dbo].[Employee] ([EmployeeId], [CompanyId], [PersonId]) VALUES (7, 1, 3)
GO
INSERT [dbo].[Employee] ([EmployeeId], [CompanyId], [PersonId]) VALUES (8, 1, 4)
GO
INSERT [dbo].[Employee] ([EmployeeId], [CompanyId], [PersonId]) VALUES (9, 3, 1)
GO
INSERT [dbo].[Employee] ([EmployeeId], [CompanyId], [PersonId]) VALUES (10, 1, 990)
GO
SET IDENTITY_INSERT [dbo].[Employee] OFF
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (1, N'Skyndu', N'62387 High Crossing Park', NULL, N'Huntsville', N'AL', 35805, N'1394262057')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (2, N'Avaveo', N'5 Randy Point', NULL, N'San Francisco', N'CA', 94159, N'7110402805')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (3, N'Twitterbeat', N'47335 Derek Plaza', NULL, N'Houston', N'TX', 77266, N'4405005810')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (4, N'Meetz', N'75 Monument Court', NULL, N'Evansville', N'IN', 47719, N'7967302760')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (5, N'Eimbee', N'96231 Cody Park', NULL, N'Zephyrhills', N'FL', 33543, N'0290900993')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (6, N'Eamia', N'19904 Westend Hill', NULL, N'London', N'KY', 40745, N'8053104014')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (7, N'Youfeed', N'9 Clyde Gallagher Pass', NULL, N'Montgomery', N'AL', 36104, N'7445140500')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (8, N'Cogibox', N'72 Kings Trail', NULL, N'New York City', N'NY', 10099, N'2506828942')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (9, N'Meeveo', N'3 Debs Parkway', NULL, N'Indianapolis', N'IN', 46216, N'9144243307')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (10, N'Skinix', N'554 Northport Avenue', NULL, N'Knoxville', N'TN', 37924, N'9294902118')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (11, N'Feedspan', N'1 Mosinee Terrace', NULL, N'Minneapolis', N'MN', 55436, N'1804202385')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (12, N'Kamba', N'5 Dovetail Road', NULL, N'Philadelphia', N'PA', 19196, N'7878067304')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (13, N'Wikibox', N'9521 Everett Court', NULL, N'Concord', N'CA', 94522, N'0499037719')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (14, N'Thoughtmix', N'98164 Old Gate Lane', NULL, N'Irving', N'TX', 75037, N'8229068136')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (15, N'Oloo', N'72 Killdeer Court', NULL, N'Cincinnati', N'OH', 45249, N'4024490194')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (16, N'Trupe', N'28 Center Trail', NULL, N'Sarasota', N'FL', 34276, N'4597628908')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (17, N'Devify', N'12246 Porter Point', NULL, N'San Antonio', N'TX', 78240, N'1154673483')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (18, N'Jaxspan', N'812 Dennis Park', NULL, N'Fairbanks', N'AK', 99709, N'6729388478')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (19, N'Yodel', N'414 Superior Park', NULL, N'Clearwater', N'FL', 33763, N'8906246277')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (20, N'Photobug', N'11 Anderson Parkway', NULL, N'Sacramento', N'CA', 94291, N'4407622417')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (21, N'Twitterworks', N'3635 Troy Way', NULL, N'Albuquerque', N'NM', 87190, N'2415748091')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (22, N'Babbleset', N'1478 Sunnyside Junction', NULL, N'Des Moines', N'IA', 50310, N'0291119500')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (23, N'Vipe', N'794 Clyde Gallagher Drive', NULL, N'Oklahoma City', N'OK', 73109, N'7759543058')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (24, N'Shuffletag', N'905 Forest Avenue', NULL, N'Santa Ana', N'CA', 92725, N'6842148159')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (25, N'Edgeify', N'085 Annamark Plaza', NULL, N'Paterson', N'NJ', 7505, N'0205032214')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (26, N'Topicware', N'5936 Welch Avenue', NULL, N'North Hollywood', N'CA', 91606, N'3023821426')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (27, N'Photolist', N'7 Ohio Junction', NULL, N'Tyler', N'TX', 75799, N'6734306847')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (28, N'Leenti', N'74375 Nobel Street', NULL, N'Nashville', N'TN', 37240, N'1762667939')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (29, N'Skyvu', N'3 Westerfield Place', NULL, N'Springfield', N'IL', 62756, N'6413785084')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (30, N'Trunyx', N'15 Thierer Point', NULL, N'El Paso', N'TX', 79977, N'3366019454')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (31, N'Topicware', N'55 Continental Center', NULL, N'Fort Wayne', N'IN', 46825, N'3866227721')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (32, N'Plambee', N'91033 Derek Lane', NULL, N'Denver', N'CO', 80255, N'6601608032')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (33, N'Einti', N'6 Sullivan Avenue', NULL, N'South Bend', N'IN', 46620, N'2825663063')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (34, N'Latz', N'9 Rockefeller Junction', NULL, N'Vienna', N'VA', 22184, N'6777107783')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (35, N'Feedfire', N'743 Randy Place', NULL, N'Houston', N'TX', 77240, N'0801794720')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (36, N'Meembee', N'93604 Forest Parkway', NULL, N'Richmond', N'VA', 23285, N'7707702603')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (37, N'Yakitri', N'578 Pleasure Way', NULL, N'Gaithersburg', N'MD', 20883, N'5056619326')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (38, N'Myworks', N'55338 Maywood Terrace', NULL, N'Charlotte', N'NC', 28299, N'8144964183')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (39, N'Voonyx', N'428 Erie Place', NULL, N'Dallas', N'TX', 75372, N'9999229238')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (40, N'DabZ', N'53009 Rusk Terrace', NULL, N'Springfield', N'MO', 65810, N'7225342433')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (41, N'Voonyx', N'6116 Quincy Pass', NULL, N'Dayton', N'OH', 45419, N'8949458718')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (42, N'Abatz', N'04486 Ridgeview Hill', NULL, N'Columbus', N'GA', 31904, N'7936381664')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (43, N'Zoomcast', N'6581 Old Shore Junction', NULL, N'Kansas City', N'MO', 64149, N'8217461486')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (44, N'Babblestorm', N'13 Trailsway Court', NULL, N'Jeffersonville', N'IN', 47134, N'7656826343')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (45, N'Realcube', N'47636 Stang Circle', NULL, N'San Angelo', N'TX', 76905, N'4624442113')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (46, N'Gigaclub', N'09116 Ridge Oak Drive', NULL, N'Kansas City', N'MO', 64114, N'1484261516')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (47, N'Meembee', N'81 Vernon Lane', NULL, N'Salt Lake City', N'UT', 84105, N'7804406534')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (48, N'Divanoodle', N'07 Bluestem Parkway', NULL, N'Long Beach', N'CA', 90840, N'0628248276')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (49, N'Skilith', N'7730 Lakeland Drive', NULL, N'Denver', N'CO', 80223, N'8160831219')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (50, N'Tagfeed', N'705 Lotheville Center', NULL, N'Des Moines', N'IA', 50315, N'6940653744')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (51, N'Skinix', N'06721 Sundown Road', NULL, N'Pasadena', N'CA', 91131, N'3986044777')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (52, N'Wikizz', N'16983 Jenna Crossing', NULL, N'Racine', N'WI', 53405, N'3139394010')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (53, N'Zooxo', N'3198 Pawling Alley', NULL, N'Chicago', N'IL', 60604, N'5454330136')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (54, N'Katz', N'0042 Glendale Way', NULL, N'Columbia', N'SC', 29208, N'1389124332')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (55, N'Ntags', N'2 Boyd Lane', NULL, N'Gastonia', N'NC', 28055, N'0701372775')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (56, N'Tagcat', N'5 Sundown Pass', NULL, N'Los Angeles', N'CA', 90065, N'0084048910')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (57, N'Devcast', N'056 Pierstorff Street', NULL, N'Miami Beach', N'FL', 33141, N'4957631352')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (58, N'Topiclounge', N'78194 Graedel Hill', NULL, N'Baltimore', N'MD', 21275, N'7580932872')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (59, N'Avamba', N'48 Drewry Street', NULL, N'Evansville', N'IN', 47719, N'4519072314')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (60, N'Topiczoom', N'7 Marquette Parkway', NULL, N'San Antonio', N'TX', 78296, N'0645135903')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (61, N'Dabshots', N'26550 Merry Park', NULL, N'Stockton', N'CA', 95298, N'3680472351')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (62, N'Skynoodle', N'03 Di Loreto Lane', NULL, N'Annapolis', N'MD', 21405, N'2914775646')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (63, N'Kwimbee', N'8019 Cordelia Plaza', NULL, N'Orlando', N'FL', 32808, N'5201336254')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (64, N'Zoombeat', N'30 Kipling Court', NULL, N'Gulfport', N'MS', 39505, N'1797792909')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (65, N'Zooveo', N'18 Birchwood Center', NULL, N'Rochester', N'NY', 14624, N'4082428471')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (66, N'Jetwire', N'10 Badeau Lane', NULL, N'Cleveland', N'OH', 44191, N'5790051815')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (67, N'Abata', N'46 Jenifer Avenue', NULL, N'Monticello', N'MN', 55565, N'5906417037')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (68, N'Jatri', N'23624 Killdeer Road', NULL, N'Philadelphia', N'PA', 19104, N'4011687888')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (69, N'Rhynoodle', N'1 Melvin Point', NULL, N'Washington', N'DC', 20380, N'1147797294')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (70, N'Oloo', N'902 Sugar Pass', NULL, N'Stockton', N'CA', 95205, N'8385097134')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (71, N'Yadel', N'12291 Sutteridge Way', NULL, N'Worcester', N'MA', 1605, N'2093144119')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (72, N'Jetpulse', N'9 Glacier Hill Trail', NULL, N'Washington', N'DC', 20546, N'0567825907')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (73, N'Zooveo', N'0 Reinke Circle', NULL, N'Fairfax', N'VA', 22036, N'5325802678')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (74, N'Twitterbridge', N'83352 Mitchell Court', NULL, N'El Paso', N'TX', 88574, N'3936784845')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (75, N'Yakitri', N'3 Walton Pass', NULL, N'Milwaukee', N'WI', 53277, N'4145335118')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (76, N'Eidel', N'66 Redwing Lane', NULL, N'San Diego', N'CA', 92145, N'9868350032')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (77, N'Topicblab', N'66 Muir Parkway', NULL, N'Nashville', N'TN', 37210, N'9754443338')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (78, N'Eayo', N'108 High Crossing Court', NULL, N'Indianapolis', N'IN', 46295, N'3460466375')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (79, N'Mydo', N'5 Shopko Circle', NULL, N'New York City', N'NY', 10019, N'2867637906')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (80, N'Cogidoo', N'25 Bay Terrace', NULL, N'San Francisco', N'CA', 94105, N'4028599852')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (81, N'Flipbug', N'86 Prairie Rose Circle', NULL, N'Austin', N'TX', 78783, N'4691422972')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (82, N'Skyndu', N'211 Holy Cross Avenue', NULL, N'Bradenton', N'FL', 34282, N'2464137089')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (83, N'Skinix', N'03 Jenifer Road', NULL, N'Cincinnati', N'OH', 45233, N'7819989006')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (84, N'Nlounge', N'885 Dunning Plaza', NULL, N'Southfield', N'MI', 48076, N'3102948883')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (85, N'Dynabox', N'4356 Annamark Circle', NULL, N'Salt Lake City', N'UT', 84140, N'4186034617')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (86, N'Zoombox', N'83 Holy Cross Court', NULL, N'Albany', N'NY', 12255, N'3460739379')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (87, N'Browsebug', N'5007 Arrowood Court', NULL, N'Birmingham', N'AL', 35279, N'1716814092')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (88, N'Abatz', N'4 Marcy Plaza', NULL, N'Chicago', N'IL', 60657, N'7821233585')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (89, N'Topicshots', N'351 Moulton Way', NULL, N'Roanoke', N'VA', 24034, N'8577053838')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (90, N'Fivebridge', N'7546 Pierstorff Street', NULL, N'Des Moines', N'IA', 50369, N'3085362657')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (91, N'Realblab', N'2 Granby Plaza', NULL, N'Sacramento', N'CA', 94263, N'0066081549')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (92, N'Oyoloo', N'1 Merchant Court', NULL, N'Houston', N'TX', 77255, N'6336080719')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (93, N'Yata', N'16904 Nobel Lane', NULL, N'San Diego', N'CA', 92105, N'2102327077')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (94, N'Skinte', N'49 Bluejay Crossing', NULL, N'Phoenix', N'AZ', 85072, N'9185022604')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (95, N'Skajo', N'0 Randy Court', NULL, N'Fresno', N'CA', 93794, N'9913461617')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (96, N'Topiczoom', N'290 Sutherland Street', NULL, N'Springfield', N'OH', 45505, N'9662170006')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (97, N'Muxo', N'0833 Darwin Center', NULL, N'Charleston', N'SC', 29411, N'0027333117')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (98, N'Babbleblab', N'37 Dakota Point', NULL, N'Asheville', N'NC', 28815, N'4330567328')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (99, N'Vidoo', N'69458 Brown Point', NULL, N'Dallas', N'TX', 75358, N'9373750087')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (100, N'Camido', N'620 Florence Parkway', NULL, N'Littleton', N'CO', 80161, N'3182167706')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (101, N'Rhyzio', N'487 Little Fleur Plaza', NULL, N'Saint Petersburg', N'FL', 33742, N'0630964721')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (102, N'Kwilith', N'19 Arkansas Plaza', NULL, N'Fort Lauderdale', N'FL', 33325, N'5947148749')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (103, N'Devshare', N'3421 Washington Pass', NULL, N'San Francisco', N'CA', 94159, N'2921176995')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (104, N'Jabbercube', N'44584 Cordelia Park', NULL, N'Sacramento', N'CA', 95823, N'9081273533')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (105, N'Youspan', N'31860 Manley Center', NULL, N'Tucson', N'AZ', 85710, N'0314970480')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (106, N'Pixope', N'13780 Heath Street', NULL, N'Orlando', N'FL', 32808, N'9180382331')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (107, N'Livetube', N'2 Kenwood Plaza', NULL, N'Melbourne', N'FL', 32941, N'6769306212')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (108, N'Kwilith', N'53 Miller Street', NULL, N'Greensboro', N'NC', 27415, N'5813477731')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (109, N'Mynte', N'9841 Mandrake Drive', NULL, N'Norwalk', N'CT', 6859, N'7305247466')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (110, N'Roomm', N'2 Carpenter Center', NULL, N'Baton Rouge', N'LA', 70815, N'9455090760')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (111, N'Browsecat', N'066 Dorton Trail', NULL, N'Los Angeles', N'CA', 90081, N'5460476913')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (112, N'Yabox', N'3 Hanover Lane', NULL, N'Memphis', N'TN', 38109, N'8199258667')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (113, N'Topiczoom', N'3828 Comanche Alley', NULL, N'Canton', N'OH', 44705, N'2132412247')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (114, N'Skivee', N'645 Bunker Hill Road', NULL, N'Bronx', N'NY', 10459, N'1384004224')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (115, N'Jabbercube', N'98 Atwood Lane', NULL, N'Boca Raton', N'FL', 33487, N'2994119996')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (116, N'Topicshots', N'0030 Debs Junction', NULL, N'Cincinnati', N'OH', 45213, N'4802312163')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (117, N'Tavu', N'10 Fieldstone Junction', NULL, N'Charlotte', N'NC', 28242, N'2643148165')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (118, N'Brightdog', N'08 Mallard Point', NULL, N'New Haven', N'CT', 6520, N'6548131109')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (119, N'Blogtag', N'558 Atwood Plaza', NULL, N'Lexington', N'KY', 40581, N'5593813752')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (120, N'Ooba', N'4 School Way', NULL, N'Las Vegas', N'NV', 89160, N'6681017272')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (121, N'Yacero', N'80 Dapin Road', NULL, N'Fresno', N'CA', 93786, N'4733575579')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (122, N'Riffwire', N'9 Cardinal Park', NULL, N'Sacramento', N'CA', 95828, N'9963650300')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (123, N'Browsebug', N'0 5th Lane', NULL, N'Spokane', N'WA', 99252, N'6643866359')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (124, N'Yata', N'565 Helena Pass', NULL, N'Syracuse', N'NY', 13224, N'2329040749')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (125, N'Lajo', N'319 Kingsford Parkway', NULL, N'Fort Lauderdale', N'FL', 33330, N'8724297021')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (126, N'Zoovu', N'4316 Browning Park', NULL, N'Los Angeles', N'CA', 90076, N'5783281784')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (127, N'Ozu', N'00701 Carioca Road', NULL, N'Saint Paul', N'MN', 55172, N'5017954656')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (128, N'Avamba', N'2 Toban Junction', NULL, N'Hattiesburg', N'MS', 39404, N'5687984308')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (129, N'Reallinks', N'94785 Union Court', NULL, N'Melbourne', N'FL', 32919, N'3903223251')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (130, N'Jabberbean', N'1 Buell Road', NULL, N'Tucson', N'AZ', 85725, N'3737997440')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (131, N'Dabfeed', N'6947 Summerview Avenue', NULL, N'Alexandria', N'VA', 22333, N'2627470428')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (132, N'Eamia', N'61 Glacier Hill Crossing', NULL, N'Oakland', N'CA', 94616, N'3617790406')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (133, N'Skyble', N'5 Main Crossing', NULL, N'San Diego', N'CA', 92137, N'9615874650')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (134, N'Flashpoint', N'3836 Maryland Circle', NULL, N'Trenton', N'NJ', 8608, N'7340012598')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (135, N'Fivebridge', N'0 Jackson Road', NULL, N'Cincinnati', N'OH', 45218, N'4541651290')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (136, N'Meetz', N'45142 Clarendon Street', NULL, N'Crawfordsville', N'IN', 47937, N'1261039141')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (137, N'Yacero', N'2 Saint Paul Parkway', NULL, N'Salem', N'OR', 97306, N'2289049044')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (138, N'Babbleopia', N'45252 Vera Alley', NULL, N'Springfield', N'IL', 62756, N'9939348633')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (139, N'Twimbo', N'5997 Susan Junction', NULL, N'Indianapolis', N'IN', 46202, N'2881521043')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (140, N'Skipfire', N'165 Independence Parkway', NULL, N'Winston Salem', N'NC', 27150, N'8471859994')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (141, N'Yambee', N'6757 Messerschmidt Junction', NULL, N'Springfield', N'IL', 62764, N'6936034498')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (142, N'Oyoloo', N'890 Eliot Parkway', NULL, N'Lancaster', N'CA', 93584, N'9208309730')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (143, N'Dabvine', N'89116 Artisan Crossing', NULL, N'Arlington', N'VA', 22212, N'8637767651')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (144, N'Browseblab', N'31672 1st Park', NULL, N'Las Vegas', N'NV', 89140, N'3773439605')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (145, N'Livetube', N'27374 Eastlawn Pass', NULL, N'Washington', N'DC', 20205, N'7139878319')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (146, N'Wordware', N'24132 Utah Crossing', NULL, N'Washington', N'DC', 20310, N'4407530531')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (147, N'Quinu', N'6 Ramsey Drive', NULL, N'Washington', N'DC', 20046, N'0095038844')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (148, N'Eidel', N'1 Shoshone Plaza', NULL, N'Houston', N'TX', 77271, N'6280656803')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (149, N'Photobug', N'0 Blackbird Point', NULL, N'Los Angeles', N'CA', 90020, N'7537269702')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (150, N'Photobug', N'6 Truax Plaza', NULL, N'Levittown', N'PA', 19058, N'1514417916')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (151, N'Photobug', N'352 Redwing Center', NULL, N'Washington', N'DC', 20244, N'6274104612')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (152, N'Browsebug', N'14 Randy Court', NULL, N'San Francisco', N'CA', 94164, N'3673803018')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (153, N'Yacero', N'31010 Arrowood Junction', NULL, N'Lees Summit', N'MO', 64082, N'9920162904')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (154, N'Jaloo', N'7864 Sauthoff Center', NULL, N'Oxnard', N'CA', 93034, N'1245585561')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (155, N'Zoomzone', N'5875 Kim Circle', NULL, N'Denton', N'TX', 76205, N'0482602646')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (156, N'Trudoo', N'66 Continental Alley', NULL, N'Aurora', N'CO', 80045, N'2561095705')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (157, N'Browsetype', N'940 American Ash Circle', NULL, N'Portsmouth', N'VA', 23705, N'9126940785')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (158, N'Skibox', N'023 Grim Junction', NULL, N'Seattle', N'WA', 98109, N'3679373244')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (159, N'Mudo', N'6783 Bobwhite Way', NULL, N'Little Rock', N'AR', 72231, N'0252568204')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (160, N'Fanoodle', N'3 3rd Place', NULL, N'Tulsa', N'OK', 74170, N'3849050073')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (161, N'Jetpulse', N'09935 Commercial Avenue', NULL, N'New Orleans', N'LA', 70142, N'4514408174')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (162, N'Demizz', N'711 Melby Place', NULL, N'Tampa', N'FL', 33694, N'6699035842')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (163, N'Aivee', N'397 Eggendart Street', NULL, N'Temple', N'TX', 76505, N'5290170986')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (164, N'Riffpath', N'8 Burrows Circle', NULL, N'Tampa', N'FL', 33625, N'7284848322')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (165, N'Chatterbridge', N'1 Hayes Circle', NULL, N'Albuquerque', N'NM', 87140, N'1690043577')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (166, N'Brainverse', N'96 Duke Park', NULL, N'Lake Charles', N'LA', 70607, N'3855035403')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (167, N'Plambee', N'674 Autumn Leaf Place', NULL, N'Abilene', N'TX', 79699, N'3859590228')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (168, N'Voonix', N'15 Hooker Road', NULL, N'Tampa', N'FL', 33661, N'1796955073')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (169, N'Skaboo', N'9563 Golden Leaf Road', NULL, N'New York City', N'NY', 10115, N'0653694147')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (170, N'Fiveclub', N'80 Troy Park', NULL, N'Austin', N'TX', 78749, N'6347701879')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (171, N'Twitterbeat', N'7 Warbler Avenue', NULL, N'Aurora', N'CO', 80015, N'9809771620')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (172, N'Jayo', N'1195 Donald Avenue', NULL, N'Ogden', N'UT', 84409, N'3391199277')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (173, N'Twitterwire', N'7 Marquette Junction', NULL, N'Richmond', N'VA', 23225, N'1091155171')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (174, N'Oyondu', N'22798 Bartelt Avenue', NULL, N'Denver', N'CO', 80243, N'0395036814')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (175, N'Zoomcast', N'561 Rusk Place', NULL, N'Atlanta', N'GA', 30375, N'9474583431')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (176, N'Rhyloo', N'247 Clarendon Parkway', NULL, N'Memphis', N'TN', 38150, N'7198279710')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (177, N'Quimba', N'5 Anhalt Place', NULL, N'Athens', N'GA', 30605, N'3212086184')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (178, N'Tazzy', N'61 Burrows Way', NULL, N'Valdosta', N'GA', 31605, N'7706870846')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (179, N'Kazio', N'9321 Gerald Avenue', NULL, N'Santa Barbara', N'CA', 93111, N'5886510500')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (180, N'Rhynoodle', N'4 Mccormick Pass', NULL, N'New Haven', N'CT', 6520, N'7163434062')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (181, N'Agivu', N'4 Homewood Pass', NULL, N'Decatur', N'IL', 62525, N'3992436791')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (182, N'Roodel', N'8 Shoshone Alley', NULL, N'Peoria', N'IL', 61656, N'5396572950')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (183, N'Zava', N'40132 Emmet Point', NULL, N'Birmingham', N'AL', 35236, N'2193118309')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (184, N'Photobug', N'75 Gerald Circle', NULL, N'Richmond', N'VA', 23293, N'6674445216')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (185, N'Fanoodle', N'09238 Calypso Junction', NULL, N'Frederick', N'MD', 21705, N'1200573742')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (186, N'Einti', N'53294 Kinsman Pass', NULL, N'Albuquerque', N'NM', 87180, N'7094713016')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (187, N'Photofeed', N'4 Carpenter Street', NULL, N'Des Moines', N'IA', 50393, N'6489742763')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (188, N'Mymm', N'15 Clyde Gallagher Crossing', NULL, N'Baton Rouge', N'LA', 70805, N'4486441681')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (189, N'Trilith', N'1490 Saint Paul Avenue', NULL, N'Fresno', N'CA', 93704, N'1608567082')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (190, N'InnoZ', N'76 Barnett Plaza', NULL, N'Charlotte', N'NC', 28256, N'5140983557')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (191, N'LiveZ', N'764 Portage Junction', NULL, N'Bryan', N'TX', 77806, N'0143113630')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (192, N'Dabtype', N'1484 Namekagon Avenue', NULL, N'Phoenix', N'AZ', 85077, N'2667739936')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (193, N'Oodoo', N'67 Meadow Valley Point', NULL, N'Anaheim', N'CA', 92812, N'5737591995')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (194, N'Oyonder', N'621 Ruskin Drive', NULL, N'Athens', N'GA', 30605, N'5692219389')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (195, N'Skivee', N'76 Heath Parkway', NULL, N'Phoenix', N'AZ', 85072, N'7501426175')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (196, N'Kamba', N'4676 Anhalt Place', NULL, N'Santa Ana', N'CA', 92725, N'8578255236')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (197, N'Skibox', N'93219 Sunbrook Avenue', NULL, N'Knoxville', N'TN', 37931, N'6855088337')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (198, N'Quaxo', N'70256 Onsgard Road', NULL, N'Oklahoma City', N'OK', 73147, N'1615108403')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (199, N'Eadel', N'244 Algoma Alley', NULL, N'Gatesville', N'TX', 76598, N'0143726734')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (200, N'Vinte', N'8 Anhalt Park', NULL, N'Mount Vernon', N'NY', 10557, N'9880352171')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (201, N'Fatz', N'0 Almo Avenue', NULL, N'Atlanta', N'GA', 30328, N'4829720797')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (202, N'Flashspan', N'2 Surrey Pass', NULL, N'Stockton', N'CA', 95219, N'3740908099')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (203, N'Rhycero', N'662 Ronald Regan Center', NULL, N'Washington', N'DC', 20260, N'7604078023')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (204, N'Zoonoodle', N'43 Hanson Circle', NULL, N'Tucson', N'AZ', 85705, N'4715822296')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (205, N'Wikivu', N'26658 Eastlawn Parkway', NULL, N'Dallas', N'TX', 75342, N'3610849678')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (206, N'Roombo', N'2918 Lillian Terrace', NULL, N'Tallahassee', N'FL', 32399, N'4617450075')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (207, N'Ainyx', N'87585 Texas Terrace', NULL, N'San Bernardino', N'CA', 92410, N'6243400574')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (208, N'Photofeed', N'04 Village Parkway', NULL, N'Akron', N'OH', 44305, N'5636407114')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (209, N'Browseblab', N'12 Karstens Street', NULL, N'Santa Fe', N'NM', 87505, N'1891226600')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (210, N'Mydeo', N'065 Anderson Terrace', NULL, N'Valley Forge', N'PA', 19495, N'9029058428')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (211, N'Eare', N'99546 Haas Junction', NULL, N'Los Angeles', N'CA', 90060, N'6029723982')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (212, N'Gigaclub', N'27889 Spaight Junction', NULL, N'Boise', N'ID', 83711, N'2203747572')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (213, N'Skipstorm', N'704 Dapin Place', NULL, N'Schenectady', N'NY', 12325, N'2492612334')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (214, N'Lajo', N'24 Lakewood Gardens Alley', NULL, N'Saginaw', N'MI', 48604, N'7240755879')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (215, N'Kwideo', N'3 Eagan Pass', NULL, N'Metairie', N'LA', 70005, N'2362122034')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (216, N'Yombu', N'280 Acker Drive', NULL, N'Mesquite', N'TX', 75185, N'5225726206')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (217, N'Youfeed', N'1 Washington Junction', NULL, N'Austin', N'TX', 78710, N'9053649560')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (218, N'Wikibox', N'55657 Vera Circle', NULL, N'Houston', N'TX', 77015, N'3998192875')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (219, N'Wikizz', N'5856 Almo Drive', NULL, N'Anaheim', N'CA', 92825, N'2083572860')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (220, N'Tagfeed', N'5730 Linden Hill', NULL, N'Jefferson City', N'MO', 65105, N'2090263688')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (221, N'Tagfeed', N'2 Clarendon Point', NULL, N'Elmira', N'NY', 14905, N'6626006758')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (222, N'Edgetag', N'96 Parkside Alley', NULL, N'Saint Paul', N'MN', 55115, N'6343988506')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (223, N'Devcast', N'0411 Northland Lane', NULL, N'Oklahoma City', N'OK', 73152, N'2133031491')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (224, N'Skipstorm', N'2880 Everett Court', NULL, N'Jamaica', N'NY', 11499, N'0072142227')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (225, N'Kwimbee', N'895 Sullivan Hill', NULL, N'Miami', N'FL', 33233, N'5586005561')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (226, N'Shufflebeat', N'81968 Annamark Park', NULL, N'Providence', N'RI', 2912, N'1719246670')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (227, N'Feedfire', N'3087 Utah Point', NULL, N'Corpus Christi', N'TX', 78470, N'3674076120')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (228, N'Edgeify', N'6 Karstens Way', NULL, N'Saint Augustine', N'FL', 32092, N'9752699507')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (229, N'Bubblebox', N'117 Vernon Trail', NULL, N'Saint Paul', N'MN', 55108, N'2684671204')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (230, N'Feedmix', N'2837 Aberg Avenue', NULL, N'Richmond', N'VA', 23225, N'2912315439')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (231, N'Agimba', N'35 Raven Pass', NULL, N'Charleston', N'SC', 29416, N'6556639836')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (232, N'Bubblebox', N'9447 Miller Court', NULL, N'Jacksonville', N'FL', 32255, N'2239196914')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (233, N'Yodo', N'73509 Onsgard Circle', NULL, N'Rochester', N'NY', 14646, N'0613897347')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (234, N'Buzzbean', N'87460 Talisman Lane', NULL, N'Bellevue', N'WA', 98008, N'7411071364')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (235, N'Janyx', N'95986 Pierstorff Street', NULL, N'Louisville', N'KY', 40215, N'0488565707')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (236, N'Twinte', N'898 Macpherson Crossing', NULL, N'Phoenix', N'AZ', 85025, N'6679576737')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (237, N'Lajo', N'1639 Sullivan Circle', NULL, N'Milwaukee', N'WI', 53285, N'9624394794')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (238, N'Twitterbeat', N'5676 Bobwhite Avenue', NULL, N'Columbus', N'OH', 43204, N'3403251145')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (239, N'Skimia', N'2 Brickson Park Center', NULL, N'Miami', N'FL', 33245, N'8523054176')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (240, N'Jetpulse', N'1 Dunning Point', NULL, N'Cleveland', N'OH', 44177, N'6166402095')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (241, N'Avavee', N'44616 Donald Center', NULL, N'Sacramento', N'CA', 95833, N'8056628839')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (242, N'Vimbo', N'64492 8th Place', NULL, N'Killeen', N'TX', 76544, N'1807876079')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (243, N'Centizu', N'97 Saint Paul Place', NULL, N'Greenville', N'SC', 29615, N'6014909516')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (244, N'Yacero', N'7 Bartelt Crossing', NULL, N'Phoenix', N'AZ', 85045, N'7441354438')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (245, N'Thoughtstorm', N'7 Oak Court', NULL, N'Madison', N'WI', 53705, N'6069905808')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (246, N'Thoughtbridge', N'7773 Colorado Street', NULL, N'Seattle', N'WA', 98115, N'9322311674')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (247, N'Aimbo', N'39652 Towne Lane', NULL, N'Lynchburg', N'VA', 24503, N'9076399885')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (248, N'Gabcube', N'277 Schlimgen Junction', NULL, N'Pittsburgh', N'PA', 15250, N'7111075136')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (249, N'Ainyx', N'88 Haas Way', NULL, N'Minneapolis', N'MN', 55441, N'0670733129')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (250, N'Vipe', N'7 Maple Wood Center', NULL, N'Pensacola', N'FL', 32590, N'2044903751')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (251, N'Yata', N'94271 Golf View Lane', NULL, N'Largo', N'FL', 34643, N'3099272342')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (252, N'Yozio', N'2 Crownhardt Place', NULL, N'Northridge', N'CA', 91328, N'8277700667')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (253, N'Agivu', N'481 Arkansas Terrace', NULL, N'Atlanta', N'GA', 31106, N'5918272174')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (254, N'Zoombox', N'2937 Superior Court', NULL, N'Tampa', N'FL', 33673, N'1723641421')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (255, N'Viva', N'2 Blaine Crossing', NULL, N'Carol Stream', N'IL', 60158, N'3663701561')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (256, N'Skimia', N'2000 Mallard Trail', NULL, N'Greensboro', N'NC', 27404, N'2267317263')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (257, N'Skiptube', N'01 Forster Terrace', NULL, N'Buffalo', N'NY', 14225, N'1433628905')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (258, N'Teklist', N'0194 Brown Terrace', NULL, N'Palm Bay', N'FL', 32909, N'3256033780')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (259, N'Eabox', N'92571 Macpherson Hill', NULL, N'Baton Rouge', N'LA', 70883, N'3579600750')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (260, N'Myworks', N'6654 Hazelcrest Alley', NULL, N'Daytona Beach', N'FL', 32118, N'6759849202')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (261, N'Bubblemix', N'314 Thackeray Avenue', NULL, N'Cincinnati', N'OH', 45238, N'7155702286')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (262, N'Skippad', N'5 Service Way', NULL, N'Round Rock', N'TX', 78682, N'6910746957')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (263, N'Ailane', N'8048 Mifflin Court', NULL, N'San Bernardino', N'CA', 92424, N'5561138927')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (264, N'Skyvu', N'39457 Weeping Birch Junction', NULL, N'Johnson City', N'TN', 37605, N'9154995763')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (265, N'Oozz', N'100 Valley Edge Court', NULL, N'Bradenton', N'FL', 34205, N'1189407763')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (266, N'Pixope', N'374 Lakewood Parkway', NULL, N'Joliet', N'IL', 60435, N'9997272378')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (267, N'Rhynyx', N'866 Reinke Street', NULL, N'Richmond', N'VA', 23203, N'1989645115')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (268, N'Dabjam', N'29 5th Road', NULL, N'Topeka', N'KS', 66667, N'3292264920')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (269, N'Avamm', N'0284 Old Gate Street', NULL, N'Sacramento', N'CA', 95894, N'2445148796')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (270, N'Lajo', N'2 Schmedeman Parkway', NULL, N'Tyler', N'TX', 75710, N'6902475825')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (271, N'Kwimbee', N'83 Susan Plaza', NULL, N'Philadelphia', N'PA', 19109, N'8677492133')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (272, N'Quinu', N'64 Dunning Alley', NULL, N'Des Moines', N'IA', 50320, N'5007861624')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (273, N'Babblestorm', N'6285 Farmco Street', NULL, N'Tulsa', N'OK', 74108, N'3721103985')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (274, N'Buzzster', N'764 Farragut Lane', NULL, N'Portland', N'OR', 97255, N'9250671879')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (275, N'Quatz', N'293 Hintze Way', NULL, N'Knoxville', N'TN', 37931, N'7838520439')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (276, N'Skimia', N'32328 Browning Road', NULL, N'West Palm Beach', N'FL', 33416, N'6129539667')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (277, N'Mudo', N'458 Riverside Parkway', NULL, N'Colorado Springs', N'CO', 80930, N'1049910283')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (278, N'Centidel', N'51256 Duke Center', NULL, N'North Little Rock', N'AR', 72118, N'4110473089')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (279, N'Cogidoo', N'36730 Duke Circle', NULL, N'Louisville', N'KY', 40266, N'5038941114')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (280, N'Devpoint', N'747 Cherokee Court', NULL, N'Jeffersonville', N'IN', 47134, N'1956810299')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (281, N'Livepath', N'8 Melby Park', NULL, N'San Diego', N'CA', 92121, N'3626689597')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (282, N'Reallinks', N'5 Jenifer Avenue', NULL, N'Johnstown', N'PA', 15906, N'4261701721')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (283, N'Mynte', N'56435 Bunker Hill Street', NULL, N'Roanoke', N'VA', 24020, N'8769710495')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (284, N'Divavu', N'7 Mosinee Point', NULL, N'Wilmington', N'DE', 19805, N'2222491530')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (285, N'Zoonoodle', N'60689 Alpine Parkway', NULL, N'Atlanta', N'GA', 31119, N'9284331441')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (286, N'Thoughtsphere', N'184 Cordelia Junction', NULL, N'Tucson', N'AZ', 85715, N'0358252443')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (287, N'Voonix', N'90 New Castle Avenue', NULL, N'Cleveland', N'OH', 44185, N'2806891755')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (288, N'Kayveo', N'44 Aberg Plaza', NULL, N'Atlanta', N'GA', 30386, N'8387134408')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (289, N'Quinu', N'5 Nancy Parkway', NULL, N'Brockton', N'MA', 2405, N'6397974083')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (290, N'Yoveo', N'771 7th Crossing', NULL, N'Bethlehem', N'PA', 18018, N'7502032250')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (291, N'Meemm', N'49 Crowley Street', NULL, N'Dallas', N'TX', 75210, N'4803207265')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (292, N'Photolist', N'680 Westport Way', NULL, N'Visalia', N'CA', 93291, N'2710127604')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (293, N'Jaxbean', N'58 Muir Plaza', NULL, N'Chicago', N'IL', 60669, N'1921908183')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (294, N'Demivee', N'52061 Luster Lane', NULL, N'Omaha', N'NE', 68144, N'5379729367')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (295, N'Skalith', N'297 New Castle Park', NULL, N'Mesa', N'AZ', 85215, N'9245867486')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (296, N'Snaptags', N'2615 Russell Drive', NULL, N'Richmond', N'VA', 23293, N'7554542959')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (297, N'Linktype', N'9756 Glendale Junction', NULL, N'Fort Wayne', N'IN', 46805, N'0206764469')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (298, N'Jaxbean', N'8927 Sunnyside Center', NULL, N'Anchorage', N'AK', 99512, N'4297300395')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (299, N'Flashset', N'0 Orin Trail', NULL, N'Houston', N'TX', 77035, N'1955127781')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (300, N'Blognation', N'7 Bartelt Crossing', NULL, N'Bronx', N'NY', 10474, N'6495832271')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (301, N'Yodo', N'6708 Sunnyside Drive', NULL, N'Frederick', N'MD', 21705, N'2883832388')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (302, N'Reallinks', N'1 Moulton Terrace', NULL, N'Sunnyvale', N'CA', 94089, N'7867259910')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (303, N'Meembee', N'6300 Victoria Alley', NULL, N'Knoxville', N'TN', 37939, N'2464180853')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (304, N'Kimia', N'2 Rockefeller Pass', NULL, N'Peoria', N'AZ', 85383, N'0701705880')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (305, N'Skinder', N'455 Roth Court', NULL, N'Houston', N'TX', 77075, N'8222021354')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (306, N'Ailane', N'93 Scofield Circle', NULL, N'Detroit', N'MI', 48211, N'1225552771')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (307, N'Skyvu', N'09 Canary Street', NULL, N'Washington', N'DC', 20067, N'2522129512')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (308, N'Brainbox', N'4 Vahlen Crossing', NULL, N'Buffalo', N'NY', 14269, N'6622600646')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (309, N'Jaxworks', N'97 Prairieview Park', NULL, N'Richmond', N'VA', 23293, N'7767344564')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (310, N'Pixonyx', N'232 Bellgrove Parkway', NULL, N'Dallas', N'TX', 75287, N'8371050068')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (311, N'Linkbridge', N'19686 Blackbird Circle', NULL, N'Hialeah', N'FL', 33013, N'3378516091')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (312, N'Browsezoom', N'991 Nelson Lane', NULL, N'Orlando', N'FL', 32859, N'1257808772')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (313, N'Roombo', N'61 3rd Lane', NULL, N'Mobile', N'AL', 36641, N'5011980637')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (314, N'Einti', N'9835 Mallard Trail', NULL, N'Memphis', N'TN', 38119, N'0378891977')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (315, N'Skyble', N'926 Cordelia Park', NULL, N'Peoria', N'IL', 61605, N'0674903342')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (316, N'Zooveo', N'27 Melby Plaza', NULL, N'Austin', N'TX', 78789, N'4933005421')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (317, N'Babbleset', N'8 Bobwhite Terrace', NULL, N'Palmdale', N'CA', 93591, N'7648208989')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (318, N'Topiczoom', N'67 Algoma Circle', NULL, N'Nashville', N'TN', 37210, N'0572173769')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (319, N'Tagtune', N'6 Darwin Terrace', NULL, N'Charlotte', N'NC', 28225, N'4782499282')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (320, N'Zoonder', N'35 Moulton Center', NULL, N'Wilmington', N'DE', 19892, N'4773208198')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (321, N'Kamba', N'76378 Lakewood Gardens Junction', NULL, N'Tyler', N'TX', 75705, N'2611104149')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (322, N'Edgeclub', N'05860 Dayton Plaza', NULL, N'Atlanta', N'GA', 30392, N'0862922971')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (323, N'Camimbo', N'50897 Memorial Circle', NULL, N'Hartford', N'CT', 6120, N'9281544245')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (324, N'Browsedrive', N'6 Bunting Court', NULL, N'Las Vegas', N'NV', 89193, N'5237994733')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (325, N'Twitterwire', N'09551 Melrose Terrace', NULL, N'Austin', N'TX', 78721, N'7688979649')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (326, N'Wikizz', N'31 Lunder Hill', NULL, N'Tyler', N'TX', 75710, N'2789170783')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (327, N'Dabfeed', N'599 Summer Ridge Avenue', NULL, N'Pueblo', N'CO', 81015, N'2125067250')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (328, N'Eadel', N'7570 Sunnyside Pass', NULL, N'Lees Summit', N'MO', 64082, N'5223944831')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (329, N'Katz', N'455 Buena Vista Court', NULL, N'Homestead', N'FL', 33034, N'0897601028')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (330, N'BlogXS', N'370 Armistice Place', NULL, N'Hamilton', N'OH', 45020, N'5493577796')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (331, N'Gabtype', N'359 Duke Terrace', NULL, N'Santa Rosa', N'CA', 95405, N'8750414878')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (332, N'Skinder', N'8 Utah Circle', NULL, N'Orlando', N'FL', 32868, N'1206111445')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (333, N'Rhyloo', N'30 Reindahl Parkway', NULL, N'Fort Collins', N'CO', 80525, N'5877597588')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (334, N'Centidel', N'08 Veith Terrace', NULL, N'Roanoke', N'VA', 24014, N'2537111144')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (335, N'Quinu', N'13280 Meadow Valley Lane', NULL, N'West Palm Beach', N'FL', 33421, N'4712779207')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (336, N'Skidoo', N'81670 Melody Terrace', NULL, N'Wichita', N'KS', 67220, N'4418824142')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (337, N'Avaveo', N'973 Di Loreto Pass', NULL, N'Knoxville', N'TN', 37919, N'2729893832')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (338, N'Miboo', N'9 Green Ridge Point', NULL, N'Pinellas Park', N'FL', 34665, N'3156494258')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (339, N'Meezzy', N'5 Corben Drive', NULL, N'Tucson', N'AZ', 85705, N'7833775875')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (340, N'Blogspan', N'0 Brentwood Street', NULL, N'Jamaica', N'NY', 11407, N'8855087742')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (341, N'Cogidoo', N'001 Sachtjen Crossing', NULL, N'High Point', N'NC', 27264, N'9683597958')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (342, N'Muxo', N'15 Garrison Lane', NULL, N'Columbus', N'MS', 39705, N'7206004469')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (343, N'Digitube', N'900 Prentice Terrace', NULL, N'Fairbanks', N'AK', 99709, N'0240972607')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (344, N'Wordify', N'34651 Hollow Ridge Place', NULL, N'El Paso', N'TX', 79989, N'3923965093')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (345, N'Quimba', N'692 8th Drive', NULL, N'Saint Louis', N'MO', 63143, N'9294569554')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (346, N'Vitz', N'49 Dixon Point', NULL, N'Trenton', N'NJ', 8638, N'8042659206')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (347, N'Dabshots', N'103 Fremont Trail', NULL, N'Milwaukee', N'WI', 53215, N'6707017380')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (348, N'Bubblebox', N'800 Upham Crossing', NULL, N'Las Vegas', N'NV', 89120, N'3417648270')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (349, N'Livetube', N'6 Sycamore Crossing', NULL, N'Peoria', N'IL', 61651, N'1677246196')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (350, N'Ainyx', N'522 Sommers Drive', NULL, N'Houston', N'TX', 77040, N'4704298507')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (351, N'Aimbo', N'231 Ryan Alley', NULL, N'Gastonia', N'NC', 28055, N'7677001802')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (352, N'Jaxbean', N'49772 Manley Terrace', NULL, N'Memphis', N'TN', 38181, N'7507379832')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (353, N'Layo', N'64 6th Park', NULL, N'Pittsburgh', N'PA', 15205, N'4162325814')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (354, N'Skyvu', N'788 Sloan Street', NULL, N'Pittsburgh', N'PA', 15205, N'4190700681')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (355, N'Zooxo', N'2 Erie Avenue', NULL, N'Jackson', N'MS', 39210, N'2041938419')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (356, N'Divavu', N'3 Elka Center', NULL, N'Rochester', N'NY', 14639, N'4045686851')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (357, N'Twinder', N'89231 Walton Alley', NULL, N'Winston Salem', N'NC', 27150, N'3584676155')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (358, N'Jaxworks', N'22 Morrow Pass', NULL, N'Roanoke', N'VA', 24034, N'6959913715')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (359, N'Bluezoom', N'957 Rieder Point', NULL, N'Sterling', N'VA', 20167, N'7590941747')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (360, N'Trunyx', N'76 Evergreen Trail', NULL, N'Washington', N'DC', 20238, N'2614893823')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (361, N'Realfire', N'03 Dixon Center', NULL, N'Fort Pierce', N'FL', 34981, N'0295407795')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (362, N'Wordify', N'9 Maple Wood Trail', NULL, N'North Hollywood', N'CA', 91606, N'6852398307')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (363, N'Photobug', N'294 Victoria Way', NULL, N'Seattle', N'WA', 98185, N'0191429675')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (364, N'Devify', N'6 Continental Terrace', NULL, N'Saint Petersburg', N'FL', 33737, N'7939691752')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (365, N'Fadeo', N'8969 Cascade Park', NULL, N'Minneapolis', N'MN', 55423, N'5967597996')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (366, N'Twinder', N'3345 Holmberg Avenue', NULL, N'Augusta', N'GA', 30911, N'1641881831')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (367, N'Yakitri', N'60023 Lakewood Drive', NULL, N'Indianapolis', N'IN', 46254, N'9792622967')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (368, N'Gabtune', N'677 Monterey Parkway', NULL, N'Jamaica', N'NY', 11431, N'9712299185')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (369, N'Trudoo', N'6 Forest Place', NULL, N'Tulsa', N'OK', 74116, N'7124261102')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (370, N'Shufflebeat', N'4915 Jenifer Avenue', NULL, N'Pittsburgh', N'PA', 15235, N'1655471057')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (371, N'Meembee', N'2280 Maryland Center', NULL, N'Atlanta', N'GA', 30311, N'3379462828')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (372, N'Cogilith', N'8 Village Green Hill', NULL, N'Albany', N'NY', 12237, N'9658424902')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (373, N'Realbuzz', N'50909 Katie Street', NULL, N'Bakersfield', N'CA', 93305, N'8336056503')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (374, N'Thoughtstorm', N'06 Clove Court', NULL, N'Dallas', N'TX', 75241, N'0811162945')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (375, N'Fadeo', N'094 Moland Trail', NULL, N'Louisville', N'KY', 40215, N'0827931942')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (376, N'Edgepulse', N'4 Rutledge Way', NULL, N'Orlando', N'FL', 32885, N'7368785851')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (377, N'Flashspan', N'87249 Arizona Park', NULL, N'Clearwater', N'FL', 33763, N'1094462081')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (378, N'Skippad', N'26378 Gale Terrace', NULL, N'Indianapolis', N'IN', 46295, N'6149031203')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (379, N'Yambee', N'75462 Merchant Street', NULL, N'Long Beach', N'CA', 90831, N'0797002359')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (380, N'Trilith', N'069 Hanover Park', NULL, N'Austin', N'TX', 78710, N'6512702836')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (381, N'Leenti', N'69037 Colorado Pass', NULL, N'Anchorage', N'AK', 99517, N'5540867052')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (382, N'Tanoodle', N'64 Esch Avenue', NULL, N'El Paso', N'TX', 88563, N'6115536547')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (383, N'Podcat', N'171 Mallory Crossing', NULL, N'Indianapolis', N'IN', 46226, N'5842024734')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (384, N'Quinu', N'52679 1st Junction', NULL, N'Dayton', N'OH', 45470, N'6551096756')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (385, N'Buzzbean', N'24473 Stoughton Pass', NULL, N'Baltimore', N'MD', 21239, N'8219859026')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (386, N'Photofeed', N'4717 Becker Center', NULL, N'Birmingham', N'AL', 35210, N'6153165121')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (387, N'Jabberstorm', N'4 Orin Hill', NULL, N'Houston', N'TX', 77030, N'8011841375')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (388, N'Zoonoodle', N'0740 Vera Point', NULL, N'Greensboro', N'NC', 27404, N'7869422868')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (389, N'Devshare', N'0433 Ridgeway Trail', NULL, N'Suffolk', N'VA', 23436, N'5803279107')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (390, N'Voonder', N'234 Hovde Center', NULL, N'Corpus Christi', N'TX', 78405, N'7798122572')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (391, N'Jaloo', N'6684 Ridge Oak Drive', NULL, N'Huntington', N'WV', 25711, N'2510887431')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (392, N'Ntag', N'7085 Morning Crossing', NULL, N'Richmond', N'VA', 23272, N'3159976488')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (393, N'Linktype', N'569 Hollow Ridge Place', NULL, N'Brea', N'CA', 92822, N'3887949148')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (394, N'Voonyx', N'9 Oneill Crossing', NULL, N'Washington', N'DC', 20260, N'2263970352')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (395, N'Divanoodle', N'988 Roth Circle', NULL, N'Saint Louis', N'MO', 63116, N'7123115183')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (396, N'Kazio', N'3 Haas Point', NULL, N'San Diego', N'CA', 92132, N'3842677751')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (397, N'Skibox', N'38 New Castle Terrace', NULL, N'Little Rock', N'AR', 72209, N'1351328700')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (398, N'Realmix', N'0371 Meadow Valley Parkway', NULL, N'Washington', N'DC', 20041, N'6941843876')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (399, N'Skyvu', N'0673 Mallard Junction', NULL, N'Oakland', N'CA', 94616, N'1932643892')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (400, N'Jetpulse', N'9 Northridge Terrace', NULL, N'Washington', N'DC', 20557, N'5823098476')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (401, N'Tazzy', N'7778 Dryden Plaza', NULL, N'Philadelphia', N'PA', 19196, N'8176010813')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (402, N'Vidoo', N'710 Coolidge Avenue', NULL, N'Sacramento', N'CA', 94297, N'2704924881')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (403, N'Shufflester', N'34683 Fuller Hill', NULL, N'Pittsburgh', N'PA', 15274, N'2143486392')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (404, N'Fliptune', N'53 1st Parkway', NULL, N'Inglewood', N'CA', 90398, N'3087256833')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (405, N'Photofeed', N'578 Kinsman Point', NULL, N'South Bend', N'IN', 46620, N'3271112939')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (406, N'Skinder', N'69158 Blaine Plaza', NULL, N'Raleigh', N'NC', 27605, N'4770031802')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (407, N'Bubbletube', N'45511 Porter Pass', NULL, N'Chicago', N'IL', 60636, N'6769392971')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (408, N'Mymm', N'43 Harbort Center', NULL, N'San Antonio', N'TX', 78278, N'1689178857')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (409, N'Twitterbeat', N'62987 South Circle', NULL, N'Flint', N'MI', 48555, N'1024091395')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (410, N'Yadel', N'2822 Village Green Junction', NULL, N'Kansas City', N'MO', 64101, N'5815991145')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (411, N'Midel', N'0 Maywood Center', NULL, N'San Luis Obispo', N'CA', 93407, N'9130767501')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (412, N'Eazzy', N'066 Dahle Alley', NULL, N'Chicago', N'IL', 60636, N'3874853716')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (413, N'Pixope', N'49 Green Street', NULL, N'Tulsa', N'OK', 74193, N'6037705236')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (414, N'Topdrive', N'3 Jenna Avenue', NULL, N'Flint', N'MI', 48550, N'3727119608')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (415, N'Twitterworks', N'3 Maryland Place', NULL, N'Des Moines', N'IA', 50347, N'9774581538')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (416, N'Kaymbo', N'17036 North Park', NULL, N'Midland', N'TX', 79705, N'3844374415')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (417, N'Fadeo', N'85176 Atwood Parkway', NULL, N'Des Moines', N'IA', 50320, N'5153179806')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (418, N'Janyx', N'972 Farragut Way', NULL, N'Washington', N'DC', 20337, N'9537406074')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (419, N'Oyoba', N'747 Merry Trail', NULL, N'Sioux City', N'IA', 51110, N'6441008051')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (420, N'Kayveo', N'48325 Village Green Alley', NULL, N'Littleton', N'CO', 80127, N'5461200887')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (421, N'Eabox', N'9720 Spenser Terrace', NULL, N'Milwaukee', N'WI', 53215, N'9716657913')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (422, N'Browsecat', N'53337 North Terrace', NULL, N'Wilkes Barre', N'PA', 18768, N'1550024536')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (423, N'Mymm', N'654 Veith Way', NULL, N'Erie', N'PA', 16534, N'1979548303')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (424, N'Jamia', N'1993 Superior Street', NULL, N'Topeka', N'KS', 66642, N'9637459433')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (425, N'Skinix', N'667 Cardinal Court', NULL, N'Denver', N'CO', 80223, N'6125003283')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (426, N'Rhycero', N'50088 Warrior Way', NULL, N'Boston', N'MA', 2203, N'3907270916')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (427, N'Quamba', N'9737 Elka Crossing', NULL, N'Saint Louis', N'MO', 63136, N'7036169217')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (428, N'Zoomdog', N'1738 Morningstar Point', NULL, N'Boulder', N'CO', 80328, N'9081917966')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (429, N'Eamia', N'137 Roxbury Point', NULL, N'Miami', N'FL', 33245, N'7112038922')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (430, N'Devbug', N'85 Kenwood Road', NULL, N'Birmingham', N'AL', 35220, N'3728773321')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (431, N'Demizz', N'7102 Springview Avenue', NULL, N'Dallas', N'TX', 75392, N'5264197081')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (432, N'Babblestorm', N'2937 Sycamore Road', NULL, N'San Mateo', N'CA', 94405, N'5737371371')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (433, N'Mymm', N'8924 Di Loreto Road', NULL, N'Youngstown', N'OH', 44505, N'1164062423')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (434, N'Skipfire', N'09 Truax Junction', NULL, N'Washington', N'DC', 20503, N'1087101323')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (435, N'Mymm', N'98843 Schurz Center', NULL, N'Louisville', N'KY', 40225, N'3318644396')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (436, N'Fanoodle', N'5771 Duke Center', NULL, N'El Paso', N'TX', 88569, N'0945507013')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (437, N'Buzzshare', N'926 Hazelcrest Junction', NULL, N'Pensacola', N'FL', 32590, N'7186076923')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (438, N'Skalith', N'20016 Eastlawn Park', NULL, N'Detroit', N'MI', 48232, N'2247477733')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (439, N'Oodoo', N'0677 Forest Parkway', NULL, N'Bethesda', N'MD', 20816, N'9728584603')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (440, N'Podcat', N'11 Twin Pines Place', NULL, N'Spokane', N'WA', 99210, N'0445365252')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (441, N'Browseblab', N'19 Thierer Point', NULL, N'College Station', N'TX', 77844, N'2434998916')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (442, N'Vinder', N'80 Debs Point', NULL, N'Los Angeles', N'CA', 90020, N'2326383632')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (443, N'Flipbug', N'24547 Oakridge Way', NULL, N'Trenton', N'NJ', 8695, N'0005630323')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (444, N'Twitterworks', N'96515 Melby Court', NULL, N'Toledo', N'OH', 43635, N'1581895427')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (445, N'Oyonder', N'60 Nevada Center', NULL, N'Raleigh', N'NC', 27621, N'3503447755')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (446, N'Quinu', N'3 Warner Junction', NULL, N'Houston', N'TX', 77240, N'7070187175')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (447, N'Browsebug', N'7 Paget Plaza', NULL, N'Philadelphia', N'PA', 19125, N'6832266720')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (448, N'Skiptube', N'304 Burning Wood Drive', NULL, N'Amarillo', N'TX', 79171, N'4726095015')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (449, N'Vinder', N'242 Summerview Plaza', NULL, N'Washington', N'DC', 20046, N'3359577358')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (450, N'Gigazoom', N'7110 Gateway Circle', NULL, N'Young America', N'MN', 55551, N'6275397270')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (451, N'Yodoo', N'9462 Colorado Court', NULL, N'Myrtle Beach', N'SC', 29579, N'4162541113')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (452, N'Jetwire', N'832 Memorial Plaza', NULL, N'Riverside', N'CA', 92519, N'0028658289')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (453, N'Yotz', N'5 Birchwood Trail', NULL, N'Fort Worth', N'TX', 76121, N'9324822764')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (454, N'Photobug', N'78 Dixon Parkway', NULL, N'Akron', N'OH', 44329, N'7113346706')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (455, N'Realpoint', N'73362 Hintze Circle', NULL, N'Brockton', N'MA', 2405, N'6713969807')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (456, N'InnoZ', N'0744 Acker Crossing', NULL, N'Charleston', N'WV', 25336, N'7324840323')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (457, N'Eare', N'73016 Porter Avenue', NULL, N'Wichita', N'KS', 67236, N'7951442661')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (458, N'Devcast', N'05022 Muir Center', NULL, N'Chico', N'CA', 95973, N'3684423633')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (459, N'Edgeblab', N'5 6th Crossing', NULL, N'Tampa', N'FL', 33615, N'2622873753')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (460, N'Yadel', N'3 Luster Place', NULL, N'Trenton', N'NJ', 8650, N'8080753423')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (461, N'Jabberstorm', N'41 International Hill', NULL, N'Cincinnati', N'OH', 45254, N'3209298210')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (462, N'Voonix', N'84 Grover Junction', NULL, N'Austin', N'TX', 78737, N'9651230244')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (463, N'Npath', N'3 Cardinal Junction', NULL, N'Toledo', N'OH', 43656, N'8360203777')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (464, N'Tagchat', N'9 Moulton Place', NULL, N'Saint Cloud', N'MN', 56398, N'4976836684')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (465, N'Trilith', N'3 Northview Pass', NULL, N'Erie', N'PA', 16505, N'0863137421')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (466, N'Zoonder', N'16 Drewry Court', NULL, N'Buffalo', N'NY', 14220, N'5746906303')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (467, N'Jabberstorm', N'790 Golf View Crossing', NULL, N'Brockton', N'MA', 2305, N'5396682067')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (468, N'Gigazoom', N'35844 Starling Center', NULL, N'Meridian', N'MS', 39305, N'8513367467')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (469, N'Linklinks', N'0386 Boyd Parkway', NULL, N'Chicago', N'IL', 60636, N'3587853041')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (470, N'Skinte', N'0586 Manufacturers Plaza', NULL, N'Albuquerque', N'NM', 87180, N'7106830177')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (471, N'Browseblab', N'95785 Hansons Hill', NULL, N'Miami', N'FL', 33142, N'9558655365')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (472, N'Blognation', N'426 Roth Trail', NULL, N'Oakland', N'CA', 94611, N'1331129633')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (473, N'Dynazzy', N'0864 Bultman Point', NULL, N'Dallas', N'TX', 75210, N'2863895999')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (474, N'Voonyx', N'14505 Jana Parkway', NULL, N'Arlington', N'TX', 76011, N'0846530214')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (475, N'LiveZ', N'3 Parkside Parkway', NULL, N'Biloxi', N'MS', 39534, N'9530478858')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (476, N'Avavee', N'3472 Magdeline Trail', NULL, N'Des Moines', N'IA', 50335, N'7494159243')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (477, N'Voomm', N'570 Starling Pass', NULL, N'Buffalo', N'NY', 14210, N'1001951160')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (478, N'Riffwire', N'011 Helena Circle', NULL, N'Pittsburgh', N'PA', 15210, N'1707133577')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (479, N'Meedoo', N'25 Dunning Trail', NULL, N'Miami', N'FL', 33142, N'5596396138')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (480, N'Ntags', N'02 Morning Parkway', NULL, N'Bakersfield', N'CA', 93399, N'4552366569')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (481, N'Thoughtmix', N'92 Canary Crossing', NULL, N'Boise', N'ID', 83757, N'3280426741')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (482, N'Kimia', N'23 Spohn Street', NULL, N'Newark', N'NJ', 7104, N'5444493603')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (483, N'Feedfire', N'3897 Sheridan Hill', NULL, N'Cincinnati', N'OH', 45271, N'3772028729')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (484, N'Tagopia', N'593 Laurel Point', NULL, N'Orlando', N'FL', 32885, N'5421190908')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (485, N'Centidel', N'1251 7th Way', NULL, N'Charlotte', N'NC', 28225, N'2165676411')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (486, N'Pixoboo', N'315 Farragut Street', NULL, N'Memphis', N'TN', 38104, N'1012805715')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (487, N'Demizz', N'426 Knutson Place', NULL, N'Tucson', N'AZ', 85732, N'1931244592')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (488, N'Thoughtblab', N'490 Mcguire Lane', NULL, N'Cincinnati', N'OH', 45254, N'2191029266')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (489, N'Gigabox', N'43 Donald Lane', NULL, N'Huntsville', N'TX', 77343, N'4463638701')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (490, N'Fadeo', N'66 Bunting Crossing', NULL, N'Little Rock', N'AR', 72209, N'3676578746')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (491, N'Trupe', N'95 Towne Park', NULL, N'New York City', N'NY', 10099, N'1386792159')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (492, N'Brainsphere', N'2 Comanche Terrace', NULL, N'Naperville', N'IL', 60567, N'6511968935')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (493, N'Wikibox', N'2 Monument Pass', NULL, N'Shawnee Mission', N'KS', 66220, N'2923932879')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (494, N'Oozz', N'11944 Hansons Avenue', NULL, N'Schenectady', N'NY', 12325, N'5185792075')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (495, N'Zava', N'3 Petterle Court', NULL, N'Saint Paul', N'MN', 55123, N'2144857874')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (496, N'Trilith', N'167 Old Gate Center', NULL, N'Rochester', N'MN', 55905, N'7068350916')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (497, N'Dazzlesphere', N'2 Autumn Leaf Alley', NULL, N'Santa Ana', N'CA', 92705, N'3989629033')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (498, N'Tagchat', N'3644 Burning Wood Court', NULL, N'Fort Myers', N'FL', 33913, N'3871077915')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (499, N'Edgewire', N'5 Pankratz Pass', NULL, N'Anderson', N'IN', 46015, N'6458697502')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (500, N'Agimba', N'24 Larry Drive', NULL, N'Washington', N'DC', 20503, N'2957529723')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (501, N'Jaloo', N'7 Esker Trail', NULL, N'Sacramento', N'CA', 95828, N'7298053686')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (502, N'Skinix', N'34063 Parkside Alley', NULL, N'Lancaster', N'CA', 93584, N'5268467291')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (503, N'Tanoodle', N'070 Sherman Drive', NULL, N'Detroit', N'MI', 48232, N'1131639614')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (504, N'Zoomcast', N'23 Moose Junction', NULL, N'Toledo', N'OH', 43656, N'7374256879')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (505, N'Voonder', N'9925 Ruskin Pass', NULL, N'Lexington', N'KY', 40546, N'4507301355')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (506, N'Skibox', N'5 Clyde Gallagher Street', NULL, N'College Station', N'TX', 77844, N'5682517374')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (507, N'Zoomdog', N'7 International Alley', NULL, N'Washington', N'DC', 20404, N'2102198575')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (508, N'Minyx', N'0129 Truax Lane', NULL, N'Minneapolis', N'MN', 55458, N'8021340554')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (509, N'Mita', N'404 Graceland Alley', NULL, N'Sacramento', N'CA', 94207, N'5677979939')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (510, N'Zoomdog', N'740 Trailsway Point', NULL, N'Austin', N'TX', 78744, N'8737746250')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (511, N'Fivespan', N'18 Anthes Point', NULL, N'Nashville', N'TN', 37250, N'7829609778')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (512, N'Gigazoom', N'62 Annamark Lane', NULL, N'Phoenix', N'AZ', 85099, N'9335435119')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (513, N'Mydeo', N'715 Paget Hill', NULL, N'Gainesville', N'FL', 32627, N'7474700880')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (514, N'Skynoodle', N'25465 Brown Way', NULL, N'New Orleans', N'LA', 70124, N'6800173144')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (515, N'Skajo', N'9 Maple Wood Avenue', NULL, N'Nashville', N'TN', 37235, N'2426166432')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (516, N'Quatz', N'583 Mallard Lane', NULL, N'Baton Rouge', N'LA', 70836, N'5038820366')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (517, N'Gabtype', N'76 Carberry Lane', NULL, N'Port Charlotte', N'FL', 33954, N'2107571701')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (518, N'Avamba', N'58295 Magdeline Drive', NULL, N'Pueblo', N'CO', 81005, N'2264280282')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (519, N'Oodoo', N'30 Manley Pass', NULL, N'Evansville', N'IN', 47712, N'9565150404')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (520, N'Devify', N'96 Truax Trail', NULL, N'Shreveport', N'LA', 71161, N'0107800039')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (521, N'Tambee', N'937 Golf Point', NULL, N'Mc Keesport', N'PA', 15134, N'0617489630')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (522, N'Dabtype', N'0 Mesta Lane', NULL, N'New Brunswick', N'NJ', 8922, N'0449579835')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (523, N'Snaptags', N'40 Loftsgordon Avenue', NULL, N'Tampa', N'FL', 33625, N'7533070627')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (524, N'Gabtype', N'192 Hoard Circle', NULL, N'Washington', N'DC', 20099, N'0044442356')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (525, N'Yacero', N'1743 Nobel Parkway', NULL, N'Midland', N'TX', 79710, N'9880303593')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (526, N'Avaveo', N'89953 Nobel Circle', NULL, N'Springfield', N'IL', 62705, N'9304038404')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (527, N'Thoughtmix', N'5 Schiller Place', NULL, N'Scottsdale', N'AZ', 85271, N'7837580908')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (528, N'Zoomdog', N'40443 Loomis Center', NULL, N'Little Rock', N'AR', 72204, N'1469113956')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (529, N'Latz', N'924 Main Circle', NULL, N'Greensboro', N'NC', 27425, N'8078785214')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (530, N'Shufflester', N'29 Fisk Park', NULL, N'Syracuse', N'NY', 13251, N'6842074119')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (531, N'Youspan', N'05 Lighthouse Bay Street', NULL, N'Louisville', N'KY', 40293, N'9465998715')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (532, N'Buzzster', N'8 Loomis Parkway', NULL, N'Topeka', N'KS', 66617, N'4956053167')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (533, N'Kayveo', N'235 Crownhardt Drive', NULL, N'Metairie', N'LA', 70033, N'3240708843')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (534, N'Devpulse', N'6259 Cambridge Crossing', NULL, N'Birmingham', N'AL', 35220, N'9573626338')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (535, N'Zoozzy', N'1023 Johnson Point', NULL, N'San Jose', N'CA', 95138, N'8773289125')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (536, N'Agivu', N'84 Rieder Alley', NULL, N'Birmingham', N'AL', 35254, N'9885163384')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (537, N'Topicstorm', N'34 3rd Way', NULL, N'Aurora', N'CO', 80015, N'9841814987')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (538, N'Topicstorm', N'7 Canary Lane', NULL, N'Dallas', N'TX', 75397, N'7535878969')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (539, N'Tagtune', N'31552 Vahlen Terrace', NULL, N'Brooklyn', N'NY', 11220, N'6151480567')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (540, N'Livepath', N'6 Armistice Center', NULL, N'Los Angeles', N'CA', 90094, N'6883050906')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (541, N'BlogXS', N'005 Sullivan Terrace', NULL, N'Lexington', N'KY', 40596, N'6170010653')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (542, N'Dynabox', N'3668 Sloan Street', NULL, N'Fresno', N'CA', 93704, N'3013875339')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (543, N'Innotype', N'2267 Kensington Trail', NULL, N'Anchorage', N'AK', 99512, N'9970694442')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (544, N'Buzzshare', N'414 Springs Court', NULL, N'Washington', N'DC', 20370, N'4357103022')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (545, N'Voonder', N'70239 Lerdahl Trail', NULL, N'San Antonio', N'TX', 78245, N'4842554753')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (546, N'Riffwire', N'56 Chive Junction', NULL, N'Boston', N'MA', 2114, N'4078475403')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (547, N'Dynava', N'6136 Vahlen Avenue', NULL, N'Stockton', N'CA', 95298, N'9458183198')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (548, N'Meemm', N'855 Kipling Alley', NULL, N'San Diego', N'CA', 92160, N'7601720057')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (549, N'Zoombeat', N'1898 Roth Street', NULL, N'Birmingham', N'AL', 35231, N'9276659277')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (550, N'Rhycero', N'9506 Springs Place', NULL, N'Olympia', N'WA', 98506, N'6279370618')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (551, N'Jayo', N'7361 Dawn Lane', NULL, N'West Palm Beach', N'FL', 33405, N'7060611049')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (552, N'Realpoint', N'5356 Merrick Lane', NULL, N'Boca Raton', N'FL', 33432, N'3005201322')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (553, N'Jaxnation', N'5860 Petterle Place', NULL, N'Philadelphia', N'PA', 19125, N'4188860077')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (554, N'Eazzy', N'3495 Sunbrook Parkway', NULL, N'Des Moines', N'IA', 50936, N'1302629045')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (555, N'Yodel', N'511 Sachtjen Circle', NULL, N'Miami', N'FL', 33153, N'9345997091')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (556, N'Yadel', N'7758 Esker Hill', NULL, N'Rochester', N'NY', 14646, N'8964878869')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (557, N'Edgeify', N'6 Cordelia Crossing', NULL, N'New York City', N'NY', 10014, N'7643876504')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (558, N'Omba', N'91 Vidon Trail', NULL, N'Stamford', N'CT', 6905, N'6047293252')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (559, N'Wordware', N'694 Bultman Center', NULL, N'Oakland', N'CA', 94616, N'0495688993')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (560, N'Tagtune', N'10996 Dwight Pass', NULL, N'Houston', N'TX', 77090, N'5349548843')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (561, N'Trupe', N'7582 Sommers Crossing', NULL, N'Lubbock', N'TX', 79405, N'4903588367')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (562, N'Twinder', N'3 Larry Hill', NULL, N'Seattle', N'WA', 98121, N'8627045825')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (563, N'Zoonoodle', N'52 Clove Place', NULL, N'Los Angeles', N'CA', 90040, N'0891394030')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (564, N'Browsetype', N'0 Sunbrook Street', NULL, N'Nashville', N'TN', 37220, N'4621181632')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (565, N'Avamm', N'883 Bartillon Way', NULL, N'Boise', N'ID', 83705, N'4764221657')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (566, N'Eidel', N'441 Tennessee Point', NULL, N'Aurora', N'IL', 60505, N'2860806952')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (567, N'Babbleset', N'34 Algoma Avenue', NULL, N'Los Angeles', N'CA', 90081, N'3881354839')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (568, N'Jabberstorm', N'9 Duke Way', NULL, N'Durham', N'NC', 27710, N'2988298827')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (569, N'Thoughtmix', N'6 Jana Trail', NULL, N'Simi Valley', N'CA', 93094, N'3398173958')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (570, N'Agivu', N'80092 Shopko Lane', NULL, N'San Diego', N'CA', 92176, N'8984683756')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (571, N'Centizu', N'4410 Mariners Cove Lane', NULL, N'Cleveland', N'OH', 44111, N'6955752471')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (572, N'Voomm', N'72310 Sunbrook Pass', NULL, N'Washington', N'DC', 20238, N'9381754350')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (573, N'Photofeed', N'686 Mandrake Park', NULL, N'Greeley', N'CO', 80638, N'1362722349')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (574, N'Digitube', N'43 Oakridge Junction', NULL, N'Kent', N'WA', 98042, N'8987370354')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (575, N'Jabbercube', N'658 Oneill Hill', NULL, N'San Francisco', N'CA', 94164, N'7080438747')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (576, N'Trudeo', N'53 Sheridan Junction', NULL, N'Pittsburgh', N'PA', 15235, N'0502049996')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (577, N'Skynoodle', N'63361 Farmco Crossing', NULL, N'Portsmouth', N'VA', 23705, N'8136335213')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (578, N'Meembee', N'8849 Lakewood Gardens Terrace', NULL, N'Sacramento', N'CA', 95828, N'8822533550')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (579, N'Zoomzone', N'74644 Amoth Alley', NULL, N'New York City', N'NY', 10165, N'4305873275')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (580, N'Edgeclub', N'5767 Schurz Street', NULL, N'New Orleans', N'LA', 70165, N'0362857782')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (581, N'Vinder', N'664 Eagle Crest Drive', NULL, N'Lincoln', N'NE', 68583, N'1522037136')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (582, N'Topicblab', N'4275 Hazelcrest Plaza', NULL, N'Schenectady', N'NY', 12325, N'4600627200')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (583, N'Topicware', N'7 Fordem Place', NULL, N'Albuquerque', N'NM', 87115, N'5141270484')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (584, N'Kaymbo', N'30 Shasta Pass', NULL, N'Lynn', N'MA', 1905, N'1360850978')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (585, N'Kamba', N'0867 Mallory Street', NULL, N'Lafayette', N'LA', 70593, N'7283057420')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (586, N'Kwinu', N'19009 Clarendon Plaza', NULL, N'Amarillo', N'TX', 79165, N'4434781419')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (587, N'Kaymbo', N'2256 Bashford Junction', NULL, N'Washington', N'DC', 20319, N'3054797370')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (588, N'Jabberstorm', N'64742 Tony Plaza', NULL, N'El Paso', N'TX', 79916, N'8652434960')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (589, N'Lazzy', N'23372 Moulton Court', NULL, N'Baton Rouge', N'LA', 70894, N'4603357822')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (590, N'Tagopia', N'0160 Buhler Hill', NULL, N'New York City', N'NY', 10292, N'7503237261')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (591, N'Yambee', N'49 Eliot Plaza', NULL, N'Pasadena', N'CA', 91117, N'0961072965')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (592, N'Mudo', N'5 Commercial Lane', NULL, N'Colorado Springs', N'CO', 80995, N'7365422715')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (593, N'Jayo', N'932 Clove Court', NULL, N'Tulsa', N'OK', 74193, N'5613408058')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (594, N'Kimia', N'51274 Sunbrook Road', NULL, N'Des Moines', N'IA', 50320, N'0990062533')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (595, N'Twitterbridge', N'290 Almo Way', NULL, N'Gastonia', N'NC', 28055, N'2295922839')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (596, N'Dynabox', N'97 Lakeland Drive', NULL, N'Tampa', N'FL', 33620, N'8461880060')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (597, N'Bluejam', N'80451 Victoria Alley', NULL, N'Orange', N'CA', 92668, N'3435623058')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (598, N'Gigazoom', N'61 Ryan Street', NULL, N'Tampa', N'FL', 33680, N'4195937380')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (599, N'Dynabox', N'24 Fallview Alley', NULL, N'Trenton', N'NJ', 8608, N'0009842335')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (600, N'Zoonoodle', N'8648 Ohio Drive', NULL, N'Carlsbad', N'CA', 92013, N'2681177235')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (601, N'Photobean', N'5 Springs Junction', NULL, N'Baltimore', N'MD', 21265, N'3915252579')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (602, N'Yambee', N'309 Dryden Park', NULL, N'Atlanta', N'GA', 31136, N'1794148936')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (603, N'Twinder', N'3299 Coleman Drive', NULL, N'San Antonio', N'TX', 78230, N'7124113692')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (604, N'Realpoint', N'8 Sundown Avenue', NULL, N'Las Vegas', N'NV', 89178, N'9239425925')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (605, N'Kwinu', N'2 Prentice Trail', NULL, N'Buffalo', N'NY', 14225, N'5919686354')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (606, N'Lazzy', N'1 Parkside Point', NULL, N'Houston', N'TX', 77090, N'9827126517')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (607, N'Voolith', N'5 Forest Run Trail', NULL, N'Pittsburgh', N'PA', 15240, N'8873494412')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (608, N'Oba', N'232 Aberg Parkway', NULL, N'Greenville', N'SC', 29605, N'4497917868')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (609, N'Viva', N'6 Mandrake Place', NULL, N'Irvine', N'CA', 92710, N'3582383732')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (610, N'Browsecat', N'6195 Farragut Hill', NULL, N'Columbus', N'OH', 43240, N'4023914297')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (611, N'Agivu', N'17 Oak Valley Park', NULL, N'Columbus', N'OH', 43226, N'8029168700')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (612, N'Quamba', N'698 Birchwood Pass', NULL, N'Brooklyn', N'NY', 11236, N'6447771152')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (613, N'Meevee', N'0 Pearson Pass', NULL, N'Chattanooga', N'TN', 37416, N'5191921937')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (614, N'Browsezoom', N'1 Del Sol Place', NULL, N'New York City', N'NY', 10170, N'1256689083')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (615, N'Voolia', N'21070 Talmadge Crossing', NULL, N'Boise', N'ID', 83711, N'4128694031')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (616, N'Demivee', N'68549 Barnett Circle', NULL, N'Charlotte', N'NC', 28230, N'7470059239')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (617, N'Twitterbridge', N'02191 Claremont Avenue', NULL, N'Bellevue', N'WA', 98008, N'0022489316')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (618, N'Edgeblab', N'6 Golf View Road', NULL, N'Duluth', N'GA', 30195, N'7894695197')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (619, N'Kazio', N'8 Meadow Vale Court', NULL, N'Houston', N'TX', 77206, N'8820663145')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (620, N'Gigashots', N'64 Dayton Court', NULL, N'Springfield', N'VA', 22156, N'3089866692')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (621, N'Ntags', N'5 Sommers Place', NULL, N'Atlanta', N'GA', 30316, N'8077376007')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (622, N'Browseblab', N'55315 Katie Park', NULL, N'San Jose', N'CA', 95113, N'3227292624')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (623, N'Mydo', N'07233 Barby Court', NULL, N'Decatur', N'GA', 30089, N'4403848891')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (624, N'Jabberbean', N'729 Hollow Ridge Drive', NULL, N'Seattle', N'WA', 98175, N'2564530808')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (625, N'Kwilith', N'968 Fuller Road', NULL, N'Minneapolis', N'MN', 55417, N'9556289556')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (626, N'Youbridge', N'1896 Fordem Road', NULL, N'Southfield', N'MI', 48076, N'2599337918')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (627, N'Voonix', N'78 Schlimgen Place', NULL, N'Hamilton', N'OH', 45020, N'2598391952')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (628, N'Abatz', N'0 Ramsey Road', NULL, N'Detroit', N'MI', 48242, N'4129410002')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (629, N'Youspan', N'5 Manley Terrace', NULL, N'Olympia', N'WA', 98516, N'1736235543')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (630, N'Latz', N'5485 Montana Place', NULL, N'Clearwater', N'FL', 33763, N'9834281357')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (631, N'Browsetype', N'35 Jana Avenue', NULL, N'Marietta', N'GA', 30066, N'6888620228')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (632, N'Skimia', N'844 Forest Dale Street', NULL, N'Hartford', N'CT', 6152, N'3021320358')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (633, N'Skippad', N'0792 Vermont Avenue', NULL, N'Lynn', N'MA', 1905, N'4064339472')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (634, N'Miboo', N'0 Porter Way', NULL, N'San Francisco', N'CA', 94159, N'0371223547')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (635, N'Realblab', N'4 Reinke Park', NULL, N'Washington', N'DC', 20238, N'5224407498')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (636, N'Yamia', N'4 Wayridge Plaza', NULL, N'Trenton', N'NJ', 8603, N'3054318651')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (637, N'Topicware', N'16 Golf Plaza', NULL, N'Sioux Falls', N'SD', 57188, N'1582499254')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (638, N'Skyble', N'7888 Monument Center', NULL, N'Richmond', N'VA', 23228, N'5327453740')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (639, N'LiveZ', N'6466 Towne Court', NULL, N'Philadelphia', N'PA', 19178, N'3807397240')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (640, N'Jabbersphere', N'5402 Corry Court', NULL, N'Boca Raton', N'FL', 33432, N'0658306475')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (641, N'Jabbercube', N'6135 Sullivan Way', NULL, N'Columbia', N'SC', 29215, N'5084594328')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (642, N'Kazu', N'525 Raven Parkway', NULL, N'Salt Lake City', N'UT', 84125, N'3595277622')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (643, N'Flashset', N'1 Basil Court', NULL, N'Shreveport', N'LA', 71115, N'2725921102')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (644, N'Yakitri', N'894 Morningstar Crossing', NULL, N'Paterson', N'NJ', 7544, N'7831944459')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (645, N'Mybuzz', N'6790 Mandrake Circle', NULL, N'Los Angeles', N'CA', 90025, N'4263206150')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (646, N'Blogtags', N'9649 Gulseth Plaza', NULL, N'Gainesville', N'FL', 32627, N'7765405091')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (647, N'Buzzdog', N'094 Corscot Way', NULL, N'Saginaw', N'MI', 48604, N'9286530633')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (648, N'Thoughtsphere', N'36523 Almo Way', NULL, N'Glendale', N'AZ', 85305, N'5995116340')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (649, N'Camimbo', N'04451 Mariners Cove Avenue', NULL, N'Lynchburg', N'VA', 24503, N'6618762009')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (650, N'Realpoint', N'856 Leroy Plaza', NULL, N'Birmingham', N'AL', 35231, N'5476957986')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (651, N'Gigazoom', N'78608 Armistice Trail', NULL, N'San Antonio', N'TX', 78285, N'7654498447')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (652, N'Tanoodle', N'92 1st Avenue', NULL, N'El Paso', N'TX', 88579, N'0921568470')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (653, N'Ntag', N'8580 Lakewood Gardens Circle', NULL, N'Houston', N'TX', 77276, N'4037611186')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (654, N'Voomm', N'3 Starling Place', NULL, N'San Diego', N'CA', 92132, N'8267857539')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (655, N'Realpoint', N'5456 Hanson Place', NULL, N'Baltimore', N'MD', 21239, N'0026692815')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (656, N'Riffpedia', N'106 Mendota Way', NULL, N'Myrtle Beach', N'SC', 29579, N'3580251671')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (657, N'Tavu', N'4 Crescent Oaks Place', NULL, N'Denver', N'CO', 80235, N'0688791518')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (658, N'Livetube', N'4704 Sauthoff Place', NULL, N'Columbia', N'SC', 29225, N'9396578137')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (659, N'Fanoodle', N'74053 Leroy Plaza', NULL, N'Louisville', N'KY', 40205, N'6241001675')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (660, N'Edgeblab', N'0238 Waubesa Way', NULL, N'Washington', N'DC', 20088, N'4093641003')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (661, N'Flipbug', N'647 Bayside Way', NULL, N'Hartford', N'CT', 6140, N'4391040556')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (662, N'Roomm', N'217 Saint Paul Center', NULL, N'El Paso', N'TX', 88563, N'7664270587')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (663, N'Abata', N'18938 Clarendon Pass', NULL, N'Kansas City', N'MO', 64125, N'5823439406')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (664, N'Kwilith', N'88 Gerald Circle', NULL, N'Fresno', N'CA', 93704, N'5189659326')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (665, N'Jabberbean', N'8841 Pond Street', NULL, N'Denver', N'CO', 80204, N'7514767474')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (666, N'Jaxspan', N'1316 Blaine Circle', NULL, N'Dayton', N'OH', 45454, N'7407046311')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (667, N'Pixoboo', N'537 Warbler Circle', NULL, N'Washington', N'DC', 20370, N'5268496681')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (668, N'Ntag', N'27 Hooker Street', NULL, N'Washington', N'DC', 20215, N'2447916765')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (669, N'Wordtune', N'634 Vidon Place', NULL, N'Columbia', N'SC', 29225, N'3149588215')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (670, N'Topiczoom', N'078 Division Street', NULL, N'Gaithersburg', N'MD', 20883, N'6440469238')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (671, N'Kwilith', N'5 Hansons Hill', NULL, N'Milwaukee', N'WI', 53263, N'1766380566')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (672, N'Flashpoint', N'04 Forest Street', NULL, N'San Bernardino', N'CA', 92410, N'9078957883')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (673, N'Zoozzy', N'97088 Badeau Plaza', NULL, N'Sacramento', N'CA', 95828, N'6443091266')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (674, N'Jaxbean', N'31 Helena Hill', NULL, N'Rochester', N'NY', 14609, N'9211924668')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (675, N'Jaxworks', N'85242 Jenifer Pass', NULL, N'Sacramento', N'CA', 94250, N'6385053921')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (676, N'Livetube', N'545 Sage Hill', NULL, N'Denver', N'CO', 80249, N'4080731127')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (677, N'Youtags', N'658 Kensington Place', NULL, N'Sacramento', N'CA', 94297, N'4044092023')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (678, N'Mudo', N'0120 Donald Street', NULL, N'Saint Louis', N'MO', 63136, N'6884710716')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (679, N'Yata', N'0188 Mayfield Place', NULL, N'Fort Worth', N'TX', 76105, N'1062641951')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (680, N'Fadeo', N'6236 Warner Drive', NULL, N'Tyler', N'TX', 75799, N'8063576453')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (681, N'Quimba', N'571 Transport Junction', NULL, N'Oklahoma City', N'OK', 73104, N'7847453151')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (682, N'Thoughtmix', N'693 School Lane', NULL, N'Tyler', N'TX', 75710, N'7688953092')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (683, N'Topicshots', N'66 Spaight Way', NULL, N'Palatine', N'IL', 60078, N'6630615970')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (684, N'Leenti', N'2 Hallows Pass', NULL, N'Fort Worth', N'TX', 76105, N'0495142981')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (685, N'Mita', N'26269 Summer Ridge Parkway', NULL, N'Columbia', N'SC', 29208, N'1614942972')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (686, N'Yambee', N'1 Pine View Terrace', NULL, N'New York City', N'NY', 10270, N'6098401776')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (687, N'Mybuzz', N'26 Eliot Junction', NULL, N'Indianapolis', N'IN', 46239, N'5707195702')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (688, N'Tagfeed', N'4781 Welch Point', NULL, N'Fresno', N'CA', 93740, N'9962071182')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (689, N'Ainyx', N'5 Novick Avenue', NULL, N'Washington', N'DC', 20310, N'6753594438')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (690, N'Dabvine', N'8 Forster Lane', NULL, N'Dallas', N'TX', 75387, N'8389925466')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (691, N'Yambee', N'849 Springview Circle', NULL, N'Washington', N'DC', 20205, N'2535759854')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (692, N'Meetz', N'2 Claremont Junction', NULL, N'Columbia', N'SC', 29220, N'1469703597')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (693, N'Skaboo', N'7 Barnett Drive', NULL, N'El Paso', N'TX', 88563, N'7850504941')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (694, N'Viva', N'77392 Forest Dale Street', NULL, N'Corpus Christi', N'TX', 78465, N'7293329556')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (695, N'Oyoba', N'155 Marquette Place', NULL, N'Knoxville', N'TN', 37995, N'1363690467')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (696, N'Zoombeat', N'56420 Green Ridge Drive', NULL, N'Washington', N'DC', 20551, N'3793196091')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (697, N'Wikivu', N'7 Kenwood Point', NULL, N'Buffalo', N'NY', 14210, N'3455820098')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (698, N'Miboo', N'48 Randy Lane', NULL, N'Columbia', N'MO', 65211, N'2993670527')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (699, N'Babbleset', N'56397 Sycamore Junction', NULL, N'Montgomery', N'AL', 36119, N'3649809233')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (700, N'Devify', N'40 Dwight Terrace', NULL, N'Philadelphia', N'PA', 19109, N'4132809918')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (701, N'Brainbox', N'0309 Old Gate Junction', NULL, N'Washington', N'DC', 20226, N'2377361480')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (702, N'Ozu', N'8 Elgar Terrace', NULL, N'Phoenix', N'AZ', 85072, N'0353773515')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (703, N'Dynabox', N'792 Shoshone Lane', NULL, N'Pasadena', N'CA', 91186, N'6982848730')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (704, N'Vimbo', N'62987 Duke Circle', NULL, N'Hamilton', N'OH', 45020, N'9120791204')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (705, N'Livepath', N'37291 Petterle Pass', NULL, N'Washington', N'DC', 20205, N'2623099895')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (706, N'Jatri', N'902 Reindahl Pass', NULL, N'New York City', N'NY', 10014, N'0147924655')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (707, N'Zoomdog', N'8 Elmside Court', NULL, N'Washington', N'DC', 20210, N'8761132502')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (708, N'Oyonder', N'0762 Myrtle Avenue', NULL, N'Charlotte', N'NC', 28205, N'3492955726')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (709, N'Reallinks', N'7 Gulseth Junction', NULL, N'Miami', N'FL', 33261, N'2879760321')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (710, N'Livetube', N'396 Menomonie Alley', NULL, N'Atlanta', N'GA', 31132, N'5851228863')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (711, N'Quatz', N'6 2nd Court', NULL, N'Odessa', N'TX', 79764, N'9474670246')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (712, N'Skivee', N'55739 Del Sol Pass', NULL, N'Pittsburgh', N'PA', 15279, N'7404176579')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (713, N'Pixonyx', N'248 Haas Circle', NULL, N'Everett', N'WA', 98206, N'9951150339')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (714, N'Talane', N'42 Crownhardt Street', NULL, N'Knoxville', N'TN', 37914, N'3609301558')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (715, N'Skipstorm', N'4811 Darwin Road', NULL, N'Montpelier', N'VT', 5609, N'7508755838')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (716, N'Tekfly', N'44 Rockefeller Crossing', NULL, N'Topeka', N'KS', 66699, N'1871530334')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (717, N'Rhycero', N'99 Shelley Avenue', NULL, N'New York City', N'NY', 10120, N'1204261996')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (718, N'Jaloo', N'21 Crownhardt Park', NULL, N'Kansas City', N'MO', 64153, N'5627413843')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (719, N'Twitterwire', N'7760 Moose Park', NULL, N'Schenectady', N'NY', 12325, N'5157459150')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (720, N'Skyble', N'233 Hoffman Lane', NULL, N'El Paso', N'TX', 88569, N'5860264505')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (721, N'Tagfeed', N'172 Charing Cross Trail', NULL, N'San Antonio', N'TX', 78291, N'7321677545')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (722, N'Tagtune', N'0 Lake View Park', NULL, N'Greensboro', N'NC', 27415, N'0881577912')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (723, N'Quatz', N'47304 Dixon Plaza', NULL, N'Saint Petersburg', N'FL', 33731, N'0642954696')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (724, N'Eazzy', N'009 Paget Drive', NULL, N'Syracuse', N'NY', 13251, N'1135711276')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (725, N'Flipopia', N'894 Saint Paul Place', NULL, N'Flushing', N'NY', 11355, N'5928215191')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (726, N'Youfeed', N'1 Mariners Cove Trail', NULL, N'Garland', N'TX', 75049, N'2082647537')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (727, N'Wikibox', N'3802 Sutherland Place', NULL, N'Saint Louis', N'MO', 63104, N'6183796538')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (728, N'Zoomlounge', N'9 Oak Valley Trail', NULL, N'Saint Louis', N'MO', 63143, N'8386875685')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (729, N'Youtags', N'22 Eastwood Drive', NULL, N'Trenton', N'NJ', 8608, N'8361363254')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (730, N'Abata', N'564 Ronald Regan Trail', NULL, N'Memphis', N'TN', 38131, N'9444141590')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (731, N'Jabbersphere', N'4106 Continental Hill', NULL, N'Birmingham', N'AL', 35290, N'7012467889')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (732, N'Eire', N'9395 Talisman Place', NULL, N'Santa Fe', N'NM', 87505, N'0961995998')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (733, N'Twitterworks', N'58092 Bonner Center', NULL, N'Dayton', N'OH', 45414, N'3130388637')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (734, N'Tagcat', N'0500 Sauthoff Center', NULL, N'Fort Worth', N'TX', 76198, N'3279577389')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (735, N'Eazzy', N'8 Vera Circle', NULL, N'Norman', N'OK', 73071, N'0368148123')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (736, N'Eadel', N'0 Hoffman Hill', NULL, N'Washington', N'DC', 20591, N'6432990497')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (737, N'Jabbercube', N'11 Prentice Road', NULL, N'Detroit', N'MI', 48242, N'6208358649')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (738, N'Rhyzio', N'5 Sauthoff Circle', NULL, N'Fresno', N'CA', 93773, N'2932371207')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (739, N'Divavu', N'8868 Grover Road', NULL, N'Dallas', N'TX', 75210, N'9240602055')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (740, N'InnoZ', N'85 Springs Alley', NULL, N'Los Angeles', N'CA', 90087, N'1712286925')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (741, N'Babbleblab', N'07 Londonderry Drive', NULL, N'Pasadena', N'CA', 91109, N'1678552753')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (742, N'Tagpad', N'41571 Sutteridge Plaza', NULL, N'Orlando', N'FL', 32835, N'3577131903')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (743, N'Eamia', N'1 Maywood Circle', NULL, N'Topeka', N'KS', 66667, N'1511490229')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (744, N'Zoomzone', N'64 Waubesa Circle', NULL, N'High Point', N'NC', 27264, N'7508857175')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (745, N'Meemm', N'19 Hayes Avenue', NULL, N'Huntington', N'WV', 25770, N'6746342879')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (746, N'Oyoyo', N'4 Melrose Place', NULL, N'Salt Lake City', N'UT', 84152, N'6425963461')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (747, N'Bluezoom', N'01550 Summit Circle', NULL, N'Sacramento', N'CA', 95865, N'2788142185')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (748, N'Skyba', N'0 Goodland Avenue', NULL, N'Evansville', N'IN', 47712, N'1368549408')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (749, N'Jazzy', N'9 Harper Circle', NULL, N'Seattle', N'WA', 98133, N'1153339927')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (750, N'Voolia', N'07877 Mcguire Pass', NULL, N'Phoenix', N'AZ', 85020, N'3972866668')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (751, N'Skalith', N'3 Russell Place', NULL, N'Mobile', N'AL', 36610, N'7182100381')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (752, N'Bluezoom', N'0 Cambridge Point', NULL, N'Reno', N'NV', 89550, N'7432645712')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (753, N'Oyoloo', N'60933 Myrtle Drive', NULL, N'Kansas City', N'MO', 64114, N'5362086036')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (754, N'Kwimbee', N'8461 Cherokee Street', NULL, N'Minneapolis', N'MN', 55470, N'5621940189')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (755, N'Fivechat', N'37 Morrow Lane', NULL, N'Torrance', N'CA', 90505, N'9656937007')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (756, N'Talane', N'91353 Bluejay Hill', NULL, N'Wilmington', N'DE', 19892, N'7430683954')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (757, N'Quinu', N'6 Butterfield Point', NULL, N'Fort Worth', N'TX', 76198, N'9329694645')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (758, N'Jabbersphere', N'20186 Petterle Junction', NULL, N'San Antonio', N'TX', 78235, N'6211328036')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (759, N'JumpXS', N'413 Carioca Crossing', NULL, N'Birmingham', N'AL', 35263, N'0061134065')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (760, N'Thoughtsphere', N'5547 Heffernan Way', NULL, N'Springfield', N'IL', 62794, N'7106021245')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (761, N'Twitterbridge', N'28 Mifflin Terrace', NULL, N'Duluth', N'GA', 30195, N'5541630222')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (762, N'Lazzy', N'25427 Canary Lane', NULL, N'Evansville', N'IN', 47725, N'8945316578')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (763, N'Quaxo', N'9 Marquette Point', NULL, N'Dallas', N'TX', 75205, N'5223318418')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (764, N'Tambee', N'4 Harbort Place', NULL, N'Irvine', N'CA', 92619, N'8416209229')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (765, N'Flashspan', N'1 Victoria Pass', NULL, N'Lafayette', N'IN', 47905, N'3738798309')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (766, N'Blogtag', N'8601 Merchant Court', NULL, N'Pueblo', N'CO', 81010, N'9531367888')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (767, N'Shuffletag', N'8607 Evergreen Trail', NULL, N'Topeka', N'KS', 66622, N'2158018559')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (768, N'Feedspan', N'271 Spenser Drive', NULL, N'Washington', N'DC', 20557, N'8411193266')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (769, N'Devcast', N'775 Messerschmidt Parkway', NULL, N'Dayton', N'OH', 45432, N'8292201332')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (770, N'Twitterlist', N'618 Knutson Road', NULL, N'New Orleans', N'LA', 70183, N'9500218917')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (771, N'Quimm', N'1822 Macpherson Lane', NULL, N'Saint Paul', N'MN', 55166, N'2931536711')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (772, N'Mynte', N'10 Magdeline Hill', NULL, N'White Plains', N'NY', 10633, N'9282831046')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (773, N'Flipstorm', N'16483 Warrior Drive', NULL, N'El Paso', N'TX', 79928, N'6343355210')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (774, N'Fanoodle', N'941 Calypso Court', NULL, N'Raleigh', N'NC', 27690, N'7654097429')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (775, N'Gabtype', N'20 Coolidge Center', NULL, N'Kansas City', N'MO', 64190, N'8354184195')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (776, N'Blogspan', N'5 Stone Corner Trail', NULL, N'Port Saint Lucie', N'FL', 34985, N'1059895293')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (777, N'Realmix', N'155 Maywood Point', NULL, N'Buffalo', N'NY', 14210, N'1034923348')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (778, N'Voolia', N'4 Coleman Pass', NULL, N'Cincinnati', N'OH', 45238, N'2719303812')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (779, N'Edgeblab', N'3174 Hayes Parkway', NULL, N'Henderson', N'NV', 89012, N'5057385032')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (780, N'Flashdog', N'76 Tennessee Terrace', NULL, N'Tulsa', N'OK', 74193, N'2266561448')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (781, N'Meetz', N'44 Armistice Road', NULL, N'Birmingham', N'AL', 35295, N'0083823024')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (782, N'Youopia', N'0977 Kedzie Avenue', NULL, N'Boston', N'MA', 2124, N'4244936893')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (783, N'Yakitri', N'8139 South Plaza', NULL, N'Irvine', N'CA', 92717, N'1943496734')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (784, N'Wikivu', N'49386 Summit Terrace', NULL, N'Anchorage', N'AK', 99507, N'6409729077')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (785, N'Vinte', N'2 Homewood Street', NULL, N'Evansville', N'IN', 47712, N'8113129330')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (786, N'Zoonder', N'452 Park Meadow Way', NULL, N'Round Rock', N'TX', 78682, N'1787571328')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (787, N'Skyvu', N'575 Manufacturers Parkway', NULL, N'Macon', N'GA', 31296, N'2298675743')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (788, N'Nlounge', N'354 Old Shore Avenue', NULL, N'Richmond', N'VA', 23272, N'0509217363')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (789, N'Midel', N'25314 Butternut Parkway', NULL, N'New Orleans', N'LA', 70174, N'9025468545')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (790, N'Teklist', N'68 Reindahl Terrace', NULL, N'Des Moines', N'IA', 50347, N'2605641699')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (791, N'Kimia', N'82760 Riverside Lane', NULL, N'Gainesville', N'FL', 32605, N'4779342691')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (792, N'Dabshots', N'7903 Hauk Alley', NULL, N'Phoenix', N'AZ', 85010, N'7806776452')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (793, N'Tagfeed', N'60 Holy Cross Terrace', NULL, N'Chicago', N'IL', 60674, N'8210775455')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (794, N'Mymm', N'2165 Talisman Plaza', NULL, N'Saint Petersburg', N'FL', 33705, N'3854793596')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (795, N'Vinder', N'42730 Florence Road', NULL, N'Chesapeake', N'VA', 23324, N'9143721349')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (796, N'Snaptags', N'511 Rowland Avenue', NULL, N'Fort Worth', N'TX', 76178, N'4984600503')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (797, N'Linktype', N'73919 Kennedy Center', NULL, N'Sacramento', N'CA', 94273, N'0137792723')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (798, N'Layo', N'1814 Longview Junction', NULL, N'Fort Lauderdale', N'FL', 33315, N'5661380050')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (799, N'Bubblemix', N'416 Kennedy Street', NULL, N'Hollywood', N'FL', 33028, N'3137955560')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (800, N'Camimbo', N'78159 Rieder Terrace', NULL, N'Houston', N'TX', 77085, N'3744635597')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (801, N'Buzzshare', N'00 Glacier Hill Circle', NULL, N'Houston', N'TX', 77234, N'3747670415')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (802, N'Zoombox', N'20 Florence Center', NULL, N'Washington', N'DC', 20099, N'2347427348')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (803, N'Roodel', N'32418 Eagan Lane', NULL, N'Miami', N'FL', 33164, N'5733830206')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (804, N'Wordware', N'81422 Morning Road', NULL, N'San Antonio', N'TX', 78255, N'3192168133')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (805, N'Chatterpoint', N'32 Lunder Circle', NULL, N'Washington', N'DC', 20205, N'5411006327')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (806, N'Realcube', N'564 Westerfield Place', NULL, N'Cincinnati', N'OH', 45223, N'8782060720')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (807, N'Quinu', N'349 Schurz Lane', NULL, N'Omaha', N'NE', 68134, N'8357083040')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (808, N'Viva', N'37 Harper Junction', NULL, N'Kansas City', N'MO', 64160, N'8678062374')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (809, N'Demimbu', N'77179 Gina Drive', NULL, N'Rochester', N'NY', 14609, N'7720041423')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (810, N'Mynte', N'131 Texas Road', NULL, N'Huntington', N'WV', 25705, N'2040656118')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (811, N'Quire', N'56 Cascade Street', NULL, N'Fort Worth', N'TX', 76105, N'2831229818')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (812, N'Janyx', N'8964 Nevada Avenue', NULL, N'Phoenix', N'AZ', 85072, N'2713792292')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (813, N'Browsezoom', N'3 Anniversary Parkway', NULL, N'Yakima', N'WA', 98907, N'3081711238')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (814, N'Quinu', N'0336 Alpine Junction', NULL, N'Paterson', N'NJ', 7544, N'1578433526')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (815, N'Gabspot', N'98 Hagan Pass', NULL, N'Garden Grove', N'CA', 92844, N'9434745890')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (816, N'Demizz', N'472 Paget Lane', NULL, N'Springfield', N'IL', 62756, N'5572615073')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (817, N'Ooba', N'5695 Lukken Terrace', NULL, N'Albuquerque', N'NM', 87190, N'6127003689')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (818, N'Zoonoodle', N'44158 Sachtjen Terrace', NULL, N'Tucson', N'AZ', 85754, N'4308548856')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (819, N'Viva', N'0 Merry Street', NULL, N'Berkeley', N'CA', 94712, N'1919566261')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (820, N'Mynte', N'853 Swallow Avenue', NULL, N'Hartford', N'CT', 6120, N'3249869924')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (821, N'Zoonoodle', N'174 Anzinger Plaza', NULL, N'Shawnee Mission', N'KS', 66220, N'7953192856')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (822, N'Skaboo', N'726 Northridge Way', NULL, N'Des Moines', N'IA', 50330, N'7236560215')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (823, N'Roodel', N'3747 Twin Pines Road', NULL, N'Carson City', N'NV', 89706, N'2276547954')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (824, N'Zoomzone', N'5 Homewood Plaza', NULL, N'Brooklyn', N'NY', 11205, N'6154236152')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (825, N'Shufflester', N'51721 Main Place', NULL, N'Orlando', N'FL', 32830, N'2869350875')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (826, N'Twitterbeat', N'27 Eggendart Avenue', NULL, N'Lakeland', N'FL', 33811, N'4389558401')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (827, N'Ooba', N'261 Loomis Circle', NULL, N'Salt Lake City', N'UT', 84105, N'2844712208')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (828, N'Flashdog', N'92 Tennessee Point', NULL, N'Amarillo', N'TX', 79171, N'6613044599')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (829, N'Twitternation', N'1425 Basil Trail', NULL, N'Asheville', N'NC', 28805, N'9653437495')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (830, N'Tagopia', N'349 Colorado Trail', NULL, N'Trenton', N'NJ', 8608, N'0341602805')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (831, N'Mymm', N'47 Union Point', NULL, N'Oakland', N'CA', 94660, N'4792487980')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (832, N'Wordware', N'0 Independence Avenue', NULL, N'Pasadena', N'CA', 91125, N'7025274576')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (833, N'Trilith', N'8 Mifflin Terrace', NULL, N'Anchorage', N'AK', 99599, N'0467685365')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (834, N'Lazz', N'1695 Gulseth Avenue', NULL, N'Tallahassee', N'FL', 32314, N'0805027872')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (835, N'Viva', N'32259 Anhalt Terrace', NULL, N'Milwaukee', N'WI', 53263, N'3493743500')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (836, N'Yozio', N'934 Sheridan Plaza', NULL, N'Bronx', N'NY', 10469, N'9203068396')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (837, N'Topiclounge', N'580 Prairieview Park', NULL, N'Toledo', N'OH', 43699, N'7085504084')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (838, N'Chatterbridge', N'5579 Kinsman Hill', NULL, N'Naples', N'FL', 34102, N'0518098276')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (839, N'Skyvu', N'4214 Westport Way', NULL, N'Albuquerque', N'NM', 87110, N'8719355173')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (840, N'Ntag', N'67 Tennessee Avenue', NULL, N'Anaheim', N'CA', 92812, N'7945206718')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (841, N'Voonder', N'93 Corscot Road', NULL, N'El Paso', N'TX', 79928, N'6874473688')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (842, N'Shuffledrive', N'4337 Bowman Parkway', NULL, N'Hicksville', N'NY', 11854, N'7113858528')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (843, N'Wikizz', N'0824 Raven Park', NULL, N'Los Angeles', N'CA', 90005, N'6432741475')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (844, N'Avamm', N'18785 Thompson Drive', NULL, N'Fort Worth', N'TX', 76134, N'1342033238')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (845, N'Bubbletube', N'8780 Del Mar Center', NULL, N'Albuquerque', N'NM', 87105, N'1720816701')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (846, N'Rhyzio', N'7504 Eastlawn Pass', NULL, N'Springfield', N'MO', 65810, N'9930451014')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (847, N'Demimbu', N'59 Bay Park', NULL, N'Atlanta', N'GA', 31190, N'3803593152')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (848, N'Vinder', N'905 Hooker Avenue', NULL, N'Honolulu', N'HI', 96845, N'6460771091')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (849, N'Vinder', N'3 Towne Drive', NULL, N'Omaha', N'NE', 68124, N'9956734388')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (850, N'Yadel', N'50402 Farragut Junction', NULL, N'Chattanooga', N'TN', 37410, N'3919324177')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (851, N'Aivee', N'184 Thierer Junction', NULL, N'Atlanta', N'GA', 30311, N'9908177448')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (852, N'Gigabox', N'31 Susan Court', NULL, N'Providence', N'RI', 2912, N'5474880073')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (853, N'Dablist', N'2 Graedel Court', NULL, N'Dallas', N'TX', 75241, N'9506528114')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (854, N'Twiyo', N'6314 Granby Place', NULL, N'Nashville', N'TN', 37250, N'8741565827')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (855, N'Tagcat', N'8 Sunnyside Point', NULL, N'Knoxville', N'TN', 37919, N'3860507061')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (856, N'Realcube', N'63788 Southridge Junction', NULL, N'Milwaukee', N'WI', 53285, N'1865361672')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (857, N'Oyoyo', N'51 Green Terrace', NULL, N'Tampa', N'FL', 33620, N'6073173448')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (858, N'Voonyx', N'6 Merry Circle', NULL, N'Columbus', N'OH', 43215, N'2800829789')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (859, N'Youopia', N'827 Moland Hill', NULL, N'Pittsburgh', N'PA', 15266, N'8663615964')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (860, N'Voonix', N'214 Mccormick Place', NULL, N'Portsmouth', N'NH', 3804, N'2348833649')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (861, N'Buzzbean', N'6615 Alpine Terrace', NULL, N'Birmingham', N'AL', 35225, N'5085492728')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (862, N'Twitterbeat', N'18788 Center Hill', NULL, N'White Plains', N'NY', 10606, N'8154891404')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (863, N'Youfeed', N'4 Rusk Park', NULL, N'Salt Lake City', N'UT', 84110, N'5432324146')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (864, N'Tanoodle', N'30198 Oak Valley Park', NULL, N'Colorado Springs', N'CO', 80995, N'7381994879')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (865, N'Jabbersphere', N'553 Farmco Terrace', NULL, N'Mountain View', N'CA', 94042, N'7652072507')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (866, N'Livetube', N'09 Trailsway Park', NULL, N'Albuquerque', N'NM', 87195, N'1298311564')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (867, N'Dabfeed', N'0 Prairieview Drive', NULL, N'Washington', N'DC', 20409, N'8801175706')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (868, N'Brainbox', N'13176 Elmside Park', NULL, N'Seattle', N'WA', 98185, N'1801511654')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (869, N'Tekfly', N'75561 Pennsylvania Center', NULL, N'Louisville', N'KY', 40225, N'7839273045')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (870, N'Shuffletag', N'6717 Hintze Circle', NULL, N'Youngstown', N'OH', 44505, N'8305573231')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (871, N'Dabvine', N'61 Butternut Junction', NULL, N'Birmingham', N'AL', 35254, N'2393264305')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (872, N'Linktype', N'96 Jay Junction', NULL, N'San Francisco', N'CA', 94126, N'9315783624')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (873, N'Skipstorm', N'258 Sunbrook Road', NULL, N'Fresno', N'CA', 93773, N'3921544994')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (874, N'Latz', N'3 Mallard Street', NULL, N'Tampa', N'FL', 33620, N'9194273126')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (875, N'Photojam', N'59 Trailsway Court', NULL, N'Washington', N'DC', 20397, N'3910829760')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (876, N'Ailane', N'334 Scoville Point', NULL, N'Philadelphia', N'PA', 19125, N'2189267646')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (877, N'Yacero', N'313 Kenwood Park', NULL, N'Detroit', N'MI', 48217, N'7323509296')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (878, N'Oloo', N'23 Welch Lane', NULL, N'Clearwater', N'FL', 33763, N'9204312140')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (879, N'Twiyo', N'9180 Saint Paul Street', NULL, N'Orlando', N'FL', 32854, N'3254836314')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (880, N'JumpXS', N'795 Lillian Pass', NULL, N'Fresno', N'CA', 93740, N'1952937167')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (881, N'Jaloo', N'82 Carey Plaza', NULL, N'Jackson', N'MS', 39296, N'0074966401')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (882, N'Tanoodle', N'872 Kropf Point', NULL, N'Amarillo', N'TX', 79116, N'8663420498')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (883, N'Jaxworks', N'17 Quincy Way', NULL, N'Waterbury', N'CT', 6721, N'9149256335')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (884, N'Yacero', N'4983 Jenna Alley', NULL, N'Charlotte', N'NC', 28247, N'6397160241')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (885, N'Npath', N'6140 Golden Leaf Alley', NULL, N'Chicago', N'IL', 60609, N'1566789129')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (886, N'Snaptags', N'4 Reindahl Crossing', NULL, N'North Little Rock', N'AR', 72199, N'9824624765')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (887, N'Dynava', N'35758 Mayfield Trail', NULL, N'Fort Worth', N'TX', 76115, N'7297884884')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (888, N'Livetube', N'66 Melvin Drive', NULL, N'Saint Paul', N'MN', 55127, N'3839320316')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (889, N'Yodel', N'59894 Sommers Place', NULL, N'New Haven', N'CT', 6505, N'8524540865')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (890, N'Jaxbean', N'279 Utah Parkway', NULL, N'Buffalo', N'NY', 14276, N'3364117648')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (891, N'Vinder', N'1313 Maywood Parkway', NULL, N'Saginaw', N'MI', 48604, N'8326923569')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (892, N'Pixoboo', N'7542 Dexter Plaza', NULL, N'Dallas', N'TX', 75323, N'8729817953')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (893, N'Linklinks', N'9161 Warrior Center', NULL, N'New Orleans', N'LA', 70124, N'5071827402')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (894, N'Zava', N'7771 Hoard Street', NULL, N'Birmingham', N'AL', 35210, N'5384529578')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (895, N'Quaxo', N'55 Ruskin Plaza', NULL, N'San Jose', N'CA', 95123, N'1240420123')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (896, N'Yacero', N'781 Springview Junction', NULL, N'Topeka', N'KS', 66629, N'1798477343')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (897, N'Fatz', N'73 Hanover Junction', NULL, N'Louisville', N'KY', 40293, N'3028186799')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (898, N'Roodel', N'261 Oak Alley', NULL, N'New York City', N'NY', 10019, N'9251694091')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (899, N'Skajo', N'92 Rieder Point', NULL, N'Houston', N'TX', 77020, N'6754063865')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (900, N'Innojam', N'77885 Leroy Alley', NULL, N'Peoria', N'IL', 61629, N'5177118638')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (901, N'Quatz', N'3689 American Plaza', NULL, N'Washington', N'DC', 20057, N'7518353264')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (902, N'Photospace', N'7872 Scott Parkway', NULL, N'Knoxville', N'TN', 37924, N'7432627917')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (903, N'Wikizz', N'643 Lakewood Circle', NULL, N'Fayetteville', N'NC', 28305, N'6998475083')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (904, N'Jetpulse', N'77029 Fallview Court', NULL, N'Tacoma', N'WA', 98442, N'2889245365')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (905, N'Voolith', N'856 Hayes Center', NULL, N'Harrisburg', N'PA', 17110, N'6863216182')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (906, N'Blognation', N'3 Cottonwood Plaza', NULL, N'Arlington', N'TX', 76011, N'9081573892')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (907, N'Devshare', N'811 Esker Hill', NULL, N'Appleton', N'WI', 54915, N'2861871774')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (908, N'Kwilith', N'8 Holy Cross Place', NULL, N'Omaha', N'NE', 68110, N'0069798846')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (909, N'Rhyzio', N'6 Mallard Terrace', NULL, N'Pensacola', N'FL', 32511, N'8660720300')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (910, N'Yodoo', N'620 Oak Street', NULL, N'Fort Worth', N'TX', 76198, N'6390074653')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (911, N'Tagcat', N'899 Anthes Alley', NULL, N'Tulsa', N'OK', 74170, N'0790585879')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (912, N'Skibox', N'0422 Schurz Court', NULL, N'Denver', N'CO', 80235, N'2501325464')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (913, N'Skaboo', N'4641 Hanson Plaza', NULL, N'New York City', N'NY', 10280, N'8405782767')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (914, N'Kwinu', N'368 Kipling Junction', NULL, N'Lansing', N'MI', 48956, N'9470755832')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (915, N'Riffwire', N'37928 8th Trail', NULL, N'Salt Lake City', N'UT', 84199, N'1660401345')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (916, N'Photolist', N'4598 Esker Pass', NULL, N'Jacksonville', N'FL', 32255, N'1495841493')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (917, N'Vipe', N'62 Havey Center', NULL, N'San Diego', N'CA', 92132, N'5604836233')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (918, N'Centidel', N'62 Logan Lane', NULL, N'Hicksville', N'NY', 11854, N'4996573089')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (919, N'Abatz', N'396 Pepper Wood Place', NULL, N'Erie', N'PA', 16534, N'1429486196')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (920, N'Realcube', N'7 Messerschmidt Circle', NULL, N'Memphis', N'TN', 38104, N'8770484846')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (921, N'Kayveo', N'4661 Roth Crossing', NULL, N'Las Vegas', N'NV', 89150, N'3980937344')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (922, N'Snaptags', N'5 Morningstar Park', NULL, N'Brockton', N'MA', 2305, N'7429218927')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (923, N'Trunyx', N'91703 Mitchell Drive', NULL, N'Nashville', N'TN', 37245, N'5227898087')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (924, N'Oyonder', N'35538 Dakota Circle', NULL, N'Washington', N'DC', 20067, N'1285882815')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (925, N'Photobug', N'12774 Mayer Park', NULL, N'Bismarck', N'ND', 58505, N'4360399371')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (926, N'Rhynyx', N'8 Warner Place', NULL, N'Norwalk', N'CT', 6859, N'6801173665')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (927, N'Yamia', N'767 Hermina Pass', NULL, N'Albany', N'NY', 12242, N'1402987686')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (928, N'Skippad', N'9 Clyde Gallagher Road', NULL, N'Odessa', N'TX', 79769, N'9093776653')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (929, N'Zoovu', N'41366 Crowley Place', NULL, N'Raleigh', N'NC', 27610, N'5688915082')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (930, N'Dabjam', N'936 Carpenter Plaza', NULL, N'San Jose', N'CA', 95150, N'2752485524')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (931, N'Photospace', N'58429 Lyons Avenue', NULL, N'Anchorage', N'AK', 99517, N'3692390139')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (932, N'Thoughtblab', N'266 Pierstorff Trail', NULL, N'Newton', N'MA', 2458, N'7724609582')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (933, N'Fivespan', N'9591 Bartelt Alley', NULL, N'Houston', N'TX', 77055, N'0539089320')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (934, N'Twinte', N'7719 Larry Parkway', NULL, N'Peoria', N'AZ', 85383, N'4924902097')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (935, N'Twinte', N'4934 Dexter Center', NULL, N'Pittsburgh', N'PA', 15286, N'3931241215')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (936, N'Tekfly', N'63028 Red Cloud Way', NULL, N'Crawfordsville', N'IN', 47937, N'9659770553')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (937, N'Aimbo', N'98772 Artisan Place', NULL, N'Tulsa', N'OK', 74184, N'2516405125')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (938, N'Tavu', N'792 Beilfuss Junction', NULL, N'San Diego', N'CA', 92153, N'7993056784')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (939, N'Wikizz', N'9 Kingsford Hill', NULL, N'Pensacola', N'FL', 32505, N'7672266279')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (940, N'Kwideo', N'5851 Sachs Junction', NULL, N'Nashville', N'TN', 37228, N'2991498675')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (941, N'Blogspan', N'84787 Logan Pass', NULL, N'Washington', N'DC', 20470, N'3154919047')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (942, N'Skinix', N'09913 Hovde Crossing', NULL, N'Macon', N'GA', 31296, N'5095865968')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (943, N'Photobug', N'26 Old Gate Hill', NULL, N'Des Moines', N'IA', 50369, N'3712962986')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (944, N'Edgepulse', N'48 Nancy Pass', NULL, N'Greensboro', N'NC', 27404, N'8784067517')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (945, N'Edgetag', N'524 Namekagon Trail', NULL, N'Alexandria', N'VA', 22313, N'4950960815')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (946, N'Quimba', N'521 Troy Circle', NULL, N'Mesa', N'AZ', 85215, N'9194573111')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (947, N'Yata', N'53413 Lindbergh Way', NULL, N'Memphis', N'TN', 38126, N'1497075268')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (948, N'Bubbletube', N'163 Cody Center', NULL, N'Salt Lake City', N'UT', 84152, N'5432137323')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (949, N'Wikivu', N'7 Village Terrace', NULL, N'Memphis', N'TN', 38197, N'3223782226')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (950, N'Oyonder', N'9 Sommers Junction', NULL, N'Boston', N'MA', 2104, N'3634129993')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (951, N'Voonix', N'5510 Brentwood Avenue', NULL, N'New York City', N'NY', 10024, N'2232183438')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (952, N'Mudo', N'22 Hauk Place', NULL, N'Miami', N'FL', 33175, N'2198189091')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (953, N'Photofeed', N'13 Grover Plaza', NULL, N'Muncie', N'IN', 47306, N'6392632920')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (954, N'Jayo', N'6836 Maywood Center', NULL, N'Houston', N'TX', 77055, N'0792299030')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (955, N'Yotz', N'9 Karstens Trail', NULL, N'Gilbert', N'AZ', 85297, N'1138079351')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (956, N'Jabbersphere', N'048 Jackson Terrace', NULL, N'Atlanta', N'GA', 30336, N'9755771802')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (957, N'Feedbug', N'0 Mallard Court', NULL, N'Charleston', N'WV', 25331, N'4967391674')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (958, N'Avamba', N'38 Toban Avenue', NULL, N'El Paso', N'TX', 88563, N'5391122304')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (959, N'Thoughtstorm', N'65 Grasskamp Pass', NULL, N'Tampa', N'FL', 33625, N'2994535867')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (960, N'Talane', N'06713 Maywood Alley', NULL, N'Spokane', N'WA', 99215, N'5327506322')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (961, N'Blogspan', N'382 Colorado Terrace', NULL, N'Dayton', N'OH', 45403, N'7013266294')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (962, N'Oozz', N'57 Sundown Crossing', NULL, N'Tulsa', N'OK', 74170, N'9686212803')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (963, N'Mynte', N'82 Welch Trail', NULL, N'San Antonio', N'TX', 78215, N'0641349154')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (964, N'Realmix', N'9 Harper Pass', NULL, N'Troy', N'MI', 48098, N'7721923099')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (965, N'Ooba', N'8754 Boyd Park', NULL, N'New Orleans', N'LA', 70165, N'7835212568')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (966, N'Voomm', N'46880 Heath Plaza', NULL, N'Chattanooga', N'TN', 37410, N'9274870253')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (967, N'Skibox', N'5 Eastlawn Place', NULL, N'San Antonio', N'TX', 78225, N'3478680049')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (968, N'Yombu', N'35 Bunting Crossing', NULL, N'Cincinnati', N'OH', 45999, N'0873713005')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (969, N'Tagtune', N'42261 Florence Lane', NULL, N'Springfield', N'MA', 1105, N'0945189318')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (970, N'Gabvine', N'78 Esch Crossing', NULL, N'Katy', N'TX', 77493, N'0594206928')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (971, N'Omba', N'2 Artisan Terrace', NULL, N'Littleton', N'CO', 80161, N'2958495122')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (972, N'Podcat', N'03 Marquette Way', NULL, N'Midland', N'TX', 79710, N'7745115661')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (973, N'Npath', N'2835 Loeprich Circle', NULL, N'Davenport', N'IA', 52809, N'2746045547')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (974, N'Twimm', N'5669 Knutson Avenue', NULL, N'Duluth', N'MN', 55811, N'8222793408')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (975, N'Topicshots', N'1 Dahle Street', NULL, N'Lake Worth', N'FL', 33462, N'5528739885')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (976, N'Skyba', N'3841 Harper Alley', NULL, N'Lake Worth', N'FL', 33462, N'4546508402')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (977, N'Mydo', N'34 Montana Drive', NULL, N'San Bernardino', N'CA', 92424, N'8571058692')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (978, N'Meembee', N'169 Prentice Crossing', NULL, N'Gatesville', N'TX', 76598, N'9989039027')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (979, N'Avamm', N'355 Delladonna Alley', NULL, N'Schenectady', N'NY', 12305, N'3368292522')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (980, N'Devpoint', N'2 Nevada Way', NULL, N'Brooksville', N'FL', 34605, N'6470330578')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (981, N'Divavu', N'3650 Eliot Place', NULL, N'Baltimore', N'MD', 21216, N'0003558415')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (982, N'Kazio', N'69 Northwestern Hill', NULL, N'Tulsa', N'OK', 74184, N'8277267822')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (983, N'Riffwire', N'81504 Southridge Road', NULL, N'Dallas', N'TX', 75210, N'0944594609')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (984, N'Innotype', N'21261 Walton Alley', NULL, N'Roanoke', N'VA', 24034, N'7932705008')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (985, N'Realcube', N'0795 Pleasure Pass', NULL, N'South Lake Tahoe', N'CA', 96154, N'6351568726')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (986, N'Topiczoom', N'555 Moland Hill', NULL, N'Irving', N'TX', 75037, N'0291623196')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (987, N'Jabbersphere', N'8418 Upham Point', NULL, N'Phoenix', N'AZ', 85067, N'3687886318')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (988, N'Wordify', N'38 Hudson Pass', NULL, N'Carlsbad', N'CA', 92013, N'8225248962')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (989, N'Flashpoint', N'6797 Katie Drive', NULL, N'Portsmouth', N'NH', 3804, N'9582058161')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (990, N'Omba', N'741 Shoshone Court', NULL, N'Shawnee Mission', N'KS', 66220, N'9044593127')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (991, N'Photobug', N'06 Schiller Hill', NULL, N'Boulder', N'CO', 80305, N'4151673727')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (992, N'Dabjam', N'239 Bluestem Crossing', NULL, N'Chicago', N'IL', 60636, N'9279823965')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (993, N'Meejo', N'6 Lillian Circle', NULL, N'Punta Gorda', N'FL', 33982, N'0020672619')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (994, N'Talane', N'797 Nevada Way', NULL, N'Albuquerque', N'NM', 87105, N'7830913253')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (995, N'Jabberbean', N'294 Basil Trail', NULL, N'Tulsa', N'OK', 74184, N'7888480764')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (996, N'Youspan', N'4160 Dottie Junction', NULL, N'Charlotte', N'NC', 28247, N'8779771992')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (997, N'Tambee', N'03 Corscot Street', NULL, N'Pittsburgh', N'PA', 15279, N'9815169253')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (998, N'Flashspan', N'56 Vahlen Park', NULL, N'Littleton', N'CO', 80161, N'2807844433')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (999, N'Rhyzio', N'153 Onsgard Circle', NULL, N'Macon', N'GA', 31217, N'2399613534')
GO
INSERT [dbo].[MockCompanies] ([id], [Name], [Address1], [Address2], [City], [StateId], [Zip], [PhoneNumber]) VALUES (1000, N'Voonte', N'13102 Lukken Lane', NULL, N'Atlanta', N'GA', 30340, N'3558559332')
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (865, N'Louis', N'Gutierrez', N'lgutierrezo0@wp.com', N'365 Cottonwood Way', N'Atlanta', N'GA', N'5-(737)316-9450', 30306)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (866, N'Patrick', N'Wallace', N'pwallaceo1@com.com', N'29 Coleman Crossing', N'Philadelphia', N'PA', N'7-(752)779-2582', 19141)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (867, N'Nicholas', N'Elliott', N'nelliotto2@wsj.com', N'5386 Susan Junction', N'Albuquerque', N'NM', N'9-(669)093-9876', 87105)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (868, N'Randy', N'Weaver', N'rweavero3@go.com', N'12 Swallow Center', N'Springfield', N'IL', N'5-(689)540-8939', 62756)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (869, N'Charles', N'Sanders', N'csanderso4@fda.gov', N'967 Ryan Circle', N'Topeka', N'KS', N'8-(012)514-5941', 66606)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (870, N'Catherine', N'Wright', N'cwrighto5@quantcast.com', N'82 Center Park', N'Greensboro', N'NC', N'3-(123)221-4976', 27415)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (871, N'Brian', N'Gomez', N'bgomezo6@addthis.com', N'09 Homewood Trail', N'Charleston', N'SC', N'9-(925)108-4470', 29424)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (872, N'Kathy', N'Nguyen', N'knguyeno7@utexas.edu', N'6913 8th Crossing', N'San Jose', N'CA', N'0-(402)924-5289', 95133)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (873, N'Willie', N'Hansen', N'whanseno8@amazon.co.jp', N'923 2nd Crossing', N'Charlotte', N'NC', N'0-(364)062-5105', 28205)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (874, N'Andrew', N'Thomas', N'athomaso9@zdnet.com', N'24 Fremont Lane', N'Saint Paul', N'MN', N'3-(669)203-5417', 55166)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (875, N'Louise', N'Burton', N'lburtonoa@cnet.com', N'39 Algoma Junction', N'Little Rock', N'AR', N'8-(505)385-9424', 72215)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (876, N'Alice', N'Brown', N'abrownob@scientificamerican.com', N'93 Monica Avenue', N'Fort Wayne', N'IN', N'9-(486)820-1820', 46805)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (877, N'Betty', N'Hill', N'bhilloc@marketwatch.com', N'3 Maryland Alley', N'Schenectady', N'NY', N'7-(630)523-2625', 12305)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (878, N'Brandon', N'Mills', N'bmillsod@elegantthemes.com', N'8 Sunbrook Drive', N'Los Angeles', N'CA', N'6-(383)965-5496', 90081)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (879, N'Amanda', N'Jenkins', N'ajenkinsoe@kickstarter.com', N'2653 Memorial Road', N'Washington', N'DC', N'4-(159)884-7381', 20546)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (880, N'Joe', N'Sims', N'jsimsof@prweb.com', N'78538 Annamark Hill', N'Jackson', N'MS', N'5-(641)649-3372', 39210)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (881, N'Christina', N'Johnston', N'cjohnstonog@theguardian.com', N'1 Anzinger Street', N'Louisville', N'KY', N'1-(680)642-6412', 40293)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (882, N'Keith', N'Lynch', N'klynchoh@wikia.com', N'800 Clyde Gallagher Place', N'Wilmington', N'DE', N'2-(838)414-3660', 19805)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (883, N'Bruce', N'Robertson', N'brobertsonoi@yolasite.com', N'2 Arizona Plaza', N'El Paso', N'TX', N'3-(846)312-0282', 88525)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (884, N'Irene', N'Adams', N'iadamsoj@ebay.com', N'93284 Glacier Hill Drive', N'Battle Creek', N'MI', N'4-(736)541-0057', 49018)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (885, N'Joyce', N'Hunt', N'jhuntok@dion.ne.jp', N'40 Northridge Junction', N'Hartford', N'CT', N'4-(509)427-7884', 6160)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (886, N'Kathryn', N'Mitchell', N'kmitchellol@google.cn', N'7683 Bobwhite Way', N'New York City', N'NY', N'7-(871)422-8296', 10120)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (887, N'Craig', N'Lee', N'cleeom@wsj.com', N'4 Manufacturers Parkway', N'Kansas City', N'MO', N'1-(688)926-9926', 64179)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (888, N'Emily', N'Hicks', N'ehickson@reverbnation.com', N'10 Carberry Trail', N'San Francisco', N'CA', N'9-(852)045-9527', 94121)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (889, N'Evelyn', N'Ward', N'ewardoo@cisco.com', N'7 Larry Way', N'Portland', N'OR', N'2-(673)604-0577', 97286)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (890, N'Kimberly', N'Morris', N'kmorrisop@ucsd.edu', N'0 Rowland Circle', N'Juneau', N'AK', N'3-(975)718-3645', 99812)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (891, N'Juan', N'Palmer', N'jpalmeroq@bing.com', N'81231 Westerfield Trail', N'Madison', N'WI', N'3-(287)480-8684', 53790)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (892, N'Diana', N'Evans', N'devansor@patch.com', N'921 Forest Street', N'San Antonio', N'TX', N'3-(582)092-0770', 78285)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (893, N'Jeffrey', N'Larson', N'jlarsonos@mediafire.com', N'0 Shasta Hill', N'Fort Lauderdale', N'FL', N'3-(032)971-0579', 33345)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (894, N'Marie', N'Wheeler', N'mwheelerot@sphinn.com', N'12372 Florence Plaza', N'Lakewood', N'WA', N'6-(881)133-6751', 98498)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (895, N'Amy', N'Freeman', N'afreemanou@microsoft.com', N'6037 Sauthoff Lane', N'Shreveport', N'LA', N'6-(412)916-6093', 71105)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (896, N'Anthony', N'Parker', N'aparkerov@dailymail.co.uk', N'6237 Quincy Avenue', N'Saint Louis', N'MO', N'0-(098)323-9995', 63143)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (897, N'Betty', N'Watkins', N'bwatkinsow@cargocollective.com', N'6 Hooker Terrace', N'Corpus Christi', N'TX', N'9-(791)305-7125', 78405)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (898, N'Cynthia', N'Taylor', N'ctaylorox@dot.gov', N'9 Sherman Parkway', N'Honolulu', N'HI', N'2-(595)449-8049', 96815)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (899, N'Rachel', N'Campbell', N'rcampbelloy@prweb.com', N'14 8th Circle', N'San Antonio', N'TX', N'8-(080)877-1629', 78215)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (900, N'Robert', N'Hanson', N'rhansonoz@miibeian.gov.cn', N'25728 Jenna Lane', N'Jersey City', N'NJ', N'9-(677)951-7625', 7305)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (901, N'Teresa', N'Smith', N'tsmithp0@histats.com', N'68329 Manley Plaza', N'Bakersfield', N'CA', N'7-(167)534-9860', 93311)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (902, N'Beverly', N'Morgan', N'bmorganp1@admin.ch', N'950 Bayside Center', N'Reston', N'VA', N'4-(777)761-8155', 22096)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (903, N'Sandra', N'Knight', N'sknightp2@theatlantic.com', N'3649 Sutteridge Court', N'Honolulu', N'HI', N'9-(979)151-9504', 96850)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (904, N'Jessica', N'Sanders', N'jsandersp3@dropbox.com', N'56 Kipling Street', N'Buffalo', N'NY', N'6-(872)673-6993', 14205)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (905, N'Aaron', N'Spencer', N'aspencerp4@mediafire.com', N'74303 Straubel Park', N'Columbus', N'GA', N'3-(401)194-2102', 31914)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (906, N'Fred', N'Reid', N'freidp5@noaa.gov', N'5246 Gulseth Alley', N'Austin', N'TX', N'3-(718)692-5738', 78721)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (907, N'Joseph', N'Davis', N'jdavisp6@pcworld.com', N'9 Iowa Street', N'Seattle', N'WA', N'1-(754)081-2728', 98109)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (908, N'Andrew', N'Murphy', N'amurphyp7@mozilla.com', N'29725 Badeau Drive', N'Tacoma', N'WA', N'5-(187)864-4973', 98481)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (909, N'Harold', N'Elliott', N'helliottp8@stanford.edu', N'97 Hanover Drive', N'Chattanooga', N'TN', N'9-(497)100-8737', 37405)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (910, N'Rachel', N'Weaver', N'rweaverp9@nydailynews.com', N'72697 Ludington Pass', N'Little Rock', N'AR', N'2-(497)456-2232', 72222)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (911, N'Jose', N'Morgan', N'jmorganpa@baidu.com', N'59037 Warbler Point', N'Cleveland', N'OH', N'1-(402)489-9032', 44197)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (912, N'Barbara', N'Dunn', N'bdunnpb@ted.com', N'457 Petterle Trail', N'Cleveland', N'OH', N'8-(762)462-5622', 44118)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (913, N'Barbara', N'Stevens', N'bstevenspc@nih.gov', N'44 Claremont Park', N'Los Angeles', N'CA', N'9-(390)603-9256', 90076)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (914, N'Emily', N'Robinson', N'erobinsonpd@altervista.org', N'6 Beilfuss Drive', N'Atlanta', N'GA', N'4-(478)155-3130', 30328)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (915, N'Jeremy', N'Bennett', N'jbennettpe@bing.com', N'5992 Coolidge Circle', N'Lexington', N'KY', N'0-(583)825-0463', 40596)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (916, N'Harry', N'Ryan', N'hryanpf@cargocollective.com', N'8 Bultman Place', N'Tulsa', N'OK', N'5-(568)527-2821', 74170)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (917, N'Jonathan', N'Burns', N'jburnspg@google.com', N'59 Heath Avenue', N'Worcester', N'MA', N'3-(420)885-1215', 1605)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (918, N'Gerald', N'Ellis', N'gellisph@gnu.org', N'73 Hudson Court', N'Columbus', N'MS', N'1-(775)927-7400', 39705)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (919, N'Brian', N'Watkins', N'bwatkinspi@hc360.com', N'45189 Tennyson Way', N'Johnstown', N'PA', N'0-(144)788-5249', 15906)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (920, N'Kelly', N'Green', N'kgreenpj@opensource.org', N'90217 Fordem Terrace', N'Springfield', N'IL', N'3-(319)355-1830', 62711)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (921, N'Jason', N'Smith', N'jsmithpk@cafepress.com', N'07 Harbort Way', N'Monroe', N'LA', N'4-(812)546-1527', 71213)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (922, N'Sean', N'Fox', N'sfoxpl@nyu.edu', N'354 Thackeray Junction', N'Philadelphia', N'PA', N'4-(647)474-5160', 19184)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (923, N'Jose', N'Williamson', N'jwilliamsonpm@dyndns.org', N'3 Fremont Pass', N'Lubbock', N'TX', N'5-(024)342-3516', 79415)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (924, N'Christina', N'Torres', N'ctorrespn@51.la', N'724 Hintze Crossing', N'Seattle', N'WA', N'4-(780)254-0823', 98127)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (925, N'Justin', N'Butler', N'jbutlerpo@imgur.com', N'57543 Northridge Park', N'Long Beach', N'CA', N'6-(267)349-7653', 90805)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (926, N'Joe', N'Nichols', N'jnicholspp@ask.com', N'0 Golf View Way', N'Norfolk', N'VA', N'2-(116)767-8468', 23504)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (927, N'Heather', N'Watkins', N'hwatkinspq@freewebs.com', N'3 Old Gate Plaza', N'Berkeley', N'CA', N'1-(578)555-8837', 94705)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (928, N'Kathy', N'Evans', N'kevanspr@cyberchimps.com', N'18684 Hudson Park', N'Champaign', N'IL', N'1-(286)077-7371', 61825)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (929, N'Paula', N'Carroll', N'pcarrollps@google.it', N'1554 Shasta Drive', N'Irvine', N'CA', N'0-(538)521-8090', 92710)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (930, N'Nancy', N'Scott', N'nscottpt@google.com.hk', N'636 Eliot Circle', N'Macon', N'GA', N'1-(510)772-5055', 31205)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (931, N'Jerry', N'Grant', N'jgrantpu@marriott.com', N'1 Glendale Place', N'Birmingham', N'AL', N'1-(387)023-8558', 35279)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (932, N'Beverly', N'Rogers', N'brogerspv@behance.net', N'623 International Plaza', N'Providence', N'RI', N'6-(872)859-5859', 2905)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (933, N'Christine', N'Roberts', N'crobertspw@weebly.com', N'228 Bluestem Alley', N'Oklahoma City', N'OK', N'8-(532)257-1630', 73157)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (934, N'Bruce', N'Richardson', N'brichardsonpx@washington.edu', N'981 Sunbrook Alley', N'New Hyde Park', N'NY', N'1-(251)872-7828', 11044)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (935, N'Joan', N'James', N'jjamespy@abc.net.au', N'33399 Corry Junction', N'Tucson', N'AZ', N'4-(781)767-0411', 85732)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (936, N'William', N'Snyder', N'wsnyderpz@upenn.edu', N'8 Charing Cross Street', N'San Jose', N'CA', N'0-(397)224-7222', 95138)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (937, N'Ralph', N'Richards', N'rrichardsq0@google.co.uk', N'58465 Northland Lane', N'Bozeman', N'MT', N'5-(381)025-7365', 59771)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (938, N'Donald', N'Myers', N'dmyersq1@ycombinator.com', N'32783 Fisk Terrace', N'Austin', N'TX', N'9-(883)391-7437', 78744)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (939, N'Eugene', N'Bell', N'ebellq2@amazon.de', N'484 Vernon Plaza', N'Orlando', N'FL', N'4-(044)360-9174', 32835)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (940, N'Wanda', N'Ramirez', N'wramirezq3@delicious.com', N'3 Tomscot Center', N'Los Angeles', N'CA', N'0-(419)893-4564', 90071)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (941, N'Frank', N'Cole', N'fcoleq4@telegraph.co.uk', N'21646 Haas Way', N'Huntington', N'WV', N'4-(340)335-1773', 25709)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (942, N'Kathy', N'Henderson', N'khendersonq5@sciencedirect.com', N'946 Butternut Drive', N'New York City', N'NY', N'6-(168)245-0854', 10105)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (943, N'Maria', N'Sanders', N'msandersq6@oracle.com', N'9982 Myrtle Lane', N'Portland', N'OR', N'8-(765)118-3296', 97232)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (944, N'Bonnie', N'Chapman', N'bchapmanq7@bloomberg.com', N'0904 Esch Place', N'Oklahoma City', N'OK', N'1-(202)555-7284', 73190)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (945, N'Justin', N'Wheeler', N'jwheelerq8@networksolutions.com', N'0284 Village Park', N'Peoria', N'IL', N'3-(522)311-5237', 61640)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (946, N'Sharon', N'Davis', N'sdavisq9@fastcompany.com', N'97244 Erie Pass', N'Jeffersonville', N'IN', N'1-(429)571-9862', 47134)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (947, N'Kevin', N'Banks', N'kbanksqa@instagram.com', N'1 7th Plaza', N'Gary', N'IN', N'9-(939)560-6810', 46406)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (948, N'Larry', N'Reid', N'lreidqb@zimbio.com', N'33 Algoma Court', N'Amarillo', N'TX', N'2-(441)598-8267', 79159)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (949, N'Lois', N'Kim', N'lkimqc@youtube.com', N'8522 Columbus Trail', N'Cincinnati', N'OH', N'7-(255)624-0252', 45264)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (950, N'Joe', N'Garza', N'jgarzaqd@people.com.cn', N'7620 Golf Course Street', N'Biloxi', N'MS', N'6-(700)785-5456', 39534)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (951, N'Clarence', N'Harrison', N'charrisonqe@digg.com', N'172 Veith Crossing', N'Honolulu', N'HI', N'9-(763)667-2705', 96810)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (952, N'Brenda', N'Lewis', N'blewisqf@surveymonkey.com', N'11325 John Wall Circle', N'Buffalo', N'NY', N'6-(166)657-8622', 14210)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (953, N'Russell', N'Dixon', N'rdixonqg@csmonitor.com', N'7411 Kedzie Place', N'Phoenix', N'AZ', N'5-(059)868-3364', 85030)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (954, N'Elizabeth', N'Berry', N'eberryqh@reverbnation.com', N'5 Northwestern Crossing', N'Newton', N'MA', N'8-(052)093-9576', 2162)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (955, N'Edward', N'Flores', N'efloresqi@craigslist.org', N'6 Granby Plaza', N'Cleveland', N'OH', N'5-(890)835-5865', 44118)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (956, N'Mary', N'Owens', N'mowensqj@linkedin.com', N'2000 Eagan Park', N'Loretto', N'MN', N'3-(084)867-9402', 55598)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (957, N'Lillian', N'Carpenter', N'lcarpenterqk@sciencedaily.com', N'82 Bowman Pass', N'Fort Wayne', N'IN', N'0-(280)640-7487', 46862)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (958, N'Sean', N'Perkins', N'sperkinsql@nature.com', N'09584 Rusk Park', N'Bradenton', N'FL', N'3-(684)331-0084', 34210)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (959, N'Lois', N'Richards', N'lrichardsqm@taobao.com', N'4864 Delaware Plaza', N'Murfreesboro', N'TN', N'6-(029)269-0029', 37131)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (960, N'Beverly', N'Carroll', N'bcarrollqn@blogger.com', N'355 Hazelcrest Court', N'Santa Rosa', N'CA', N'1-(596)230-6013', 95405)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (961, N'Linda', N'Reyes', N'lreyesqo@squidoo.com', N'33491 Elmside Pass', N'Springfield', N'MO', N'7-(368)033-8309', 65805)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (962, N'Sara', N'Chapman', N'schapmanqp@slashdot.org', N'40 Monterey Junction', N'Kansas City', N'MO', N'7-(180)070-4099', 64142)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (963, N'Bruce', N'Ramirez', N'bramirezqq@fastcompany.com', N'9874 Tennessee Hill', N'Phoenix', N'AZ', N'8-(640)850-3208', 85035)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (964, N'Michael', N'Hicks', N'mhicksqr@hao123.com', N'4 Anderson Parkway', N'Austin', N'TX', N'2-(738)211-7769', 78759)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (965, N'Lisa', N'Wallace', N'lwallaceqs@bandcamp.com', N'354 Holy Cross Crossing', N'Jackson', N'MS', N'7-(633)369-7265', 39210)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (966, N'Mary', N'Hunter', N'mhunterqt@yale.edu', N'0 Del Sol Place', N'Sacramento', N'CA', N'8-(074)127-2344', 94297)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (967, N'Alan', N'Coleman', N'acolemanqu@w3.org', N'11 Evergreen Circle', N'Sacramento', N'CA', N'0-(792)561-2561', 94297)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (968, N'Nicole', N'Howell', N'nhowellqv@trellian.com', N'3711 Veith Point', N'Torrance', N'CA', N'3-(399)153-5201', 90510)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (969, N'Samuel', N'Peterson', N'spetersonqw@bbb.org', N'52 Mcbride Trail', N'Aurora', N'CO', N'4-(943)707-2604', 80044)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (970, N'Margaret', N'Schmidt', N'mschmidtqx@npr.org', N'4168 Loftsgordon Park', N'Santa Monica', N'CA', N'3-(440)808-3787', 90405)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (971, N'Anne', N'Fields', N'afieldsqy@privacy.gov.au', N'7 Linden Center', N'El Paso', N'TX', N'6-(174)765-5561', 79968)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (972, N'Benjamin', N'Ferguson', N'bfergusonqz@odnoklassniki.ru', N'16145 Ryan Circle', N'Washington', N'DC', N'1-(690)406-7557', 20041)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (973, N'Robert', N'Fuller', N'rfullerr0@statcounter.com', N'416 Columbus Junction', N'Los Angeles', N'CA', N'0-(914)319-7846', 90050)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (974, N'Amanda', N'Ross', N'arossr1@nyu.edu', N'50 Clemons Road', N'Scottsdale', N'AZ', N'0-(793)430-8487', 85260)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (975, N'Evelyn', N'Lawrence', N'elawrencer2@mtv.com', N'833 Pine View Road', N'Tacoma', N'WA', N'5-(351)469-8404', 98411)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (976, N'Kimberly', N'Gray', N'kgrayr3@census.gov', N'9719 Bluestem Park', N'Cleveland', N'OH', N'4-(934)986-8404', 44105)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (977, N'Bruce', N'Richardson', N'brichardsonr4@who.int', N'5885 Laurel Place', N'Daytona Beach', N'FL', N'1-(959)884-2191', 32118)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (978, N'Jeffrey', N'Nguyen', N'jnguyenr5@fda.gov', N'5 Park Meadow Hill', N'Jackson', N'MS', N'6-(136)926-1880', 39204)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (979, N'Catherine', N'Gutierrez', N'cgutierrezr6@skyrock.com', N'10 Twin Pines Way', N'Woburn', N'MA', N'0-(723)943-5619', 1813)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (980, N'Jack', N'Murphy', N'jmurphyr7@shutterfly.com', N'95080 Memorial Center', N'Minneapolis', N'MN', N'4-(520)746-2132', 55448)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (981, N'Michael', N'Weaver', N'mweaverr8@odnoklassniki.ru', N'4 Dapin Avenue', N'Washington', N'DC', N'1-(923)735-1489', 20404)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (982, N'Brandon', N'Cole', N'bcoler9@ft.com', N'2591 Forest Hill', N'Winston Salem', N'NC', N'3-(209)807-9161', 27157)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (983, N'Jane', N'Webb', N'jwebbra@twitpic.com', N'627 Fallview Terrace', N'Houston', N'TX', N'5-(955)452-1185', 77095)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (984, N'Maria', N'Harvey', N'mharveyrb@icio.us', N'2528 High Crossing Pass', N'Philadelphia', N'PA', N'9-(672)209-0876', 19104)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (985, N'Amanda', N'Perry', N'aperryrc@dell.com', N'99724 Fairfield Pass', N'Pueblo', N'CO', N'9-(051)073-6479', 81015)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (986, N'Thomas', N'Miller', N'tmillerrd@mozilla.org', N'55294 Ilene Center', N'Denver', N'CO', N'6-(953)648-6670', 80249)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (987, N'Joan', N'Knight', N'jknightre@un.org', N'322 Northland Crossing', N'Tampa', N'FL', N'2-(283)059-2870', 33605)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (988, N'Michael', N'Ortiz', N'mortizrf@statcounter.com', N'73 Elgar Way', N'Merrifield', N'VA', N'2-(194)323-1654', 22119)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (989, N'Robert', N'Garcia', N'rgarciarg@yolasite.com', N'125 Walton Park', N'Dallas', N'TX', N'5-(605)562-8091', 75310)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (990, N'Sarah', N'Mills', N'smillsrh@ebay.co.uk', N'3 Crowley Crossing', N'Charlotte', N'NC', N'5-(550)088-9771', 28242)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (991, N'Mildred', N'Porter', N'mporterri@amazon.com', N'04 Blackbird Place', N'Green Bay', N'WI', N'6-(054)323-7059', 54305)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (992, N'Phillip', N'Richards', N'prichardsrj@sbwire.com', N'64613 Raven Center', N'Port Saint Lucie', N'FL', N'7-(403)442-4036', 34985)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (993, N'George', N'Collins', N'gcollinsrk@bloglines.com', N'7 Armistice Road', N'Hartford', N'CT', N'1-(515)202-8744', 6120)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (994, N'Laura', N'Hall', N'lhallrl@wunderground.com', N'3 Washington Avenue', N'Saint Paul', N'MN', N'1-(703)411-2929', 55172)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (995, N'Christopher', N'Garrett', N'cgarrettrm@simplemachines.org', N'6 Corben Parkway', N'Burbank', N'CA', N'0-(211)552-1059', 91505)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (996, N'Victor', N'Cunningham', N'vcunninghamrn@elegantthemes.com', N'8 Buhler Way', N'Washington', N'DC', N'8-(714)331-5659', 20591)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (997, N'Ralph', N'Reynolds', N'rreynoldsro@mapy.cz', N'126 Mifflin Avenue', N'Tacoma', N'WA', N'0-(280)333-1506', 98447)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (998, N'Sandra', N'Mitchell', N'smitchellrp@chronoengine.com', N'61 Crowley Park', N'Columbia', N'SC', N'6-(286)161-2495', 29208)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (999, N'Larry', N'Simmons', N'lsimmonsrq@auda.org.au', N'07 Rigney Lane', N'Ridgely', N'MD', N'4-(550)969-2295', 21684)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (1000, N'Jeremy', N'Green', N'jgreenrr@xinhuanet.com', N'6 Kipling Street', N'Milwaukee', N'WI', N'6-(494)350-2374', 53225)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (1, N'Christina', N'Perkins', N'cperkins0@gmpg.org', N'957 Basil Road', N'Buffalo', N'NY', N'3-(109)784-7107', 14225)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (2, N'Keith', N'Lewis', N'klewis1@squidoo.com', N'8 Graceland Trail', N'Virginia Beach', N'VA', N'7-(374)404-2151', 23464)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (3, N'Keith', N'Riley', N'kriley2@latimes.com', N'1 Tennessee Way', N'Newark', N'NJ', N'4-(732)393-5777', 7112)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (4, N'Daniel', N'Fernandez', N'dfernandez3@census.gov', N'7 Montana Center', N'Santa Ana', N'CA', N'8-(529)968-2078', 92705)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (5, N'Kathryn', N'Reynolds', N'kreynolds4@webs.com', N'46413 Mayer Court', N'Austin', N'TX', N'4-(746)893-3044', 78721)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (6, N'Nancy', N'Williams', N'nwilliams5@wikispaces.com', N'67359 Lyons Park', N'Tampa', N'FL', N'5-(593)214-8738', 33694)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (7, N'Jessica', N'Bell', N'jbell6@ebay.co.uk', N'89093 Banding Junction', N'Saint Paul', N'MN', N'0-(257)066-5327', 55108)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (8, N'Jose', N'Morris', N'jmorris7@taobao.com', N'0 Welch Crossing', N'Sunnyvale', N'CA', N'0-(262)739-5264', 94089)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (9, N'Gloria', N'Austin', N'gaustin8@dagondesign.com', N'690 Lindbergh Place', N'Greensboro', N'NC', N'6-(391)025-8087', 27425)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (10, N'Christopher', N'Fuller', N'cfuller9@diigo.com', N'612 Hanson Street', N'Memphis', N'TN', N'1-(435)644-8063', 38136)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (11, N'Pamela', N'Ramos', N'pramosa@harvard.edu', N'1 Springview Alley', N'Jackson', N'TN', N'2-(404)133-7692', 38308)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (12, N'Larry', N'Johnson', N'ljohnsonb@timesonline.co.uk', N'88 Walton Lane', N'Minneapolis', N'MN', N'6-(811)379-8111', 55470)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (13, N'Cynthia', N'George', N'cgeorgec@globo.com', N'6 Prairie Rose Point', N'San Antonio', N'TX', N'0-(976)605-2154', 78215)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (14, N'Sandra', N'Watson', N'swatsond@fda.gov', N'0 Dapin Trail', N'Schaumburg', N'IL', N'9-(306)303-5661', 60193)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (15, N'Carlos', N'Hanson', N'chansone@illinois.edu', N'4037 Independence Point', N'Louisville', N'KY', N'4-(322)354-7646', 40298)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (16, N'Lawrence', N'Flores', N'lfloresf@google.com.au', N'10 Esch Court', N'Largo', N'FL', N'1-(192)686-3857', 34643)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (17, N'Rebecca', N'Myers', N'rmyersg@google.it', N'9198 Melody Parkway', N'Fort Worth', N'TX', N'9-(055)339-3443', 76105)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (18, N'Anna', N'Castillo', N'acastilloh@instagram.com', N'412 Gateway Junction', N'Lincoln', N'NE', N'7-(191)875-9515', 68505)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (19, N'Martin', N'Brooks', N'mbrooksi@weather.com', N'45 Declaration Road', N'Gainesville', N'FL', N'5-(481)734-6613', 32605)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (20, N'Norma', N'Lopez', N'nlopezj@google.co.uk', N'219 Mesta Hill', N'Littleton', N'CO', N'1-(258)735-6909', 80126)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (21, N'Virginia', N'Crawford', N'vcrawfordk@over-blog.com', N'8940 Susan Place', N'Washington', N'DC', N'5-(149)103-8291', 20299)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (22, N'Christina', N'Larson', N'clarsonl@redcross.org', N'63337 John Wall Plaza', N'Pittsburgh', N'PA', N'5-(503)882-6874', 15274)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (23, N'Jeremy', N'Cruz', N'jcruzm@mozilla.org', N'425 Sherman Alley', N'Gatesville', N'TX', N'8-(781)859-4092', 76598)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (24, N'Dennis', N'Burns', N'dburnsn@woothemes.com', N'809 Hooker Point', N'Cincinnati', N'OH', N'6-(008)545-5142', 45999)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (25, N'Theresa', N'Brown', N'tbrowno@si.edu', N'31 Lerdahl Junction', N'Conroe', N'TX', N'2-(438)272-5606', 77305)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (26, N'George', N'Ellis', N'gellisp@nbcnews.com', N'54692 Talisman Drive', N'Meridian', N'MS', N'7-(219)509-6622', 39305)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (27, N'Russell', N'George', N'rgeorgeq@amazon.com', N'68275 Nobel Circle', N'Richmond', N'VA', N'1-(048)690-0099', 23277)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (28, N'Joe', N'Hall', N'jhallr@usa.gov', N'0384 Maple Wood Court', N'Minneapolis', N'MN', N'8-(547)428-0147', 55446)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (29, N'Laura', N'Miller', N'lmillers@themeforest.net', N'4821 Mendota Road', N'Birmingham', N'AL', N'4-(701)834-1158', 35285)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (30, N'Anna', N'Stevens', N'astevenst@macromedia.com', N'4 Forest Point', N'Ocala', N'FL', N'2-(334)276-8373', 34479)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (31, N'Jane', N'Elliott', N'jelliottu@privacy.gov.au', N'7 Merchant Terrace', N'Texarkana', N'TX', N'1-(912)958-9181', 75507)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (32, N'Karen', N'Gilbert', N'kgilbertv@technorati.com', N'6766 Shelley Court', N'Charlotte', N'NC', N'2-(896)001-3165', 28289)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (33, N'Kenneth', N'West', N'kwestw@auda.org.au', N'24 Prairieview Circle', N'Memphis', N'TN', N'5-(293)329-0454', 38197)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (34, N'Diana', N'Cox', N'dcoxx@cafepress.com', N'26 Kingsford Hill', N'San Jose', N'CA', N'7-(366)392-5058', 95113)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (35, N'Julia', N'Flores', N'jfloresy@deviantart.com', N'153 Petterle Street', N'Salem', N'OR', N'7-(161)440-1668', 97312)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (36, N'Lillian', N'Parker', N'lparkerz@t-online.de', N'90 Hazelcrest Street', N'Pasadena', N'CA', N'7-(530)683-9388', 91117)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (37, N'Andrea', N'Allen', N'aallen10@php.net', N'20 Granby Street', N'Nashville', N'TN', N'5-(157)060-1981', 37245)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (38, N'Donna', N'Wagner', N'dwagner11@addtoany.com', N'2703 Annamark Place', N'Bradenton', N'FL', N'1-(584)471-3437', 34210)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (39, N'Evelyn', N'Burton', N'eburton12@oaic.gov.au', N'394 Dahle Center', N'Jacksonville', N'FL', N'3-(410)422-3820', 32236)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (40, N'Lisa', N'Mendoza', N'lmendoza13@sphinn.com', N'4322 Hagan Terrace', N'Green Bay', N'WI', N'8-(738)537-3220', 54313)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (41, N'Michael', N'Gonzales', N'mgonzales14@topsy.com', N'1623 Towne Plaza', N'Virginia Beach', N'VA', N'9-(328)262-1018', 23464)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (42, N'Paul', N'Mitchell', N'pmitchell15@microsoft.com', N'8 Dwight Plaza', N'Denver', N'CO', N'5-(585)759-6981', 80249)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (43, N'Jason', N'Gibson', N'jgibson16@wired.com', N'40269 Transport Park', N'Houston', N'TX', N'6-(947)545-4323', 77075)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (44, N'Bobby', N'Olson', N'bolson17@ucsd.edu', N'4705 Anniversary Court', N'Kalamazoo', N'MI', N'3-(756)197-7215', 49048)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (45, N'Carlos', N'Williamson', N'cwilliamson18@home.pl', N'459 Havey Street', N'Hialeah', N'FL', N'2-(858)904-4323', 33018)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (46, N'Rebecca', N'Grant', N'rgrant19@netlog.com', N'4764 Buhler Terrace', N'Huntington Beach', N'CA', N'3-(642)837-0012', 92648)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (47, N'Gary', N'Edwards', N'gedwards1a@51.la', N'52698 Melby Trail', N'Jamaica', N'NY', N'0-(831)387-9519', 11436)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (48, N'Norma', N'Tucker', N'ntucker1b@amazon.de', N'8 Northland Way', N'Columbus', N'GA', N'8-(830)606-6141', 31998)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (49, N'Walter', N'Jones', N'wjones1c@stumbleupon.com', N'1 Everett Junction', N'Evansville', N'IN', N'4-(646)244-4475', 47719)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (50, N'Jack', N'Patterson', N'jpatterson1d@123-reg.co.uk', N'6 Cody Place', N'Orlando', N'FL', N'4-(538)266-9392', 32803)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (51, N'Martin', N'Sullivan', N'msullivan1e@aboutads.info', N'98 Pepper Wood Avenue', N'Philadelphia', N'PA', N'7-(575)810-5522', 19093)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (52, N'Fred', N'Russell', N'frussell1f@smh.com.au', N'22 Carberry Crossing', N'Harrisburg', N'PA', N'1-(259)154-1426', 17121)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (53, N'Raymond', N'Palmer', N'rpalmer1g@youtu.be', N'7908 Warbler Park', N'Las Vegas', N'NV', N'8-(741)926-9918', 89140)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (54, N'William', N'Lee', N'wlee1h@ycombinator.com', N'530 Arizona Lane', N'Houston', N'TX', N'3-(295)069-2805', 77030)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (55, N'Sarah', N'Robinson', N'srobinson1i@tripadvisor.com', N'751 Meadow Vale Trail', N'Corpus Christi', N'TX', N'6-(866)482-0168', 78465)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (56, N'Teresa', N'Day', N'tday1j@bloomberg.com', N'5011 Colorado Street', N'Miami', N'FL', N'2-(884)881-2522', 33134)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (57, N'Shirley', N'Evans', N'sevans1k@usgs.gov', N'419 Tennyson Street', N'Fort Myers', N'FL', N'7-(262)607-4156', 33913)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (58, N'Aaron', N'Marshall', N'amarshall1l@lycos.com', N'2132 Ridgeway Pass', N'Marietta', N'GA', N'9-(934)951-6416', 30061)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (59, N'Kenneth', N'Welch', N'kwelch1m@webeden.co.uk', N'20948 Jay Road', N'Portland', N'OR', N'9-(514)012-7788', 97296)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (60, N'Linda', N'Jones', N'ljones1n@1688.com', N'2258 Namekagon Circle', N'Lansing', N'MI', N'5-(357)442-4470', 48956)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (61, N'Robin', N'Sims', N'rsims1o@youtu.be', N'30 Esch Point', N'Washington', N'DC', N'2-(139)708-1631', 20409)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (62, N'Karen', N'Sims', N'ksims1p@ebay.co.uk', N'0 Maple Trail', N'El Paso', N'TX', N'0-(566)219-4689', 79989)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (63, N'David', N'Greene', N'dgreene1q@earthlink.net', N'112 Colorado Junction', N'Washington', N'DC', N'4-(928)468-3992', 20430)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (64, N'Tammy', N'Gardner', N'tgardner1r@google.com.br', N'8388 Lakewood Way', N'Waco', N'TX', N'8-(809)171-0990', 76796)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (65, N'Christopher', N'Castillo', N'ccastillo1s@exblog.jp', N'399 Burrows Road', N'Silver Spring', N'MD', N'8-(293)253-0069', 20918)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (66, N'Christina', N'Welch', N'cwelch1t@sourceforge.net', N'3 American Place', N'Denver', N'CO', N'5-(810)928-5594', 80262)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (67, N'Albert', N'Watkins', N'awatkins1u@eepurl.com', N'45673 Laurel Parkway', N'San Bernardino', N'CA', N'4-(196)715-8904', 92405)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (68, N'David', N'Moore', N'dmoore1v@goodreads.com', N'76794 Main Trail', N'Jackson', N'MS', N'3-(627)027-4892', 39282)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (69, N'Jean', N'Carter', N'jcarter1w@ibm.com', N'35710 Kings Alley', N'Hattiesburg', N'MS', N'7-(320)974-0046', 39404)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (70, N'Jason', N'Watkins', N'jwatkins1x@csmonitor.com', N'9034 Merrick Terrace', N'Hayward', N'CA', N'8-(692)037-1416', 94544)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (71, N'Linda', N'Butler', N'lbutler1y@prweb.com', N'2262 Gateway Terrace', N'San Francisco', N'CA', N'4-(626)191-2852', 94121)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (72, N'Katherine', N'Cox', N'kcox1z@telegraph.co.uk', N'99505 Bultman Parkway', N'Washington', N'DC', N'1-(384)009-1984', 20535)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (73, N'Frances', N'Robinson', N'frobinson20@mozilla.org', N'00996 Huxley Drive', N'Denver', N'CO', N'4-(872)391-1467', 80243)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (74, N'Martha', N'Murray', N'mmurray21@google.co.jp', N'21254 Florence Trail', N'Albuquerque', N'NM', N'8-(869)873-1048', 87190)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (75, N'Anne', N'Boyd', N'aboyd22@slate.com', N'0561 Vidon Point', N'Dallas', N'TX', N'9-(455)773-2585', 75246)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (76, N'Kathy', N'James', N'kjames23@mysql.com', N'067 Raven Alley', N'Davenport', N'IA', N'3-(648)745-3634', 52804)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (77, N'Johnny', N'Stevens', N'jstevens24@forbes.com', N'10 New Castle Road', N'Charlottesville', N'VA', N'3-(772)276-2030', 22908)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (78, N'Johnny', N'Mcdonald', N'jmcdonald25@last.fm', N'2 Fisk Lane', N'Houston', N'TX', N'2-(028)308-4758', 77271)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (79, N'Louis', N'Kennedy', N'lkennedy26@eepurl.com', N'9 Kipling Terrace', N'Fort Smith', N'AR', N'4-(513)006-1553', 72916)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (80, N'Janice', N'Reynolds', N'jreynolds27@liveinternet.ru', N'9 Sheridan Plaza', N'New Orleans', N'LA', N'0-(330)494-0746', 70179)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (81, N'Ryan', N'Cook', N'rcook28@go.com', N'4790 Logan Trail', N'Stockton', N'CA', N'5-(902)329-8730', 95219)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (82, N'Arthur', N'Scott', N'ascott29@woothemes.com', N'4447 Lawn Crossing', N'Panama City', N'FL', N'3-(380)565-1681', 32405)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (83, N'Cynthia', N'Clark', N'cclark2a@tiny.cc', N'14 Cherokee Park', N'Corpus Christi', N'TX', N'7-(815)507-4866', 78426)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (84, N'Melissa', N'Matthews', N'mmatthews2b@dailymail.co.uk', N'30 Brickson Park Terrace', N'Lincoln', N'NE', N'5-(199)635-7760', 68524)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (85, N'Elizabeth', N'Lane', N'elane2c@mysql.com', N'9015 Fairfield Center', N'Lima', N'OH', N'0-(484)816-7424', 45807)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (86, N'Linda', N'Simmons', N'lsimmons2d@google.co.jp', N'5487 Arkansas Avenue', N'Phoenix', N'AZ', N'8-(991)941-2227', 85025)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (87, N'Kenneth', N'Chapman', N'kchapman2e@posterous.com', N'940 Moulton Drive', N'Worcester', N'MA', N'7-(130)518-7163', 1654)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (88, N'Raymond', N'Wheeler', N'rwheeler2f@pagesperso-orange.fr', N'5605 Service Hill', N'Tacoma', N'WA', N'6-(269)406-7180', 98481)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (89, N'Mary', N'Kelley', N'mkelley2g@wsj.com', N'7968 1st Center', N'Pomona', N'CA', N'2-(141)214-3961', 91797)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (90, N'Benjamin', N'Coleman', N'bcoleman2h@t-online.de', N'12 Thackeray Avenue', N'El Paso', N'TX', N'6-(162)726-3592', 79928)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (91, N'Sean', N'Johnston', N'sjohnston2i@huffingtonpost.com', N'3429 Dorton Trail', N'High Point', N'NC', N'5-(212)829-7647', 27264)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (92, N'Sharon', N'Hamilton', N'shamilton2j@theguardian.com', N'132 3rd Crossing', N'Raleigh', N'NC', N'1-(670)010-4942', 27610)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (93, N'Paula', N'Peterson', N'ppeterson2k@macromedia.com', N'89626 Springview Center', N'Long Beach', N'CA', N'6-(272)005-8923', 90847)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (94, N'William', N'Day', N'wday2l@vistaprint.com', N'16792 Dottie Place', N'Akron', N'OH', N'6-(518)537-0402', 44393)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (95, N'Shawn', N'Nguyen', N'snguyen2m@drupal.org', N'3045 Hudson Lane', N'Wichita Falls', N'TX', N'3-(642)489-9539', 76305)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (96, N'Maria', N'Alexander', N'malexander2n@google.com', N'6 Mosinee Parkway', N'Seattle', N'WA', N'6-(264)303-8893', 98133)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (97, N'Debra', N'Carroll', N'dcarroll2o@wired.com', N'38 Morning Drive', N'Wilmington', N'DE', N'9-(361)256-6009', 19897)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (98, N'Donna', N'Hughes', N'dhughes2p@technorati.com', N'81 School Terrace', N'Amarillo', N'TX', N'5-(784)962-4708', 79176)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (99, N'Pamela', N'Little', N'plittle2q@geocities.jp', N'1966 3rd Trail', N'El Paso', N'TX', N'3-(459)397-4748', 88519)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (100, N'Janice', N'Turner', N'jturner2r@about.me', N'689 Mitchell Plaza', N'El Paso', N'TX', N'8-(365)844-7356', 79945)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (101, N'Scott', N'Gardner', N'sgardner2s@google.co.jp', N'11 Schurz Crossing', N'Springfield', N'IL', N'6-(008)073-1458', 62776)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (102, N'George', N'Richards', N'grichards2t@edublogs.org', N'6504 Hermina Avenue', N'Stockton', N'CA', N'6-(773)776-9412', 95205)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (103, N'Brenda', N'Henry', N'bhenry2u@vinaora.com', N'0 Bay Alley', N'Schaumburg', N'IL', N'8-(468)745-9659', 60193)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (104, N'Joan', N'White', N'jwhite2v@eventbrite.com', N'8069 Rockefeller Lane', N'Washington', N'DC', N'5-(449)012-7511', 20041)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (105, N'Emily', N'Freeman', N'efreeman2w@1und1.de', N'2783 Donald Road', N'Hampton', N'VA', N'8-(892)787-8247', 23668)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (106, N'Larry', N'Baker', N'lbaker2x@google.nl', N'102 Rusk Street', N'Sacramento', N'CA', N'4-(786)908-6807', 95813)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (107, N'Emily', N'Murray', N'emurray2y@cbsnews.com', N'35433 Pearson Avenue', N'Albuquerque', N'NM', N'8-(057)577-0018', 87110)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (108, N'Joseph', N'Jackson', N'jjackson2z@hp.com', N'186 Mendota Lane', N'New Orleans', N'LA', N'0-(840)206-1919', 70187)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (109, N'Norma', N'Reynolds', N'nreynolds30@marketwatch.com', N'19 Jana Junction', N'Springfield', N'IL', N'7-(892)310-7702', 62723)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (110, N'Carl', N'Bennett', N'cbennett31@google.nl', N'7 Moland Crossing', N'Bronx', N'NY', N'3-(951)762-3649', 10469)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (111, N'Jane', N'Riley', N'jriley32@netvibes.com', N'404 Haas Avenue', N'Saint Paul', N'MN', N'7-(018)208-0462', 55127)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (112, N'Bobby', N'Reid', N'breid33@weibo.com', N'609 Loftsgordon Trail', N'Orlando', N'FL', N'5-(635)607-2092', 32813)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (113, N'Ernest', N'Garrett', N'egarrett34@forbes.com', N'2891 Village Green Alley', N'Trenton', N'NJ', N'8-(557)278-1179', 8638)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (114, N'Larry', N'Burke', N'lburke35@posterous.com', N'78912 Pankratz Junction', N'Fresno', N'CA', N'3-(644)378-8083', 93762)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (115, N'Jeremy', N'Griffin', N'jgriffin36@vk.com', N'4222 Lake View Center', N'Whittier', N'CA', N'7-(255)614-3468', 90605)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (116, N'Beverly', N'Pierce', N'bpierce37@hhs.gov', N'235 Claremont Place', N'Gaithersburg', N'MD', N'2-(972)352-7702', 20883)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (117, N'Betty', N'Ellis', N'bellis38@omniture.com', N'2 New Castle Junction', N'Gainesville', N'FL', N'2-(844)962-9286', 32605)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (118, N'Russell', N'Martin', N'rmartin39@is.gd', N'72146 Independence Lane', N'Fort Lauderdale', N'FL', N'7-(940)065-7962', 33355)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (119, N'Sharon', N'Mitchell', N'smitchell3a@cmu.edu', N'328 Comanche Park', N'Memphis', N'TN', N'3-(321)391-2178', 38109)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (120, N'Marie', N'Nelson', N'mnelson3b@taobao.com', N'99643 Packers Lane', N'Springfield', N'IL', N'1-(195)087-5484', 62764)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (121, N'Larry', N'Alexander', N'lalexander3c@sbwire.com', N'45989 Canary Park', N'San Diego', N'CA', N'0-(190)129-7389', 92132)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (122, N'Anthony', N'Hill', N'ahill3d@google.ca', N'76999 Debra Lane', N'Jefferson City', N'MO', N'0-(465)542-6350', 65105)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (123, N'Roger', N'Hudson', N'rhudson3e@un.org', N'02 Southridge Avenue', N'Tucson', N'AZ', N'9-(843)381-3541', 85705)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (124, N'Joan', N'Jackson', N'jjackson3f@gizmodo.com', N'419 Goodland Park', N'Washington', N'DC', N'8-(796)242-3326', 20557)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (125, N'Angela', N'Woods', N'awoods3g@arizona.edu', N'714 Maple Crossing', N'Peoria', N'IL', N'2-(637)971-2831', 61640)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (126, N'Emily', N'Wood', N'ewood3h@opensource.org', N'85422 Lillian Trail', N'Fresno', N'CA', N'1-(354)730-9881', 93704)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (127, N'Charles', N'Turner', N'cturner3i@springer.com', N'84185 Center Point', N'Santa Cruz', N'CA', N'2-(526)065-7529', 95064)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (128, N'Henry', N'Banks', N'hbanks3j@buzzfeed.com', N'1097 Blackbird Place', N'Springfield', N'MA', N'3-(272)188-4781', 1114)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (129, N'Phillip', N'Riley', N'priley3k@hc360.com', N'437 Mallard Plaza', N'Colorado Springs', N'CO', N'5-(282)567-3027', 80995)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (130, N'Harold', N'Wright', N'hwright3l@dailymail.co.uk', N'24475 Gulseth Junction', N'Pittsburgh', N'PA', N'6-(105)720-3638', 15215)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (131, N'Louise', N'Gray', N'lgray3m@virginia.edu', N'2 Sauthoff Point', N'Sacramento', N'CA', N'5-(365)304-7266', 95865)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (132, N'Melissa', N'Franklin', N'mfranklin3n@fda.gov', N'6 Shoshone Junction', N'Charlotte', N'NC', N'5-(463)665-4189', 28263)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (133, N'Rose', N'Stanley', N'rstanley3o@utexas.edu', N'2823 Crest Line Road', N'Louisville', N'KY', N'6-(045)670-4593', 40250)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (134, N'Linda', N'Bowman', N'lbowman3p@ibm.com', N'87 Marquette Park', N'Boise', N'ID', N'2-(368)953-1196', 83732)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (135, N'Karen', N'Walker', N'kwalker3q@icq.com', N'3197 Golf Junction', N'Atlanta', N'GA', N'4-(907)161-7717', 30316)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (136, N'Larry', N'Fernandez', N'lfernandez3r@drupal.org', N'8 New Castle Avenue', N'Hyattsville', N'MD', N'1-(770)871-0616', 20784)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (137, N'Charles', N'Watkins', N'cwatkins3s@merriam-webster.com', N'023 Fremont Avenue', N'Waterbury', N'CT', N'6-(275)519-1522', 6705)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (138, N'Paul', N'Bailey', N'pbailey3t@google.co.jp', N'8885 Maywood Avenue', N'Santa Cruz', N'CA', N'4-(911)909-2871', 95064)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (139, N'Catherine', N'Long', N'clong3u@prweb.com', N'8890 Randy Circle', N'Dallas', N'TX', N'0-(860)607-3248', 75216)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (140, N'Bonnie', N'Mendoza', N'bmendoza3v@netscape.com', N'72 Nova Center', N'Austin', N'TX', N'1-(651)385-7858', 78769)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (141, N'Sharon', N'Gordon', N'sgordon3w@sohu.com', N'76572 Artisan Hill', N'Mobile', N'AL', N'2-(746)370-8406', 36616)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (142, N'Rebecca', N'Hughes', N'rhughes3x@mtv.com', N'9292 Everett Center', N'Bakersfield', N'CA', N'7-(842)116-0502', 93311)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (143, N'Patricia', N'Boyd', N'pboyd3y@rediff.com', N'46419 Debs Crossing', N'Daytona Beach', N'FL', N'4-(419)933-5975', 32123)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (144, N'Bobby', N'Reed', N'breed3z@shutterfly.com', N'95655 Declaration Pass', N'Austin', N'TX', N'9-(734)834-5310', 78715)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (145, N'Matthew', N'Garcia', N'mgarcia40@domainmarket.com', N'6 Bayside Court', N'New York City', N'NY', N'8-(137)904-4769', 10099)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (146, N'Jimmy', N'Palmer', N'jpalmer41@microsoft.com', N'3743 Dorton Lane', N'Fort Myers', N'FL', N'3-(346)029-3406', 33994)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (147, N'Emily', N'Martinez', N'emartinez42@ovh.net', N'0 Longview Way', N'San Jose', N'CA', N'8-(756)335-8894', 95138)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (148, N'Richard', N'Rice', N'rrice43@nps.gov', N'9103 5th Parkway', N'Albany', N'NY', N'2-(665)995-2051', 12227)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (149, N'Dorothy', N'Johnson', N'djohnson44@msu.edu', N'81 Shelley Avenue', N'Seattle', N'WA', N'4-(444)765-7273', 98121)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (150, N'Brandon', N'Ray', N'bray45@google.es', N'2808 Mariners Cove Plaza', N'Aiken', N'SC', N'2-(069)256-9621', 29805)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (151, N'Roy', N'Simpson', N'rsimpson46@so-net.ne.jp', N'2596 Russell Junction', N'Canton', N'OH', N'3-(344)833-1015', 44710)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (152, N'Shawn', N'Howard', N'showard47@kickstarter.com', N'59 Mesta Terrace', N'Minneapolis', N'MN', N'9-(077)251-3964', 55402)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (153, N'Charles', N'Bowman', N'cbowman48@clickbank.net', N'2211 Hollow Ridge Parkway', N'Chicago', N'IL', N'7-(091)463-6111', 60630)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (154, N'Ruth', N'Ray', N'rray49@hud.gov', N'72268 Northport Park', N'Huntington', N'WV', N'0-(436)188-5765', 25709)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (155, N'Roy', N'Foster', N'rfoster4a@bloglovin.com', N'1664 Ridgeview Alley', N'Brockton', N'MA', N'2-(265)360-0684', 2305)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (156, N'Anthony', N'Banks', N'abanks4b@freewebs.com', N'95 Aberg Drive', N'Birmingham', N'AL', N'3-(684)037-4630', 35236)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (157, N'Gregory', N'Gibson', N'ggibson4c@tamu.edu', N'8 Kensington Parkway', N'Pasadena', N'CA', N'6-(184)009-5314', 91125)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (158, N'Earl', N'Williams', N'ewilliams4d@sogou.com', N'3586 Blue Bill Park Alley', N'Dallas', N'TX', N'7-(558)328-2674', 75231)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (159, N'Katherine', N'Watson', N'kwatson4e@diigo.com', N'63 Fieldstone Plaza', N'Seattle', N'WA', N'6-(445)114-4469', 98175)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (160, N'Donna', N'Owens', N'dowens4f@ed.gov', N'911 Grasskamp Street', N'Houston', N'TX', N'2-(862)362-6307', 77075)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (161, N'Johnny', N'Ruiz', N'jruiz4g@hud.gov', N'9 Hoffman Point', N'Las Vegas', N'NV', N'0-(575)916-4001', 89105)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (162, N'Wayne', N'Schmidt', N'wschmidt4h@prlog.org', N'03840 Declaration Circle', N'Waterbury', N'CT', N'0-(489)958-0525', 6705)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (163, N'Jean', N'Gray', N'jgray4i@bluehost.com', N'25790 Stoughton Crossing', N'Washington', N'DC', N'2-(199)115-0185', 20268)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (164, N'Theresa', N'Ramirez', N'tramirez4j@ucoz.com', N'44689 Vidon Crossing', N'Richmond', N'VA', N'8-(233)940-2230', 23228)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (165, N'Andrew', N'Diaz', N'adiaz4k@gravatar.com', N'00380 Lien Court', N'Austin', N'TX', N'6-(155)835-2941', 78754)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (166, N'Jose', N'Barnes', N'jbarnes4l@about.com', N'391 Warbler Trail', N'Minneapolis', N'MN', N'5-(674)685-1642', 55487)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (167, N'Eugene', N'Thompson', N'ethompson4m@bbb.org', N'682 Nova Terrace', N'Chicago', N'IL', N'1-(564)723-6322', 60614)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (168, N'Dennis', N'Ramirez', N'dramirez4n@ihg.com', N'65626 Forest Junction', N'Miami', N'FL', N'6-(500)401-9296', 33180)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (169, N'David', N'Jenkins', N'djenkins4o@people.com.cn', N'17681 Northfield Court', N'Minneapolis', N'MN', N'4-(511)657-6273', 55412)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (170, N'Richard', N'Alexander', N'ralexander4p@ovh.net', N'36 Claremont Park', N'Dallas', N'TX', N'9-(981)660-5663', 75226)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (171, N'Christopher', N'Thomas', N'cthomas4q@disqus.com', N'62539 Warrior Terrace', N'El Paso', N'TX', N'9-(416)327-5517', 79950)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (172, N'Rebecca', N'Gilbert', N'rgilbert4r@virginia.edu', N'9317 Di Loreto Street', N'Detroit', N'MI', N'4-(314)948-0299', 48232)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (173, N'Douglas', N'Martin', N'dmartin4s@amazonaws.com', N'60 Carey Parkway', N'Anderson', N'SC', N'6-(515)358-3220', 29625)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (174, N'Lori', N'Frazier', N'lfrazier4t@yahoo.com', N'99303 Summit Alley', N'Minneapolis', N'MN', N'7-(773)060-2056', 55458)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (175, N'Bobby', N'Boyd', N'bboyd4u@timesonline.co.uk', N'9274 Schurz Way', N'Great Neck', N'NY', N'1-(799)570-7418', 11024)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (176, N'Theresa', N'Pierce', N'tpierce4v@baidu.com', N'7807 Dennis Crossing', N'Columbia', N'SC', N'8-(179)782-9172', 29203)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (177, N'Dennis', N'Fuller', N'dfuller4w@walmart.com', N'328 Coolidge Avenue', N'Oxnard', N'CA', N'6-(441)200-2475', 93034)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (178, N'Andrew', N'Perez', N'aperez4x@ucoz.ru', N'6 Rigney Hill', N'Salt Lake City', N'UT', N'6-(842)504-4348', 84145)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (179, N'Wayne', N'Garza', N'wgarza4y@java.com', N'69829 Fuller Drive', N'Colorado Springs', N'CO', N'5-(494)639-0354', 80930)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (180, N'Anthony', N'Ramos', N'aramos4z@shareasale.com', N'55718 Northwestern Plaza', N'San Antonio', N'TX', N'8-(817)906-1287', 78205)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (181, N'Virginia', N'Jackson', N'vjackson50@google.es', N'9 Loomis Lane', N'Minneapolis', N'MN', N'2-(757)888-3923', 55407)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (182, N'Christina', N'King', N'cking51@lulu.com', N'2094 Stephen Junction', N'Fort Worth', N'TX', N'5-(181)486-7397', 76115)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (183, N'Rose', N'Armstrong', N'rarmstrong52@lulu.com', N'32734 Kim Court', N'Kansas City', N'MO', N'0-(473)783-5197', 64190)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (184, N'Gary', N'King', N'gking53@java.com', N'5 Clyde Gallagher Park', N'Omaha', N'NE', N'8-(306)237-4487', 68179)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (185, N'Anne', N'Payne', N'apayne54@bluehost.com', N'3404 Scoville Road', N'Chesapeake', N'VA', N'9-(361)337-3953', 23324)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (186, N'Sandra', N'Bishop', N'sbishop55@wp.com', N'743 Drewry Road', N'Grand Rapids', N'MI', N'4-(154)517-8990', 49544)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (187, N'Mark', N'Alvarez', N'malvarez56@mit.edu', N'493 Gerald Drive', N'Harrisburg', N'PA', N'5-(947)251-8680', 17121)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (188, N'Jimmy', N'Larson', N'jlarson57@miitbeian.gov.cn', N'248 Bluestem Drive', N'Charlotte', N'NC', N'1-(340)851-2910', 28210)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (189, N'Eric', N'Perez', N'eperez58@squarespace.com', N'4 Sunnyside Circle', N'Dallas', N'TX', N'2-(232)706-5125', 75221)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (190, N'Janice', N'Murray', N'jmurray59@dagondesign.com', N'44 Pierstorff Lane', N'Bradenton', N'FL', N'4-(579)495-7703', 34210)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (191, N'Cynthia', N'Nguyen', N'cnguyen5a@e-recht24.de', N'4283 Center Court', N'Indianapolis', N'IN', N'5-(255)968-9131', 46226)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (192, N'Gerald', N'Henderson', N'ghenderson5b@nih.gov', N'869 Calypso Hill', N'Spokane', N'WA', N'1-(094)505-5124', 99260)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (193, N'Marie', N'Gutierrez', N'mgutierrez5c@stanford.edu', N'9 Utah Street', N'Saint Louis', N'MO', N'5-(272)605-8678', 63158)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (194, N'Alan', N'Lopez', N'alopez5d@jalbum.net', N'117 Center Terrace', N'Seattle', N'WA', N'3-(198)456-9411', 98166)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (195, N'Jason', N'Palmer', N'jpalmer5e@bloomberg.com', N'132 Burning Wood Avenue', N'Zephyrhills', N'FL', N'3-(650)380-2818', 33543)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (196, N'Debra', N'Gordon', N'dgordon5f@dyndns.org', N'48 Utah Trail', N'San Jose', N'CA', N'4-(597)164-4787', 95128)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (197, N'Frances', N'Phillips', N'fphillips5g@simplemachines.org', N'533 Schlimgen Terrace', N'Milwaukee', N'WI', N'0-(859)938-2295', 53215)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (198, N'Walter', N'Duncan', N'wduncan5h@google.com.hk', N'63579 Vera Street', N'Rochester', N'NY', N'2-(995)462-0916', 14624)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (199, N'Kathy', N'Garcia', N'kgarcia5i@paginegialle.it', N'950 Michigan Court', N'Carol Stream', N'IL', N'5-(122)688-3134', 60351)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (200, N'Harry', N'Woods', N'hwoods5j@t-online.de', N'242 Charing Cross Park', N'Buffalo', N'NY', N'3-(181)311-3671', 14233)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (201, N'Gloria', N'Stewart', N'gstewart5k@cbc.ca', N'749 Basil Street', N'South Lake Tahoe', N'CA', N'4-(773)194-7019', 96154)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (202, N'Matthew', N'Hunter', N'mhunter5l@example.com', N'94 Blackbird Hill', N'Lansing', N'MI', N'3-(322)254-3350', 48956)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (203, N'Clarence', N'Lewis', N'clewis5m@craigslist.org', N'4 Grayhawk Street', N'Saginaw', N'MI', N'9-(113)534-6307', 48609)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (204, N'Rose', N'Gonzales', N'rgonzales5n@topsy.com', N'4 Lukken Center', N'Houston', N'TX', N'8-(770)770-9401', 77299)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (205, N'Steve', N'Franklin', N'sfranklin5o@example.com', N'14 Bartillon Terrace', N'Richmond', N'VA', N'1-(842)931-3149', 23272)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (206, N'Timothy', N'Ryan', N'tryan5p@forbes.com', N'44 Pearson Trail', N'Fort Worth', N'TX', N'0-(652)573-5212', 76162)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (207, N'Eric', N'Alvarez', N'ealvarez5q@ifeng.com', N'9200 Sherman Point', N'Boston', N'MA', N'1-(277)020-9694', 2124)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (208, N'Margaret', N'Edwards', N'medwards5r@github.io', N'1135 Emmet Parkway', N'Seattle', N'WA', N'7-(026)138-3073', 98158)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (209, N'Debra', N'Brooks', N'dbrooks5s@apple.com', N'7542 Lawn Hill', N'Chicago', N'IL', N'8-(586)523-8250', 60604)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (210, N'Jean', N'Carter', N'jcarter5t@irs.gov', N'4380 Kingsford Park', N'Greeley', N'CO', N'4-(717)731-1054', 80638)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (211, N'Irene', N'Ramos', N'iramos5u@craigslist.org', N'6577 Monica Pass', N'Memphis', N'TN', N'7-(837)985-0744', 38119)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (212, N'Louise', N'Rodriguez', N'lrodriguez5v@google.fr', N'88328 Amoth Street', N'Raleigh', N'NC', N'7-(300)962-5762', 27621)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (213, N'Roy', N'Perry', N'rperry5w@fastcompany.com', N'58548 Westridge Point', N'Petaluma', N'CA', N'4-(780)623-7552', 94975)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (214, N'Louise', N'Fuller', N'lfuller5x@bandcamp.com', N'9 Katie Junction', N'Austin', N'TX', N'3-(471)642-0536', 78759)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (215, N'Michael', N'Matthews', N'mmatthews5y@washingtonpost.com', N'6710 Old Shore Place', N'San Francisco', N'CA', N'0-(816)715-5680', 94132)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (216, N'Jesse', N'Lane', N'jlane5z@cocolog-nifty.com', N'07 Warbler Plaza', N'Vancouver', N'WA', N'9-(895)747-5320', 98687)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (217, N'Peter', N'Daniels', N'pdaniels60@cisco.com', N'1394 Southridge Center', N'Oxnard', N'CA', N'7-(227)258-2731', 93034)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (218, N'Mark', N'Russell', N'mrussell61@salon.com', N'00297 Bayside Plaza', N'Fresno', N'CA', N'6-(618)691-8173', 93740)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (219, N'Kathryn', N'Lawson', N'klawson62@altervista.org', N'49 Cambridge Circle', N'Baltimore', N'MD', N'9-(050)370-6604', 21239)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (220, N'Katherine', N'Hughes', N'khughes63@auda.org.au', N'838 Boyd Alley', N'Ashburn', N'VA', N'8-(755)918-6823', 22093)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (221, N'Edward', N'Lewis', N'elewis64@ibm.com', N'512 Gale Alley', N'White Plains', N'NY', N'3-(518)591-4495', 10606)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (222, N'Willie', N'Burns', N'wburns65@constantcontact.com', N'41 Morningstar Center', N'Austin', N'TX', N'0-(417)616-5044', 78778)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (223, N'Jennifer', N'Reynolds', N'jreynolds66@nationalgeographic.com', N'667 Spenser Alley', N'Fresno', N'CA', N'8-(161)591-2367', 93709)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (224, N'Thomas', N'Williams', N'twilliams67@samsung.com', N'2864 Green Ridge Trail', N'Jamaica', N'NY', N'3-(210)999-8341', 11470)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (225, N'Carl', N'Rivera', N'crivera68@go.com', N'63 Pepper Wood Lane', N'Houston', N'TX', N'0-(333)463-5376', 77245)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (226, N'Scott', N'Rice', N'srice69@yahoo.com', N'158 Mesta Avenue', N'Cincinnati', N'OH', N'1-(563)220-0056', 45264)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (227, N'Howard', N'Coleman', N'hcoleman6a@chron.com', N'47679 Mayfield Park', N'Los Angeles', N'CA', N'3-(925)655-2996', 90189)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (228, N'Ruth', N'Pierce', N'rpierce6b@sciencedaily.com', N'289 Forest Run Junction', N'Norfolk', N'VA', N'9-(752)928-4572', 23504)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (229, N'Martin', N'Lopez', N'mlopez6c@npr.org', N'45905 Hansons Park', N'Chattanooga', N'TN', N'0-(010)954-8433', 37450)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (230, N'Keith', N'Rivera', N'krivera6d@biblegateway.com', N'28107 Reinke Lane', N'Honolulu', N'HI', N'4-(799)549-8898', 96805)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (231, N'Diane', N'Bryant', N'dbryant6e@vistaprint.com', N'842 5th Terrace', N'Hollywood', N'FL', N'9-(076)431-7781', 33023)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (232, N'Anna', N'Fox', N'afox6f@goo.ne.jp', N'32 Packers Plaza', N'Newton', N'MA', N'6-(411)048-3120', 2458)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (233, N'Jennifer', N'Peters', N'jpeters6g@dot.gov', N'240 Upham Avenue', N'Washington', N'DC', N'2-(161)267-8184', 20226)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (234, N'Mary', N'Murray', N'mmurray6h@icio.us', N'21 Becker Terrace', N'Lakeland', N'FL', N'3-(183)503-8476', 33805)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (235, N'Joe', N'Hall', N'jhall6i@cmu.edu', N'89 Leroy Road', N'Rochester', N'MN', N'4-(012)776-4905', 55905)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (236, N'Ernest', N'Wilson', N'ewilson6j@arstechnica.com', N'835 Holy Cross Terrace', N'Norfolk', N'VA', N'4-(586)632-9971', 23514)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (237, N'Raymond', N'Cruz', N'rcruz6k@networksolutions.com', N'16572 Waxwing Avenue', N'Honolulu', N'HI', N'1-(317)882-3467', 96820)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (238, N'Albert', N'Carroll', N'acarroll6l@furl.net', N'41929 Oakridge Terrace', N'Green Bay', N'WI', N'4-(330)305-5605', 54313)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (239, N'Martha', N'Cole', N'mcole6m@walmart.com', N'73796 Paget Circle', N'Nashville', N'TN', N'0-(751)882-8556', 37220)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (240, N'Theresa', N'Romero', N'tromero6n@zimbio.com', N'37124 Lighthouse Bay Avenue', N'Watertown', N'MA', N'2-(114)954-3161', 2472)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (241, N'Patricia', N'Johnston', N'pjohnston6o@army.mil', N'108 8th Center', N'Pittsburgh', N'PA', N'6-(182)104-4914', 15250)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (242, N'Scott', N'Reed', N'sreed6p@google.fr', N'934 Dayton Way', N'Springfield', N'VA', N'7-(010)494-6662', 22156)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (243, N'Diane', N'Rose', N'drose6q@geocities.com', N'16511 Esker Lane', N'York', N'PA', N'8-(249)730-6971', 17405)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (244, N'Jennifer', N'Nichols', N'jnichols6r@constantcontact.com', N'589 Birchwood Road', N'Alexandria', N'VA', N'8-(365)006-7988', 22301)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (245, N'Lillian', N'Berry', N'lberry6s@51.la', N'577 Schlimgen Pass', N'Punta Gorda', N'FL', N'2-(219)764-9496', 33982)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (246, N'Larry', N'Morris', N'lmorris6t@state.tx.us', N'55 Comanche Drive', N'Hialeah', N'FL', N'2-(270)569-8797', 33018)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (247, N'Keith', N'Owens', N'kowens6u@amazon.co.jp', N'52 Schurz Hill', N'Birmingham', N'AL', N'6-(082)852-7966', 35225)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (248, N'Daniel', N'Hill', N'dhill6v@skype.com', N'63943 Oak Valley Trail', N'Sacramento', N'CA', N'7-(835)186-4568', 94237)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (249, N'Jesse', N'Andrews', N'jandrews6w@xinhuanet.com', N'69679 Everett Crossing', N'London', N'KY', N'7-(356)014-2300', 40745)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (250, N'Rebecca', N'Stanley', N'rstanley6x@weebly.com', N'5 Trailsway Place', N'Fort Myers', N'FL', N'4-(246)126-7870', 33913)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (251, N'Joseph', N'Fisher', N'jfisher6y@deliciousdays.com', N'15 Forest Run Lane', N'Omaha', N'NE', N'1-(336)729-1989', 68105)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (252, N'Sara', N'Stewart', N'sstewart6z@dell.com', N'3 Fordem Center', N'Los Angeles', N'CA', N'3-(420)653-6912', 90040)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (253, N'Fred', N'Harvey', N'fharvey70@omniture.com', N'0392 Goodland Avenue', N'Hialeah', N'FL', N'9-(773)285-4177', 33018)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (254, N'Alice', N'Burke', N'aburke71@hud.gov', N'39 Shasta Drive', N'Chula Vista', N'CA', N'4-(412)007-4123', 91913)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (255, N'Harold', N'Johnson', N'hjohnson72@ucla.edu', N'09891 Miller Park', N'New Orleans', N'LA', N'4-(675)273-7179', 70174)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (256, N'Joseph', N'Burns', N'jburns73@google.it', N'987 Mayfield Parkway', N'Independence', N'MO', N'4-(855)880-7478', 64054)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (257, N'Jacqueline', N'Cunningham', N'jcunningham74@blogger.com', N'76238 Springs Trail', N'Fredericksburg', N'VA', N'8-(875)318-5634', 22405)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (258, N'Timothy', N'Butler', N'tbutler75@microsoft.com', N'42154 Colorado Center', N'Austin', N'TX', N'3-(623)963-6007', 78744)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (259, N'Bruce', N'Franklin', N'bfranklin76@lulu.com', N'05553 Calypso Hill', N'Waterbury', N'CT', N'7-(607)316-8114', 6705)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (260, N'Anne', N'James', N'ajames77@reuters.com', N'4927 Buhler Point', N'Kansas City', N'MO', N'1-(921)314-4775', 64179)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (261, N'Nancy', N'Hart', N'nhart78@auda.org.au', N'63533 Anderson Plaza', N'Oklahoma City', N'OK', N'4-(988)892-2889', 73104)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (262, N'Christine', N'Hart', N'chart79@yahoo.com', N'93 Shopko Avenue', N'Columbus', N'OH', N'9-(389)818-3731', 43220)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (263, N'Brenda', N'Franklin', N'bfranklin7a@ox.ac.uk', N'84 Monica Park', N'Odessa', N'TX', N'2-(468)179-4883', 79769)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (264, N'Judy', N'Cole', N'jcole7b@cnet.com', N'1 Sugar Way', N'Sacramento', N'CA', N'3-(335)606-6327', 95865)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (265, N'Rebecca', N'Howard', N'rhoward7c@whitehouse.gov', N'8473 Grayhawk Crossing', N'Sterling', N'VA', N'1-(844)665-0537', 20167)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (266, N'Theresa', N'Coleman', N'tcoleman7d@github.io', N'97723 Warrior Road', N'Roanoke', N'VA', N'1-(717)170-2640', 24034)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (267, N'Anthony', N'Davis', N'adavis7e@icio.us', N'2271 Hoepker Circle', N'Clearwater', N'FL', N'5-(230)315-2775', 33758)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (268, N'Matthew', N'Murphy', N'mmurphy7f@wisc.edu', N'6 Fallview Crossing', N'Clearwater', N'FL', N'8-(680)475-4789', 34615)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (269, N'Russell', N'Burns', N'rburns7g@ask.com', N'76 Elmside Alley', N'Sacramento', N'CA', N'3-(676)726-1662', 95828)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (270, N'Daniel', N'Spencer', N'dspencer7h@go.com', N'82 Oneill Way', N'Huntington', N'WV', N'3-(615)501-1383', 25716)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (271, N'Susan', N'Tucker', N'stucker7i@ibm.com', N'95095 Hanson Street', N'Merrifield', N'VA', N'3-(606)299-7378', 22119)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (272, N'Johnny', N'Ford', N'jford7j@nsw.gov.au', N'9662 Graedel Terrace', N'Kent', N'WA', N'1-(216)051-2481', 98042)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (273, N'Elizabeth', N'Brown', N'ebrown7k@comsenz.com', N'7261 Bartillon Terrace', N'Sacramento', N'CA', N'9-(528)903-5716', 95865)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (274, N'Joe', N'Smith', N'jsmith7l@booking.com', N'2 New Castle Crossing', N'Springfield', N'MO', N'9-(763)941-3432', 65898)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (275, N'Ernest', N'Day', N'eday7m@123-reg.co.uk', N'1 Doe Crossing Place', N'Houston', N'TX', N'9-(278)668-1562', 77245)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (276, N'Angela', N'Dunn', N'adunn7n@opera.com', N'175 Garrison Terrace', N'Houston', N'TX', N'9-(028)478-3756', 77045)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (277, N'Roger', N'Moreno', N'rmoreno7o@telegraph.co.uk', N'42 Morrow Trail', N'Scottsdale', N'AZ', N'3-(136)035-4386', 85255)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (278, N'Brandon', N'Evans', N'bevans7p@vimeo.com', N'46289 Fieldstone Terrace', N'Orange', N'CA', N'9-(631)761-0193', 92862)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (279, N'Brandon', N'Evans', N'bevans7q@businesswire.com', N'22380 Delaware Park', N'Huntington', N'WV', N'4-(418)755-6775', 25770)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (280, N'Annie', N'Perez', N'aperez7r@mashable.com', N'6088 Leroy Junction', N'Boca Raton', N'FL', N'8-(065)171-3582', 33487)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (281, N'Steven', N'Williams', N'swilliams7s@xrea.com', N'96006 Morning Road', N'Albany', N'NY', N'0-(142)973-6884', 12262)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (282, N'Joshua', N'Warren', N'jwarren7t@spotify.com', N'4 Morningstar Street', N'Minneapolis', N'MN', N'9-(057)136-9902', 55441)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (283, N'Clarence', N'Cruz', N'ccruz7u@xing.com', N'3556 Red Cloud Junction', N'El Paso', N'TX', N'8-(144)711-8146', 79916)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (284, N'Katherine', N'Lynch', N'klynch7v@ask.com', N'00768 Derek Way', N'Denton', N'TX', N'7-(655)050-8321', 76210)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (285, N'Anna', N'Wilson', N'awilson7w@thetimes.co.uk', N'017 Kedzie Street', N'Saint Louis', N'MO', N'4-(458)838-5357', 63116)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (286, N'Shirley', N'Marshall', N'smarshall7x@comcast.net', N'82 Hermina Pass', N'Mesa', N'AZ', N'6-(760)996-1345', 85215)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (287, N'Sean', N'Mccoy', N'smccoy7y@sphinn.com', N'1 Buhler Drive', N'Trenton', N'NJ', N'8-(044)471-6166', 8608)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (288, N'Juan', N'Cunningham', N'jcunningham7z@liveinternet.ru', N'10 Bartelt Drive', N'Fort Lauderdale', N'FL', N'9-(203)603-6911', 33355)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (289, N'Gregory', N'Kelley', N'gkelley80@washington.edu', N'465 Straubel Terrace', N'Hattiesburg', N'MS', N'3-(863)850-4897', 39404)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (290, N'Scott', N'Cruz', N'scruz81@howstuffworks.com', N'73 Oneill Junction', N'Lansing', N'MI', N'9-(264)271-7649', 48956)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (291, N'Anthony', N'Hart', N'ahart82@blogspot.com', N'37 Crest Line Trail', N'Philadelphia', N'PA', N'8-(068)069-7272', 19146)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (292, N'Teresa', N'Bryant', N'tbryant83@dailymail.co.uk', N'3 Orin Terrace', N'Canton', N'OH', N'9-(814)644-3349', 44720)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (293, N'Steven', N'Anderson', N'sanderson84@intel.com', N'7849 Charing Cross Avenue', N'Jersey City', N'NJ', N'1-(159)545-9087', 7310)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (294, N'Donna', N'Elliott', N'delliott85@java.com', N'75 Badeau Point', N'San Antonio', N'TX', N'2-(648)249-3489', 78255)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (295, N'Lisa', N'Peterson', N'lpeterson86@marriott.com', N'2576 Becker Drive', N'Springfield', N'IL', N'4-(471)919-1400', 62764)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (296, N'Kathleen', N'Diaz', N'kdiaz87@flickr.com', N'4 Dovetail Point', N'Louisville', N'KY', N'4-(170)386-7284', 40298)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (297, N'Betty', N'Frazier', N'bfrazier88@networkadvertising.org', N'03726 Corry Parkway', N'Johnstown', N'PA', N'8-(236)178-4447', 15906)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (298, N'Mildred', N'Franklin', N'mfranklin89@foxnews.com', N'8607 Alpine Center', N'Honolulu', N'HI', N'0-(441)341-7396', 96825)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (299, N'Jacqueline', N'Bryant', N'jbryant8a@chronoengine.com', N'43572 Clove Park', N'Lafayette', N'LA', N'5-(120)695-0344', 70593)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (300, N'Brian', N'Reynolds', N'breynolds8b@usda.gov', N'37943 Eagle Crest Crossing', N'Los Angeles', N'CA', N'8-(767)166-0982', 90081)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (301, N'Lori', N'Collins', N'lcollins8c@devhub.com', N'043 Pleasure Lane', N'Denton', N'TX', N'8-(299)365-0409', 76205)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (302, N'Bonnie', N'Sanders', N'bsanders8d@shop-pro.jp', N'60 Almo Crossing', N'Durham', N'NC', N'9-(403)221-7047', 27705)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (303, N'Patricia', N'Howell', N'phowell8e@techcrunch.com', N'17 Knutson Drive', N'Spokane', N'WA', N'9-(254)484-6489', 99220)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (304, N'Ashley', N'Williams', N'awilliams8f@acquirethisname.com', N'3164 Calypso Crossing', N'San Jose', N'CA', N'0-(502)519-5004', 95155)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (305, N'Eric', N'Murray', N'emurray8g@ucoz.ru', N'29099 Shopko Trail', N'San Antonio', N'TX', N'3-(335)255-1012', 78240)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (306, N'Eugene', N'Harper', N'eharper8h@walmart.com', N'51 Harbort Center', N'Pompano Beach', N'FL', N'1-(152)196-2544', 33075)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (307, N'Anna', N'Hunter', N'ahunter8i@psu.edu', N'57 Northfield Plaza', N'Sioux Falls', N'SD', N'0-(043)850-1790', 57105)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (308, N'Earl', N'Davis', N'edavis8j@eventbrite.com', N'8204 Dennis Parkway', N'Anchorage', N'AK', N'8-(430)396-8157', 99599)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (309, N'Albert', N'Mills', N'amills8k@cmu.edu', N'206 Graceland Park', N'San Diego', N'CA', N'3-(338)438-7641', 92110)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (310, N'Emily', N'Hunter', N'ehunter8l@goo.ne.jp', N'6 Lakeland Parkway', N'Las Vegas', N'NV', N'1-(802)928-3724', 89166)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (311, N'Roy', N'Lynch', N'rlynch8m@virginia.edu', N'7330 Rutledge Trail', N'Sioux City', N'IA', N'8-(212)812-5214', 51110)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (312, N'Bruce', N'Moreno', N'bmoreno8n@theguardian.com', N'43359 Alpine Place', N'Cleveland', N'OH', N'9-(405)415-2324', 44105)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (313, N'Jonathan', N'Powell', N'jpowell8o@photobucket.com', N'860 New Castle Way', N'Longview', N'TX', N'9-(292)070-6224', 75605)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (314, N'Dorothy', N'Parker', N'dparker8p@i2i.jp', N'871 Anhalt Street', N'Alexandria', N'VA', N'7-(424)665-9290', 22313)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (315, N'Ronald', N'Bailey', N'rbailey8q@samsung.com', N'4 Main Park', N'Salt Lake City', N'UT', N'8-(458)130-7670', 84140)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (316, N'Aaron', N'Romero', N'aromero8r@nyu.edu', N'0 Beilfuss Crossing', N'Houston', N'TX', N'9-(404)810-2637', 77020)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (317, N'Howard', N'Allen', N'hallen8s@reverbnation.com', N'04 Fairview Drive', N'Colorado Springs', N'CO', N'2-(090)214-5679', 80940)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (318, N'Billy', N'Reyes', N'breyes8t@com.com', N'0651 Ryan Center', N'Bronx', N'NY', N'8-(250)974-7047', 10464)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (319, N'Carl', N'Gardner', N'cgardner8u@live.com', N'9559 Sachtjen Plaza', N'Saint Joseph', N'MO', N'8-(655)261-7051', 64504)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (320, N'Phillip', N'Hamilton', N'phamilton8v@surveymonkey.com', N'01701 Stang Street', N'Bryan', N'TX', N'4-(459)392-8688', 77806)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (321, N'Paul', N'Greene', N'pgreene8w@diigo.com', N'507 2nd Plaza', N'Houston', N'TX', N'6-(796)237-4985', 77060)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (322, N'Ernest', N'Ortiz', N'eortiz8x@storify.com', N'74 Arapahoe Hill', N'Jacksonville', N'FL', N'4-(306)746-4592', 32209)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (323, N'Peter', N'Greene', N'pgreene8y@biglobe.ne.jp', N'00998 Sachtjen Park', N'Sioux City', N'IA', N'8-(076)236-4782', 51110)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (324, N'Debra', N'Lawson', N'dlawson8z@ftc.gov', N'44098 Washington Junction', N'San Antonio', N'TX', N'5-(961)147-8113', 78260)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (325, N'Russell', N'Young', N'ryoung90@umich.edu', N'9622 School Court', N'Madison', N'WI', N'3-(757)898-8136', 53726)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (326, N'Fred', N'Fowler', N'ffowler91@chron.com', N'60482 Union Lane', N'Fort Wayne', N'IN', N'0-(317)452-8867', 46805)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (327, N'Maria', N'Reid', N'mreid92@psu.edu', N'82 Atwood Court', N'Colorado Springs', N'CO', N'8-(863)872-4830', 80995)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (328, N'Shirley', N'Shaw', N'sshaw93@godaddy.com', N'6602 School Avenue', N'Fort Smith', N'AR', N'6-(605)579-6844', 72905)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (329, N'John', N'Foster', N'jfoster94@nih.gov', N'86 Burrows Street', N'Naperville', N'IL', N'8-(631)636-2277', 60567)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (330, N'Sarah', N'George', N'sgeorge95@europa.eu', N'49842 Longview Trail', N'Columbus', N'OH', N'5-(574)122-4967', 43231)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (331, N'Jeffrey', N'Burns', N'jburns96@blogtalkradio.com', N'7697 Main Plaza', N'Grand Forks', N'ND', N'2-(077)365-4350', 58207)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (332, N'Laura', N'Bryant', N'lbryant97@arizona.edu', N'68639 Ridgeview Terrace', N'Worcester', N'MA', N'0-(572)715-3988', 1605)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (333, N'Ruby', N'Allen', N'rallen98@newyorker.com', N'7 Bluejay Parkway', N'Buffalo', N'NY', N'9-(342)221-8806', 14205)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (334, N'Douglas', N'Arnold', N'darnold99@columbia.edu', N'446 Cody Lane', N'Birmingham', N'AL', N'1-(229)307-1134', 35231)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (335, N'Timothy', N'Richardson', N'trichardson9a@friendfeed.com', N'227 International Center', N'Boston', N'MA', N'5-(178)567-3866', 2124)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (336, N'Gregory', N'Fuller', N'gfuller9b@chicagotribune.com', N'8 Di Loreto Drive', N'Phoenix', N'AZ', N'0-(196)733-2107', 85062)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (337, N'Lillian', N'Reed', N'lreed9c@ning.com', N'90 Kropf Street', N'Austin', N'TX', N'6-(641)076-5577', 78778)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (338, N'Christine', N'Freeman', N'cfreeman9d@squidoo.com', N'690 Towne Trail', N'Toledo', N'OH', N'5-(625)811-5552', 43615)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (339, N'Steve', N'Johnson', N'sjohnson9e@youku.com', N'39 Fair Oaks Way', N'Tulsa', N'OK', N'3-(032)038-0566', 74156)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (340, N'Chris', N'Hamilton', N'chamilton9f@webmd.com', N'6 Raven Crossing', N'Atlanta', N'GA', N'0-(771)104-6997', 31165)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (341, N'Judy', N'Richards', N'jrichards9g@wisc.edu', N'766 Anniversary Park', N'Seattle', N'WA', N'6-(212)295-4217', 98109)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (342, N'Jimmy', N'Rogers', N'jrogers9h@pinterest.com', N'2898 Summit Center', N'Des Moines', N'IA', N'4-(040)212-2181', 50320)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (343, N'Stephen', N'Thompson', N'sthompson9i@mapy.cz', N'86 Di Loreto Crossing', N'Springfield', N'IL', N'3-(980)725-7331', 62776)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (344, N'Philip', N'Lane', N'plane9j@businessinsider.com', N'77954 Mitchell Pass', N'Evansville', N'IN', N'3-(943)219-2475', 47747)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (345, N'Craig', N'Carter', N'ccarter9k@google.co.jp', N'83861 Morningstar Plaza', N'Waco', N'TX', N'5-(921)913-9052', 76711)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (346, N'Carol', N'Campbell', N'ccampbell9l@networkadvertising.org', N'619 Kim Lane', N'Washington', N'DC', N'9-(295)189-2715', 20508)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (347, N'Howard', N'Holmes', N'hholmes9m@accuweather.com', N'6584 Nevada Point', N'Wilmington', N'DE', N'3-(937)826-1647', 19805)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (348, N'Tina', N'Torres', N'ttorres9n@sbwire.com', N'86 Crest Line Point', N'Shreveport', N'LA', N'0-(511)716-8407', 71137)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (349, N'Helen', N'Mendoza', N'hmendoza9o@shutterfly.com', N'9056 Charing Cross Alley', N'Erie', N'PA', N'5-(516)152-1366', 16550)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (350, N'Louise', N'Palmer', N'lpalmer9p@psu.edu', N'2 Heffernan Lane', N'Washington', N'DC', N'5-(076)777-2598', 20036)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (351, N'Samuel', N'Parker', N'sparker9q@miitbeian.gov.cn', N'4 Forster Circle', N'Yakima', N'WA', N'9-(520)533-1649', 98907)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (352, N'Raymond', N'Hunt', N'rhunt9r@paginegialle.it', N'567 Buena Vista Alley', N'Los Angeles', N'CA', N'7-(588)110-3794', 90005)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (353, N'Donna', N'Marshall', N'dmarshall9s@usda.gov', N'97 Toban Pass', N'Salt Lake City', N'UT', N'7-(516)056-1611', 84170)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (354, N'Jean', N'Greene', N'jgreene9t@meetup.com', N'676 Milwaukee Park', N'Milwaukee', N'WI', N'4-(651)638-8274', 53215)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (355, N'Paul', N'Collins', N'pcollins9u@godaddy.com', N'037 Pearson Place', N'Arlington', N'TX', N'0-(842)841-9399', 76011)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (356, N'Amy', N'Kim', N'akim9v@facebook.com', N'379 Hoard Plaza', N'Houston', N'TX', N'4-(095)945-3004', 77060)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (357, N'Randy', N'Weaver', N'rweaver9w@dailymotion.com', N'8681 Bunker Hill Court', N'Nashville', N'TN', N'7-(776)020-4855', 37220)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (358, N'Christina', N'Myers', N'cmyers9x@trellian.com', N'2 West Parkway', N'Houston', N'TX', N'9-(133)301-8499', 77060)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (359, N'Joyce', N'Little', N'jlittle9y@sakura.ne.jp', N'85432 Elgar Drive', N'Sacramento', N'CA', N'3-(173)300-5244', 94250)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (360, N'Raymond', N'Rivera', N'rrivera9z@ebay.com', N'28398 Ridge Oak Plaza', N'Seattle', N'WA', N'6-(480)161-3390', 98158)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (361, N'Randy', N'Garza', N'rgarzaa0@marriott.com', N'562 Manley Avenue', N'Akron', N'OH', N'6-(396)010-1011', 44310)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (362, N'Joyce', N'Carr', N'jcarra1@naver.com', N'45 Straubel Point', N'Detroit', N'MI', N'5-(565)690-5980', 48295)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (363, N'Kathryn', N'Vasquez', N'kvasqueza2@phpbb.com', N'587 Ridgeview Circle', N'Honolulu', N'HI', N'9-(940)713-1122', 96820)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (364, N'Kenneth', N'Johnston', N'kjohnstona3@trellian.com', N'4 Moulton Lane', N'Louisville', N'KY', N'3-(827)114-8848', 40256)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (365, N'Jack', N'Foster', N'jfostera4@cafepress.com', N'847 Dorton Hill', N'Annapolis', N'MD', N'2-(844)751-0211', 21405)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (366, N'Sharon', N'Medina', N'smedinaa5@nasa.gov', N'0 Maple Wood Avenue', N'Columbus', N'OH', N'4-(162)563-8591', 43240)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (367, N'Scott', N'Wilson', N'swilsona6@example.com', N'66869 Armistice Hill', N'Greeley', N'CO', N'8-(375)911-1985', 80638)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (368, N'Roger', N'Perry', N'rperrya7@dropbox.com', N'6212 Hoffman Court', N'Daytona Beach', N'FL', N'0-(199)712-1263', 32118)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (369, N'Ryan', N'Foster', N'rfostera8@narod.ru', N'98 Annamark Parkway', N'Des Moines', N'IA', N'2-(959)460-2780', 50310)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (370, N'Susan', N'Griffin', N'sgriffina9@weibo.com', N'0 Marquette Street', N'Sacramento', N'CA', N'6-(680)683-4460', 94230)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (371, N'Carolyn', N'Thompson', N'cthompsonaa@creativecommons.org', N'97 Donald Drive', N'Fort Lauderdale', N'FL', N'1-(451)037-3760', 33305)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (372, N'Walter', N'Williamson', N'wwilliamsonab@wikimedia.org', N'9 Hintze Crossing', N'Temple', N'TX', N'0-(053)088-1511', 76505)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (373, N'Kenneth', N'Hunter', N'khunterac@facebook.com', N'0 Banding Plaza', N'Peoria', N'IL', N'6-(188)028-0981', 61651)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (374, N'Jerry', N'Jacobs', N'jjacobsad@mtv.com', N'839 Center Crossing', N'Oklahoma City', N'OK', N'1-(257)630-4053', 73104)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (375, N'Steven', N'Chavez', N'schavezae@slate.com', N'3907 High Crossing Junction', N'Washington', N'DC', N'3-(691)064-6757', 20041)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (376, N'Walter', N'Moore', N'wmooreaf@noaa.gov', N'80 Westport Drive', N'Scottsdale', N'AZ', N'5-(918)158-4437', 85255)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (377, N'Michelle', N'Marshall', N'mmarshallag@alexa.com', N'102 Iowa Center', N'Winston Salem', N'NC', N'0-(982)994-8963', 27110)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (378, N'Louis', N'Elliott', N'lelliottah@va.gov', N'2206 Luster Place', N'Gainesville', N'FL', N'5-(199)342-7033', 32605)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (379, N'Matthew', N'Dean', N'mdeanai@jimdo.com', N'6586 Lawn Street', N'Houston', N'TX', N'0-(494)544-7495', 77030)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (380, N'Earl', N'Green', N'egreenaj@ihg.com', N'1 Sutherland Terrace', N'Wichita', N'KS', N'0-(760)254-9282', 67210)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (381, N'Paul', N'Hughes', N'phughesak@digg.com', N'2221 Dorton Plaza', N'San Bernardino', N'CA', N'1-(605)926-9534', 92424)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (382, N'John', N'Garcia', N'jgarciaal@bbc.co.uk', N'08541 Declaration Place', N'Santa Monica', N'CA', N'5-(476)068-4662', 90405)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (383, N'Katherine', N'Burns', N'kburnsam@imdb.com', N'63 Monterey Junction', N'Washington', N'DC', N'2-(515)372-9660', 20046)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (384, N'Charles', N'Richardson', N'crichardsonan@privacy.gov.au', N'7 Old Gate Way', N'San Jose', N'CA', N'6-(302)888-5915', 95128)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (385, N'Anne', N'Robinson', N'arobinsonao@huffingtonpost.com', N'1564 Crest Line Court', N'Bowie', N'MD', N'4-(125)804-1739', 20719)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (386, N'Angela', N'Ramirez', N'aramirezap@wix.com', N'50 Scofield Plaza', N'El Paso', N'TX', N'1-(375)622-4886', 88546)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (387, N'Maria', N'Carter', N'mcarteraq@sun.com', N'03323 Dawn Plaza', N'Orange', N'CA', N'4-(810)230-6147', 92668)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (388, N'Christina', N'Wilson', N'cwilsonar@washington.edu', N'20447 Mayer Park', N'Monticello', N'MN', N'1-(237)105-2902', 55590)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (389, N'Deborah', N'Hunt', N'dhuntas@barnesandnoble.com', N'247 Lighthouse Bay Center', N'Los Angeles', N'CA', N'5-(424)766-7927', 90189)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (390, N'Samuel', N'Diaz', N'sdiazat@imageshack.us', N'931 Towne Center', N'Tucson', N'AZ', N'7-(549)383-3278', 85710)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (391, N'Kimberly', N'Phillips', N'kphillipsau@cnet.com', N'1 Claremont Court', N'Garden Grove', N'CA', N'2-(686)979-3775', 92844)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (392, N'Clarence', N'Weaver', N'cweaverav@earthlink.net', N'02699 Iowa Pass', N'Chattanooga', N'TN', N'8-(383)704-0961', 37416)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (393, N'Anthony', N'Bishop', N'abishopaw@japanpost.jp', N'718 Di Loreto Street', N'Springfield', N'IL', N'3-(436)552-6192', 62776)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (394, N'Robin', N'Gomez', N'rgomezax@springer.com', N'19981 Fieldstone Trail', N'Austin', N'TX', N'4-(679)192-4678', 78754)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (395, N'Justin', N'Diaz', N'jdiazay@joomla.org', N'15729 Loomis Road', N'Ridgely', N'MD', N'5-(719)560-8637', 21684)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (396, N'Kathryn', N'Powell', N'kpowellaz@histats.com', N'6204 Rieder Alley', N'Portland', N'ME', N'8-(434)306-7842', 4109)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (397, N'Ann', N'Williamson', N'awilliamsonb0@vinaora.com', N'16 Vera Point', N'Bradenton', N'FL', N'8-(859)719-6134', 34282)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (398, N'Susan', N'Chapman', N'schapmanb1@techcrunch.com', N'83358 Maple Wood Drive', N'Miami', N'FL', N'0-(058)072-6725', 33134)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (399, N'Rachel', N'Ford', N'rfordb2@pbs.org', N'07033 Sherman Drive', N'Farmington', N'MI', N'1-(664)781-7807', 48335)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (400, N'Adam', N'Marshall', N'amarshallb3@ox.ac.uk', N'3526 Fairfield Place', N'San Francisco', N'CA', N'8-(557)193-1586', 94105)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (401, N'Kathleen', N'Hansen', N'khansenb4@privacy.gov.au', N'9356 Miller Place', N'Laredo', N'TX', N'5-(750)676-1624', 78044)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (402, N'Julie', N'Martin', N'jmartinb5@auda.org.au', N'749 Rigney Terrace', N'Stamford', N'CT', N'0-(658)453-9353', 6912)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (403, N'Cheryl', N'Wheeler', N'cwheelerb6@cloudflare.com', N'2 Center Terrace', N'Roanoke', N'VA', N'6-(723)408-9502', 24034)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (404, N'Tina', N'George', N'tgeorgeb7@privacy.gov.au', N'78525 Anhalt Trail', N'Silver Spring', N'MD', N'2-(592)957-3552', 20904)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (405, N'Shirley', N'Hawkins', N'shawkinsb8@sourceforge.net', N'8 Express Terrace', N'Frankfort', N'KY', N'8-(082)756-8296', 40618)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (406, N'Lawrence', N'Stevens', N'lstevensb9@wisc.edu', N'5047 Hollow Ridge Point', N'Bloomington', N'IN', N'2-(573)803-8994', 47405)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (407, N'Katherine', N'Rose', N'kroseba@123-reg.co.uk', N'2 Mariners Cove Junction', N'Tacoma', N'WA', N'7-(367)041-6131', 98481)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (408, N'Kenneth', N'Vasquez', N'kvasquezbb@xinhuanet.com', N'279 Mitchell Road', N'Saint Petersburg', N'FL', N'6-(159)554-5754', 33710)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (409, N'Edward', N'Fisher', N'efisherbc@wikimedia.org', N'9179 Gale Point', N'Houston', N'TX', N'9-(007)338-6114', 77090)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (410, N'Evelyn', N'Hernandez', N'ehernandezbd@so-net.ne.jp', N'07717 Golf Road', N'Rochester', N'NY', N'3-(102)206-7091', 14604)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (411, N'Harry', N'Fernandez', N'hfernandezbe@blogger.com', N'68913 Cody Plaza', N'White Plains', N'NY', N'4-(925)498-2788', 10606)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (412, N'Bonnie', N'Holmes', N'bholmesbf@nih.gov', N'989 Hanson Hill', N'Minneapolis', N'MN', N'3-(044)146-1101', 55417)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (413, N'Michael', N'Gray', N'mgraybg@cargocollective.com', N'70044 Dorton Park', N'Albany', N'NY', N'7-(230)988-6530', 12262)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (414, N'Joyce', N'Cook', N'jcookbh@abc.net.au', N'3 Waubesa Parkway', N'North Las Vegas', N'NV', N'7-(121)219-9330', 89036)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (415, N'Victor', N'Mendoza', N'vmendozabi@histats.com', N'5543 Longview Place', N'Cincinnati', N'OH', N'0-(232)121-4584', 45228)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (416, N'Earl', N'Ward', N'ewardbj@discovery.com', N'05048 Mandrake Junction', N'Salt Lake City', N'UT', N'3-(005)831-4400', 84120)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (417, N'Emily', N'Crawford', N'ecrawfordbk@illinois.edu', N'3895 Crest Line Center', N'Shreveport', N'LA', N'0-(869)523-8031', 71130)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (418, N'Benjamin', N'Ramos', N'bramosbl@cbslocal.com', N'4330 Garrison Park', N'Oakland', N'CA', N'0-(501)213-0813', 94611)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (419, N'Lisa', N'Washington', N'lwashingtonbm@trellian.com', N'8 Shopko Lane', N'Washington', N'DC', N'1-(296)471-4923', 20580)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (420, N'Beverly', N'Green', N'bgreenbn@yale.edu', N'35 Thierer Junction', N'Fresno', N'CA', N'2-(818)073-0239', 93704)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (421, N'Sara', N'Black', N'sblackbo@wikipedia.org', N'78269 Ridgeway Plaza', N'Nashville', N'TN', N'4-(200)021-2449', 37210)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (422, N'Katherine', N'King', N'kkingbp@army.mil', N'1 Mariners Cove Circle', N'Anchorage', N'AK', N'1-(056)793-5316', 99522)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (423, N'Bobby', N'Crawford', N'bcrawfordbq@biglobe.ne.jp', N'9 Burning Wood Road', N'El Paso', N'TX', N'5-(180)531-6030', 79923)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (424, N'Phyllis', N'Gonzales', N'pgonzalesbr@java.com', N'054 Lillian Terrace', N'Vero Beach', N'FL', N'5-(057)144-8064', 32969)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (425, N'Wanda', N'Wilson', N'wwilsonbs@dion.ne.jp', N'667 Rieder Place', N'Bakersfield', N'CA', N'4-(683)610-1348', 93399)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (426, N'Janet', N'Bryant', N'jbryantbt@i2i.jp', N'1837 Cordelia Alley', N'Fort Worth', N'TX', N'7-(091)887-9059', 76192)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (427, N'Judy', N'Griffin', N'jgriffinbu@cocolog-nifty.com', N'09093 Anzinger Crossing', N'Houston', N'TX', N'9-(290)266-1424', 77218)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (428, N'Matthew', N'Evans', N'mevansbv@privacy.gov.au', N'974 Algoma Hill', N'Buffalo', N'NY', N'3-(862)655-5299', 14225)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (429, N'Rose', N'Russell', N'rrussellbw@reuters.com', N'162 Raven Crossing', N'Pittsburgh', N'PA', N'6-(479)992-4732', 15220)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (430, N'Jose', N'Myers', N'jmyersbx@studiopress.com', N'75328 Sutteridge Drive', N'Augusta', N'GA', N'7-(704)017-3044', 30905)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (431, N'Janice', N'Fields', N'jfieldsby@amazon.com', N'5740 Vermont Trail', N'Oklahoma City', N'OK', N'8-(171)305-6095', 73129)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (432, N'Brian', N'Cox', N'bcoxbz@netvibes.com', N'632 Myrtle Point', N'Reno', N'NV', N'0-(606)835-7132', 89595)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (433, N'John', N'Alexander', N'jalexanderc0@dagondesign.com', N'36 Comanche Parkway', N'Washington', N'DC', N'2-(722)520-8482', 20073)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (434, N'Lori', N'Butler', N'lbutlerc1@odnoklassniki.ru', N'53411 Hintze Street', N'New Orleans', N'LA', N'8-(040)675-4601', 70149)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (435, N'Kathleen', N'Myers', N'kmyersc2@a8.net', N'65681 Mariners Cove Road', N'Milwaukee', N'WI', N'2-(140)209-1281', 53210)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (436, N'Beverly', N'Fisher', N'bfisherc3@usda.gov', N'23413 Corry Street', N'Wilmington', N'DE', N'7-(090)603-0478', 19810)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (437, N'Irene', N'Olson', N'iolsonc4@usnews.com', N'3 Waxwing Crossing', N'Sacramento', N'CA', N'0-(657)055-7426', 95865)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (438, N'Jeffrey', N'Hunt', N'jhuntc5@mtv.com', N'76 Darwin Center', N'Fairbanks', N'AK', N'2-(096)256-7845', 99709)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (439, N'Paula', N'Fowler', N'pfowlerc6@linkedin.com', N'378 Monterey Plaza', N'Abilene', N'TX', N'3-(588)853-6446', 79605)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (440, N'Ryan', N'Garza', N'rgarzac7@google.nl', N'09 Browning Point', N'Kansas City', N'MO', N'1-(095)822-3876', 64149)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (441, N'William', N'Ferguson', N'wfergusonc8@soup.io', N'1 Debs Parkway', N'Tulsa', N'OK', N'1-(936)251-1448', 74156)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (442, N'Judith', N'Richardson', N'jrichardsonc9@theatlantic.com', N'17 Heffernan Parkway', N'Des Moines', N'IA', N'9-(890)202-8011', 50369)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (443, N'Ashley', N'Gray', N'agrayca@friendfeed.com', N'904 Eagan Terrace', N'Philadelphia', N'PA', N'5-(234)079-9118', 19141)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (444, N'Kevin', N'Morrison', N'kmorrisoncb@cloudflare.com', N'9876 Lien Hill', N'Bakersfield', N'CA', N'3-(219)636-3538', 93311)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (445, N'Shirley', N'Ortiz', N'sortizcc@technorati.com', N'6553 Nevada Street', N'Charlotte', N'NC', N'8-(159)500-9437', 28242)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (446, N'Gregory', N'Parker', N'gparkercd@ameblo.jp', N'5 Lotheville Way', N'Austin', N'TX', N'3-(287)236-1407', 78783)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (447, N'Brandon', N'Sanders', N'bsandersce@fema.gov', N'88 Northview Road', N'Bryan', N'TX', N'7-(172)555-2999', 77806)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (448, N'Phyllis', N'Simmons', N'psimmonscf@nba.com', N'98512 Arizona Point', N'Honolulu', N'HI', N'2-(574)345-7467', 96850)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (449, N'Sean', N'Cole', N'scolecg@diigo.com', N'4071 Maple Parkway', N'New York City', N'NY', N'7-(260)369-7179', 10280)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (450, N'Fred', N'Moreno', N'fmorenoch@yahoo.com', N'811 Golden Leaf Point', N'Huntington Beach', N'CA', N'6-(810)269-3279', 92648)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (451, N'Dorothy', N'Duncan', N'dduncanci@cdc.gov', N'0698 Shopko Parkway', N'Santa Fe', N'NM', N'4-(393)317-7356', 87505)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (452, N'Patricia', N'Washington', N'pwashingtoncj@geocities.jp', N'7977 Moland Pass', N'Fort Wayne', N'IN', N'3-(651)100-5185', 46825)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (453, N'John', N'Robertson', N'jrobertsonck@examiner.com', N'4772 Nancy Park', N'Augusta', N'GA', N'4-(204)843-1395', 30905)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (454, N'Anna', N'Lawson', N'alawsoncl@patch.com', N'13824 Gerald Center', N'Indianapolis', N'IN', N'7-(213)711-2455', 46266)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (455, N'Randy', N'Myers', N'rmyerscm@hc360.com', N'89 Towne Street', N'Dayton', N'OH', N'4-(916)080-6775', 45426)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (456, N'Carlos', N'Fox', N'cfoxcn@wufoo.com', N'9 Trailsway Street', N'Washington', N'DC', N'2-(166)365-6401', 20575)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (457, N'Elizabeth', N'Martinez', N'emartinezco@blogger.com', N'64 Jackson Parkway', N'San Francisco', N'CA', N'2-(476)169-3091', 94132)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (458, N'Catherine', N'Richards', N'crichardscp@delicious.com', N'77 Jay Way', N'Clearwater', N'FL', N'2-(891)958-3628', 34615)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (459, N'Helen', N'Hawkins', N'hhawkinscq@ucla.edu', N'43 Ridge Oak Point', N'Jacksonville', N'FL', N'6-(067)058-5790', 32204)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (460, N'Daniel', N'Lopez', N'dlopezcr@amazon.com', N'440 Independence Way', N'Raleigh', N'NC', N'9-(276)778-0930', 27690)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (461, N'Marie', N'Harvey', N'mharveycs@wisc.edu', N'8715 Grayhawk Drive', N'Scottsdale', N'AZ', N'5-(678)740-9884', 85260)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (462, N'Carlos', N'Jordan', N'cjordanct@blog.com', N'7085 Fordem Point', N'Columbus', N'OH', N'2-(483)305-8567', 43210)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (463, N'Rose', N'Harrison', N'rharrisoncu@nasa.gov', N'571 Anhalt Junction', N'Oklahoma City', N'OK', N'7-(939)762-6309', 73167)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (464, N'Debra', N'Mendoza', N'dmendozacv@baidu.com', N'87 Straubel Crossing', N'Houston', N'TX', N'4-(503)047-2543', 77281)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (465, N'Melissa', N'Mendoza', N'mmendozacw@tiny.cc', N'8673 Cambridge Junction', N'Miami', N'FL', N'6-(008)609-6098', 33190)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (466, N'Donald', N'Crawford', N'dcrawfordcx@mlb.com', N'746 Bluestem Trail', N'Worcester', N'MA', N'6-(278)886-4939', 1610)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (467, N'Brian', N'Sanders', N'bsanderscy@tripod.com', N'7475 Mcguire Trail', N'Hampton', N'VA', N'0-(239)322-6488', 23668)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (468, N'Nicole', N'Butler', N'nbutlercz@who.int', N'983 Waxwing Drive', N'Orlando', N'FL', N'8-(868)439-1240', 32830)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (469, N'Louis', N'Bishop', N'lbishopd0@wisc.edu', N'723 Killdeer Terrace', N'Houston', N'TX', N'1-(082)964-2548', 77020)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (470, N'Louis', N'Black', N'lblackd1@biblegateway.com', N'970 Claremont Parkway', N'Salt Lake City', N'UT', N'5-(580)142-7186', 84105)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (471, N'Earl', N'Ford', N'efordd2@cnbc.com', N'9 Arizona Trail', N'Lawrenceville', N'GA', N'3-(061)949-0903', 30245)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (472, N'Doris', N'Tucker', N'dtuckerd3@whitehouse.gov', N'14 Fremont Road', N'Boston', N'MA', N'1-(850)552-1201', 2298)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (473, N'Rose', N'Sanders', N'rsandersd4@hc360.com', N'4 Lake View Alley', N'Washington', N'DC', N'2-(511)666-2299', 20205)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (474, N'Patricia', N'Jenkins', N'pjenkinsd5@redcross.org', N'20576 New Castle Plaza', N'San Jose', N'CA', N'3-(255)032-5612', 95173)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (475, N'Ruth', N'Nelson', N'rnelsond6@opera.com', N'8571 Fremont Drive', N'Concord', N'CA', N'8-(026)580-5161', 94522)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (476, N'Rose', N'Rogers', N'rrogersd7@arizona.edu', N'38 Goodland Circle', N'Houston', N'TX', N'5-(814)886-4022', 77201)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (477, N'Earl', N'Arnold', N'earnoldd8@dyndns.org', N'705 Blaine Way', N'Kansas City', N'MO', N'8-(962)099-8802', 64101)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (478, N'Debra', N'Castillo', N'dcastillod9@nature.com', N'40160 Waxwing Hill', N'El Paso', N'TX', N'1-(675)420-8164', 79955)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (479, N'Richard', N'Howell', N'rhowellda@foxnews.com', N'0 Lake View Park', N'Chicago', N'IL', N'5-(615)594-9579', 60630)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (480, N'Melissa', N'Davis', N'mdavisdb@cdbaby.com', N'69386 Barby Park', N'Richmond', N'VA', N'9-(729)334-4768', 23285)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (481, N'Marie', N'Diaz', N'mdiazdc@google.cn', N'58 Stephen Drive', N'Los Angeles', N'CA', N'4-(937)035-8107', 90094)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (482, N'Brandon', N'Brooks', N'bbrooksdd@usatoday.com', N'2 Golf Course Street', N'Washington', N'DC', N'1-(866)216-5681', 20442)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (483, N'Beverly', N'Edwards', N'bedwardsde@merriam-webster.com', N'4168 Holy Cross Parkway', N'Winston Salem', N'NC', N'4-(684)650-6236', 27110)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (484, N'Kathy', N'Perkins', N'kperkinsdf@tamu.edu', N'5 Melvin Crossing', N'Waltham', N'MA', N'7-(344)521-7091', 2453)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (485, N'Bruce', N'Ramos', N'bramosdg@gov.uk', N'70042 Lillian Junction', N'Worcester', N'MA', N'8-(479)635-7488', 1605)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (486, N'Ernest', N'Porter', N'eporterdh@a8.net', N'952 Nancy Park', N'Cincinnati', N'OH', N'5-(743)495-1164', 45999)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (487, N'Deborah', N'Harris', N'dharrisdi@house.gov', N'993 Eastlawn Alley', N'New York City', N'NY', N'4-(314)662-5311', 10014)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (488, N'Chris', N'Burton', N'cburtondj@g.co', N'02965 Bunker Hill Alley', N'Sacramento', N'CA', N'5-(484)393-5174', 94291)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (489, N'Brenda', N'Welch', N'bwelchdk@vinaora.com', N'8 Lunder Place', N'Fort Myers', N'FL', N'8-(050)833-8675', 33913)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (490, N'Mary', N'Wallace', N'mwallacedl@wikipedia.org', N'2481 Swallow Avenue', N'Tucson', N'AZ', N'1-(844)844-0125', 85748)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (491, N'Juan', N'Washington', N'jwashingtondm@behance.net', N'49 Crescent Oaks Parkway', N'Phoenix', N'AZ', N'2-(554)429-0572', 85083)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (492, N'Pamela', N'Wilson', N'pwilsondn@biblegateway.com', N'0243 Merchant Trail', N'Atlanta', N'GA', N'2-(423)075-5236', 31165)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (493, N'Beverly', N'Cole', N'bcoledo@youtube.com', N'2380 Farragut Park', N'Anchorage', N'AK', N'6-(226)435-0670', 99517)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (494, N'Jessica', N'Carter', N'jcarterdp@sfgate.com', N'8 Hermina Center', N'Las Vegas', N'NV', N'2-(224)548-6704', 89166)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (495, N'Kathy', N'Taylor', N'ktaylordq@fema.gov', N'326 Alpine Center', N'San Francisco', N'CA', N'4-(804)705-4943', 94159)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (496, N'Edward', N'Fernandez', N'efernandezdr@ucla.edu', N'98 Ilene Parkway', N'Sioux Falls', N'SD', N'5-(108)503-3522', 57105)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (497, N'Henry', N'Robinson', N'hrobinsonds@seattletimes.com', N'3 Colorado Way', N'Birmingham', N'AL', N'4-(494)816-9594', 35244)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (498, N'Joseph', N'Freeman', N'jfreemandt@intel.com', N'19 Kings Pass', N'Miami', N'FL', N'3-(331)084-7476', 33233)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (499, N'Nicholas', N'Mason', N'nmasondu@hexun.com', N'9 Ohio Hill', N'Pocatello', N'ID', N'5-(962)956-5559', 83206)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (500, N'Eric', N'Foster', N'efosterdv@businesswire.com', N'275 Memorial Terrace', N'Denver', N'CO', N'4-(211)689-0804', 80249)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (501, N'Samuel', N'Simpson', N'ssimpsondw@cloudflare.com', N'97 Kinsman Drive', N'El Paso', N'TX', N'9-(523)508-5398', 88569)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (502, N'Joseph', N'Watson', N'jwatsondx@nyu.edu', N'0 Dixon Crossing', N'San Jose', N'CA', N'6-(160)869-8604', 95118)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (503, N'Billy', N'King', N'bkingdy@cmu.edu', N'3 Shasta Lane', N'San Antonio', N'TX', N'3-(934)349-0683', 78225)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (504, N'Steven', N'Jenkins', N'sjenkinsdz@weebly.com', N'3 Marcy Alley', N'Saint Petersburg', N'FL', N'0-(581)500-9275', 33737)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (505, N'Emily', N'Kelley', N'ekelleye0@buzzfeed.com', N'67665 Reindahl Point', N'Washington', N'DC', N'8-(497)987-1120', 20205)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (506, N'Raymond', N'Green', N'rgreene1@nationalgeographic.com', N'568 Messerschmidt Street', N'Los Angeles', N'CA', N'2-(761)812-2833', 90005)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (507, N'Janice', N'Dean', N'jdeane2@netscape.com', N'57 Coolidge Center', N'Tucson', N'AZ', N'8-(091)244-6667', 85720)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (508, N'Harry', N'Rose', N'hrosee3@nsw.gov.au', N'97228 Havey Street', N'Santa Rosa', N'CA', N'2-(244)856-6413', 95405)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (509, N'Charles', N'Butler', N'cbutlere4@hp.com', N'3 Springview Road', N'Port Charlotte', N'FL', N'7-(811)952-7059', 33954)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (510, N'Emily', N'Alexander', N'ealexandere5@github.com', N'095 Veith Drive', N'Louisville', N'KY', N'7-(327)620-6373', 40220)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (511, N'Kathryn', N'Murphy', N'kmurphye6@springer.com', N'1 Knutson Crossing', N'Saint Louis', N'MO', N'1-(333)216-6528', 63196)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (512, N'Sara', N'Wilson', N'swilsone7@statcounter.com', N'52 John Wall Center', N'Appleton', N'WI', N'8-(226)660-3758', 54915)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (513, N'Andrew', N'Fowler', N'afowlere8@bloglines.com', N'09 Prentice Place', N'Austin', N'TX', N'6-(366)077-6217', 78789)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (514, N'Richard', N'Stewart', N'rstewarte9@umich.edu', N'454 Merry Junction', N'Las Vegas', N'NV', N'3-(735)292-1279', 89130)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (515, N'Pamela', N'Watson', N'pwatsonea@eepurl.com', N'23333 Clarendon Avenue', N'Lakeland', N'FL', N'0-(643)448-2310', 33805)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (516, N'Nancy', N'Mendoza', N'nmendozaeb@surveymonkey.com', N'84412 Knutson Street', N'Milwaukee', N'WI', N'1-(738)544-0523', 53234)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (517, N'Sean', N'Burke', N'sburkeec@who.int', N'8469 Service Crossing', N'Baltimore', N'MD', N'0-(574)886-9985', 21265)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (518, N'Helen', N'Armstrong', N'harmstronged@nps.gov', N'6 Independence Plaza', N'Houston', N'TX', N'4-(048)380-5641', 77020)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (519, N'Scott', N'Young', N'syoungee@engadget.com', N'02 Blackbird Junction', N'Houston', N'TX', N'2-(543)639-8218', 77045)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (520, N'Amy', N'Evans', N'aevansef@webeden.co.uk', N'052 Mandrake Road', N'San Francisco', N'CA', N'5-(485)790-5261', 94121)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (521, N'Jane', N'Dunn', N'jdunneg@soundcloud.com', N'73 Erie Park', N'Saint Cloud', N'MN', N'6-(306)518-9591', 56398)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (522, N'Patrick', N'Schmidt', N'pschmidteh@slideshare.net', N'77663 Westerfield Plaza', N'Atlanta', N'GA', N'2-(649)156-6976', 31190)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (523, N'Todd', N'Rogers', N'trogersei@columbia.edu', N'4260 Thierer Circle', N'Wilmington', N'NC', N'3-(241)286-8881', 28405)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (524, N'Sarah', N'Willis', N'swillisej@nbcnews.com', N'77426 Waubesa Center', N'Macon', N'GA', N'5-(853)352-6877', 31217)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (525, N'Steve', N'Patterson', N'spattersonek@yahoo.co.jp', N'81311 Annamark Junction', N'Portsmouth', N'NH', N'1-(316)152-6641', 214)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (526, N'Laura', N'Jones', N'ljonesel@google.pl', N'78 Everett Crossing', N'Richmond', N'VA', N'4-(081)282-4062', 23242)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (527, N'Mary', N'Hamilton', N'mhamiltonem@ycombinator.com', N'83245 Katie Place', N'Oklahoma City', N'OK', N'2-(949)726-9070', 73114)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (528, N'Brian', N'Hernandez', N'bhernandezen@51.la', N'65065 Del Sol Parkway', N'Jamaica', N'NY', N'9-(628)456-3472', 11407)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (529, N'Mark', N'Lewis', N'mlewiseo@devhub.com', N'3918 Burrows Court', N'Tucson', N'AZ', N'0-(556)891-5677', 85743)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (530, N'Margaret', N'Miller', N'mmillerep@wunderground.com', N'40322 Twin Pines Drive', N'Tucson', N'AZ', N'0-(217)938-8646', 85715)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (531, N'Wayne', N'Cook', N'wcookeq@bloglovin.com', N'088 Larry Plaza', N'South Bend', N'IN', N'0-(394)561-1375', 46614)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (532, N'Thomas', N'Mccoy', N'tmccoyer@cyberchimps.com', N'10813 Crescent Oaks Trail', N'Colorado Springs', N'CO', N'6-(685)119-7676', 80925)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (533, N'Alan', N'Lee', N'aleees@businessweek.com', N'35 Ramsey Drive', N'Port Saint Lucie', N'FL', N'4-(602)970-6051', 34985)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (534, N'Jean', N'Richards', N'jrichardset@cafepress.com', N'03 Stephen Crossing', N'Lexington', N'KY', N'9-(036)716-3725', 40505)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (535, N'Jonathan', N'Collins', N'jcollinseu@constantcontact.com', N'0154 Vermont Alley', N'Anchorage', N'AK', N'9-(487)797-0626', 99599)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (536, N'Maria', N'Wheeler', N'mwheelerev@toplist.cz', N'6 Florence Park', N'Mesa', N'AZ', N'1-(185)100-6270', 85210)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (537, N'Kelly', N'Woods', N'kwoodsew@yellowpages.com', N'74201 3rd Court', N'Mobile', N'AL', N'9-(902)368-1116', 36670)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (538, N'Matthew', N'Thomas', N'mthomasex@google.ca', N'59873 Brentwood Junction', N'Pueblo', N'CO', N'2-(410)164-5920', 81010)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (539, N'Jane', N'Gomez', N'jgomezey@dyndns.org', N'4 Oakridge Crossing', N'Brooklyn', N'NY', N'4-(795)001-3529', 11236)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (540, N'Carol', N'White', N'cwhiteez@netvibes.com', N'0 Katie Lane', N'Aurora', N'CO', N'6-(797)543-3978', 80015)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (541, N'Gerald', N'Torres', N'gtorresf0@ucoz.com', N'0 Dryden Parkway', N'Washington', N'DC', N'6-(411)755-7460', 20226)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (542, N'Eric', N'Roberts', N'erobertsf1@timesonline.co.uk', N'3 Cherokee Alley', N'Houston', N'TX', N'7-(768)853-1016', 77010)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (543, N'James', N'Wheeler', N'jwheelerf2@squidoo.com', N'60350 Barby Circle', N'Ocala', N'FL', N'3-(671)227-7340', 34474)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (544, N'Dennis', N'Lawson', N'dlawsonf3@lulu.com', N'30142 Hagan Circle', N'White Plains', N'NY', N'7-(674)225-0656', 10633)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (545, N'Julia', N'Reynolds', N'jreynoldsf4@csmonitor.com', N'13 Hoard Trail', N'Baton Rouge', N'LA', N'1-(346)192-9188', 70894)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (546, N'Joshua', N'Henry', N'jhenryf5@va.gov', N'5 Vermont Lane', N'Pueblo', N'CO', N'1-(311)169-5723', 81005)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (547, N'Carlos', N'Perkins', N'cperkinsf6@umich.edu', N'95 Arrowood Terrace', N'Pittsburgh', N'PA', N'0-(171)756-1574', 15205)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (548, N'Todd', N'Peterson', N'tpetersonf7@yellowbook.com', N'9625 Village Green Street', N'Stockton', N'CA', N'2-(472)449-3571', 95210)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (549, N'Ruby', N'Henderson', N'rhendersonf8@examiner.com', N'6 Stone Corner Trail', N'Daytona Beach', N'FL', N'9-(442)873-1120', 32128)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (550, N'Robert', N'Henderson', N'rhendersonf9@tripadvisor.com', N'3021 Melrose Crossing', N'Miami', N'FL', N'3-(258)932-5427', 33261)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (551, N'Lisa', N'Knight', N'lknightfa@google.ru', N'25430 East Street', N'New York City', N'NY', N'1-(223)931-2862', 10029)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (552, N'Betty', N'Tucker', N'btuckerfb@home.pl', N'9 Schmedeman Center', N'Jacksonville', N'FL', N'5-(893)279-2852', 32215)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (553, N'Lori', N'Harris', N'lharrisfc@wikia.com', N'3 Claremont Street', N'Toledo', N'OH', N'3-(713)786-7926', 43699)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (554, N'Kevin', N'Coleman', N'kcolemanfd@noaa.gov', N'85 Barnett Parkway', N'Dayton', N'OH', N'7-(848)795-1405', 45490)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (555, N'Richard', N'Hill', N'rhillfe@hao123.com', N'70629 Ridgeview Point', N'Suffolk', N'VA', N'9-(219)997-9325', 23436)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (556, N'Clarence', N'Cunningham', N'ccunninghamff@ucoz.ru', N'9 Ronald Regan Court', N'Salt Lake City', N'UT', N'9-(302)179-6122', 84105)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (557, N'Rachel', N'Willis', N'rwillisfg@sphinn.com', N'7853 Quincy Junction', N'North Port', N'FL', N'4-(436)318-8618', 34290)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (558, N'Judy', N'Gilbert', N'jgilbertfh@prweb.com', N'257 Pleasure Avenue', N'Amarillo', N'TX', N'7-(699)579-8092', 79118)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (559, N'Kimberly', N'Hughes', N'khughesfi@newsvine.com', N'4 Homewood Court', N'Fort Wayne', N'IN', N'1-(783)412-1548', 46867)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (560, N'Sandra', N'Lopez', N'slopezfj@berkeley.edu', N'10886 Fieldstone Court', N'Spokane', N'WA', N'2-(654)379-5154', 99210)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (561, N'Frances', N'Nichols', N'fnicholsfk@usda.gov', N'8 Morrow Parkway', N'Baltimore', N'MD', N'1-(516)903-2951', 21203)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (562, N'Robin', N'Crawford', N'rcrawfordfl@stumbleupon.com', N'2463 Summer Ridge Alley', N'Charlotte', N'NC', N'3-(569)707-1768', 28210)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (563, N'Julie', N'Snyder', N'jsnyderfm@canalblog.com', N'84 Chinook Trail', N'Austin', N'TX', N'4-(060)086-4331', 78732)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (564, N'Gloria', N'Peterson', N'gpetersonfn@unesco.org', N'3 Magdeline Drive', N'Winston Salem', N'NC', N'8-(497)745-4789', 27157)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (565, N'Irene', N'Gomez', N'igomezfo@pinterest.com', N'562 East Hill', N'Bradenton', N'FL', N'1-(896)405-2586', 34282)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (566, N'Jose', N'Nelson', N'jnelsonfp@state.tx.us', N'3 Waxwing Center', N'Santa Fe', N'NM', N'7-(938)377-0590', 87592)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (567, N'Kathy', N'Lane', N'klanefq@yelp.com', N'727 Glendale Trail', N'Fullerton', N'CA', N'5-(673)490-2958', 92835)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (568, N'Wayne', N'Young', N'wyoungfr@over-blog.com', N'00 Lotheville Alley', N'Raleigh', N'NC', N'0-(086)314-2327', 27621)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (569, N'Marilyn', N'James', N'mjamesfs@epa.gov', N'80030 Mcbride Junction', N'Cleveland', N'OH', N'8-(920)330-1982', 44185)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (570, N'Bonnie', N'Montgomery', N'bmontgomeryft@hp.com', N'51 Kensington Point', N'Wilmington', N'DE', N'8-(346)050-6828', 19892)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (571, N'Norma', N'Carr', N'ncarrfu@salon.com', N'24888 Del Sol Hill', N'San Antonio', N'TX', N'2-(712)669-0474', 78296)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (572, N'Diane', N'Taylor', N'dtaylorfv@google.de', N'82 Golf View Center', N'Pasadena', N'CA', N'3-(687)788-6818', 91186)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (573, N'Linda', N'Campbell', N'lcampbellfw@google.de', N'0 Spenser Crossing', N'Sacramento', N'CA', N'4-(926)112-7998', 94273)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (574, N'Jesse', N'Owens', N'jowensfx@unesco.org', N'5578 Boyd Trail', N'Lakewood', N'WA', N'7-(987)442-1226', 98498)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (575, N'Christine', N'Morgan', N'cmorganfy@istockphoto.com', N'93657 Dunning Crossing', N'Tulsa', N'OK', N'2-(923)233-3927', 74116)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (576, N'Mildred', N'Burke', N'mburkefz@ycombinator.com', N'762 Washington Pass', N'Montgomery', N'AL', N'6-(549)451-3033', 36114)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (577, N'Shirley', N'Henderson', N'shendersong0@oracle.com', N'6 Charing Cross Parkway', N'Houston', N'TX', N'5-(849)473-1112', 77010)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (578, N'Donald', N'Garcia', N'dgarciag1@va.gov', N'9048 Spaight Trail', N'Las Vegas', N'NV', N'0-(447)515-2149', 89120)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (579, N'Donald', N'Cook', N'dcookg2@usgs.gov', N'74 Comanche Pass', N'Sarasota', N'FL', N'8-(858)629-3886', 34238)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (580, N'Kathleen', N'Hayes', N'khayesg3@cargocollective.com', N'564 Blue Bill Park Hill', N'Helena', N'MT', N'2-(090)550-5963', 59623)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (581, N'Steve', N'Dunn', N'sdunng4@fc2.com', N'1919 Prairieview Lane', N'Bismarck', N'ND', N'7-(080)305-2745', 58505)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (582, N'Jose', N'Franklin', N'jfrankling5@bloglines.com', N'81732 Pankratz Center', N'Lafayette', N'LA', N'6-(220)624-9028', 70505)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (583, N'Diane', N'Matthews', N'dmatthewsg6@com.com', N'2315 Holmberg Hill', N'Tallahassee', N'FL', N'7-(351)330-6283', 32304)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (584, N'Virginia', N'Bradley', N'vbradleyg7@salon.com', N'3 Corscot Center', N'San Diego', N'CA', N'3-(694)403-5962', 92196)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (585, N'David', N'Collins', N'dcollinsg8@ftc.gov', N'48 Helena Crossing', N'Migrate', N'KY', N'8-(915)215-4264', 41905)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (586, N'Barbara', N'Wood', N'bwoodg9@exblog.jp', N'0 Erie Parkway', N'Sacramento', N'CA', N'5-(830)061-2879', 95828)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (587, N'Jack', N'Rivera', N'jriveraga@sohu.com', N'606 Jenna Street', N'Las Vegas', N'NV', N'7-(353)552-2106', 89178)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (588, N'Gloria', N'Fuller', N'gfullergb@sitemeter.com', N'6173 Drewry Crossing', N'Spokane', N'WA', N'6-(382)436-4597', 99205)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (589, N'Jean', N'Freeman', N'jfreemangc@xinhuanet.com', N'4 Kipling Crossing', N'New York City', N'NY', N'3-(847)097-2063', 10131)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (590, N'Ronald', N'Chapman', N'rchapmangd@altervista.org', N'446 Ohio Avenue', N'Muskegon', N'MI', N'5-(119)507-9463', 49444)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (591, N'John', N'Day', N'jdayge@phpbb.com', N'98151 Di Loreto Crossing', N'Minneapolis', N'MN', N'6-(231)459-9525', 55470)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (592, N'Julie', N'Garrett', N'jgarrettgf@boston.com', N'3 Donald Road', N'Chattanooga', N'TN', N'7-(175)149-9749', 37410)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (593, N'Sean', N'Howard', N'showardgg@ycombinator.com', N'845 Sunbrook Circle', N'Kansas City', N'MO', N'8-(895)122-5475', 64190)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (594, N'Cheryl', N'Simpson', N'csimpsongh@dell.com', N'25583 Westport Way', N'Aurora', N'CO', N'5-(094)878-4448', 80044)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (595, N'Michael', N'Simmons', N'msimmonsgi@aol.com', N'985 Coleman Hill', N'Oakland', N'CA', N'9-(832)758-8156', 94627)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (596, N'Peter', N'Payne', N'ppaynegj@harvard.edu', N'93 Chive Trail', N'Houston', N'TX', N'1-(976)555-0943', 77055)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (597, N'James', N'Flores', N'jfloresgk@mtv.com', N'71223 Cordelia Drive', N'Evansville', N'IN', N'0-(939)116-8132', 47725)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (598, N'Sara', N'Fisher', N'sfishergl@biglobe.ne.jp', N'71495 Dexter Crossing', N'Chico', N'CA', N'4-(955)566-7157', 95973)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (599, N'Jessica', N'Marshall', N'jmarshallgm@youtu.be', N'40827 Crescent Oaks Avenue', N'San Francisco', N'CA', N'6-(248)230-7439', 94159)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (600, N'Thomas', N'Hughes', N'thughesgn@com.com', N'84001 Buell Street', N'Richmond', N'VA', N'2-(650)964-9540', 23293)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (601, N'Ruby', N'Harper', N'rharpergo@digg.com', N'5 Clemons Park', N'Philadelphia', N'PA', N'8-(920)543-1200', 19151)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (602, N'Anne', N'Woods', N'awoodsgp@smugmug.com', N'786 Springview Way', N'Washington', N'DC', N'3-(498)388-3364', 20005)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (603, N'Janet', N'Lewis', N'jlewisgq@topsy.com', N'72 Bashford Drive', N'Kansas City', N'KS', N'5-(148)742-7709', 66105)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (604, N'Harold', N'Morgan', N'hmorgangr@si.edu', N'778 South Hill', N'Las Vegas', N'NV', N'4-(111)825-1833', 89120)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (605, N'Susan', N'Webb', N'swebbgs@marriott.com', N'7447 Marcy Park', N'New Haven', N'CT', N'1-(786)789-2492', 6538)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (606, N'Anne', N'Johnston', N'ajohnstongt@wikimedia.org', N'6469 Warbler Circle', N'El Paso', N'TX', N'5-(334)286-5560', 88519)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (607, N'Benjamin', N'Hunt', N'bhuntgu@usnews.com', N'06284 Birchwood Alley', N'Corpus Christi', N'TX', N'6-(466)373-8418', 78410)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (608, N'Dennis', N'Daniels', N'ddanielsgv@dyndns.org', N'49 Browning Pass', N'Washington', N'DC', N'5-(335)493-9260', 20575)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (609, N'Christopher', N'Nichols', N'cnicholsgw@shutterfly.com', N'639 Tennessee Circle', N'San Jose', N'CA', N'1-(290)832-0016', 95155)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (610, N'Eric', N'Walker', N'ewalkergx@etsy.com', N'77275 Becker Point', N'San Jose', N'CA', N'2-(185)990-4252', 95118)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (611, N'Judy', N'Ramos', N'jramosgy@live.com', N'22 Rutledge Street', N'Baton Rouge', N'LA', N'2-(335)919-6331', 70820)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (612, N'Harry', N'Jones', N'hjonesgz@blogtalkradio.com', N'9 Londonderry Avenue', N'Fort Wayne', N'IN', N'3-(880)779-4366', 46825)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (613, N'Brandon', N'Campbell', N'bcampbellh0@is.gd', N'60604 Mesta Alley', N'Palatine', N'IL', N'1-(407)610-4147', 60078)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (614, N'Emily', N'Baker', N'ebakerh1@webeden.co.uk', N'3 Tomscot Court', N'Sacramento', N'CA', N'2-(481)640-4462', 94273)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (615, N'Karen', N'Chavez', N'kchavezh2@sciencedaily.com', N'275 Rowland Way', N'Jamaica', N'NY', N'0-(921)859-2001', 11480)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (616, N'Donald', N'Lee', N'dleeh3@google.cn', N'71625 Melody Street', N'Carson City', N'NV', N'9-(840)161-2528', 89706)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (617, N'Karen', N'Day', N'kdayh4@mysql.com', N'7930 American Court', N'Amarillo', N'TX', N'7-(137)363-2993', 79105)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (618, N'Michael', N'Fuller', N'mfullerh5@economist.com', N'552 Manufacturers Way', N'Fort Worth', N'TX', N'6-(241)297-1014', 76121)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (619, N'Brian', N'Wallace', N'bwallaceh6@berkeley.edu', N'9 Lighthouse Bay Way', N'New York City', N'NY', N'2-(056)592-0260', 10270)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (620, N'Samuel', N'Rose', N'sroseh7@hubpages.com', N'0 Sommers Point', N'Seattle', N'WA', N'4-(257)068-0019', 98195)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (621, N'Wanda', N'Young', N'wyoungh8@elegantthemes.com', N'7 Corscot Drive', N'Hattiesburg', N'MS', N'3-(292)773-3537', 39404)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (622, N'Philip', N'Ramos', N'pramosh9@howstuffworks.com', N'547 Lakewood Gardens Park', N'Cincinnati', N'OH', N'0-(327)403-4334', 45999)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (623, N'Annie', N'Nichols', N'anicholsha@hhs.gov', N'55 Sycamore Terrace', N'Richmond', N'VA', N'4-(904)775-7610', 23203)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (624, N'Diane', N'Hart', N'dharthb@51.la', N'6216 Marquette Center', N'Kansas City', N'MO', N'7-(002)182-2474', 64142)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (625, N'Ruth', N'Reyes', N'rreyeshc@posterous.com', N'089 Towne Park', N'Boston', N'MA', N'8-(252)439-1820', 2114)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (626, N'Sharon', N'Berry', N'sberryhd@plala.or.jp', N'886 Bartillon Road', N'Portland', N'ME', N'1-(124)101-5385', 4109)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (627, N'Victor', N'Allen', N'vallenhe@privacy.gov.au', N'94753 Eliot Park', N'Orlando', N'FL', N'7-(394)332-8019', 32891)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (628, N'Brenda', N'Reed', N'breedhf@istockphoto.com', N'53 Steensland Trail', N'Shreveport', N'LA', N'7-(948)986-5072', 71166)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (629, N'Ruby', N'Hamilton', N'rhamiltonhg@stanford.edu', N'2089 Cambridge Drive', N'Memphis', N'TN', N'2-(820)175-3266', 38126)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (630, N'Norma', N'Hawkins', N'nhawkinshh@indiegogo.com', N'06 Anthes Crossing', N'Evansville', N'IN', N'7-(081)028-4735', 47705)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (631, N'Ruth', N'Kim', N'rkimhi@360.cn', N'5133 Veith Place', N'Charlotte', N'NC', N'0-(302)019-9871', 28278)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (632, N'Frank', N'Rogers', N'frogershj@pbs.org', N'36 Surrey Street', N'Clearwater', N'FL', N'3-(012)004-4131', 34620)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (633, N'Lori', N'Simpson', N'lsimpsonhk@hhs.gov', N'07 Pankratz Road', N'Aurora', N'CO', N'9-(858)611-6064', 80015)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (634, N'Henry', N'Watson', N'hwatsonhl@pagesperso-orange.fr', N'76 Clemons Junction', N'Dallas', N'TX', N'9-(795)561-1779', 75392)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (635, N'Mary', N'Meyer', N'mmeyerhm@mail.ru', N'5 Golden Leaf Junction', N'Saint Louis', N'MO', N'4-(853)961-6655', 63180)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (636, N'Ryan', N'Mitchell', N'rmitchellhn@hexun.com', N'53750 Bellgrove Crossing', N'Los Angeles', N'CA', N'6-(436)042-7101', 90035)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (637, N'Randy', N'Hanson', N'rhansonho@bloglovin.com', N'86 Golf View Place', N'Houston', N'TX', N'4-(502)619-1391', 77206)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (638, N'Amy', N'Vasquez', N'avasquezhp@craigslist.org', N'9 Dovetail Road', N'Fort Worth', N'TX', N'8-(366)209-5206', 76198)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (639, N'Anne', N'Jenkins', N'ajenkinshq@furl.net', N'770 Waxwing Trail', N'Seattle', N'WA', N'7-(197)251-2336', 98166)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (640, N'Jesse', N'Cunningham', N'jcunninghamhr@marriott.com', N'40 Buell Junction', N'Trenton', N'NJ', N'7-(655)273-6327', 8608)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (641, N'Christina', N'Jacobs', N'cjacobshs@prweb.com', N'4529 Annamark Lane', N'San Antonio', N'TX', N'6-(954)885-6307', 78255)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (642, N'Benjamin', N'Allen', N'ballenht@time.com', N'873 Kensington Junction', N'Jackson', N'MS', N'4-(223)749-3423', 39210)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (643, N'Juan', N'Fernandez', N'jfernandezhu@youtu.be', N'03 Northridge Lane', N'Saint Paul', N'MN', N'8-(126)930-5782', 55123)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (644, N'Ryan', N'Torres', N'rtorreshv@about.com', N'9987 Aberg Way', N'Mansfield', N'OH', N'5-(317)543-6032', 44905)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (645, N'Antonio', N'Harper', N'aharperhw@arizona.edu', N'8302 Macpherson Crossing', N'Knoxville', N'TN', N'8-(511)982-0648', 37919)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (646, N'Philip', N'Morgan', N'pmorganhx@hhs.gov', N'426 Mcguire Point', N'Fresno', N'CA', N'9-(536)243-6392', 93762)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (647, N'Martha', N'Snyder', N'msnyderhy@constantcontact.com', N'0759 Moose Plaza', N'Washington', N'DC', N'5-(292)270-2075', 20414)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (648, N'Aaron', N'James', N'ajameshz@home.pl', N'8 Fisk Plaza', N'Dallas', N'TX', N'9-(530)735-1391', 75226)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (649, N'Ann', N'Rivera', N'ariverai0@php.net', N'43 Dapin Plaza', N'Oxnard', N'CA', N'3-(670)119-6783', 93034)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (650, N'James', N'Rogers', N'jrogersi1@msu.edu', N'3 Hayes Street', N'Grand Junction', N'CO', N'1-(270)046-2339', 81505)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (651, N'Katherine', N'Wilson', N'kwilsoni2@bbb.org', N'22292 Pierstorff Avenue', N'Bryan', N'TX', N'5-(414)227-7201', 77806)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (652, N'Janet', N'Rivera', N'jriverai3@vk.com', N'4 Haas Street', N'Shreveport', N'LA', N'7-(658)423-7175', 71115)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (653, N'Paul', N'Hansen', N'phanseni4@sfgate.com', N'95055 Oak Valley Junction', N'Las Vegas', N'NV', N'8-(885)993-7097', 89178)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (654, N'Jesse', N'Scott', N'jscotti5@arstechnica.com', N'378 Esch Point', N'Chicago', N'IL', N'1-(710)779-3591', 60646)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (655, N'Brenda', N'Weaver', N'bweaveri6@shop-pro.jp', N'5269 Waubesa Pass', N'Pittsburgh', N'PA', N'2-(736)460-0025', 15279)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (656, N'Steven', N'Ferguson', N'sfergusoni7@marriott.com', N'11689 Lotheville Alley', N'Berkeley', N'CA', N'1-(645)596-0217', 94712)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (657, N'Sharon', N'Austin', N'saustini8@businessinsider.com', N'0073 Forest Pass', N'Bellevue', N'WA', N'5-(561)469-7022', 98008)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (658, N'Edward', N'Lee', N'eleei9@clickbank.net', N'7815 Main Center', N'Mobile', N'AL', N'3-(951)214-3333', 36622)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (659, N'Jack', N'Thompson', N'jthompsonia@technorati.com', N'9 Ilene Park', N'Waterbury', N'CT', N'1-(174)398-5369', 6705)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (660, N'Bobby', N'Williams', N'bwilliamsib@exblog.jp', N'16 Macpherson Alley', N'Austin', N'TX', N'1-(268)055-2633', 78769)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (661, N'Wayne', N'Hawkins', N'whawkinsic@usda.gov', N'95850 Red Cloud Center', N'Des Moines', N'IA', N'5-(228)270-3322', 50320)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (662, N'Patrick', N'Washington', N'pwashingtonid@digg.com', N'873 Banding Lane', N'Carlsbad', N'CA', N'8-(219)738-0334', 92013)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (663, N'Ralph', N'Fox', N'rfoxie@businessinsider.com', N'5 Fairview Hill', N'Dallas', N'TX', N'6-(114)628-9072', 75287)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (664, N'Angela', N'Lawson', N'alawsonif@domainmarket.com', N'9301 Montana Junction', N'San Diego', N'CA', N'6-(099)722-1587', 92110)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (665, N'Joan', N'Brooks', N'jbrooksig@twitpic.com', N'57 Loomis Avenue', N'Newark', N'DE', N'1-(777)650-6054', 19714)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (666, N'Marilyn', N'Bell', N'mbellih@myspace.com', N'34300 Green Ridge Center', N'Metairie', N'LA', N'4-(276)646-1662', 70005)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (667, N'Larry', N'Harvey', N'lharveyii@nasa.gov', N'815 Spohn Hill', N'East Saint Louis', N'IL', N'7-(735)712-3565', 62205)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (668, N'Deborah', N'Allen', N'dallenij@rediff.com', N'777 Nevada Center', N'Jamaica', N'NY', N'8-(957)238-8015', 11436)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (669, N'Jack', N'Morrison', N'jmorrisonik@illinois.edu', N'5915 Hanover Crossing', N'Albuquerque', N'NM', N'2-(795)547-9690', 87180)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (670, N'Jose', N'Black', N'jblackil@w3.org', N'2437 Springs Street', N'San Francisco', N'CA', N'1-(322)458-0071', 94159)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (671, N'Linda', N'Carter', N'lcarterim@taobao.com', N'482 High Crossing Park', N'El Paso', N'TX', N'1-(032)928-9641', 88589)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (672, N'Howard', N'Coleman', N'hcolemanin@ted.com', N'5205 Sachtjen Plaza', N'Erie', N'PA', N'2-(507)213-6926', 16550)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (673, N'Andrew', N'Murphy', N'amurphyio@symantec.com', N'214 Cody Junction', N'Charleston', N'WV', N'4-(912)055-9400', 25313)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (674, N'Jason', N'Nguyen', N'jnguyenip@yahoo.com', N'38616 Scofield Avenue', N'Van Nuys', N'CA', N'7-(633)962-3929', 91499)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (675, N'Eric', N'Hart', N'ehartiq@pen.io', N'01321 Pond Junction', N'San Bernardino', N'CA', N'1-(695)379-0515', 92410)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (676, N'Barbara', N'Payne', N'bpayneir@bloglines.com', N'52 Bobwhite Park', N'Lynn', N'MA', N'2-(945)263-1093', 1905)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (677, N'Teresa', N'Carpenter', N'tcarpenteris@comsenz.com', N'5 Waxwing Crossing', N'Oxnard', N'CA', N'7-(148)907-6694', 93034)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (678, N'Heather', N'Butler', N'hbutlerit@wunderground.com', N'67454 Oriole Avenue', N'Newport Beach', N'CA', N'0-(882)966-5769', 92662)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (679, N'Joseph', N'Martin', N'jmartiniu@weebly.com', N'01036 Evergreen Place', N'Tulsa', N'OK', N'5-(890)344-4037', 74103)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (680, N'Tina', N'Bailey', N'tbaileyiv@geocities.jp', N'25 Novick Park', N'Suffolk', N'VA', N'0-(668)360-0889', 23436)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (681, N'Raymond', N'Williams', N'rwilliamsiw@hexun.com', N'198 Mandrake Street', N'Houston', N'TX', N'8-(988)220-5917', 77276)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (682, N'Ruby', N'Fowler', N'rfowlerix@mozilla.org', N'2058 Kings Lane', N'Wichita Falls', N'TX', N'2-(644)143-7844', 76310)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (683, N'Ronald', N'Mitchell', N'rmitchelliy@washington.edu', N'560 Welch Parkway', N'Bonita Springs', N'FL', N'5-(682)841-9475', 34135)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (684, N'Ronald', N'Richardson', N'rrichardsoniz@edublogs.org', N'109 Lyons Street', N'Grand Junction', N'CO', N'0-(128)928-9940', 81505)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (685, N'Ralph', N'Matthews', N'rmatthewsj0@ocn.ne.jp', N'9 Mendota Plaza', N'Santa Barbara', N'CA', N'3-(335)270-7768', 93111)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (686, N'Jason', N'Holmes', N'jholmesj1@sogou.com', N'2 Dennis Trail', N'Springfield', N'VA', N'4-(585)658-7752', 22156)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (687, N'Ruth', N'Welch', N'rwelchj2@printfriendly.com', N'79607 Mosinee Junction', N'Jersey City', N'NJ', N'4-(399)849-9145', 7310)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (688, N'Kathy', N'Morrison', N'kmorrisonj3@businessweek.com', N'9 Emmet Parkway', N'Olympia', N'WA', N'1-(930)169-2020', 98516)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (689, N'Joshua', N'Frazier', N'jfrazierj4@github.io', N'19887 Emmet Pass', N'Bronx', N'NY', N'1-(368)449-7222', 10469)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (690, N'Evelyn', N'Reed', N'ereedj5@huffingtonpost.com', N'02 Fisk Trail', N'Las Vegas', N'NV', N'7-(315)577-0148', 89120)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (691, N'Karen', N'Lewis', N'klewisj6@rediff.com', N'785 Quincy Road', N'Boulder', N'CO', N'8-(424)602-0829', 80328)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (692, N'Cheryl', N'Ross', N'crossj7@a8.net', N'482 Butternut Circle', N'Baltimore', N'MD', N'7-(725)815-5638', 21229)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (693, N'Stephanie', N'Reynolds', N'sreynoldsj8@addtoany.com', N'7036 Claremont Plaza', N'Peoria', N'AZ', N'2-(059)939-6460', 85383)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (694, N'Jack', N'Schmidt', N'jschmidtj9@bing.com', N'73697 Londonderry Drive', N'Fairfax', N'VA', N'8-(187)067-1657', 22036)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (695, N'Peter', N'Kelley', N'pkelleyja@nasa.gov', N'47 Rockefeller Terrace', N'Columbus', N'OH', N'5-(236)326-3386', 43231)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (696, N'Emily', N'Washington', N'ewashingtonjb@washington.edu', N'425 Cascade Plaza', N'Peoria', N'IL', N'8-(913)976-9651', 61635)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (697, N'Louis', N'Allen', N'lallenjc@google.ca', N'7787 Dixon Hill', N'New Orleans', N'LA', N'7-(069)559-9474', 70179)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (698, N'Willie', N'Mills', N'wmillsjd@1688.com', N'6183 Leroy Road', N'Colorado Springs', N'CO', N'5-(006)650-4022', 80995)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (699, N'Sean', N'Alexander', N'salexanderje@walmart.com', N'24 Waywood Street', N'Levittown', N'PA', N'5-(157)388-5793', 19058)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (700, N'Ralph', N'Harrison', N'rharrisonjf@admin.ch', N'109 Oriole Crossing', N'Canton', N'OH', N'1-(433)496-2820', 44705)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (701, N'Joseph', N'Smith', N'jsmithjg@nyu.edu', N'54213 Stoughton Lane', N'Huntington', N'WV', N'3-(078)582-9429', 25770)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (702, N'Richard', N'West', N'rwestjh@nationalgeographic.com', N'76 Lighthouse Bay Junction', N'Philadelphia', N'PA', N'9-(656)559-2497', 19125)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (703, N'Julie', N'Chapman', N'jchapmanji@list-manage.com', N'0 Sage Point', N'Richmond', N'VA', N'7-(615)186-7319', 23260)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (704, N'Beverly', N'Young', N'byoungjj@economist.com', N'59259 Milwaukee Crossing', N'Syracuse', N'NY', N'3-(839)950-7304', 13251)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (705, N'Cynthia', N'Mccoy', N'cmccoyjk@last.fm', N'373 Sunnyside Lane', N'Portland', N'OR', N'4-(943)991-5724', 97229)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (706, N'Judith', N'Castillo', N'jcastillojl@ifeng.com', N'305 Helena Point', N'Lafayette', N'LA', N'4-(308)985-6456', 70505)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (707, N'Russell', N'Edwards', N'redwardsjm@clickbank.net', N'92678 Magdeline Avenue', N'Charlotte', N'NC', N'8-(511)994-0936', 28225)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (708, N'Phyllis', N'Reed', N'preedjn@nhs.uk', N'87 Almo Alley', N'Baton Rouge', N'LA', N'8-(025)573-7150', 70820)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (709, N'Cheryl', N'Barnes', N'cbarnesjo@adobe.com', N'229 Nancy Lane', N'Fort Worth', N'TX', N'8-(084)324-3104', 76129)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (710, N'Virginia', N'Payne', N'vpaynejp@gnu.org', N'15 Graedel Street', N'Odessa', N'TX', N'8-(433)897-6759', 79769)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (711, N'Marilyn', N'Meyer', N'mmeyerjq@ning.com', N'65380 Schurz Point', N'Englewood', N'CO', N'3-(403)436-0094', 80150)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (712, N'Walter', N'Young', N'wyoungjr@dedecms.com', N'446 Pleasure Court', N'Chattanooga', N'TN', N'8-(104)911-9733', 37405)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (713, N'Todd', N'Willis', N'twillisjs@msn.com', N'23180 Scofield Junction', N'Saint Petersburg', N'FL', N'5-(233)288-4700', 33710)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (714, N'Nicholas', N'Bowman', N'nbowmanjt@omniture.com', N'07 Delaware Point', N'Stockton', N'CA', N'9-(266)582-9753', 95219)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (715, N'Timothy', N'Ray', N'trayju@tamu.edu', N'454 Prairieview Avenue', N'Bradenton', N'FL', N'0-(313)776-8827', 34210)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (716, N'Ruby', N'Bailey', N'rbaileyjv@forbes.com', N'898 John Wall Street', N'Orlando', N'FL', N'1-(383)414-8140', 32819)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (717, N'Willie', N'Larson', N'wlarsonjw@theguardian.com', N'7 Badeau Lane', N'Monticello', N'MN', N'5-(294)896-8052', 55565)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (718, N'Jessica', N'Peters', N'jpetersjx@webs.com', N'7471 Anniversary Avenue', N'Las Vegas', N'NV', N'4-(861)017-7065', 89125)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (719, N'Susan', N'Kelley', N'skelleyjy@mayoclinic.com', N'4 Glacier Hill Point', N'Loretto', N'MN', N'8-(450)061-9359', 55598)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (720, N'Anthony', N'Knight', N'aknightjz@wordpress.org', N'96 Esch Trail', N'Cincinnati', N'OH', N'3-(075)666-1969', 45249)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (721, N'Patricia', N'Harrison', N'pharrisonk0@rambler.ru', N'180 Buell Pass', N'Washington', N'DC', N'3-(342)548-0710', 20540)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (722, N'Bobby', N'Mccoy', N'bmccoyk1@pinterest.com', N'883 Northland Center', N'Maple Plain', N'MN', N'7-(542)592-2838', 55572)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (723, N'Wanda', N'Gonzalez', N'wgonzalezk2@drupal.org', N'50660 Troy Lane', N'Zephyrhills', N'FL', N'5-(330)109-1431', 33543)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (724, N'Ruth', N'Johnson', N'rjohnsonk3@addtoany.com', N'82566 Annamark Road', N'Sarasota', N'FL', N'4-(419)532-7336', 34276)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (725, N'Amy', N'Crawford', N'acrawfordk4@cbc.ca', N'649 Morning Alley', N'San Diego', N'CA', N'9-(931)931-6823', 92127)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (726, N'Alice', N'Parker', N'aparkerk5@alibaba.com', N'65 Moland Street', N'Lexington', N'KY', N'6-(403)029-9066', 40510)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (727, N'Kathryn', N'Robinson', N'krobinsonk6@google.ca', N'39 Columbus Court', N'Jackson', N'MS', N'5-(454)199-9507', 39296)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (728, N'Samuel', N'Schmidt', N'sschmidtk7@thetimes.co.uk', N'7969 Carioca Center', N'Memphis', N'TN', N'4-(261)631-5676', 38188)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (729, N'Judith', N'Reyes', N'jreyesk8@edublogs.org', N'0838 Ramsey Pass', N'Elizabeth', N'NJ', N'9-(147)065-4707', 7208)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (730, N'Andrea', N'Larson', N'alarsonk9@google.ca', N'80213 Lakeland Alley', N'Mobile', N'AL', N'8-(514)258-5881', 36605)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (731, N'Willie', N'Gordon', N'wgordonka@forbes.com', N'32455 Waxwing Parkway', N'Houston', N'TX', N'4-(499)223-7117', 77045)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (732, N'Louis', N'Hawkins', N'lhawkinskb@cbsnews.com', N'8068 Vera Parkway', N'Harrisburg', N'PA', N'4-(945)962-0822', 17105)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (733, N'Joan', N'Russell', N'jrussellkc@aol.com', N'27441 Petterle Junction', N'Indianapolis', N'IN', N'5-(595)794-4251', 46254)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (734, N'Pamela', N'Lopez', N'plopezkd@apache.org', N'44438 Vidon Road', N'Alexandria', N'VA', N'6-(338)343-0776', 22309)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (735, N'Anne', N'Alvarez', N'aalvarezke@tinypic.com', N'15 6th Terrace', N'Toledo', N'OH', N'9-(784)936-4864', 43610)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (736, N'Willie', N'Bryant', N'wbryantkf@bloglines.com', N'7199 Texas Trail', N'Birmingham', N'AL', N'7-(460)615-3688', 35290)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (737, N'Elizabeth', N'Knight', N'eknightkg@eventbrite.com', N'476 Lighthouse Bay Alley', N'Washington', N'DC', N'1-(560)245-0811', 20057)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (738, N'Ruth', N'Banks', N'rbankskh@symantec.com', N'7 Cherokee Court', N'Bethlehem', N'PA', N'2-(701)133-7853', 18018)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (739, N'Alan', N'Butler', N'abutlerki@surveymonkey.com', N'83 Garrison Circle', N'Fort Worth', N'TX', N'5-(054)099-3366', 76115)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (740, N'Larry', N'Gutierrez', N'lgutierrezkj@businesswire.com', N'36851 Hayes Lane', N'Kansas City', N'MO', N'1-(767)144-4040', 64114)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (741, N'Stephanie', N'Hawkins', N'shawkinskk@reverbnation.com', N'5384 Kipling Terrace', N'Arlington', N'TX', N'8-(886)702-4916', 76004)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (742, N'Jimmy', N'Wallace', N'jwallacekl@tumblr.com', N'04818 Oakridge Terrace', N'Trenton', N'NJ', N'4-(442)612-1141', 8603)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (743, N'Raymond', N'Alvarez', N'ralvarezkm@creativecommons.org', N'062 Ridgeview Point', N'Jacksonville', N'FL', N'2-(418)499-6981', 32225)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (744, N'Mark', N'Williams', N'mwilliamskn@biglobe.ne.jp', N'5 Esch Alley', N'Brooklyn', N'NY', N'5-(205)856-9209', 11205)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (745, N'Samuel', N'Lewis', N'slewisko@list-manage.com', N'0 Kedzie Plaza', N'Naples', N'FL', N'4-(743)039-3858', 34114)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (746, N'Gregory', N'Torres', N'gtorreskp@zdnet.com', N'3652 Green Ridge Avenue', N'Jersey City', N'NJ', N'6-(911)883-8130', 7310)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (747, N'Peter', N'Burke', N'pburkekq@cyberchimps.com', N'91427 Jay Avenue', N'New York City', N'NY', N'7-(563)808-9926', 10045)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (748, N'Norma', N'Burton', N'nburtonkr@nbcnews.com', N'931 Eagan Drive', N'Memphis', N'TN', N'6-(354)670-3720', 38119)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (749, N'John', N'Barnes', N'jbarnesks@ucla.edu', N'3753 Surrey Avenue', N'Memphis', N'TN', N'7-(185)151-7498', 38168)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (750, N'Diana', N'Murphy', N'dmurphykt@cnet.com', N'873 Paget Pass', N'Portland', N'OR', N'2-(052)085-8610', 97216)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (751, N'Timothy', N'Ryan', N'tryanku@uiuc.edu', N'07984 Dwight Trail', N'Anchorage', N'AK', N'8-(488)418-7720', 99599)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (752, N'Willie', N'Hunt', N'whuntkv@bing.com', N'9092 Rockefeller Hill', N'Missoula', N'MT', N'8-(759)226-1382', 59806)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (753, N'Marilyn', N'Porter', N'mporterkw@oakley.com', N'7655 Fordem Circle', N'New York City', N'NY', N'7-(929)566-8339', 10009)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (754, N'Jacqueline', N'Morrison', N'jmorrisonkx@soup.io', N'6668 Hooker Pass', N'Aurora', N'CO', N'2-(025)622-2446', 80044)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (755, N'Amy', N'Hanson', N'ahansonky@wiley.com', N'84621 Dryden Trail', N'Bradenton', N'FL', N'7-(786)779-4382', 34282)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (756, N'Doris', N'Mitchell', N'dmitchellkz@mozilla.com', N'48 John Wall Road', N'Brockton', N'MA', N'4-(247)462-6791', 2405)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (757, N'Harold', N'Ruiz', N'hruizl0@mac.com', N'801 Becker Center', N'Toledo', N'OH', N'7-(635)455-1282', 43610)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (758, N'Linda', N'Richardson', N'lrichardsonl1@statcounter.com', N'75479 Sunbrook Trail', N'Fort Pierce', N'FL', N'5-(386)345-6171', 34981)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (759, N'Lori', N'Henderson', N'lhendersonl2@ted.com', N'40 Randy Court', N'Monticello', N'MN', N'8-(099)608-6256', 55565)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (760, N'Mildred', N'Garrett', N'mgarrettl3@nature.com', N'3840 Moulton Avenue', N'Akron', N'OH', N'5-(684)770-0267', 44310)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (761, N'Mildred', N'Ray', N'mrayl4@cargocollective.com', N'111 Loomis Avenue', N'Miami', N'FL', N'7-(650)270-0398', 33175)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (762, N'Paula', N'Frazier', N'pfrazierl5@wisc.edu', N'46876 Tomscot Road', N'Hartford', N'CT', N'5-(663)510-0393', 6183)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (763, N'Philip', N'Henry', N'phenryl6@bluehost.com', N'18 Morning Court', N'Wilmington', N'DE', N'4-(397)335-2783', 19810)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (764, N'Angela', N'Roberts', N'arobertsl7@oaic.gov.au', N'1 Sachs Pass', N'Mesquite', N'TX', N'5-(228)192-7375', 75185)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (765, N'Harold', N'Gilbert', N'hgilbertl8@princeton.edu', N'5020 Bultman Pass', N'Lynchburg', N'VA', N'0-(733)897-3314', 24503)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (766, N'Walter', N'Peters', N'wpetersl9@adobe.com', N'6 Washington Road', N'Fort Wayne', N'IN', N'6-(463)293-3517', 46825)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (767, N'Mark', N'Harrison', N'mharrisonla@netscape.com', N'86969 Hollow Ridge Park', N'Tulsa', N'OK', N'8-(917)820-2120', 74103)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (768, N'Lois', N'Taylor', N'ltaylorlb@scientificamerican.com', N'58 Reindahl Terrace', N'Charlottesville', N'VA', N'7-(848)977-3280', 22908)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (769, N'Diane', N'Gibson', N'dgibsonlc@icio.us', N'79 Basil Drive', N'Omaha', N'NE', N'8-(512)538-9741', 68197)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (770, N'Jennifer', N'Stanley', N'jstanleyld@skype.com', N'1865 Morrow Way', N'Baltimore', N'MD', N'3-(916)379-2628', 21265)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (771, N'Brandon', N'Rose', N'brosele@usgs.gov', N'64481 Westport Point', N'San Antonio', N'TX', N'6-(929)266-1586', 78255)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (772, N'Antonio', N'Alvarez', N'aalvarezlf@nih.gov', N'145 Dunning Lane', N'Naperville', N'IL', N'5-(390)789-1468', 60567)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (773, N'Earl', N'Marshall', N'emarshalllg@netlog.com', N'2960 Coleman Parkway', N'Cleveland', N'OH', N'2-(565)497-0592', 44197)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (774, N'Debra', N'Allen', N'dallenlh@cyberchimps.com', N'1 Hazelcrest Road', N'Buffalo', N'NY', N'0-(888)332-6125', 14269)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (775, N'Irene', N'Gonzalez', N'igonzalezli@va.gov', N'580 Armistice Center', N'Orlando', N'FL', N'5-(269)335-0879', 32813)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (776, N'Jane', N'Dunn', N'jdunnlj@gnu.org', N'88 Hoepker Parkway', N'Oklahoma City', N'OK', N'5-(144)048-3995', 73129)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (777, N'Charles', N'Johnson', N'cjohnsonlk@wordpress.org', N'25 Dennis Alley', N'Jacksonville', N'FL', N'2-(364)513-6908', 32259)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (778, N'Rose', N'Barnes', N'rbarnesll@rambler.ru', N'9887 Paget Drive', N'Dayton', N'OH', N'6-(733)562-6903', 45440)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (779, N'Nicholas', N'Ray', N'nraylm@bizjournals.com', N'4566 Debra Crossing', N'Augusta', N'GA', N'7-(853)406-2249', 30911)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (780, N'Betty', N'Kelly', N'bkellyln@reddit.com', N'06358 Erie Place', N'Santa Rosa', N'CA', N'8-(510)170-4623', 95405)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (781, N'Jack', N'Collins', N'jcollinslo@upenn.edu', N'0 Fuller Lane', N'New Orleans', N'LA', N'6-(809)503-9810', 70174)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (782, N'Sean', N'Reid', N'sreidlp@flavors.me', N'42327 Larry Hill', N'Tallahassee', N'FL', N'8-(167)055-2586', 32314)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (783, N'Russell', N'Frazier', N'rfrazierlq@ning.com', N'507 Myrtle Lane', N'Melbourne', N'FL', N'8-(221)586-1062', 32919)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (784, N'Betty', N'Flores', N'bfloreslr@exblog.jp', N'2795 5th Point', N'Jacksonville', N'FL', N'3-(449)435-0619', 32277)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (785, N'Stephen', N'Fisher', N'sfisherls@newyorker.com', N'553 Milwaukee Center', N'Schenectady', N'NY', N'2-(858)012-1720', 12325)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (786, N'Angela', N'Alexander', N'aalexanderlt@vk.com', N'08902 East Terrace', N'Miami', N'FL', N'5-(931)347-6294', 33158)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (787, N'Kenneth', N'Richardson', N'krichardsonlu@yellowbook.com', N'4982 Daystar Drive', N'Saint Paul', N'MN', N'4-(063)336-3944', 55123)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (788, N'Laura', N'Tucker', N'ltuckerlv@tuttocitta.it', N'9161 Arizona Plaza', N'Houston', N'TX', N'9-(931)160-0366', 77045)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (789, N'Gary', N'Frazier', N'gfrazierlw@ovh.net', N'1 Texas Junction', N'Glendale', N'AZ', N'2-(739)113-3980', 85305)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (790, N'Ruby', N'Lee', N'rleelx@blog.com', N'433 Fieldstone Terrace', N'Spokane', N'WA', N'0-(400)424-5151', 99260)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (791, N'Bobby', N'Elliott', N'belliottly@dropbox.com', N'28 Delladonna Avenue', N'Salt Lake City', N'UT', N'5-(820)204-5966', 84140)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (792, N'Scott', N'Lee', N'sleelz@youtu.be', N'0057 Union Alley', N'Kansas City', N'MO', N'9-(728)358-3440', 64130)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (793, N'Louise', N'Carter', N'lcarterm0@ucoz.com', N'30166 Commercial Plaza', N'Des Moines', N'IA', N'8-(205)283-6618', 50330)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (794, N'Christine', N'Austin', N'caustinm1@altervista.org', N'43529 Hoffman Drive', N'Dallas', N'TX', N'5-(820)446-1960', 75358)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (795, N'Rebecca', N'Gibson', N'rgibsonm2@biblegateway.com', N'0102 Farwell Crossing', N'Sacramento', N'CA', N'6-(817)179-4893', 94263)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (796, N'Shawn', N'Stewart', N'sstewartm3@businessinsider.com', N'6 Clemons Plaza', N'Washington', N'DC', N'4-(585)400-2864', 20078)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (797, N'Arthur', N'Hudson', N'ahudsonm4@themeforest.net', N'6 Straubel Terrace', N'Torrance', N'CA', N'3-(357)817-7136', 90505)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (798, N'Pamela', N'Carroll', N'pcarrollm5@ibm.com', N'86 Sugar Hill', N'Lakeland', N'FL', N'9-(539)927-3926', 33811)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (799, N'Ann', N'Gutierrez', N'agutierrezm6@theatlantic.com', N'3 Sommers Hill', N'Wichita', N'KS', N'5-(878)564-6043', 67210)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (800, N'George', N'Carpenter', N'gcarpenterm7@discuz.net', N'59141 Maryland Drive', N'Shawnee Mission', N'KS', N'6-(568)117-7048', 66286)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (801, N'Nicholas', N'Reyes', N'nreyesm8@mail.ru', N'865 Sullivan Hill', N'Cleveland', N'OH', N'0-(229)275-1710', 44105)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (802, N'Michelle', N'Knight', N'mknightm9@spiegel.de', N'279 Holmberg Parkway', N'Sacramento', N'CA', N'1-(670)443-4376', 95852)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (803, N'Rebecca', N'Turner', N'rturnerma@parallels.com', N'387 Fairfield Court', N'San Rafael', N'CA', N'8-(260)335-5206', 94913)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (804, N'Harold', N'Butler', N'hbutlermb@gmpg.org', N'58404 Lake View Plaza', N'Jacksonville', N'FL', N'4-(438)237-3603', 32215)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (805, N'Sharon', N'Gomez', N'sgomezmc@businessinsider.com', N'7607 Village Junction', N'Huntington', N'WV', N'3-(462)500-4156', 25709)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (806, N'Melissa', N'Bowman', N'mbowmanmd@sphinn.com', N'00 Graceland Road', N'Saint Louis', N'MO', N'4-(755)927-7877', 63126)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (807, N'Harry', N'Cook', N'hcookme@instagram.com', N'6 High Crossing Junction', N'Rochester', N'NY', N'1-(071)267-5122', 14624)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (808, N'Jimmy', N'Smith', N'jsmithmf@e-recht24.de', N'20 David Parkway', N'Paterson', N'NJ', N'6-(323)100-7340', 7505)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (809, N'Gregory', N'Welch', N'gwelchmg@hatena.ne.jp', N'94 Cherokee Way', N'Los Angeles', N'CA', N'2-(343)585-5973', 90065)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (810, N'Clarence', N'Rose', N'crosemh@latimes.com', N'4 Dixon Avenue', N'Jacksonville', N'FL', N'5-(366)721-9561', 32209)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (811, N'Eugene', N'Medina', N'emedinami@bravesites.com', N'62 Oxford Crossing', N'Las Vegas', N'NV', N'3-(144)052-1151', 89130)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (812, N'Marilyn', N'Kennedy', N'mkennedymj@businessinsider.com', N'48836 Park Meadow Crossing', N'Syracuse', N'NY', N'4-(224)637-3267', 13217)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (813, N'Kimberly', N'Warren', N'kwarrenmk@dot.gov', N'7160 La Follette Park', N'Seattle', N'WA', N'2-(554)425-3430', 98115)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (814, N'Eric', N'Berry', N'eberryml@cargocollective.com', N'3 Stone Corner Park', N'Erie', N'PA', N'9-(666)946-5058', 16510)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (815, N'Stephanie', N'Gomez', N'sgomezmm@sbwire.com', N'183 Express Trail', N'Lancaster', N'PA', N'4-(955)448-4323', 17605)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (816, N'Timothy', N'Hernandez', N'thernandezmn@upenn.edu', N'669 High Crossing Alley', N'Fort Collins', N'CO', N'9-(117)540-1056', 80525)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (817, N'Eric', N'Stewart', N'estewartmo@illinois.edu', N'9454 Morrow Point', N'Stamford', N'CT', N'0-(840)701-6247', 6922)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (818, N'Beverly', N'Martinez', N'bmartinezmp@yelp.com', N'7 Jenifer Parkway', N'Simi Valley', N'CA', N'9-(875)024-3170', 93094)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (819, N'Teresa', N'Henry', N'thenrymq@addtoany.com', N'255 North Place', N'Saint Joseph', N'MO', N'7-(477)614-4437', 64504)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (820, N'Janet', N'Romero', N'jromeromr@fc2.com', N'82 Rigney Park', N'Sioux City', N'IA', N'4-(238)745-1438', 51110)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (821, N'Earl', N'Bowman', N'ebowmanms@netvibes.com', N'54272 Birchwood Junction', N'Oceanside', N'CA', N'7-(083)240-5079', 92056)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (822, N'Harry', N'Morris', N'hmorrismt@webnode.com', N'062 Meadow Valley Drive', N'Salt Lake City', N'UT', N'1-(637)544-5332', 84120)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (823, N'Nicole', N'Lopez', N'nlopezmu@phoca.cz', N'2 Forest Dale Trail', N'Columbia', N'SC', N'9-(678)535-9863', 29203)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (824, N'Alan', N'Nguyen', N'anguyenmv@oakley.com', N'55414 Golden Leaf Point', N'Lincoln', N'NE', N'8-(206)939-0455', 68531)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (825, N'William', N'Hughes', N'whughesmw@facebook.com', N'17 Debs Hill', N'Las Vegas', N'NV', N'8-(082)991-1499', 89178)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (826, N'Jerry', N'Ramirez', N'jramirezmx@addtoany.com', N'00 Eggendart Court', N'Torrance', N'CA', N'0-(288)858-0327', 90505)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (827, N'Antonio', N'Morris', N'amorrismy@myspace.com', N'851 Donald Terrace', N'Richmond', N'VA', N'0-(611)970-0575', 23285)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (828, N'Evelyn', N'Dean', N'edeanmz@i2i.jp', N'83720 Bultman Parkway', N'Boise', N'ID', N'8-(688)906-0162', 83716)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (829, N'Ruby', N'Mendoza', N'rmendozan0@nhs.uk', N'10542 Prentice Place', N'San Francisco', N'CA', N'9-(762)683-2591', 94110)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (830, N'Adam', N'Ryan', N'aryann1@amazon.de', N'82 Morrow Court', N'San Antonio', N'TX', N'4-(375)178-0178', 78255)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (831, N'Kevin', N'Mcdonald', N'kmcdonaldn2@sohu.com', N'17 Lakewood Parkway', N'Troy', N'MI', N'6-(053)144-3064', 48098)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (832, N'Dorothy', N'Roberts', N'drobertsn3@google.com.br', N'8 Sachs Place', N'Kansas City', N'MO', N'7-(718)180-0925', 64114)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (833, N'Fred', N'Woods', N'fwoodsn4@studiopress.com', N'95994 Burning Wood Trail', N'Philadelphia', N'PA', N'3-(335)450-9911', 19131)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (834, N'Susan', N'Meyer', N'smeyern5@newsvine.com', N'88 Heath Point', N'San Bernardino', N'CA', N'7-(711)422-7982', 92415)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (835, N'Susan', N'Richards', N'srichardsn6@wordpress.org', N'686 Bowman Junction', N'Brooklyn', N'NY', N'8-(304)809-4021', 11215)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (836, N'Daniel', N'Washington', N'dwashingtonn7@independent.co.uk', N'96 Lyons Center', N'Houston', N'TX', N'7-(317)763-2654', 77299)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (837, N'Sharon', N'Wood', N'swoodn8@indiegogo.com', N'6 La Follette Place', N'Baton Rouge', N'LA', N'0-(594)066-6687', 70894)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (838, N'Joshua', N'Gutierrez', N'jgutierrezn9@feedburner.com', N'01493 Canary Crossing', N'Denver', N'CO', N'4-(243)765-3263', 80223)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (839, N'Bobby', N'Holmes', N'bholmesna@i2i.jp', N'65075 Everett Hill', N'Arlington', N'VA', N'5-(152)084-1145', 22217)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (840, N'Henry', N'Mcdonald', N'hmcdonaldnb@list-manage.com', N'17440 Emmet Terrace', N'Columbus', N'OH', N'5-(044)031-7446', 43268)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (841, N'Robert', N'Harris', N'rharrisnc@slashdot.org', N'365 Montana Terrace', N'Erie', N'PA', N'2-(770)537-5239', 16510)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (842, N'Jeremy', N'Alexander', N'jalexandernd@example.com', N'1251 Waxwing Avenue', N'Cheyenne', N'WY', N'6-(350)101-7534', 82007)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (843, N'Elizabeth', N'Miller', N'emillerne@fda.gov', N'6826 Northridge Crossing', N'New Orleans', N'LA', N'4-(239)700-1855', 70154)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (844, N'Johnny', N'Arnold', N'jarnoldnf@disqus.com', N'97463 Buena Vista Plaza', N'Washington', N'DC', N'5-(419)668-1229', 20535)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (845, N'Diana', N'Rice', N'driceng@whitehouse.gov', N'9026 Marquette Terrace', N'Tulsa', N'OK', N'7-(052)287-6401', 74149)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (846, N'Wanda', N'Sanchez', N'wsancheznh@bloglines.com', N'93738 Briar Crest Plaza', N'Warren', N'OH', N'6-(815)559-7688', 44485)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (847, N'Donald', N'Ross', N'drossni@illinois.edu', N'05 Nancy Street', N'Saint Paul', N'MN', N'6-(924)488-0167', 55114)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (848, N'Kathryn', N'Carroll', N'kcarrollnj@umn.edu', N'5244 Weeping Birch Street', N'New Bedford', N'MA', N'5-(347)937-7870', 2745)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (849, N'Edward', N'Wilson', N'ewilsonnk@chronoengine.com', N'28 Oneill Way', N'Anchorage', N'AK', N'5-(882)995-7648', 99599)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (850, N'Stephanie', N'Lawrence', N'slawrencenl@altervista.org', N'78334 Scoville Plaza', N'Birmingham', N'AL', N'5-(976)396-3928', 35244)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (851, N'Lisa', N'Flores', N'lfloresnm@mozilla.org', N'19 Westridge Center', N'Albuquerque', N'NM', N'5-(782)022-1926', 87115)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (852, N'Rachel', N'Taylor', N'rtaylornn@php.net', N'82673 Caliangt Road', N'Sacramento', N'CA', N'9-(234)496-7826', 94297)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (853, N'Margaret', N'West', N'mwestno@mapquest.com', N'60071 Jackson Park', N'Fort Lauderdale', N'FL', N'5-(575)053-0893', 33320)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (854, N'Sandra', N'Perry', N'sperrynp@cpanel.net', N'245 Old Gate Avenue', N'Grand Rapids', N'MI', N'0-(253)520-2135', 49560)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (855, N'George', N'Lewis', N'glewisnq@slideshare.net', N'14536 Acker Pass', N'Buffalo', N'NY', N'2-(322)393-6457', 14233)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (856, N'Terry', N'Burton', N'tburtonnr@163.com', N'5790 Kenwood Point', N'Pasadena', N'CA', N'5-(338)167-2856', 91125)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (857, N'Alan', N'Harvey', N'aharveyns@posterous.com', N'04 Dakota Alley', N'New York City', N'NY', N'1-(927)616-0433', 10270)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (858, N'Donna', N'Daniels', N'ddanielsnt@behance.net', N'6336 Namekagon Alley', N'Washington', N'DC', N'9-(402)494-3670', 20051)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (859, N'Theresa', N'Berry', N'tberrynu@com.com', N'5901 Evergreen Park', N'Denver', N'CO', N'2-(313)264-2941', 80209)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (860, N'Ashley', N'Sanchez', N'asancheznv@cdc.gov', N'68 Boyd Lane', N'Montgomery', N'AL', N'5-(240)954-9166', 36177)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (861, N'Samuel', N'Wallace', N'swallacenw@instagram.com', N'4 Killdeer Crossing', N'Lakewood', N'WA', N'5-(240)495-9569', 98498)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (862, N'Tina', N'Spencer', N'tspencernx@nytimes.com', N'48 Lien Circle', N'Alexandria', N'VA', N'0-(499)847-3986', 22333)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (863, N'Patricia', N'Smith', N'psmithny@xing.com', N'94 Oriole Street', N'Portland', N'OR', N'3-(827)909-1439', 97229)
GO
INSERT [dbo].[MockPeople] ([id], [first_name], [last_name], [email], [address], [city], [stateCode], [phone], [zipCode]) VALUES (864, N'Catherine', N'Edwards', N'cedwardsnz@chron.com', N'66 Oakridge Park', N'Shreveport', N'LA', N'9-(534)099-0067', 71105)
GO
SET IDENTITY_INSERT [dbo].[Person] ON 

GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (1, N'Billy', N'Bob', N'Thorton')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (2, N'Clark', N'T', N'Kent')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (3, N'Bruce', N'A', N'Banner')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (4, N'Captain', N'USA', N'America')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (5, N'Tony', N'Raymond', N'Stark')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (7, N'Diddy', N'Donkey', N'Kong')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (9, N'Louis', N'', N'Gutierrez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (10, N'Patrick', N'', N'Wallace')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (11, N'Nicholas', N'', N'Elliott')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (12, N'Randy', N'', N'Weaver')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (13, N'Charles', N'', N'Sanders')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (14, N'Catherine', N'', N'Wright')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (15, N'Brian', N'', N'Gomez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (16, N'Kathy', N'', N'Nguyen')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (17, N'Willie', N'', N'Hansen')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (18, N'Andrew', N'', N'Thomas')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (19, N'Louise', N'', N'Burton')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (20, N'Alice', N'', N'Brown')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (21, N'Betty', N'', N'Hill')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (22, N'Brandon', N'', N'Mills')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (23, N'Amanda', N'', N'Jenkins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (24, N'Joe', N'', N'Sims')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (25, N'Christina', N'', N'Johnston')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (26, N'Keith', N'', N'Lynch')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (27, N'Bruce', N'', N'Robertson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (28, N'Irene', N'', N'Adams')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (29, N'Joyce', N'', N'Hunt')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (30, N'Kathryn', N'', N'Mitchell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (31, N'Craig', N'', N'Lee')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (32, N'Emily', N'', N'Hicks')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (33, N'Evelyn', N'', N'Ward')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (34, N'Kimberly', N'', N'Morris')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (35, N'Juan', N'', N'Palmer')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (36, N'Diana', N'', N'Evans')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (37, N'Jeffrey', N'', N'Larson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (38, N'Marie', N'', N'Wheeler')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (39, N'Amy', N'', N'Freeman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (40, N'Anthony', N'', N'Parker')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (41, N'Betty', N'', N'Watkins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (42, N'Cynthia', N'', N'Taylor')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (43, N'Rachel', N'', N'Campbell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (44, N'Robert', N'', N'Hanson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (45, N'Teresa', N'', N'Smith')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (46, N'Beverly', N'', N'Morgan')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (47, N'Sandra', N'', N'Knight')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (48, N'Jessica', N'', N'Sanders')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (49, N'Aaron', N'', N'Spencer')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (50, N'Fred', N'', N'Reid')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (51, N'Joseph', N'', N'Davis')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (52, N'Andrew', N'', N'Murphy')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (53, N'Harold', N'', N'Elliott')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (54, N'Rachel', N'', N'Weaver')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (55, N'Jose', N'', N'Morgan')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (56, N'Barbara', N'', N'Dunn')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (57, N'Barbara', N'', N'Stevens')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (58, N'Emily', N'', N'Robinson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (59, N'Jeremy', N'', N'Bennett')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (60, N'Harry', N'', N'Ryan')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (61, N'Jonathan', N'', N'Burns')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (62, N'Gerald', N'', N'Ellis')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (63, N'Brian', N'', N'Watkins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (64, N'Kelly', N'', N'Green')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (65, N'Jason', N'', N'Smith')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (66, N'Sean', N'', N'Fox')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (67, N'Jose', N'', N'Williamson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (68, N'Christina', N'', N'Torres')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (69, N'Justin', N'', N'Butler')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (70, N'Joe', N'', N'Nichols')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (71, N'Heather', N'', N'Watkins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (72, N'Kathy', N'', N'Evans')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (73, N'Paula', N'', N'Carroll')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (74, N'Nancy', N'', N'Scott')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (75, N'Jerry', N'', N'Grant')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (76, N'Beverly', N'', N'Rogers')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (77, N'Christine', N'', N'Roberts')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (78, N'Bruce', N'', N'Richardson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (79, N'Joan', N'', N'James')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (80, N'William', N'', N'Snyder')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (81, N'Ralph', N'', N'Richards')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (82, N'Donald', N'', N'Myers')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (83, N'Eugene', N'', N'Bell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (84, N'Wanda', N'', N'Ramirez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (85, N'Frank', N'', N'Cole')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (86, N'Kathy', N'', N'Henderson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (87, N'Maria', N'', N'Sanders')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (88, N'Bonnie', N'', N'Chapman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (89, N'Justin', N'', N'Wheeler')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (90, N'Sharon', N'', N'Davis')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (91, N'Kevin', N'', N'Banks')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (92, N'Larry', N'', N'Reid')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (93, N'Lois', N'', N'Kim')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (94, N'Joe', N'', N'Garza')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (95, N'Clarence', N'', N'Harrison')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (96, N'Brenda', N'', N'Lewis')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (97, N'Russell', N'', N'Dixon')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (98, N'Elizabeth', N'', N'Berry')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (99, N'Edward', N'', N'Flores')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (100, N'Mary', N'', N'Owens')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (101, N'Lillian', N'', N'Carpenter')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (102, N'Sean', N'', N'Perkins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (103, N'Lois', N'', N'Richards')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (104, N'Beverly', N'', N'Carroll')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (105, N'Linda', N'', N'Reyes')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (106, N'Sara', N'', N'Chapman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (107, N'Bruce', N'', N'Ramirez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (108, N'Michael', N'', N'Hicks')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (109, N'Lisa', N'', N'Wallace')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (110, N'Mary', N'', N'Hunter')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (111, N'Alan', N'', N'Coleman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (112, N'Nicole', N'', N'Howell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (113, N'Samuel', N'', N'Peterson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (114, N'Margaret', N'', N'Schmidt')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (115, N'Anne', N'', N'Fields')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (116, N'Benjamin', N'', N'Ferguson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (117, N'Robert', N'', N'Fuller')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (118, N'Amanda', N'', N'Ross')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (119, N'Evelyn', N'', N'Lawrence')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (120, N'Kimberly', N'', N'Gray')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (121, N'Bruce', N'', N'Richardson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (122, N'Jeffrey', N'', N'Nguyen')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (123, N'Catherine', N'', N'Gutierrez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (124, N'Jack', N'', N'Murphy')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (125, N'Michael', N'', N'Weaver')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (126, N'Brandon', N'', N'Cole')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (127, N'Jane', N'', N'Webb')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (128, N'Maria', N'', N'Harvey')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (129, N'Amanda', N'', N'Perry')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (130, N'Thomas', N'', N'Miller')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (131, N'Joan', N'', N'Knight')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (132, N'Michael', N'', N'Ortiz')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (133, N'Robert', N'', N'Garcia')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (134, N'Sarah', N'', N'Mills')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (135, N'Mildred', N'', N'Porter')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (136, N'Phillip', N'', N'Richards')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (137, N'George', N'', N'Collins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (138, N'Laura', N'', N'Hall')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (139, N'Christopher', N'', N'Garrett')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (140, N'Victor', N'', N'Cunningham')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (141, N'Ralph', N'', N'Reynolds')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (142, N'Sandra', N'', N'Mitchell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (143, N'Larry', N'', N'Simmons')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (144, N'Jeremy', N'', N'Green')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (145, N'Christina', N'', N'Perkins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (146, N'Keith', N'', N'Lewis')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (147, N'Keith', N'', N'Riley')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (148, N'Daniel', N'', N'Fernandez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (149, N'Kathryn', N'', N'Reynolds')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (150, N'Nancy', N'', N'Williams')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (151, N'Jessica', N'', N'Bell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (152, N'Jose', N'', N'Morris')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (153, N'Gloria', N'', N'Austin')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (154, N'Christopher', N'', N'Fuller')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (155, N'Pamela', N'', N'Ramos')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (156, N'Larry', N'', N'Johnson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (157, N'Cynthia', N'', N'George')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (158, N'Sandra', N'', N'Watson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (159, N'Carlos', N'', N'Hanson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (160, N'Lawrence', N'', N'Flores')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (161, N'Rebecca', N'', N'Myers')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (162, N'Anna', N'', N'Castillo')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (163, N'Martin', N'', N'Brooks')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (164, N'Norma', N'', N'Lopez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (165, N'Virginia', N'', N'Crawford')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (166, N'Christina', N'', N'Larson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (167, N'Jeremy', N'', N'Cruz')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (168, N'Dennis', N'', N'Burns')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (169, N'Theresa', N'', N'Brown')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (170, N'George', N'', N'Ellis')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (171, N'Russell', N'', N'George')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (172, N'Joe', N'', N'Hall')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (173, N'Laura', N'', N'Miller')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (174, N'Anna', N'', N'Stevens')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (175, N'Jane', N'', N'Elliott')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (176, N'Karen', N'', N'Gilbert')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (177, N'Kenneth', N'', N'West')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (178, N'Diana', N'', N'Cox')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (179, N'Julia', N'', N'Flores')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (180, N'Lillian', N'', N'Parker')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (181, N'Andrea', N'', N'Allen')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (182, N'Donna', N'', N'Wagner')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (183, N'Evelyn', N'', N'Burton')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (184, N'Lisa', N'', N'Mendoza')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (185, N'Michael', N'', N'Gonzales')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (186, N'Paul', N'', N'Mitchell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (187, N'Jason', N'', N'Gibson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (188, N'Bobby', N'', N'Olson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (189, N'Carlos', N'', N'Williamson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (190, N'Rebecca', N'', N'Grant')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (191, N'Gary', N'', N'Edwards')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (192, N'Norma', N'', N'Tucker')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (193, N'Walter', N'', N'Jones')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (194, N'Jack', N'', N'Patterson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (195, N'Martin', N'', N'Sullivan')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (196, N'Fred', N'', N'Russell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (197, N'Raymond', N'', N'Palmer')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (198, N'William', N'', N'Lee')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (199, N'Sarah', N'', N'Robinson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (200, N'Teresa', N'', N'Day')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (201, N'Shirley', N'', N'Evans')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (202, N'Aaron', N'', N'Marshall')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (203, N'Kenneth', N'', N'Welch')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (204, N'Linda', N'', N'Jones')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (205, N'Robin', N'', N'Sims')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (206, N'Karen', N'', N'Sims')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (207, N'David', N'', N'Greene')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (208, N'Tammy', N'', N'Gardner')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (209, N'Christopher', N'', N'Castillo')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (210, N'Christina', N'', N'Welch')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (211, N'Albert', N'', N'Watkins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (212, N'David', N'', N'Moore')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (213, N'Jean', N'', N'Carter')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (214, N'Jason', N'', N'Watkins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (215, N'Linda', N'', N'Butler')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (216, N'Katherine', N'', N'Cox')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (217, N'Frances', N'', N'Robinson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (218, N'Martha', N'', N'Murray')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (219, N'Anne', N'', N'Boyd')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (220, N'Kathy', N'', N'James')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (221, N'Johnny', N'', N'Stevens')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (222, N'Johnny', N'', N'Mcdonald')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (223, N'Louis', N'', N'Kennedy')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (224, N'Janice', N'', N'Reynolds')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (225, N'Ryan', N'', N'Cook')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (226, N'Arthur', N'', N'Scott')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (227, N'Cynthia', N'', N'Clark')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (228, N'Melissa', N'', N'Matthews')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (229, N'Elizabeth', N'', N'Lane')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (230, N'Linda', N'', N'Simmons')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (231, N'Kenneth', N'', N'Chapman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (232, N'Raymond', N'', N'Wheeler')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (233, N'Mary', N'', N'Kelley')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (234, N'Benjamin', N'', N'Coleman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (235, N'Sean', N'', N'Johnston')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (236, N'Sharon', N'', N'Hamilton')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (237, N'Paula', N'', N'Peterson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (238, N'William', N'', N'Day')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (239, N'Shawn', N'', N'Nguyen')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (240, N'Maria', N'', N'Alexander')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (241, N'Debra', N'', N'Carroll')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (242, N'Donna', N'', N'Hughes')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (243, N'Pamela', N'', N'Little')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (244, N'Janice', N'', N'Turner')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (245, N'Scott', N'', N'Gardner')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (246, N'George', N'', N'Richards')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (247, N'Brenda', N'', N'Henry')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (248, N'Joan', N'', N'White')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (249, N'Emily', N'', N'Freeman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (250, N'Larry', N'', N'Baker')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (251, N'Emily', N'', N'Murray')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (252, N'Joseph', N'', N'Jackson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (253, N'Norma', N'', N'Reynolds')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (254, N'Carl', N'', N'Bennett')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (255, N'Jane', N'', N'Riley')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (256, N'Bobby', N'', N'Reid')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (257, N'Ernest', N'', N'Garrett')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (258, N'Larry', N'', N'Burke')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (259, N'Jeremy', N'', N'Griffin')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (260, N'Beverly', N'', N'Pierce')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (261, N'Betty', N'', N'Ellis')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (262, N'Russell', N'', N'Martin')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (263, N'Sharon', N'', N'Mitchell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (264, N'Marie', N'', N'Nelson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (265, N'Larry', N'', N'Alexander')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (266, N'Anthony', N'', N'Hill')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (267, N'Roger', N'', N'Hudson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (268, N'Joan', N'', N'Jackson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (269, N'Angela', N'', N'Woods')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (270, N'Emily', N'', N'Wood')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (271, N'Charles', N'', N'Turner')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (272, N'Henry', N'', N'Banks')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (273, N'Phillip', N'', N'Riley')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (274, N'Harold', N'', N'Wright')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (275, N'Louise', N'', N'Gray')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (276, N'Melissa', N'', N'Franklin')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (277, N'Rose', N'', N'Stanley')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (278, N'Linda', N'', N'Bowman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (279, N'Karen', N'', N'Walker')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (280, N'Larry', N'', N'Fernandez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (281, N'Charles', N'', N'Watkins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (282, N'Paul', N'', N'Bailey')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (283, N'Catherine', N'', N'Long')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (284, N'Bonnie', N'', N'Mendoza')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (285, N'Sharon', N'', N'Gordon')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (286, N'Rebecca', N'', N'Hughes')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (287, N'Patricia', N'', N'Boyd')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (288, N'Bobby', N'', N'Reed')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (289, N'Matthew', N'', N'Garcia')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (290, N'Jimmy', N'', N'Palmer')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (291, N'Emily', N'', N'Martinez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (292, N'Richard', N'', N'Rice')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (293, N'Dorothy', N'', N'Johnson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (294, N'Brandon', N'', N'Ray')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (295, N'Roy', N'', N'Simpson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (296, N'Shawn', N'', N'Howard')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (297, N'Charles', N'', N'Bowman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (298, N'Ruth', N'', N'Ray')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (299, N'Roy', N'', N'Foster')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (300, N'Anthony', N'', N'Banks')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (301, N'Gregory', N'', N'Gibson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (302, N'Earl', N'', N'Williams')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (303, N'Katherine', N'', N'Watson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (304, N'Donna', N'', N'Owens')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (305, N'Johnny', N'', N'Ruiz')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (306, N'Wayne', N'', N'Schmidt')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (307, N'Jean', N'', N'Gray')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (308, N'Theresa', N'', N'Ramirez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (309, N'Andrew', N'', N'Diaz')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (310, N'Jose', N'', N'Barnes')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (311, N'Eugene', N'', N'Thompson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (312, N'Dennis', N'', N'Ramirez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (313, N'David', N'', N'Jenkins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (314, N'Richard', N'', N'Alexander')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (315, N'Christopher', N'', N'Thomas')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (316, N'Rebecca', N'', N'Gilbert')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (317, N'Douglas', N'', N'Martin')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (318, N'Lori', N'', N'Frazier')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (319, N'Bobby', N'', N'Boyd')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (320, N'Theresa', N'', N'Pierce')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (321, N'Dennis', N'', N'Fuller')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (322, N'Andrew', N'', N'Perez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (323, N'Wayne', N'', N'Garza')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (324, N'Anthony', N'', N'Ramos')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (325, N'Virginia', N'', N'Jackson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (326, N'Christina', N'', N'King')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (327, N'Rose', N'', N'Armstrong')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (328, N'Gary', N'', N'King')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (329, N'Anne', N'', N'Payne')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (330, N'Sandra', N'', N'Bishop')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (331, N'Mark', N'', N'Alvarez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (332, N'Jimmy', N'', N'Larson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (333, N'Eric', N'', N'Perez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (334, N'Janice', N'', N'Murray')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (335, N'Cynthia', N'', N'Nguyen')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (336, N'Gerald', N'', N'Henderson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (337, N'Marie', N'', N'Gutierrez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (338, N'Alan', N'', N'Lopez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (339, N'Jason', N'', N'Palmer')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (340, N'Debra', N'', N'Gordon')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (341, N'Frances', N'', N'Phillips')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (342, N'Walter', N'', N'Duncan')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (343, N'Kathy', N'', N'Garcia')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (344, N'Harry', N'', N'Woods')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (345, N'Gloria', N'', N'Stewart')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (346, N'Matthew', N'', N'Hunter')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (347, N'Clarence', N'', N'Lewis')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (348, N'Rose', N'', N'Gonzales')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (349, N'Steve', N'', N'Franklin')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (350, N'Timothy', N'', N'Ryan')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (351, N'Eric', N'', N'Alvarez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (352, N'Margaret', N'', N'Edwards')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (353, N'Debra', N'', N'Brooks')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (354, N'Jean', N'', N'Carter')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (355, N'Irene', N'', N'Ramos')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (356, N'Louise', N'', N'Rodriguez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (357, N'Roy', N'', N'Perry')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (358, N'Louise', N'', N'Fuller')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (359, N'Michael', N'', N'Matthews')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (360, N'Jesse', N'', N'Lane')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (361, N'Peter', N'', N'Daniels')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (362, N'Mark', N'', N'Russell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (363, N'Kathryn', N'', N'Lawson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (364, N'Katherine', N'', N'Hughes')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (365, N'Edward', N'', N'Lewis')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (366, N'Willie', N'', N'Burns')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (367, N'Jennifer', N'', N'Reynolds')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (368, N'Thomas', N'', N'Williams')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (369, N'Carl', N'', N'Rivera')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (370, N'Scott', N'', N'Rice')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (371, N'Howard', N'', N'Coleman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (372, N'Ruth', N'', N'Pierce')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (373, N'Martin', N'', N'Lopez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (374, N'Keith', N'', N'Rivera')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (375, N'Diane', N'', N'Bryant')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (376, N'Anna', N'', N'Fox')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (377, N'Jennifer', N'', N'Peters')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (378, N'Mary', N'', N'Murray')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (379, N'Joe', N'', N'Hall')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (380, N'Ernest', N'', N'Wilson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (381, N'Raymond', N'', N'Cruz')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (382, N'Albert', N'', N'Carroll')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (383, N'Martha', N'', N'Cole')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (384, N'Theresa', N'', N'Romero')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (385, N'Patricia', N'', N'Johnston')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (386, N'Scott', N'', N'Reed')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (387, N'Diane', N'', N'Rose')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (388, N'Jennifer', N'', N'Nichols')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (389, N'Lillian', N'', N'Berry')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (390, N'Larry', N'', N'Morris')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (391, N'Keith', N'', N'Owens')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (392, N'Daniel', N'', N'Hill')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (393, N'Jesse', N'', N'Andrews')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (394, N'Rebecca', N'', N'Stanley')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (395, N'Joseph', N'', N'Fisher')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (396, N'Sara', N'', N'Stewart')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (397, N'Fred', N'', N'Harvey')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (398, N'Alice', N'', N'Burke')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (399, N'Harold', N'', N'Johnson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (400, N'Joseph', N'', N'Burns')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (401, N'Jacqueline', N'', N'Cunningham')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (402, N'Timothy', N'', N'Butler')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (403, N'Bruce', N'', N'Franklin')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (404, N'Anne', N'', N'James')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (405, N'Nancy', N'', N'Hart')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (406, N'Christine', N'', N'Hart')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (407, N'Brenda', N'', N'Franklin')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (408, N'Judy', N'', N'Cole')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (409, N'Rebecca', N'', N'Howard')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (410, N'Theresa', N'', N'Coleman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (411, N'Anthony', N'', N'Davis')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (412, N'Matthew', N'', N'Murphy')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (413, N'Russell', N'', N'Burns')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (414, N'Daniel', N'', N'Spencer')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (415, N'Susan', N'', N'Tucker')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (416, N'Johnny', N'', N'Ford')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (417, N'Elizabeth', N'', N'Brown')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (418, N'Joe', N'', N'Smith')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (419, N'Ernest', N'', N'Day')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (420, N'Angela', N'', N'Dunn')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (421, N'Roger', N'', N'Moreno')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (422, N'Brandon', N'', N'Evans')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (423, N'Brandon', N'', N'Evans')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (424, N'Annie', N'', N'Perez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (425, N'Steven', N'', N'Williams')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (426, N'Joshua', N'', N'Warren')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (427, N'Clarence', N'', N'Cruz')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (428, N'Katherine', N'', N'Lynch')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (429, N'Anna', N'', N'Wilson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (430, N'Shirley', N'', N'Marshall')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (431, N'Sean', N'', N'Mccoy')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (432, N'Juan', N'', N'Cunningham')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (433, N'Gregory', N'', N'Kelley')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (434, N'Scott', N'', N'Cruz')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (435, N'Anthony', N'', N'Hart')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (436, N'Teresa', N'', N'Bryant')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (437, N'Steven', N'', N'Anderson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (438, N'Donna', N'', N'Elliott')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (439, N'Lisa', N'', N'Peterson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (440, N'Kathleen', N'', N'Diaz')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (441, N'Betty', N'', N'Frazier')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (442, N'Mildred', N'', N'Franklin')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (443, N'Jacqueline', N'', N'Bryant')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (444, N'Brian', N'', N'Reynolds')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (445, N'Lori', N'', N'Collins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (446, N'Bonnie', N'', N'Sanders')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (447, N'Patricia', N'', N'Howell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (448, N'Ashley', N'', N'Williams')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (449, N'Eric', N'', N'Murray')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (450, N'Eugene', N'', N'Harper')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (451, N'Anna', N'', N'Hunter')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (452, N'Earl', N'', N'Davis')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (453, N'Albert', N'', N'Mills')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (454, N'Emily', N'', N'Hunter')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (455, N'Roy', N'', N'Lynch')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (456, N'Bruce', N'', N'Moreno')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (457, N'Jonathan', N'', N'Powell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (458, N'Dorothy', N'', N'Parker')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (459, N'Ronald', N'', N'Bailey')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (460, N'Aaron', N'', N'Romero')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (461, N'Howard', N'', N'Allen')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (462, N'Billy', N'', N'Reyes')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (463, N'Carl', N'', N'Gardner')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (464, N'Phillip', N'', N'Hamilton')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (465, N'Paul', N'', N'Greene')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (466, N'Ernest', N'', N'Ortiz')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (467, N'Peter', N'', N'Greene')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (468, N'Debra', N'', N'Lawson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (469, N'Russell', N'', N'Young')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (470, N'Fred', N'', N'Fowler')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (471, N'Maria', N'', N'Reid')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (472, N'Shirley', N'', N'Shaw')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (473, N'John', N'', N'Foster')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (474, N'Sarah', N'', N'George')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (475, N'Jeffrey', N'', N'Burns')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (476, N'Laura', N'', N'Bryant')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (477, N'Ruby', N'', N'Allen')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (478, N'Douglas', N'', N'Arnold')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (479, N'Timothy', N'', N'Richardson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (480, N'Gregory', N'', N'Fuller')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (481, N'Lillian', N'', N'Reed')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (482, N'Christine', N'', N'Freeman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (483, N'Steve', N'', N'Johnson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (484, N'Chris', N'', N'Hamilton')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (485, N'Judy', N'', N'Richards')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (486, N'Jimmy', N'', N'Rogers')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (487, N'Stephen', N'', N'Thompson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (488, N'Philip', N'', N'Lane')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (489, N'Craig', N'', N'Carter')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (490, N'Carol', N'', N'Campbell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (491, N'Howard', N'', N'Holmes')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (492, N'Tina', N'', N'Torres')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (493, N'Helen', N'', N'Mendoza')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (494, N'Louise', N'', N'Palmer')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (495, N'Samuel', N'', N'Parker')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (496, N'Raymond', N'', N'Hunt')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (497, N'Donna', N'', N'Marshall')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (498, N'Jean', N'', N'Greene')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (499, N'Paul', N'', N'Collins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (500, N'Amy', N'', N'Kim')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (501, N'Randy', N'', N'Weaver')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (502, N'Christina', N'', N'Myers')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (503, N'Joyce', N'', N'Little')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (504, N'Raymond', N'', N'Rivera')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (505, N'Randy', N'', N'Garza')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (506, N'Joyce', N'', N'Carr')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (507, N'Kathryn', N'', N'Vasquez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (508, N'Kenneth', N'', N'Johnston')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (509, N'Jack', N'', N'Foster')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (510, N'Sharon', N'', N'Medina')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (511, N'Scott', N'', N'Wilson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (512, N'Roger', N'', N'Perry')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (513, N'Ryan', N'', N'Foster')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (514, N'Susan', N'', N'Griffin')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (515, N'Carolyn', N'', N'Thompson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (516, N'Walter', N'', N'Williamson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (517, N'Kenneth', N'', N'Hunter')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (518, N'Jerry', N'', N'Jacobs')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (519, N'Steven', N'', N'Chavez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (520, N'Walter', N'', N'Moore')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (521, N'Michelle', N'', N'Marshall')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (522, N'Louis', N'', N'Elliott')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (523, N'Matthew', N'', N'Dean')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (524, N'Earl', N'', N'Green')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (525, N'Paul', N'', N'Hughes')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (526, N'John', N'', N'Garcia')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (527, N'Katherine', N'', N'Burns')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (528, N'Charles', N'', N'Richardson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (529, N'Anne', N'', N'Robinson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (530, N'Angela', N'', N'Ramirez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (531, N'Maria', N'', N'Carter')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (532, N'Christina', N'', N'Wilson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (533, N'Deborah', N'', N'Hunt')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (534, N'Samuel', N'', N'Diaz')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (535, N'Kimberly', N'', N'Phillips')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (536, N'Clarence', N'', N'Weaver')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (537, N'Anthony', N'', N'Bishop')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (538, N'Robin', N'', N'Gomez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (539, N'Justin', N'', N'Diaz')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (540, N'Kathryn', N'', N'Powell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (541, N'Ann', N'', N'Williamson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (542, N'Susan', N'', N'Chapman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (543, N'Rachel', N'', N'Ford')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (544, N'Adam', N'', N'Marshall')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (545, N'Kathleen', N'', N'Hansen')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (546, N'Julie', N'', N'Martin')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (547, N'Cheryl', N'', N'Wheeler')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (548, N'Tina', N'', N'George')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (549, N'Shirley', N'', N'Hawkins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (550, N'Lawrence', N'', N'Stevens')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (551, N'Katherine', N'', N'Rose')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (552, N'Kenneth', N'', N'Vasquez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (553, N'Edward', N'', N'Fisher')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (554, N'Evelyn', N'', N'Hernandez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (555, N'Harry', N'', N'Fernandez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (556, N'Bonnie', N'', N'Holmes')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (557, N'Michael', N'', N'Gray')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (558, N'Joyce', N'', N'Cook')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (559, N'Victor', N'', N'Mendoza')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (560, N'Earl', N'', N'Ward')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (561, N'Emily', N'', N'Crawford')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (562, N'Benjamin', N'', N'Ramos')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (563, N'Lisa', N'', N'Washington')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (564, N'Beverly', N'', N'Green')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (565, N'Sara', N'', N'Black')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (566, N'Katherine', N'', N'King')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (567, N'Bobby', N'', N'Crawford')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (568, N'Phyllis', N'', N'Gonzales')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (569, N'Wanda', N'', N'Wilson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (570, N'Janet', N'', N'Bryant')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (571, N'Judy', N'', N'Griffin')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (572, N'Matthew', N'', N'Evans')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (573, N'Rose', N'', N'Russell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (574, N'Jose', N'', N'Myers')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (575, N'Janice', N'', N'Fields')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (576, N'Brian', N'', N'Cox')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (577, N'John', N'', N'Alexander')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (578, N'Lori', N'', N'Butler')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (579, N'Kathleen', N'', N'Myers')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (580, N'Beverly', N'', N'Fisher')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (581, N'Irene', N'', N'Olson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (582, N'Jeffrey', N'', N'Hunt')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (583, N'Paula', N'', N'Fowler')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (584, N'Ryan', N'', N'Garza')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (585, N'William', N'', N'Ferguson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (586, N'Judith', N'', N'Richardson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (587, N'Ashley', N'', N'Gray')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (588, N'Kevin', N'', N'Morrison')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (589, N'Shirley', N'', N'Ortiz')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (590, N'Gregory', N'', N'Parker')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (591, N'Brandon', N'', N'Sanders')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (592, N'Phyllis', N'', N'Simmons')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (593, N'Sean', N'', N'Cole')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (594, N'Fred', N'', N'Moreno')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (595, N'Dorothy', N'', N'Duncan')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (596, N'Patricia', N'', N'Washington')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (597, N'John', N'', N'Robertson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (598, N'Anna', N'', N'Lawson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (599, N'Randy', N'', N'Myers')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (600, N'Carlos', N'', N'Fox')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (601, N'Elizabeth', N'', N'Martinez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (602, N'Catherine', N'', N'Richards')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (603, N'Helen', N'', N'Hawkins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (604, N'Daniel', N'', N'Lopez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (605, N'Marie', N'', N'Harvey')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (606, N'Carlos', N'', N'Jordan')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (607, N'Rose', N'', N'Harrison')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (608, N'Debra', N'', N'Mendoza')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (609, N'Melissa', N'', N'Mendoza')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (610, N'Donald', N'', N'Crawford')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (611, N'Brian', N'', N'Sanders')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (612, N'Nicole', N'', N'Butler')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (613, N'Louis', N'', N'Bishop')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (614, N'Louis', N'', N'Black')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (615, N'Earl', N'', N'Ford')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (616, N'Doris', N'', N'Tucker')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (617, N'Rose', N'', N'Sanders')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (618, N'Patricia', N'', N'Jenkins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (619, N'Ruth', N'', N'Nelson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (620, N'Rose', N'', N'Rogers')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (621, N'Earl', N'', N'Arnold')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (622, N'Debra', N'', N'Castillo')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (623, N'Richard', N'', N'Howell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (624, N'Melissa', N'', N'Davis')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (625, N'Marie', N'', N'Diaz')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (626, N'Brandon', N'', N'Brooks')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (627, N'Beverly', N'', N'Edwards')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (628, N'Kathy', N'', N'Perkins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (629, N'Bruce', N'', N'Ramos')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (630, N'Ernest', N'', N'Porter')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (631, N'Deborah', N'', N'Harris')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (632, N'Chris', N'', N'Burton')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (633, N'Brenda', N'', N'Welch')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (634, N'Mary', N'', N'Wallace')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (635, N'Juan', N'', N'Washington')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (636, N'Pamela', N'', N'Wilson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (637, N'Beverly', N'', N'Cole')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (638, N'Jessica', N'', N'Carter')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (639, N'Kathy', N'', N'Taylor')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (640, N'Edward', N'', N'Fernandez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (641, N'Henry', N'', N'Robinson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (642, N'Joseph', N'', N'Freeman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (643, N'Nicholas', N'', N'Mason')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (644, N'Eric', N'', N'Foster')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (645, N'Samuel', N'', N'Simpson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (646, N'Joseph', N'', N'Watson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (647, N'Billy', N'', N'King')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (648, N'Steven', N'', N'Jenkins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (649, N'Emily', N'', N'Kelley')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (650, N'Raymond', N'', N'Green')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (651, N'Janice', N'', N'Dean')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (652, N'Harry', N'', N'Rose')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (653, N'Charles', N'', N'Butler')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (654, N'Emily', N'', N'Alexander')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (655, N'Kathryn', N'', N'Murphy')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (656, N'Sara', N'', N'Wilson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (657, N'Andrew', N'', N'Fowler')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (658, N'Richard', N'', N'Stewart')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (659, N'Pamela', N'', N'Watson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (660, N'Nancy', N'', N'Mendoza')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (661, N'Sean', N'', N'Burke')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (662, N'Helen', N'', N'Armstrong')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (663, N'Scott', N'', N'Young')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (664, N'Amy', N'', N'Evans')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (665, N'Jane', N'', N'Dunn')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (666, N'Patrick', N'', N'Schmidt')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (667, N'Todd', N'', N'Rogers')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (668, N'Sarah', N'', N'Willis')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (669, N'Steve', N'', N'Patterson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (670, N'Laura', N'', N'Jones')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (671, N'Mary', N'', N'Hamilton')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (672, N'Brian', N'', N'Hernandez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (673, N'Mark', N'', N'Lewis')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (674, N'Margaret', N'', N'Miller')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (675, N'Wayne', N'', N'Cook')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (676, N'Thomas', N'', N'Mccoy')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (677, N'Alan', N'', N'Lee')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (678, N'Jean', N'', N'Richards')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (679, N'Jonathan', N'', N'Collins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (680, N'Maria', N'', N'Wheeler')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (681, N'Kelly', N'', N'Woods')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (682, N'Matthew', N'', N'Thomas')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (683, N'Jane', N'', N'Gomez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (684, N'Carol', N'', N'White')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (685, N'Gerald', N'', N'Torres')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (686, N'Eric', N'', N'Roberts')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (687, N'James', N'', N'Wheeler')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (688, N'Dennis', N'', N'Lawson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (689, N'Julia', N'', N'Reynolds')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (690, N'Joshua', N'', N'Henry')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (691, N'Carlos', N'', N'Perkins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (692, N'Todd', N'', N'Peterson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (693, N'Ruby', N'', N'Henderson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (694, N'Robert', N'', N'Henderson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (695, N'Lisa', N'', N'Knight')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (696, N'Betty', N'', N'Tucker')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (697, N'Lori', N'', N'Harris')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (698, N'Kevin', N'', N'Coleman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (699, N'Richard', N'', N'Hill')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (700, N'Clarence', N'', N'Cunningham')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (701, N'Rachel', N'', N'Willis')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (702, N'Judy', N'', N'Gilbert')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (703, N'Kimberly', N'', N'Hughes')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (704, N'Sandra', N'', N'Lopez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (705, N'Frances', N'', N'Nichols')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (706, N'Robin', N'', N'Crawford')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (707, N'Julie', N'', N'Snyder')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (708, N'Gloria', N'', N'Peterson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (709, N'Irene', N'', N'Gomez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (710, N'Jose', N'', N'Nelson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (711, N'Kathy', N'', N'Lane')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (712, N'Wayne', N'', N'Young')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (713, N'Marilyn', N'', N'James')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (714, N'Bonnie', N'', N'Montgomery')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (715, N'Norma', N'', N'Carr')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (716, N'Diane', N'', N'Taylor')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (717, N'Linda', N'', N'Campbell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (718, N'Jesse', N'', N'Owens')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (719, N'Christine', N'', N'Morgan')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (720, N'Mildred', N'', N'Burke')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (721, N'Shirley', N'', N'Henderson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (722, N'Donald', N'', N'Garcia')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (723, N'Donald', N'', N'Cook')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (724, N'Kathleen', N'', N'Hayes')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (725, N'Steve', N'', N'Dunn')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (726, N'Jose', N'', N'Franklin')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (727, N'Diane', N'', N'Matthews')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (728, N'Virginia', N'', N'Bradley')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (729, N'David', N'', N'Collins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (730, N'Barbara', N'', N'Wood')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (731, N'Jack', N'', N'Rivera')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (732, N'Gloria', N'', N'Fuller')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (733, N'Jean', N'', N'Freeman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (734, N'Ronald', N'', N'Chapman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (735, N'John', N'', N'Day')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (736, N'Julie', N'', N'Garrett')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (737, N'Sean', N'', N'Howard')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (738, N'Cheryl', N'', N'Simpson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (739, N'Michael', N'', N'Simmons')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (740, N'Peter', N'', N'Payne')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (741, N'James', N'', N'Flores')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (742, N'Sara', N'', N'Fisher')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (743, N'Jessica', N'', N'Marshall')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (744, N'Thomas', N'', N'Hughes')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (745, N'Ruby', N'', N'Harper')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (746, N'Anne', N'', N'Woods')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (747, N'Janet', N'', N'Lewis')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (748, N'Harold', N'', N'Morgan')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (749, N'Susan', N'', N'Webb')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (750, N'Anne', N'', N'Johnston')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (751, N'Benjamin', N'', N'Hunt')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (752, N'Dennis', N'', N'Daniels')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (753, N'Christopher', N'', N'Nichols')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (754, N'Eric', N'', N'Walker')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (755, N'Judy', N'', N'Ramos')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (756, N'Harry', N'', N'Jones')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (757, N'Brandon', N'', N'Campbell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (758, N'Emily', N'', N'Baker')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (759, N'Karen', N'', N'Chavez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (760, N'Donald', N'', N'Lee')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (761, N'Karen', N'', N'Day')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (762, N'Michael', N'', N'Fuller')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (763, N'Brian', N'', N'Wallace')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (764, N'Samuel', N'', N'Rose')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (765, N'Wanda', N'', N'Young')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (766, N'Philip', N'', N'Ramos')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (767, N'Annie', N'', N'Nichols')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (768, N'Diane', N'', N'Hart')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (769, N'Ruth', N'', N'Reyes')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (770, N'Sharon', N'', N'Berry')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (771, N'Victor', N'', N'Allen')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (772, N'Brenda', N'', N'Reed')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (773, N'Ruby', N'', N'Hamilton')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (774, N'Norma', N'', N'Hawkins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (775, N'Ruth', N'', N'Kim')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (776, N'Frank', N'', N'Rogers')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (777, N'Lori', N'', N'Simpson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (778, N'Henry', N'', N'Watson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (779, N'Mary', N'', N'Meyer')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (780, N'Ryan', N'', N'Mitchell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (781, N'Randy', N'', N'Hanson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (782, N'Amy', N'', N'Vasquez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (783, N'Anne', N'', N'Jenkins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (784, N'Jesse', N'', N'Cunningham')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (785, N'Christina', N'', N'Jacobs')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (786, N'Benjamin', N'', N'Allen')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (787, N'Juan', N'', N'Fernandez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (788, N'Ryan', N'', N'Torres')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (789, N'Antonio', N'', N'Harper')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (790, N'Philip', N'', N'Morgan')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (791, N'Martha', N'', N'Snyder')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (792, N'Aaron', N'', N'James')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (793, N'Ann', N'', N'Rivera')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (794, N'James', N'', N'Rogers')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (795, N'Katherine', N'', N'Wilson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (796, N'Janet', N'', N'Rivera')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (797, N'Paul', N'', N'Hansen')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (798, N'Jesse', N'', N'Scott')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (799, N'Brenda', N'', N'Weaver')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (800, N'Steven', N'', N'Ferguson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (801, N'Sharon', N'', N'Austin')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (802, N'Edward', N'', N'Lee')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (803, N'Jack', N'', N'Thompson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (804, N'Bobby', N'', N'Williams')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (805, N'Wayne', N'', N'Hawkins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (806, N'Patrick', N'', N'Washington')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (807, N'Ralph', N'', N'Fox')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (808, N'Angela', N'', N'Lawson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (809, N'Joan', N'', N'Brooks')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (810, N'Marilyn', N'', N'Bell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (811, N'Larry', N'', N'Harvey')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (812, N'Deborah', N'', N'Allen')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (813, N'Jack', N'', N'Morrison')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (814, N'Jose', N'', N'Black')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (815, N'Linda', N'', N'Carter')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (816, N'Howard', N'', N'Coleman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (817, N'Andrew', N'', N'Murphy')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (818, N'Jason', N'', N'Nguyen')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (819, N'Eric', N'', N'Hart')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (820, N'Barbara', N'', N'Payne')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (821, N'Teresa', N'', N'Carpenter')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (822, N'Heather', N'', N'Butler')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (823, N'Joseph', N'', N'Martin')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (824, N'Tina', N'', N'Bailey')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (825, N'Raymond', N'', N'Williams')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (826, N'Ruby', N'', N'Fowler')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (827, N'Ronald', N'', N'Mitchell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (828, N'Ronald', N'', N'Richardson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (829, N'Ralph', N'', N'Matthews')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (830, N'Jason', N'', N'Holmes')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (831, N'Ruth', N'', N'Welch')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (832, N'Kathy', N'', N'Morrison')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (833, N'Joshua', N'', N'Frazier')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (834, N'Evelyn', N'', N'Reed')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (835, N'Karen', N'', N'Lewis')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (836, N'Cheryl', N'', N'Ross')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (837, N'Stephanie', N'', N'Reynolds')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (838, N'Jack', N'', N'Schmidt')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (839, N'Peter', N'', N'Kelley')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (840, N'Emily', N'', N'Washington')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (841, N'Louis', N'', N'Allen')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (842, N'Willie', N'', N'Mills')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (843, N'Sean', N'', N'Alexander')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (844, N'Ralph', N'', N'Harrison')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (845, N'Joseph', N'', N'Smith')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (846, N'Richard', N'', N'West')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (847, N'Julie', N'', N'Chapman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (848, N'Beverly', N'', N'Young')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (849, N'Cynthia', N'', N'Mccoy')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (850, N'Judith', N'', N'Castillo')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (851, N'Russell', N'', N'Edwards')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (852, N'Phyllis', N'', N'Reed')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (853, N'Cheryl', N'', N'Barnes')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (854, N'Virginia', N'', N'Payne')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (855, N'Marilyn', N'', N'Meyer')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (856, N'Walter', N'', N'Young')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (857, N'Todd', N'', N'Willis')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (858, N'Nicholas', N'', N'Bowman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (859, N'Timothy', N'', N'Ray')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (860, N'Ruby', N'', N'Bailey')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (861, N'Willie', N'', N'Larson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (862, N'Jessica', N'', N'Peters')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (863, N'Susan', N'', N'Kelley')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (864, N'Anthony', N'', N'Knight')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (865, N'Patricia', N'', N'Harrison')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (866, N'Bobby', N'', N'Mccoy')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (867, N'Wanda', N'', N'Gonzalez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (868, N'Ruth', N'', N'Johnson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (869, N'Amy', N'', N'Crawford')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (870, N'Alice', N'', N'Parker')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (871, N'Kathryn', N'', N'Robinson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (872, N'Samuel', N'', N'Schmidt')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (873, N'Judith', N'', N'Reyes')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (874, N'Andrea', N'', N'Larson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (875, N'Willie', N'', N'Gordon')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (876, N'Louis', N'', N'Hawkins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (877, N'Joan', N'', N'Russell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (878, N'Pamela', N'', N'Lopez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (879, N'Anne', N'', N'Alvarez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (880, N'Willie', N'', N'Bryant')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (881, N'Elizabeth', N'', N'Knight')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (882, N'Ruth', N'', N'Banks')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (883, N'Alan', N'', N'Butler')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (884, N'Larry', N'', N'Gutierrez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (885, N'Stephanie', N'', N'Hawkins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (886, N'Jimmy', N'', N'Wallace')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (887, N'Raymond', N'', N'Alvarez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (888, N'Mark', N'', N'Williams')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (889, N'Samuel', N'', N'Lewis')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (890, N'Gregory', N'', N'Torres')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (891, N'Peter', N'', N'Burke')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (892, N'Norma', N'', N'Burton')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (893, N'John', N'', N'Barnes')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (894, N'Diana', N'', N'Murphy')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (895, N'Timothy', N'', N'Ryan')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (896, N'Willie', N'', N'Hunt')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (897, N'Marilyn', N'', N'Porter')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (898, N'Jacqueline', N'', N'Morrison')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (899, N'Amy', N'', N'Hanson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (900, N'Doris', N'', N'Mitchell')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (901, N'Harold', N'', N'Ruiz')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (902, N'Linda', N'', N'Richardson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (903, N'Lori', N'', N'Henderson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (904, N'Mildred', N'', N'Garrett')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (905, N'Mildred', N'', N'Ray')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (906, N'Paula', N'', N'Frazier')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (907, N'Philip', N'', N'Henry')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (908, N'Angela', N'', N'Roberts')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (909, N'Harold', N'', N'Gilbert')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (910, N'Walter', N'', N'Peters')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (911, N'Mark', N'', N'Harrison')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (912, N'Lois', N'', N'Taylor')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (913, N'Diane', N'', N'Gibson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (914, N'Jennifer', N'', N'Stanley')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (915, N'Brandon', N'', N'Rose')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (916, N'Antonio', N'', N'Alvarez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (917, N'Earl', N'', N'Marshall')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (918, N'Debra', N'', N'Allen')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (919, N'Irene', N'', N'Gonzalez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (920, N'Jane', N'', N'Dunn')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (921, N'Charles', N'', N'Johnson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (922, N'Rose', N'', N'Barnes')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (923, N'Nicholas', N'', N'Ray')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (924, N'Betty', N'', N'Kelly')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (925, N'Jack', N'', N'Collins')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (926, N'Sean', N'', N'Reid')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (927, N'Russell', N'', N'Frazier')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (928, N'Betty', N'', N'Flores')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (929, N'Stephen', N'', N'Fisher')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (930, N'Angela', N'', N'Alexander')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (931, N'Kenneth', N'', N'Richardson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (932, N'Laura', N'', N'Tucker')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (933, N'Gary', N'', N'Frazier')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (934, N'Ruby', N'', N'Lee')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (935, N'Bobby', N'', N'Elliott')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (936, N'Scott', N'', N'Lee')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (937, N'Louise', N'', N'Carter')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (938, N'Christine', N'', N'Austin')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (939, N'Rebecca', N'', N'Gibson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (940, N'Shawn', N'', N'Stewart')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (941, N'Arthur', N'', N'Hudson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (942, N'Pamela', N'', N'Carroll')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (943, N'Ann', N'', N'Gutierrez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (944, N'George', N'', N'Carpenter')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (945, N'Nicholas', N'', N'Reyes')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (946, N'Michelle', N'', N'Knight')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (947, N'Rebecca', N'', N'Turner')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (948, N'Harold', N'', N'Butler')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (949, N'Sharon', N'', N'Gomez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (950, N'Melissa', N'', N'Bowman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (951, N'Harry', N'', N'Cook')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (952, N'Jimmy', N'', N'Smith')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (953, N'Gregory', N'', N'Welch')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (954, N'Clarence', N'', N'Rose')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (955, N'Eugene', N'', N'Medina')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (956, N'Marilyn', N'', N'Kennedy')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (957, N'Kimberly', N'', N'Warren')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (958, N'Eric', N'', N'Berry')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (959, N'Stephanie', N'', N'Gomez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (960, N'Timothy', N'', N'Hernandez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (961, N'Eric', N'', N'Stewart')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (962, N'Beverly', N'', N'Martinez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (963, N'Teresa', N'', N'Henry')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (964, N'Janet', N'', N'Romero')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (965, N'Earl', N'', N'Bowman')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (966, N'Harry', N'', N'Morris')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (967, N'Nicole', N'', N'Lopez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (968, N'Alan', N'', N'Nguyen')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (969, N'William', N'', N'Hughes')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (970, N'Jerry', N'', N'Ramirez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (971, N'Antonio', N'', N'Morris')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (972, N'Evelyn', N'', N'Dean')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (973, N'Ruby', N'', N'Mendoza')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (974, N'Adam', N'', N'Ryan')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (975, N'Kevin', N'', N'Mcdonald')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (976, N'Dorothy', N'', N'Roberts')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (977, N'Fred', N'', N'Woods')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (978, N'Susan', N'', N'Meyer')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (979, N'Susan', N'', N'Richards')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (980, N'Daniel', N'', N'Washington')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (981, N'Sharon', N'', N'Wood')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (982, N'Joshua', N'', N'Gutierrez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (983, N'Bobby', N'', N'Holmes')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (984, N'Henry', N'', N'Mcdonald')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (985, N'Robert', N'', N'Harris')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (986, N'Jeremy', N'', N'Alexander')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (987, N'Elizabeth', N'', N'Miller')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (988, N'Johnny', N'', N'Arnold')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (989, N'Diana', N'', N'Rice')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (990, N'Wanda', N'', N'Sanchez')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (991, N'Donald', N'', N'Ross')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (992, N'Kathryn', N'', N'Carroll')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (993, N'Edward', N'', N'Wilson')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (994, N'Stephanie', N'', N'Lawrence')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (995, N'Lisa', N'', N'Flores')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (996, N'Rachel', N'', N'Taylor')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (997, N'Margaret', N'', N'West')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (998, N'Sandra', N'', N'Perry')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (999, N'George', N'', N'Lewis')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (1000, N'Terry', N'', N'Burton')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (1001, N'Alan', N'', N'Harvey')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (1002, N'Donna', N'', N'Daniels')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (1003, N'Theresa', N'', N'Berry')
GO
INSERT [dbo].[Person] ([PersonId], [FirstName], [MiddleName], [LastName]) VALUES (2009, N'ZaneBlah', N'blahZane', N'Zuppa')
GO
SET IDENTITY_INSERT [dbo].[Person] OFF
GO
SET IDENTITY_INSERT [dbo].[Project] ON 

GO
INSERT [dbo].[Project] ([ProjectId], [StatusId], [Name], [PlannedStartDate], [ActualStartDate], [PlannedEndDate], [ActualEndDate], [CompanyId]) VALUES (1, 3, N'Project64x', CAST(0x9A370B00 AS Date), NULL, CAST(0xFD3C0B00 AS Date), NULL, 3)
GO
INSERT [dbo].[Project] ([ProjectId], [StatusId], [Name], [PlannedStartDate], [ActualStartDate], [PlannedEndDate], [ActualEndDate], [CompanyId]) VALUES (2, 1, N'SpaceX', CAST(0x95230B00 AS Date), NULL, CAST(0xA0240B00 AS Date), NULL, 1)
GO
INSERT [dbo].[Project] ([ProjectId], [StatusId], [Name], [PlannedStartDate], [ActualStartDate], [PlannedEndDate], [ActualEndDate], [CompanyId]) VALUES (3, 2, N'McDonalds', CAST(0x26390B00 AS Date), NULL, NULL, NULL, 1)
GO
INSERT [dbo].[Project] ([ProjectId], [StatusId], [Name], [PlannedStartDate], [ActualStartDate], [PlannedEndDate], [ActualEndDate], [CompanyId]) VALUES (4, 3, N'TestProject', CAST(0x103A0B00 AS Date), NULL, NULL, NULL, 3)
GO
SET IDENTITY_INSERT [dbo].[Project] OFF
GO
SET IDENTITY_INSERT [dbo].[Status] ON 

GO
INSERT [dbo].[Status] ([StatusId], [Name]) VALUES (1, N'Done')
GO
INSERT [dbo].[Status] ([StatusId], [Name]) VALUES (2, N'In Progress')
GO
INSERT [dbo].[Status] ([StatusId], [Name]) VALUES (3, N'Not Started')
GO
SET IDENTITY_INSERT [dbo].[Status] OFF
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'ALASKA', N'AK')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'ALABAMA', N'AL')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'ARKANSAS', N'AR')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'ARIZONA', N'AZ')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'CALIFORNIA', N'CA')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'COLORADO', N'CO')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'CONNECTICUT', N'CT')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'District of Columbia', N'DC')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'DELAWARE', N'DE')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'FLORIDA', N'FL')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'GEORGIA', N'GA')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'HAWAII', N'HI')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'IOWA', N'IA')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'IDAHO', N'ID')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'ILLINOIS', N'IL')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'INDIANA', N'IN')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'KANSAS', N'KS')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'KENTUCKY', N'KY')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'LOUISIANA', N'LA')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'MASSACHUSETTS', N'MA')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'MARYLAND', N'MD')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'MAINE', N'ME')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'MICHIGAN', N'MI')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'MINNESOTA', N'MN')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'MISSOURI', N'MO')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'MISSISSIPPI', N'MS')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'MONTANA', N'MT')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'NORTH CAROLINA', N'NC')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'NORTH DAKOTA', N'ND')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'NEBRASKA', N'NE')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'NEW HAMPSHIRE', N'NH')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'NEW JERSEY', N'NJ')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'NEW MEXICO', N'NM')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'NEVADA', N'NV')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'NEW YORK', N'NY')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'OHIO', N'OH')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'OKLAHOMA', N'OK')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'OREGON', N'OR')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'PENNSYLVANIA', N'PA')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'RHODE ISLAND', N'RI')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'SOUTH CAROLINA', N'SC')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'SOUTH DAKOTA', N'SD')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'TENNESSEE', N'TN')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'TEXAS', N'TX')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'UTAH', N'UT')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'VIRGINIA', N'VA')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'VERMONT', N'VT')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'WASHINGTON', N'WA')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'WISCONSIN', N'WI')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'WEST VIRGINIA', N'WV')
GO
INSERT [dbo].[USStates] ([name], [abbreviation]) VALUES (N'WYOMING', N'WY')
GO
ALTER TABLE [dbo].[Assignment]  WITH CHECK ADD  CONSTRAINT [FK_Assignment_Employee1] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([EmployeeId])
GO
ALTER TABLE [dbo].[Assignment] CHECK CONSTRAINT [FK_Assignment_Employee1]
GO
ALTER TABLE [dbo].[Assignment]  WITH CHECK ADD  CONSTRAINT [FK_Assignment_Project1] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[Assignment] CHECK CONSTRAINT [FK_Assignment_Project1]
GO
ALTER TABLE [dbo].[Company]  WITH CHECK ADD  CONSTRAINT [FK_Company_USStates] FOREIGN KEY([StateId])
REFERENCES [dbo].[USStates] ([abbreviation])
GO
ALTER TABLE [dbo].[Company] CHECK CONSTRAINT [FK_Company_USStates]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Company]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Person] FOREIGN KEY([PersonId])
REFERENCES [dbo].[Person] ([PersonId])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Person]
GO
ALTER TABLE [dbo].[Project]  WITH CHECK ADD  CONSTRAINT [FK_Project_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[Project] CHECK CONSTRAINT [FK_Project_Company]
GO
ALTER TABLE [dbo].[Project]  WITH CHECK ADD  CONSTRAINT [FK_Project_Status1] FOREIGN KEY([StatusId])
REFERENCES [dbo].[Status] ([StatusId])
GO
ALTER TABLE [dbo].[Project] CHECK CONSTRAINT [FK_Project_Status1]
GO
USE [master]
GO
ALTER DATABASE [SolutiaCMS] SET  READ_WRITE 
GO
