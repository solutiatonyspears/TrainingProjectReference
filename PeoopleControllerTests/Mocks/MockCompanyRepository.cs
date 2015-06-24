using DataAccess.DataContracts;
using DataAccess.DataModels;
using DataAccess.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CompanyControllerTests.Mocks
{
    class MockCompanyRepository : ICompanyRepository
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
        
            public ICompany AddCompany(ICompany company)
            {
                _companies.Add(company);
                company.CompanyId = _companies.Count();

                return company;
            }

            public ICompany UpdateCompany(ICompany company)
            {
                var testCompany = GetCompanyById(company.CompanyId);
                if (testCompany == null)
                {
                    throw new KeyNotFoundException();
                }else{
                    _companies.Remove(GetCompanyById(company.CompanyId));
                    _companies.Add(company);

                    return company;
                }
            }

            public void DeleteCompany(int companyId)
            {
                var company = GetCompanyById(companyId);
                if (company != null)
                {
                    _companies.Remove(company);
                }
            }

            public ICompany GetCompanyById(int companyId)
            {
                return (from c in _companies where c.CompanyId == companyId select c).SingleOrDefault();
            }

            public IEnumerable<ICompany> Search(DataAccess.CompanySearchParameters parameters)
            {
 	            throw new NotImplementedException();
            }
        }

     
    }

