using BusinessLogic.Interfaces;
using BusinessLogic.UtilityClasses;
using DataAccess.DataContracts;
using DataAccess.DataModels;
using DataAccess.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace SolutiaCMS.Controllers
{
    [RoutePrefix("api/project")]
    public class ProjectController : ApiController
    {
        IProjectBusinessLogic _businessLogic;

        public ProjectController(IProjectBusinessLogic businessLogic)
        {
            _businessLogic = businessLogic;
        }

        [HttpGet]
        [Route("{projectId}")]
        public HttpResponseMessage Get(int projectId)
        {
            var project = _businessLogic.GetProject(projectId);

            if (project != null)
            {
                return Request.CreateResponse(project);
            }
            else
            {
                return Request.CreateResponse(HttpStatusCode.NotFound);
            }
        }

        [HttpPost]
        public HttpResponseMessage Post(Project project)
        {
            try
            {
                var newProject = _businessLogic.CreateProject(project);
                var response = Request.CreateResponse(HttpStatusCode.Created, newProject);
                string uri = Url.Link("DefaultApi", new { id = project.ProjectId });
                response.Headers.Location = new Uri(uri);

                return response;
            }
            catch (ValidationException e)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, e.Data);
            }
            catch (Exception e)
            {
                
                return Request.CreateResponse(HttpStatusCode.InternalServerError, e.Message);
            }
        }

        [HttpPut]
        public HttpResponseMessage Put(Project project)
        {
            try
            {
                var updatedProject = _businessLogic.UpdateProject(project);
                var response = Request.CreateResponse(HttpStatusCode.OK, updatedProject);
                string uri = Url.Link("DefaultApi", new { id = project.ProjectId });
                response.Headers.Location = new Uri(uri);

                return response;
            }
            catch(ValidationException e)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, e.Data);
            }
            catch (Exception e)
            {
                
                return Request.CreateResponse(HttpStatusCode.InternalServerError, e.Message);
            }
        }

        [HttpDelete]
        [Route("{projectId}")]
        public HttpResponseMessage Delete(int projectId)
        {
            try
            {
                _businessLogic.DeleteProject(projectId);
                var response = Request.CreateResponse(HttpStatusCode.OK);

                return response;
            }
            catch(Exception e)
            {
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, e.Message);
            }
        }

        [HttpPost]
        [Route("{projectId}/employees/{employeeId}")]
        public HttpResponseMessage AddEmployeeToProject(int employeeId, int projectId)
        {
            _businessLogic.AddEmployeeToProject(projectId, employeeId);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [HttpDelete]
        [Route("{projectId}/employees/{employeeId}")]
        public HttpResponseMessage RemoveEmployeeFromProject(int employeeId, int projectId)
        {
            _businessLogic.RemoveEmployeeFromProject(projectId, employeeId);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [HttpGet]
        [Route("{projectId}/employees/all")]
        public HttpResponseMessage GetEmployeesForProject(int projectId)
        {
            var employees = _businessLogic.GetEmployeesOnProject(projectId);
            if(employees != null)
            {
                return Request.CreateResponse(employees);
            }
            else
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Specified Project was not found.");
            }
        }
    }
}
