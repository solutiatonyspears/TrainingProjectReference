using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess
{
    public class CompanySearchParameters
    {
        public string Name { get; set; }
        public string Address1 { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string PostalCode { get; set; }
        public string PhoneNumber { get; set; }
    }
}
