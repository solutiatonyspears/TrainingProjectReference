using BusinessLogic.Interfaces;
using DataAccess;
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
    [RoutePrefix("api/company")]
    public class CompanyController : ApiController
    {
        private ICompanyBusinessLogic _companyBusinessLogic;
        
        public CompanyController()
        { }

        protected Uri CreateResourceUri(ICompany company)
        {
            string uri = Url.Link("DefaultApi", new { id = company.CompanyId });
            return new Uri(uri);
        }

        public CompanyController(ICompanyBusinessLogic companyBusinessLogic)
        {
            _companyBusinessLogic = companyBusinessLogic;
        }

        [Route("{companyId}")]
        public HttpResponseMessage Get(int companyId)
        {
            var company = _companyBusinessLogic.GetCompanyById(companyId);

            if(company != null)
            {
                return Request.CreateResponse(company);
            }
            else
            {
                return Request.CreateResponse(HttpStatusCode.NotFound);
            }
        }

        [HttpGet]
        [Route("search")]
        public HttpResponseMessage Search([FromUri]CompanySearchParameters parameters)
        {
            var companies = _companyBusinessLogic.SearchForCompanies(parameters);

            return Request.CreateResponse(companies);
        }

        [HttpPost]
        public HttpResponseMessage Post(Company company)
        {
            try
            {
                var newCompany = _companyBusinessLogic.CreateCompany(company);

                var response = Request.CreateResponse(HttpStatusCode.Created, newCompany);
                response.Headers.Location = CreateResourceUri(company);

                return response;
            }
            catch(Exception e)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, e.Message); 
            }
        }

       [HttpPut]
       public HttpResponseMessage Put(Company company)
        {
            try
            {
                var updatedCompany = _companyBusinessLogic.UpdateCompany(company);
                var response = Request.CreateResponse(HttpStatusCode.OK, updatedCompany);
                response.Headers.Location = CreateResourceUri(company);

                return response;
            }
            catch (Exception e)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, e.Message);
            }
        }

       [HttpDelete]
       [Route("{companyId}")]
       public HttpResponseMessage Delete(int companyId)
       {
           _companyBusinessLogic.DeleteCompany(companyId);

           var response = Request.CreateResponse(HttpStatusCode.OK);
           
           return response;
       }

        [HttpPost]
        [Route("{companyId}/employee/{employeeId}")]
        public HttpResponseMessage AddEmployee(int companyId, int employeeId)
        {
            try 
	        {
                if (_companyBusinessLogic.AddEmployee(employeeId, companyId))
                {

                    var response = Request.CreateResponse(HttpStatusCode.OK);
                    return response;
                }
                else
                {
                    return Request.CreateResponse(HttpStatusCode.BadRequest);
                }
           }
           catch(Exception e)
           {
               return Request.CreateResponse(HttpStatusCode.InternalServerError, e.Message);
           }
        }

        [HttpDelete]
        [Route("{companyId}/employee/{employeeId}")]
        public HttpResponseMessage RemoveEmployee(int companyId, int employeeId)
        {
            try{
                _companyBusinessLogic.RemoveEmployee(employeeId, companyId);
                var response = Request.CreateResponse(HttpStatusCode.OK);
                return response;
            }
            catch(Exception e)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, e.Message);
            }
        }

        [HttpGet]
        [Route("{companyId}/employeeIds/all")]
        public HttpResponseMessage GetAllEmployeeIdsForCompany(int companyId)
        {

            var employeeList = _companyBusinessLogic.GetAllEmployeeIds(companyId);
            var response = Request.CreateResponse(HttpStatusCode.OK, employeeList);
            return response;
            
        }

        [HttpGet]
        [Route("{companyId}/employees/all")]
        public HttpResponseMessage GetAllEmployeesForCompany(int companyId)
        {            
            var employeeList = _companyBusinessLogic.GetAllEmployees(companyId);
            var response = Request.CreateResponse(HttpStatusCode.OK, employeeList);
            return response;
        }

        [HttpGet]
        [Route("{companyId}/projects/all")]
        public HttpResponseMessage GetAllProjectsForCompany(int companyId)
        {
            var projectList = _companyBusinessLogic.GetProjectsForCompany(companyId);
            var response = Request.CreateResponse(HttpStatusCode.OK, projectList);
            return response;
        }
    }
}
