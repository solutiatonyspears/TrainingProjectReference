using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess
{
    public class ProjectSearchParameters
    {
        public string Name { get; set; }
        public int? CompanyId { get; set; }
        public int? StatusId { get; set; }
        public DateTime? ProjectedStartDate { get; set; }
        public DateTime? ProjectedEndDate { get; set; }
        public DateTime? ActualStartDate { get; set; }
        public DateTime? ActualEndDate { get; set; }
    }
}
