using DataAccess.DataContracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.DataModels
{
    public class Company : ICompany
    {
        public int CompanyId { get; set; }
        public string Name { get; set; }
        public Address Address { get; set; }
        public string PhoneNumber { get; set; }

        public Company()
        {
            Address = new Address();
        }
    }
}
