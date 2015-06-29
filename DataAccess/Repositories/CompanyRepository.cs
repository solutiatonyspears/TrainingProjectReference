using DataAccess.Interfaces;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using DataAccess.DataModels;
using System.Data;
using DataAccess.DataAdapters;
using DataAccess.DataContracts;

namespace DataAccess.Repositories
{
  public class CompanyRepository : Repository, ICompanyRepository, IEmployeeRepository
    {
        public DataContracts.ICompany AddCompany(DataContracts.ICompany company)
        {
            Company newCompany = null;
            using(var connection = new SqlConnection(base.ConnectionString))
            {
                connection.Open();

                using( var command = new SqlCommand("sp_CompanyCreate", connection))
                {
                    command.CommandType = System.Data.CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@Name", company.Name);
                    command.Parameters.AddWithValue("@Address1", company.Address.Street1);
                    command.Parameters.AddWithValue("@Address2", company.Address.Street2);
                    command.Parameters.AddWithValue("@City", company.Address.City);
                    command.Parameters.AddWithValue("@StateId", company.Address.StateCode);
                    command.Parameters.AddWithValue("@Zip", company.Address.PostalCode);
                    command.Parameters.AddWithValue("@PhoneNumber", company.PhoneNumber);

                    connection.Open();
                    var dataReader = command.ExecuteReader();

                    //Get the newly created Company.
                    while (dataReader.Read())
                    {
                        newCompany = (Company)new CompanyAdapter().Resolve(new Company(), dataReader);
                    }
                }
            }

            return newCompany;
        }

        public DataContracts.ICompany UpdateCompany(DataContracts.ICompany company)
        {
            using(var connection = new SqlConnection(base.ConnectionString))
            {
                
                using(var command = new SqlCommand("UPDATE COMPANY SET NAME = @Name, ADDRESS1 = @Address1, ADDRESS2 = @Address2, CITY = @City, STATEID = @StateID, ZIP = @Zip, PHONENUMBER = @PhoneNumber WHERE CompanyID = @CompanyID", connection))
                {
                    command.Parameters.AddWithValue("@Name", company.Name);
                    command.Parameters.AddWithValue("@Address1", company.Address.Street1);
                    command.Parameters.AddWithValue("@Address2", company.Address.Street2);
                    command.Parameters.AddWithValue("@City", company.Address.City);
                    command.Parameters.AddWithValue("@StateId", company.Address.StateCode);
                    command.Parameters.AddWithValue("@Zip", company.Address.PostalCode);
                    command.Parameters.AddWithValue("@PhoneNumber", company.PhoneNumber);
                    command.Parameters.AddWithValue("@CompanyId", company.CompanyId);

                    connection.Open();
                    command.ExecuteNonQuery();
                    connection.Close();
                }
            }
            return company;
        }

        public void DeleteCompany(int companyId)
        {
           using(var connection = new SqlConnection(base.ConnectionString))
           {
               using(var command = new SqlCommand("sp_CompanyDelete", connection))
               {
                   command.Parameters.AddWithValue("@companyId", companyId);

                   connection.Open();
                   command.ExecuteNonQuery();
                   connection.Close();
               }
           }
        }

        public DataContracts.ICompany GetCompanyById(int companyId)
        {
            Company company = null;

            using (var connection = new SqlConnection(base.ConnectionString))
            {
                using (var command = new SqlCommand("sp_CompanyRetrieveById", connection))
                {
                    command.Parameters.AddWithValue("@companyId", companyId);
                    command.CommandType = CommandType.StoredProcedure;

                    connection.Open();
                    var reader = command.ExecuteReader();

                    while (reader.Read())
                    {
                        company = (Company)new CompanyAdapter().Resolve(new Company(), reader);
                    }

                    connection.Close();
                }
            }
            return company;
           
        }

        public IEnumerable<DataContracts.ICompany> Search(CompanySearchParameters parameters)
        {
            var companies = new List<ICompany>();

            using (var connection = new SqlConnection(base.ConnectionString))
            {
                using(var command = new SqlCommand("sp_CompanySearch", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@companyName", (object)parameters.Name ?? DBNull.Value);
                    command.Parameters.AddWithValue("@address1", (object)parameters.Address1 ?? DBNull.Value);
                    command.Parameters.AddWithValue("@city", (object)parameters.City ?? DBNull.Value);
                    command.Parameters.AddWithValue("@stateId", (object)parameters.State ?? DBNull.Value);
                    command.Parameters.AddWithValue("@zip", (object)parameters.PostalCode ?? DBNull.Value);
                    command.Parameters.AddWithValue("@phoneNumber", (object)parameters.PhoneNumber ?? DBNull.Value);

                    var adapter = new CompanyAdapter();

                    connection.Open();
                    var reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        companies.Add((Company)adapter.Resolve(new Company(), reader));
                    }
                }
            }

            return companies;
        }

        public void DeleteEmployee(int employeeId)
        {
            using (var connection = new SqlConnection(base.ConnectionString))
            {
                using (var command = new SqlCommand("sp_CompanyRemoveEmployee", connection))
                {
                    command.Parameters.AddWithValue("@employeeId", employeeId);
                    command.CommandType = CommandType.StoredProcedure;

                    connection.Open();
                    var reader = command.ExecuteReader();

                    connection.Close();
                }
            }
        }

        public DataContracts.IEmployee AddPersonToCompany(int personId, int companyId)
        {
            Employee employee = null;

            using (var connection = new SqlConnection(base.ConnectionString))
            {
                using (var command = new SqlCommand("sp_CompanyAddPerson", connection))
                {
                    command.Parameters.AddWithValue("@personId", personId);
                    command.Parameters.AddWithValue("@companyId", companyId);

                    command.CommandType = CommandType.StoredProcedure;

                    connection.Open();
                    var reader = command.ExecuteReader();

                    while (reader.Read())
                    {
                        employee = new Employee();
                        employee.CompanyId = companyId;
                        employee.Person = new PersonAdapter().Resolve(new Person(), reader);
                        employee.EmployeeId = Convert.ToInt32(reader["EmployeeId"]);
                    }

                    connection.Close();
                }
            }

            return employee;
        }

        public DataContracts.IEmployee GetEmployeeById(int employeeId)
        {
            Employee employee = null;

            using (var connection = new SqlConnection(base.ConnectionString))
            {
                using (var command = new SqlCommand("sp_EmployeeRetrieveById", connection))
                {
                    command.Parameters.AddWithValue("@employeeId", employeeId);
                    command.CommandType = CommandType.StoredProcedure;

                    connection.Open();
                    var reader = command.ExecuteReader();


                    while (reader.Read())
                    {
                        employee = new Employee();
                        employee.CompanyId = Convert.ToInt32(reader["companyId"]);
                        employee.Person = new PersonAdapter().Resolve(new Person(), reader);
                        employee.EmployeeId = Convert.ToInt32(reader["EmployeeId"]);
                    }

                    connection.Close();
                }
            }

            return employee;
        }


        public IEnumerable<DataContracts.IEmployee> GetAllEmployees(int companyId)
        {
            var employees = new List<IEmployee>();

            using (var connection = new SqlConnection(base.ConnectionString))
            {
                using (var command = new SqlCommand("sp_CompanyRetrieveEmployees", connection))
                {
                    command.Parameters.AddWithValue("@companyId", companyId);
                    command.CommandType = CommandType.StoredProcedure;

                    connection.Open();
                    var reader = command.ExecuteReader();
                    var personAdapter = new PersonAdapter();

                    while (reader.Read())
                    {
                        var employee = new Employee();
                        employee.CompanyId = Convert.ToInt32(reader["companyId"]);
                        employee.EmployeeId = Convert.ToInt32(reader["EmployeeId"]);
                        employee.Person = personAdapter.Resolve(new Person(), reader);

                        employees.Add(employee);
                    }

                    connection.Close();
                }
            }

            return employees;
        }


        public IEmployee RemoveEmployeeFromCompany(int employeeId, int companyId)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<int> GetAllEmployeeIds(int companyId)
        {
            throw new NotImplementedException();
        }


        public IEmployee UpdateEmployee(IEmployee employee)
        {
            throw new NotImplementedException();
        }
    }
}
