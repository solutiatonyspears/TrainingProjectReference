using BusinessLogic.DTOs;
using DataAccess;
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
         IEnumerable<int> GetAllEmployeeIds(int companyId);
         IEnumerable<IEmployee> GetAllEmployees(int companyId);
         IEnumerable<ICompany> SearchForCompanies(CompanySearchParameters parameters);
         IEnumerable<IProject> GetProjectsForCompany(int companyId);
    }
}
