using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.DataContracts
{
    public interface IPerson
    {
         int PersonId { get; set; }
         string FirstName { get; set; }
         string MiddleName { get; set; }
         string LastName { get; set; }
    }
}
