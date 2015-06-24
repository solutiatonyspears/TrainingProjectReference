using DataAccess.DataContracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.DataModels
{
    public class USState:IUSState
    {
        public string Abbreviation { get; set; }
        public string Name { get; set; }
    }
}
