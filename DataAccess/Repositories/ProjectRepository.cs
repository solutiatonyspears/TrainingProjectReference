using DataAccess.DataAdapters;
using DataAccess.DataContracts;
using DataAccess.DataModels;
using DataAccess.Interfaces;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Repositories
{
    public class ProjectRepository : Repository, IProjectRepository
    {
        public DataContracts.IProject GetProjectById(int projectId)
        {
            Project project = null;

            using (var connection = new SqlConnection(base.ConnectionString))
            {
                using (var command = new SqlCommand("sp_ProjectRetrieveById", connection))
                {
                    command.Parameters.AddWithValue("@projectId", projectId);
                    command.CommandType = CommandType.StoredProcedure;

                    connection.Open();
                    var reader = command.ExecuteReader();

                    while (reader.Read())
                    {
                        project = (Project)new ProjectAdapter().Resolve(new Project(), reader);
                    }

                    connection.Close();
                }
            }
            return project;
        }

        public DataContracts.IProject AddProject(DataContracts.IProject project)
        {
            using (var connection = new SqlConnection(base.ConnectionString))
            {
                var adapter = new ProjectAdapter();

                using (var command = new SqlCommand("sp_projectCreate", connection))
                {
                    command.Parameters.AddRange(adapter.ResolveToParameters(project).ToArray());
 
                    command.CommandType = CommandType.StoredProcedure;

                    connection.Open();
                    var reader = command.ExecuteReader();

                    while (reader.Read())
                    {
                        project = (Project)adapter.Resolve(new Project(), reader);
                    }

                    connection.Close();
                }
            }
            return project;
        }

        public DataContracts.IProject UpdateProject(DataContracts.IProject project)
        {
            using (var connection = new SqlConnection(base.ConnectionString))
            {
                var adapter = new ProjectAdapter();

                using (var command = new SqlCommand("sp_projectUpdate", connection))
                {
                    command.Parameters.AddRange(adapter.ResolveToParameters(project).ToArray());

                    command.CommandType = CommandType.StoredProcedure;

                    connection.Open();
                    var reader = command.ExecuteReader();

                    while (reader.Read())
                    {
                        project = (Project)adapter.Resolve(new Project(), reader);
                    }

                    connection.Close();
                }
            }
            return project;
        }

        public IEnumerable<DataContracts.IProject> Search(ProjectSearchParameters parameters)
        {
            return null;
        }

        public void DeleteProject(int projectId)
        {
           
            using (var connection = new SqlConnection(base.ConnectionString))
            {
                var adapter = new ProjectAdapter();

                using (var command = new SqlCommand("sp_projectDelete", connection))
                {
                    command.Parameters.AddWithValue("@projectId", projectId);

                    command.CommandType = CommandType.StoredProcedure;

                    connection.Open();
                    var reader = command.ExecuteReader();
                    connection.Close();
                }
            }
        }

        public void RemoveEmployeeFromProject(int employeeId, int projectId)
        {
            using (var connection = new SqlConnection(base.ConnectionString))
            {
                var adapter = new ProjectAdapter();

                using (var command = new SqlCommand("sp_projectRemoveEmployee", connection))
                {
                    command.Parameters.AddWithValue("@employeeId", employeeId);
                    command.Parameters.AddWithValue("@projectId", projectId);

                    command.CommandType = CommandType.StoredProcedure;

                    connection.Open();
                    var reader = command.ExecuteReader();
                    connection.Close();
                }
            }
        }

        public void AddEmployeeToProject(int employeeId, int projectId)
        {
            using (var connection = new SqlConnection(base.ConnectionString))
            {
                var adapter = new ProjectAdapter();

                using (var command = new SqlCommand("sp_projectAddEmployee", connection))
                {
                    command.Parameters.AddWithValue("@employeeId", employeeId);
                    command.Parameters.AddWithValue("@projectId", projectId);

                    command.CommandType = CommandType.StoredProcedure;

                    connection.Open();
                    var reader = command.ExecuteReader();
                    connection.Close();
                }
            }
        }

        
        public IEnumerable<DataContracts.IProject> GetProjectsForCompanyId(int companyId)
        {
            var projects = new List<IProject>();

            using (var connection = new SqlConnection(base.ConnectionString))
            {
                var adapter = new ProjectAdapter();

                using (var command = new SqlCommand("sp_projectsRetrieveByCompanyId", connection))
                {
                    command.Parameters.AddWithValue("@companyId", companyId);

                    command.CommandType = CommandType.StoredProcedure;

                    connection.Open();
                    var reader = command.ExecuteReader();

                    while(reader.Read())
                    {
                        projects.Add(adapter.Resolve(new Project(), reader));
                    }

                    connection.Close();
                }
            }

            return projects;
        }

        public IEnumerable<IEmployeeProjectAssignment> GetEmployeesAssignedToProject(int projectId)
        {
            var assignments = new List<IEmployeeProjectAssignment>();

            using (var connection = new SqlConnection(base.ConnectionString))
            {
                var adapter = new ProjectAdapter();

                using (var command = new SqlCommand("sp_ProjectRetrieveEmployees", connection))
                {
                    command.Parameters.AddWithValue("@projectId", projectId);

                    command.CommandType = CommandType.StoredProcedure;

                    connection.Open();
                    var reader = command.ExecuteReader();
                    var personAdapter = new PersonAdapter();

                    while (reader.Read())
                    {
                        var assignment = new EmployeeProjectAssignment();
                        assignment.ProjectId = projectId;
                        assignment.EmployeeId = Convert.ToInt32(reader["EmployeeId"]);
                        assignment.Person = personAdapter.Resolve(new Person(), reader);

                        assignments.Add(assignment);
                    }

                    connection.Close();
                }
            }

            return assignments;
        }
    }
}
