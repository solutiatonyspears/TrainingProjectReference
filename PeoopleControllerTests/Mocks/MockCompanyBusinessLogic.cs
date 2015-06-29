using BusinessLogic.Interfaces;
using DataAccess.DataContracts;
using DataAccess.DataModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PeoopleControllerTests.Mocks
{
    class MockCompanyBusinessLogic : ICompanyBusinessLogic
    {
        private List<ICompany> _companies = new List<ICompany>{
            new Company {
                CompanyId = 1,
                Name = "ABC Plumbing",
                PhoneNumber = "123-456-7891"
            },
            new Company{
                CompanyId = 2,
                Name = "Home Depot",
                PhoneNumber = "999-111-2222"
            }

            };

        public MockCompanyBusinessLogic(List<ICompany> companies)
        {
            _companies = companies;
        }
        public DataAccess.DataContracts.ICompany CreateCompany(DataAccess.DataContracts.ICompany company)
        {
            company.CompanyId = 1;
            return company;
        }

        public DataAccess.DataContracts.ICompany UpdateCompany(DataAccess.DataContracts.ICompany company)
        {
            return company;
        }

        public DataAccess.DataContracts.ICompany GetCompanyById(int companyId)
        {
            return (from c in _companies where c.CompanyId == companyId select c).SingleOrDefault();
        }

        public DataAccess.DataContracts.ICompany DeleteCompany(int companyId)
        {
            if(companyId == 0 )
            {
                return null;
            }
            else
            {
                var company = GetCompanyById(companyId);
                _companies.Remove(company);
                return company;
            }
        }

        public bool AddEmployee(int employeeId, int companyId)
        {
            if(employeeId > 0 && companyId > 0)
            {
                return true;
            }
            return false;
        }

        public bool RemoveEmployee(int employeeId, int companyId)
        {
            if (employeeId > 0 && companyId > 0)
            {
                return true;
            }
            return false;
        }

        public IEnumerable<int> GetAllEmployeeIds(int companyId)
        {
            if (companyId > 0 )
            {
                return new List<int> {
                    1,2,3,4,5
                };
            }
            else
            {
                return null;
            }
        }


        public IEnumerable<IEmployee> GetAllEmployees(int companyId)
        {
            throw new NotImplementedException();
        }


        public IEnumerable<ICompany> SearchForCompanies(DataAccess.CompanySearchParameters parameters)
        {
            throw new NotImplementedException();
        }
    }
}
