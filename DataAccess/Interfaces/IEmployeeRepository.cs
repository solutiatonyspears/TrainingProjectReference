using DataAccess.DataContracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Interfaces
{
    public interface IEmployeeRepository
    {
        IEmployee UpdateEmployee(IEmployee employee);
        void DeleteEmployee(int employeeId);
        IEmployee AddPersonToCompany(int employeeId, int companyId);
        IEmployee GetEmployeeById(int employeeId);
        IEmployee RemoveEmployeeFromCompany(int employeeId, int companyId);
        IEnumerable<int> GetAllEmployeeIds(int companyId);
        IEnumerable<IEmployee> GetAllEmployees(int companyId);
    }
}
