using DataAccess.DataContracts;
using DataAccess.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace SolutiaCMS.Controllers
{
    public class ProjectController : ApiController
    {
        IProjectRepository _repository;

        public ProjectController(IProjectRepository repository)
        {
            _repository = repository;
        }

        public HttpResponseMessage Get(int projectId)
        {
            var project = _repository.GetProjectById(projectId);

            if (project != null)
            {
                return Request.CreateResponse(project);
            }
            else
            {
                return Request.CreateResponse(HttpStatusCode.NotFound);
            }
        }

        public HttpResponseMessage Post(IProject project)
        {
            try
            {
                var newProject = _repository.AddProject(project);
                var response = Request.CreateResponse(HttpStatusCode.Created, newProject);
                //string uri = Url.Link("DefaultApi", new { id = project.ProjectId });
                //response.Headers.Location = new Uri(uri);

                return response;
            }
            catch (Exception e)
            {
                
                return Request.CreateResponse(HttpStatusCode.InternalServerError, e.Message);
            }
        }

        public HttpResponseMessage Put(IProject project)
        {
            try
            {
                var updatedProject = _repository.GetProjectById(project.ProjectId);
                var response = Request.CreateResponse(HttpStatusCode.OK, updatedProject);
                string uri = Url.Link("DefaultApi", new { id = project.ProjectId });
                response.Headers.Location = new Uri(uri);

                return response;
            }
            catch (Exception e)
            {
                
                return Request.CreateResponse(HttpStatusCode.InternalServerError, e.Message);
            }
        }

        public HttpResponseMessage Delete(int projectId)
        {
            _repository.DeleteProject(projectId);
            var response = Request.CreateResponse(HttpStatusCode.OK);

            return response;
        }
    }
}
