using DataAccess.DataContracts;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.DataAdapters
{
    public class PersonAdapter
    {
        public IPerson Resolve(IPerson person, SqlDataReader reader)
        {
            person.PersonId = Convert.ToInt32(reader["personId"]);
            person.FirstName = Convert.ToString(reader["firstName"]);
            person.MiddleName = Convert.ToString(reader["middleName"]);
            person.LastName = Convert.ToString(reader["lastName"]);

            return person;
        }
    }
}
