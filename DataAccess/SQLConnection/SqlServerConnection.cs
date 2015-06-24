using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.SQLConnection
{
    public class SqlServerConnection:IConnection, IDisposable
    {
        private SqlConnection _connection;
        private string _connectionString;

        public SqlServerConnection(string connectionString)
        {
            _connectionString = connectionString;
        }
        
        private SqlConnection CreateConnection()
        {
            return new SqlConnection(_connectionString);
        }

        public void Open()
        {
 	        if(_connection == null)
            {
                _connection = CreateConnection();
            }

            _connection.Open();
        }

        public void Close()
        {
            if(_connection != null)
            {
                _connection.Close();
            }
        }

        public void Dispose()
        {
            if(_connection != null)
            {
                _connection.Dispose();
            }
        }
    }
}
