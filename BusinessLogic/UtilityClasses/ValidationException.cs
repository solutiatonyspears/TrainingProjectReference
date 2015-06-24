using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLogic.UtilityClasses
{
    public class ValidationException : Exception
    {
        public ValidationException(string message, List<string> validationErrors) : base(message)
        {
            this.Data["ValidationErrors"] = validationErrors;

        }
    }
}
