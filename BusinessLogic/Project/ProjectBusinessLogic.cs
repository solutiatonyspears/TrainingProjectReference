using BusinessLogic.Interfaces;
using BusinessLogic.UtilityClasses;
using DataAccess.DataContracts;
using DataAccess.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLogic.Project
{
    public class ProjectBusinessLogic:IProjectBusinessLogic
    {
        private IProjectRepository _projectRepository;
        private IEmployeeRepository _employeeRepository;

        public ProjectBusinessLogic(IProjectRepository projectRepository, IEmployeeRepository employeeRepository)
        {
            _projectRepository = projectRepository;
            _employeeRepository = employeeRepository;
        }

        public IProject GetProject(int projectId)
        {
            return _projectRepository.GetProjectById(projectId);
        }

        public DataAccess.DataContracts.IProject CreateProject(DataAccess.DataContracts.IProject project)
        {
            var validationErrors = new ProjectValidator().ValidateProject(project);
            if(validationErrors.Count == 0)
            {
                return _projectRepository.AddProject(project);
            }
            else
            {
                throw new ValidationException("Unable to create project due to one or more errors.", validationErrors.ToList());
            }
        }

        public DataAccess.DataContracts.IProject UpdateProject(DataAccess.DataContracts.IProject project)
        {
            var validationErrors = new ProjectValidator().ValidateProject(project);
            if (validationErrors.Count == 0)
            {
                return _projectRepository.UpdateProject(project);
            }
            else
            {
                throw new ValidationException("Unable to update project due to one or more errors.", validationErrors.ToList());
            }
        }

        public void DeleteProject(int projectId)
        {
            _projectRepository.DeleteProject(projectId);
        }

        public IEnumerable<DataAccess.DataContracts.IProject> SearchForProjects(DataAccess.ProjectSearchParameters parameters)
        {
            var results = _projectRepository.Search(parameters);
            return results.OrderBy(p => p.Name);
        }

        public void StartProject(int projectId)
        {
            var project = _projectRepository.GetProjectById(projectId);
            if(project != null)
            {
                project.ActualStartDate = DateTime.Now;
                _projectRepository.UpdateProject(project);
            }
            else
            {
                throw new Exception("The specified Project was not found.");
            }
        }

        public void EndProject(int projectId)
        {
            var project = _projectRepository.GetProjectById(projectId);
            if(project != null)
            {
                if(project.ActualEndDate != null)
                {
                    project.ActualEndDate = DateTime.Now;
                }
                else
                {
                    throw new Exception("The specified Project has already ended.");
                }
            }
            else
            {
                throw new Exception("The specified Project was not found.");
            }
        }

        public void AddEmployeeToProject(int projectId, int employeeId)
        {
            var employee = _employeeRepository.GetEmployeeById(employeeId);

            if(employee != null)
            {
                var project = _projectRepository.GetProjectById(projectId);
                
                if(project != null)
                {
                    if (employee.CompanyId == project.CompanyId)
                    {
                        _projectRepository.AddEmployeeToProject(employeeId, projectId);
                    }
                    else
                    {
                        throw new Exception("Cannot add an Employee to a Project at a different Company.");
                    }
                }
                else
                {
                    throw new Exception("The specified Project was not found.");
                }
            }
            else
            {
                throw new Exception("The specified Employee was not found.");
            }
        }

        public void RemoveEmployeeFromProject(int projectId, int employeeId)
        {
            var employee = _employeeRepository.GetEmployeeById(employeeId);

            if (employee != null)
            {
                var project = _projectRepository.GetProjectById(projectId);

                if (project != null)
                {
                    if (employee.CompanyId == project.CompanyId)
                    {
                        _projectRepository.RemoveEmployeeFromProject(employeeId, projectId);
                    }
                    else
                    {
                        throw new Exception("Cannot remove an Employee from a Project at a different Company.");
                    }
                }
                else
                {
                    throw new Exception("The specified Project was not found.");
                }
            }
            else
            {
                throw new Exception("The specified Employee was not found.");
            }
        }

        public IEnumerable<IEmployeeProjectAssignment> GetEmployeesOnProject(int projectId)
        {
            var project = _projectRepository.GetProjectById(projectId);

            if(project != null)
            {
                return _projectRepository.GetEmployeesAssignedToProject(projectId);
            }
            else
            {
                throw new Exception("The specified Project was not found.");
            }
        }

    }
}
