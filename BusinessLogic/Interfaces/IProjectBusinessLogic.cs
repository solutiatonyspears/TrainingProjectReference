using DataAccess;
using DataAccess.DataContracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLogic.Interfaces
{
    public interface IProjectBusinessLogic
    {
        IProject GetProject(int projectId);
        IProject CreateProject(IProject project);
        IProject UpdateProject(IProject project);
        void DeleteProject(int projectId);
        IEnumerable<IProject> SearchForProjects(ProjectSearchParameters parameters);
        void StartProject(int projectId);
        void EndProject(int projectId);
        void AddEmployeeToProject(int projectId, int employeeId);
        void RemoveEmployeeFromProject(int projectId, int employeeId);
        IEnumerable<IEmployeeProjectAssignment> GetEmployeesOnProject(int projectId);
    }
}
