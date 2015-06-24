using DataAccess.DataContracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLogic.Address
{
    public class AddressValidator
    {
        private List<string> validationErrors = new List<string>();

        public List<string> validateAddress(IAddress address)
        {
            if (address != null)
            {


                if (string.IsNullOrEmpty(address.Street1))
                {
                    validationErrors.Add("Street1 is a required field.");
                }
                if (string.IsNullOrEmpty(address.City))
                {
                    validationErrors.Add("City is a required field.");
                }
                if (string.IsNullOrEmpty(address.StateCode))
                {
                    validationErrors.Add("State Code is a required field");
                }
                else
                {
                    if (address.StateCode.Length != 2)
                    {
                        validationErrors.Add("State Code must be two characters.");
                    }
                }
                if (string.IsNullOrEmpty(address.PostalCode))
                {
                    validationErrors.Add("Postal Code is a required field.");
                }
                else
                {
                    int n;
                    if (!int.TryParse(address.PostalCode, out n))
                    {
                        validationErrors.Add("Postal code must be numeric.");
                    }
                    if (address.PostalCode.Length != 5 && address.PostalCode.Length != 9)
                    {
                        validationErrors.Add("Postal code must be either 5 or 9 digits long.");
                    }
                }
            }
            else
            {
                validationErrors.Add("Address is null.");
            }
            return validationErrors;
        }
    }
}
