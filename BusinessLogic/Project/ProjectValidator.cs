using DataAccess.DataContracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLogic.Project
{
    public class ProjectValidator
    {
        public IList<string>ValidateProject(IProject project)
        {
            var validationErrors = new List<string>();

            if(string.IsNullOrEmpty(project.Name))
            {
                validationErrors.Add("Project name is required.");
            }

            if(project.CompanyId == 0)
            {
                validationErrors.Add("A Company ID is required.");
            }

            if(project.StatusId == 0)
            {
                validationErrors.Add("Project Status ID is not valid.");
            }

            if(project.PlannedStartDate != null && project.PlannedEndDate != null && (project.PlannedStartDate > project.PlannedEndDate))
            {
                validationErrors.Add("Planned Start Date must occur before Planned End Date.");
            }

            if (project.ActualStartDate != null && project.ActualStartDate != null && (project.ActualStartDate > project.ActualEndDate))
            {
                validationErrors.Add("Actual Start Date must occur before Actual End Date.");
            }

            return validationErrors;
        }
    }
}
