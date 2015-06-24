using DataAccess.DataContracts;
using DataAccess.DataModels;
using DataAccess.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PeoopleControllerTests.Mocks
{
    public class MockPersonRepository:IPersonRepository
    {
        private List<IPerson> _people = new List<IPerson>{
            new Person
            {
                PersonId = 1,
                FirstName = "Test",
                MiddleName = "Person",
                LastName = "1"
            },
            new Person
            {
                PersonId = 2,
                FirstName = "Test",
                MiddleName = "Person",
                LastName = "2"
            }
        };

        public DataAccess.DataContracts.IPerson GetPersonById(int Id)
        {
            return(from p in _people where p.PersonId == Id select p).SingleOrDefault();
        }

        public IEnumerable<DataAccess.DataContracts.IPerson> Search(DataAccess.PersonSearchParameters parameters)
        {
            throw new NotImplementedException();
        }

        public DataAccess.DataContracts.IPerson AddPerson(DataAccess.DataContracts.IPerson person)
        {
            _people.Add(person);
            person.PersonId = _people.Count();
      
            return person;
        }

        public DataAccess.DataContracts.IPerson UpdatePerson(DataAccess.DataContracts.IPerson person)
        {
            var testPerson = GetPersonById(person.PersonId);
            if(testPerson == null)
            {
                throw new KeyNotFoundException();
            }
            else
            {
                _people.Remove(GetPersonById(person.PersonId));
                _people.Add(person);

                return person;
            }
            
        }

        public void DeletePerson(int personId)
        {
            var person = GetPersonById(personId);
            if(person != null)
            {
                _people.Remove(person);
            }
        }
    }
}
