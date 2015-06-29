using DataAccess.DataAdapters;
using DataAccess.DataContracts;
using DataAccess.DataModels;
using DataAccess.Interfaces;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Repositories
{
    public class PersonRepository : Repository, IPersonRepository
    {
        public DataContracts.IPerson GetPersonById(int Id)
        {
            Person person = null;

            using (var connection = new SqlConnection(base.ConnectionString))
            {
                using(var command = new SqlCommand("sp_PersonRetrieveById", connection))
                {
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@personId", Id);

                    connection.Open();
                    var dataReader = command.ExecuteReader();

                    while (dataReader.Read())
                    {
                        person = (Person)new PersonAdapter().Resolve(new Person(), dataReader);
                    }
                }
            }

            return person;
        }

        public IEnumerable<DataContracts.IPerson> Search(PersonSearchParameters parameters)
        {
            var people = new List<IPerson>();

            using (var connection = new SqlConnection(base.ConnectionString))
            {
                using (var command = new SqlCommand("sp_PersonSearch", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@firstName", (object)parameters.FirstName ?? DBNull.Value);
                    command.Parameters.AddWithValue("@middleName", (object)parameters.MiddleName ?? DBNull.Value);
                    command.Parameters.AddWithValue("@lastName", (object)parameters.LastName ?? DBNull.Value);

                    var adapter = new PersonAdapter();

                    connection.Open();
                    var reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        people.Add((Person)adapter.Resolve(new Person(), reader));
                    }
                }
            }

            return people;
        }

        public DataContracts.IPerson AddPerson(DataContracts.IPerson person)
        {
            using (var connection = new SqlConnection(base.ConnectionString))
            {
                using (var command = new SqlCommand("sp_PersonCreate", connection))
                {
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@firstName", person.FirstName);
                    command.Parameters.AddWithValue("@middleName", person.MiddleName);
                    command.Parameters.AddWithValue("@lastName", person.LastName);

                    connection.Open();
                    var dataReader = command.ExecuteReader();

                    while (dataReader.Read())
                    {
                        person = (Person)new PersonAdapter().Resolve(new Person(), dataReader);
                    }
                }
            }

            return person;
        }

        public DataContracts.IPerson UpdatePerson(DataContracts.IPerson person)
        {
            using (var connection = new SqlConnection(base.ConnectionString))
            {
                using (var command = new SqlCommand("sp_PersonUpdate", connection))
                {
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@personId", person.PersonId);
                    command.Parameters.AddWithValue("@firstName", person.FirstName);
                    command.Parameters.AddWithValue("@middleName", person.MiddleName);
                    command.Parameters.AddWithValue("@lastName", person.LastName);

                    connection.Open();
                    var dataReader = command.ExecuteReader();

                    while (dataReader.Read())
                    {
                        person = (Person)new PersonAdapter().Resolve(new Person(), dataReader);
                    }
                }
            }

            return person;
        }

        public void DeletePerson(int personId)
        {
            using (var connection = new SqlConnection(base.ConnectionString))
            {
                connection.Open();
                using (var command = new SqlCommand("sp_PersonDelete", connection))
                {
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@personId", personId);

                    connection.Open();
                    command.ExecuteReader();
                }
            }
        }
    }
}
