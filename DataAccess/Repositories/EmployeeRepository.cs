using DataAccess.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Repositories
{
    public class EmployeeRepository : IEmployeeRepository
    {
        public DataContracts.IEmployee UpdateEmployee(DataContracts.IEmployee employee)
        {
            throw new NotImplementedException();
        }

        public void DeleteEmployee(int employeeId)
        {
            throw new NotImplementedException();
        }

        public DataContracts.IEmployee AddEmployeeToCompany(int employeeId, int companyId)
        {
            throw new NotImplementedException();
        }

        public DataContracts.IEmployee GetEmployeeById(int employeeId)
        {
            throw new NotImplementedException();
        }

        public DataContracts.IEmployee RemoveEmployeeFromCompany(int employeeId, int companyId)
        {
            throw new NotImplementedException();
        }

        public List<int> GetAllEmployeeIds(int companyId)
        {
            throw new NotImplementedException();
        }


        bool IEmployeeRepository.AddEmployeeToCompany(int employeeId, int companyId)
        {
            throw new NotImplementedException();
        }



        public List<DataContracts.IEmployee> GetAllEmployees(int companyId)
        {
            throw new NotImplementedException();
        }
    }
}
