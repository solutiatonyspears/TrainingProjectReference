using DataAccess.DataContracts;
using DataAccess.DataModels;
using DataAccess.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PeoopleControllerTests.Mocks
{
   public class MockProjectRepository : IProjectRepository
    {
       private List<IProject> _projects = new List<IProject>{
        new Project{
            ProjectId = 1,
            CompanyId = 1,
            Name = "Test Project",
            PlannedStartDate = DateTime.Now,
            PlannedEndDate = DateTime.Now
        },
        new Project{
            ProjectId = 2,
            CompanyId = 2,
            Name = "Project 2",
            PlannedStartDate = DateTime.Now,
            PlannedEndDate = DateTime.Now
        }
        };



       public IProject GetProjectById(int projectId)
       {
           return (from p in _projects where p.ProjectId == projectId select p).SingleOrDefault();
       }

       public IProject AddProject(IProject project)
       {
           _projects.Add(project);
           project.ProjectId = _projects.Count();

           return project;
       }

       public IProject UpdateProject(IProject project)
       {
           var testProject = GetProjectById(project.ProjectId);
           if(testProject != null)
           {
               _projects.Remove(GetProjectById(project.ProjectId));
               _projects.Add(project);

               return project;
           }
           else
           {
               throw new KeyNotFoundException(); 
           }
       }

       public IEnumerable<IProject> Search(DataAccess.ProjectSearchParameters parameters)
       {
           throw new NotImplementedException();
       }

       public void DeleteProject(int projectId)
       {
           _projects.Remove(GetProjectById(projectId));

       }


       public List<IProject> GetProjectsForCompanyId(int companyId)
       {
           throw new NotImplementedException();
       }
    }
}
