using DataAccess.DataContracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Interfaces
{
    public interface IProjectRepository
    {
        IProject GetProjectById(int projectId);
        IProject AddProject(IProject project);
        IProject UpdateProject(IProject project);
        IEnumerable<IProject> Search(ProjectSearchParameters parameters);
        void DeleteProject(int projectId);
        List<IProject> GetProjectsForCompanyId(int companyId);
    }
}
