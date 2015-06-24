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
    public class EmployeeController : ApiController
    {
        IEmployeeRepository _repository;

        public EmployeeController(IEmployeeRepository repository)
        {
            _repository = repository;
        }

        public HttpResponseMessage Get(int employeeId)
        {
            var employee = _repository.GetEmployeeById(employeeId);

            if(employee != null)
            {
                return Request.CreateResponse(employee);
            }
            else
            {
                return Request.CreateResponse(HttpStatusCode.NotFound);
            }
        }

        public HttpResponseMessage Put(IEmployee employee)
        {
            try
            {
                var updatedEmployee = _repository.UpdateEmployee(employee);
                var response = Request.CreateResponse(HttpStatusCode.OK, updatedEmployee);

                string uri = Url.Link("DefaultApi", new { id = employee.EmployeeId });
                response.Headers.Location = new Uri(uri);

                return response;
            }
            catch (Exception e)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, e.Message);
            }
        }

        public HttpResponseMessage Delete(int employeeId)
        {
            _repository.DeleteEmployee(employeeId);
            var response = Request.CreateResponse(HttpStatusCode.OK);
            return response;
        }
    }
}
