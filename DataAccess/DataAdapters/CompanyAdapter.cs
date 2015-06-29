using DataAccess.DataContracts;
using DataAccess.DataModels;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.DataAdapters
{
    public class CompanyAdapter
    {
        public ICompany Resolve(ICompany company, SqlDataReader reader)
        {
            company.Name = Convert.ToString(reader["Name"]);
            company.Address.City = Convert.ToString(reader["City"]);
            company.Address.Street1 = Convert.ToString(reader["Address1"]);
            company.Address.Street2 = Convert.ToString(reader["Address2"]);
            company.Address.PostalCode = Convert.ToString(reader["Zip"]);
            company.Address.StateCode = Convert.ToString(reader["StateId"]);
            company.CompanyId = Convert.ToInt32(reader["CompanyId"]);
            company.PhoneNumber = Convert.ToString(reader["PhoneNumber"]);

            return company;
        }
    }
}
