using DataAccess.DataContracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Interfaces
{
    public interface IPersonRepository
    {
        IPerson GetPersonById(int Id);
        IEnumerable<IPerson> Search(PersonSearchParameters parameters);
        IPerson AddPerson(IPerson person);
        IPerson UpdatePerson(IPerson person);
        void DeletePerson(int personId);
    }
}
