using BusinessLogic.Interfaces;
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

        public CompanyController(ICompanyBusinessLogic companyBusinessLogic)
        {
            _companyBusinessLogic = companyBusinessLogic;
            
        }

        [Route("{companyId}")]
        public HttpResponseMessage Get(int companyID)
        {
            var company = _companyBusinessLogic.GetCompanyById(companyID);

            if(company != null)
            {
                return Request.CreateResponse(company);
            }
            else
            {
                return Request.CreateResponse(HttpStatusCode.NotFound);
            }
        }

        public HttpResponseMessage Post(ICompany company)
        {
            try
            {
                var newCompany = _companyBusinessLogic.CreateCompany(company);

                var response = Request.CreateResponse(HttpStatusCode.Created, newCompany);
                string uri = Url.Link("DefaultApi", new { id = company.CompanyId });
                response.Headers.Location = new Uri(uri);

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

                string uri = Url.Link("DefaultApi", new { id = company.CompanyId });
                response.Headers.Location = new Uri(uri);

                return response;
            }
            catch (Exception e)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, e.Message);
            }
        }

        public HttpResponseMessage Delete(int companyId)
       {
           _companyBusinessLogic.DeleteCompany(companyId);
           var response = Request.CreateResponse(HttpStatusCode.OK);
           return response;
       }

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

        public HttpResponseMessage GetAllEmployeeIds(int companyId)
        {

            var employeeList = _companyBusinessLogic.GetAllEmployeeIds(companyId);
            var response = Request.CreateResponse(HttpStatusCode.OK, employeeList);
            return response;
            
        }

        public HttpResponseMessage GetAllEmployees(int companyId)
        {
            
            var employeeList = _companyBusinessLogic.GetAllEmployees(companyId);
            var response = Request.CreateResponse(HttpStatusCode.OK, employeeList);
            return response;
        }
    }
}
