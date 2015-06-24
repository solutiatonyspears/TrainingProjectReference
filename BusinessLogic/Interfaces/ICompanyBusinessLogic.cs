using BusinessLogic.DTOs;
using DataAccess.DataContracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLogic.Interfaces
{
    public interface ICompanyBusinessLogic
    {
         ICompany CreateCompany(ICompany company);
         ICompany UpdateCompany(ICompany company);
         ICompany GetCompanyById(int companyId);
         ICompany DeleteCompany(int companyId);
         bool AddEmployee(int employeeId, int companyId);
         bool RemoveEmployee(int employeeId, int companyId);
         List<int> GetAllEmployeeIds(int companyId);
         List<PersonEmployee> GetAllEmployees(int companyId);
        
    }
}
