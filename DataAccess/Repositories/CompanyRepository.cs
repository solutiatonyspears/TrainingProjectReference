using DataAccess.Interfaces;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using DataAccess.DataModels;

namespace DataAccess.Repositories
{
  public class CompanyRepository : Repository, ICompanyRepository
    {
        public DataContracts.ICompany AddCompany(DataContracts.ICompany company)
        {
            throw new NotImplementedException();
        }

        public DataContracts.ICompany UpdateCompany(DataContracts.ICompany company)
        {
           

            using(var connection = new SqlConnection(base.ConnectionString))
            {
                connection.Open();
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

                    command.ExecuteNonQuery();
                    connection.Close();
                }
            }
            return company;
        }

        public void DeleteCompany(int companyId)
        {
            throw new NotImplementedException();
        }

        public DataContracts.ICompany GetCompanyById(int companyId)
        {
           
            Company company = null;

            using (var connection = new SqlConnection(base.ConnectionString))
            {
                connection.Open();

                using (var command = new SqlCommand("select * from Company where CompanyId = " + companyId, connection))
                {
                    var reader = command.ExecuteReader();

                    while (reader.Read())
                    {
                        company = new Company();

                        company.Name = Convert.ToString(reader["Name"]);
                        company.Address.City = Convert.ToString(reader["City"]);
                        company.Address.Street1 = Convert.ToString(reader["Address1"]);
                        company.Address.Street2 = Convert.ToString(reader["Address2"]);
                        company.Address.PostalCode = Convert.ToString(reader["Zip"]);
                        company.Address.StateCode = Convert.ToString(reader["StateId"]);
                        company.CompanyId = Convert.ToInt32(reader["CompanyId"]);
                        company.PhoneNumber = Convert.ToString(reader["PhoneNumber"]);
                    }
                    
                }
            }
            return company;
           
        }

        public IEnumerable<DataContracts.ICompany> Search(CompanySearchParameters parameters)
        {
            throw new NotImplementedException();
        }
    }
}
