using DataAccess.DataModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.DataContracts
{
    public interface ICompany
    {
        int CompanyId { get; set; }
        string Name { get; set; }
        Address Address { get; set; }
        string PhoneNumber { get; set; }
    }
}
