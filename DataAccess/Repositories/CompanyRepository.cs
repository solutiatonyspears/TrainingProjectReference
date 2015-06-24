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
            throw new NotImplementedException();
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
