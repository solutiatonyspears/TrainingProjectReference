using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.SQLConnection
{
    public interface IConnection
    {
        void Open();
        void Close();
    }
}
