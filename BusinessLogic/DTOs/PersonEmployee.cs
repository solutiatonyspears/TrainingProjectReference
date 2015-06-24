using DataAccess.DataContracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLogic.DTOs
{
    public class PersonEmployee : IPerson, IEmployee
    {
        public int PersonId
        {
            get;
            set;
        }

        public string FirstName
        {
            get;
            set;
        }

        public string MiddleName
        {
            get;
            set;
        }

        public string LastName
        {
            get;
            set;
        }

        public int EmployeeId
        {
            get;
            set;
        }

        public int CompanyId
        {
            get;
            set;
        }

        public int Personid
        {
            get;
            set;
        }

        public DateTime HireDate
        {
            get;
            set;
        }

        public DateTime? TerminationDate
        {
            get;
            set;
        }

        public bool IsActive
        {
            get;
            set;
        }
    }
}
