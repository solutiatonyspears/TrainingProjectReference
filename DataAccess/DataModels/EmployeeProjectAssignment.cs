using DataAccess.DataContracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.DataModels
{
    public class EmployeeProjectAssignment : IEmployeeProjectAssignment
    {
        public int ProjectId { get; set; }
        public int EmployeeId { get; set; }
        public IPerson Person { get; set; }
    }
}
