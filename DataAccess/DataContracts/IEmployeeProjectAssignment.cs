using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.DataContracts
{
    public interface IEmployeeProjectAssignment
    {
        int ProjectId { get; set; }
        int EmployeeId { get; set; }
        IPerson Person { get; set; }
    }
}
