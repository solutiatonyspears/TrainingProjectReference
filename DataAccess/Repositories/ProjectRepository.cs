using DataAccess.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Repositories
{
    public class ProjectRepository : IProjectRepository
    {
        public DataContracts.IProject GetProjectById(int projectId)
        {
            throw new NotImplementedException();
        }

        public DataContracts.IProject AddProject(DataContracts.IProject project)
        {
            throw new NotImplementedException();
        }

        public DataContracts.IProject UpdateProject(DataContracts.IProject project)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<DataContracts.IProject> Search(ProjectSearchParameters parameters)
        {
            throw new NotImplementedException();
        }

        public void DeleteProject(int projectId)
        {
            throw new NotImplementedException();
        }


        public List<DataContracts.IProject> GetProjectsForCompanyId(int companyId)
        {
            throw new NotImplementedException();
        }
    }
}
