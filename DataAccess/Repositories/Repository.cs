using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Repositories
{
    public class Repository
    {
        public string ConnectionString{
            get{
             return ConfigurationManager.AppSettings["ConnectionString"];
            }
            
         }
    }
}
