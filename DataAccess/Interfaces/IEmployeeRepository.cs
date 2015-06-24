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
        bool AddEmployeeToCompany(int employeeId, int companyId);
        IEmployee GetEmployeeById(int employeeId);
        IEmployee RemoveEmployeeFromCompany(int employeeId, int companyId);
        List<int> GetAllEmployeeIds(int companyId);
        List<IEmployee> GetAllEmployees(int companyId);
    }
}
