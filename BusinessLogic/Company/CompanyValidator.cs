using BusinessLogic.Address;
using DataAccess.DataContracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLogic.Company
{
    public class CompanyValidator
    {
        private List<string> validationErrors = new List<string>();

        public List<string> validateCompany(ICompany company)
        {
            if (string.IsNullOrEmpty(company.Name))
            {
                validationErrors.Add("Company Name is required.");
            }
            if (string.IsNullOrEmpty(company.PhoneNumber))
            {
                validationErrors.Add("Company Phone Number is required.");
            }
            else
            {
                long n;
                if (!long.TryParse(company.PhoneNumber, out n))
                {
                    validationErrors.Add("Company Phone Number is not properly formatted.");
                }
                if (company.PhoneNumber.Length != 10)
                {
                    validationErrors.Add("Company Phone Number must have 10 digits.");
                }
            }
            if (company.Address == null)
            {
                validationErrors.Add("Company Address is required.");
            }
            else
            {
                AddressValidator v = new AddressValidator();
                validationErrors.AddRange(v.validateAddress(company.Address));
            }
            return validationErrors;
        }
    }
}
