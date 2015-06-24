using DataAccess.DataContracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Interfaces
{
    public interface ICompanyRepository
    {
        ICompany AddCompany(ICompany company);
        ICompany UpdateCompany(ICompany company);
        void DeleteCompany(int companyId);
        ICompany GetCompanyById(int companyId);
        IEnumerable<ICompany> Search(CompanySearchParameters parameters);
    }
}
