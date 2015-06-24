using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.DataContracts
{
    public interface IAddress
    {
         string Street1 { get; set; }
         string Street2 { get; set; }
         string Street3 { get; set; }
         string City { get; set; }
         string StateCode { get; set; }
         string PostalCode { get; set; }
    }
}
