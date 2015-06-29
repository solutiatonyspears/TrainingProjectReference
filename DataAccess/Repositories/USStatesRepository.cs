﻿using DataAccess.DataContracts;
using DataAccess.DataModels;
using DataAccess.Interfaces;
using DataAccess.SQLConnection;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Repositories
{
    public class USStatesRepository:Repository, IUSStatesRepository
    {
        public USStatesRepository()
        {}

        public IEnumerable<DataContracts.IUSState> GetAllStates()
        {
            var stateList = new List<IUSState>();

            using (var connection = new SqlConnection(base.ConnectionString))
            {
                connection.Open();

                using (var command = new SqlCommand("SELECT name, abbreviation FROM USStates ORDER BY name", (SqlConnection)connection))
                {
                    var reader = command.ExecuteReader();

                    while(reader.Read())
                    {
                        stateList.Add(new USState
                            {
                                Name = reader.GetString(0),
                                Abbreviation = reader.GetString(1)
                            });
                    }
                }
            }

            return stateList;
        }
    }
}
