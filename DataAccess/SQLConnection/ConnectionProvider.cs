using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

namespace DataAccess.SQLConnection
{
    public static class ConnectionProvider
    {
        public static string ConnectionString
        {
            get
            {
                return ConfigurationManager.AppSettings["ConnectionString"];
            }
        }
    }
}
