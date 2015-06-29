using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.DataContracts
{
    public interface IEmployee
    {
        int EmployeeId { get; set; }
        int CompanyId { get; set; }
        IPerson Person { get; set; }
        DateTime HireDate { get; set; }
        DateTime? TerminationDate { get; set; }
        bool IsActive { get; set; }
    }
}
