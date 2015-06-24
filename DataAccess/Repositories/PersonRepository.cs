using DataAccess.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Repositories
{
    public class PersonRepository : IPersonRepository
    {
        public DataContracts.IPerson GetPersonById(int Id)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<DataContracts.IPerson> Search(PersonSearchParameters parameters)
        {
            throw new NotImplementedException();
        }

        public DataContracts.IPerson AddPerson(DataContracts.IPerson person)
        {
            throw new NotImplementedException();
        }

        public DataContracts.IPerson UpdatePerson(DataContracts.IPerson person)
        {
            throw new NotImplementedException();
        }

        public void DeletePerson(int personId)
        {
            throw new NotImplementedException();
        }
    }
}
