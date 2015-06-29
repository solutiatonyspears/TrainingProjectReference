using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.DataContracts
{
    public interface IProject
    {
        int ProjectId { get; set; }
        int CompanyId { get; set; }
        string Name { get; set; }
        int StatusId { get; set; }
        DateTime? PlannedStartDate { get; set; }
        DateTime? PlannedEndDate { get; set; }
        DateTime? ActualStartDate { get; set; }
        DateTime? ActualEndDate { get; set; }
    }
}
