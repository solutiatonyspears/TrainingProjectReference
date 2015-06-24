using DataAccess.DataContracts;
using DataAccess.DataModels;
using DataAccess.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PeoopleControllerTests.Mocks
{
    public class MockEmployeeRepository : IEmployeeRepository
    {
        private List<IEmployee> _employees = new List<IEmployee>
        {
            new Employee{
                EmployeeId = 1,
                CompanyId = 2,
                HireDate = DateTime.Now,
                IsActive = true
            },
            new Employee{
                EmployeeId = 2,
                CompanyId = 1,
                HireDate = DateTime.Now,
                IsActive = true
            },
            new Employee{
                EmployeeId = 3,
                CompanyId = 2,
                HireDate = DateTime.Now,
                IsActive = true
            }
        };
            
        public bool AddEmployeeToCompany(int employeeId, int companyId)
        {
            var employee = GetEmployeeById(employeeId);
            employee.CompanyId = companyId;

            return true;
        }

        public IEmployee GetEmployeeById(int employeeId)
        {
            return (from e in _employees where e.EmployeeId == employeeId select e).SingleOrDefault();
        }

        public IEmployee RemoveEmployeeFromCompany(int employeeId, int companyId)
        {
            var employee = GetEmployeeById(employeeId);
            if (employee.CompanyId == companyId)
            {
                employee.CompanyId = 0;
                return employee;
            }
            else
            {
                throw new KeyNotFoundException();
            }
        }


        public List<int> GetAllEmployeeIds(int companyId)
        {
            return (from e in _employees where e.CompanyId == companyId select e.EmployeeId).ToList();
        }



        public IEmployee UpdateEmployee(IEmployee employee)
        {
            var testEmployee = GetEmployeeById(employee.EmployeeId);
            if (testEmployee == null)
            {
                throw new KeyNotFoundException();
            }
            else
            {
                _employees.Remove(GetEmployeeById(employee.EmployeeId));
                _employees.Add(employee);

                return employee;
            }
        }

        public void DeleteEmployee(int employeeId)
        {
            var employee = GetEmployeeById(employeeId);
            if (employee != null)
            {
                _employees.Remove(employee);
            }
        }


        public List<IEmployee> GetAllEmployees(int companyId)
        {
            throw new NotImplementedException();
        }
    }
}
