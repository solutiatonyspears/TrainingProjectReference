using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.DataContracts
{
    public interface IUSState
    {
        string Abbreviation { get; set; }
        string Name { get; set; }
    }
}
