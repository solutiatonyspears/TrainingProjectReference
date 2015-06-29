using BusinessLogic.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PeoopleControllerTests.Mocks
{
    public class MockProjectBusinessLogic:IProjectBusinessLogic
    {
        public DataAccess.DataContracts.IProject GetProject(int projectId)
        {
            throw new NotImplementedException();
        }

        public DataAccess.DataContracts.IProject CreateProject(DataAccess.DataContracts.IProject project)
        {
            throw new NotImplementedException();
        }

        public DataAccess.DataContracts.IProject UpdateProject(DataAccess.DataContracts.IProject project)
        {
            throw new NotImplementedException();
        }

        public void DeleteProject(int projectId)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<DataAccess.DataContracts.IProject> SearchForProjects(DataAccess.ProjectSearchParameters parameters)
        {
            throw new NotImplementedException();
        }

        public void StartProject(int projectId)
        {
            throw new NotImplementedException();
        }

        public void EndProject(int projectId)
        {
            throw new NotImplementedException();
        }

        public void AddEmployeeToProject(int projectId, int employeeId)
        {
            throw new NotImplementedException();
        }

        public void RemoveEmployeeFromProject(int projectId, int employeeId)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<DataAccess.DataContracts.IEmployeeProjectAssignment> GetEmployeesOnProject(int projectId)
        {
            throw new NotImplementedException();
        }
    }
}
