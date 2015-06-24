using DataAccess.DataContracts;
using DataAccess.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace SolutiaCMS.Controllers
{
    public class PersonController:ApiController
    {
        IPersonRepository _repository;

        public PersonController(IPersonRepository repository)
        {
            _repository = repository;
        }

        public HttpResponseMessage Get(int personId)
        {
            var person = _repository.GetPersonById(personId);

            if(person != null)
            {
                return Request.CreateResponse(person);
            }
            else
            {
                return Request.CreateResponse(HttpStatusCode.NotFound);
            }
        }
        
        public HttpResponseMessage Put(IPerson person)
        {
            try
            {
                var updatedPerson = _repository.UpdatePerson(person);

                var response = Request.CreateResponse(HttpStatusCode.OK, updatedPerson);
                string uri = Url.Link("DefaultApi", new { id = person.PersonId });
                response.Headers.Location = new Uri(uri);

                return response;
            }
            catch(Exception e)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, e.Message); //<--Generally you don't want to do this. Rather, you'd want to map the exception to a user-friendly error message and log the real exception.
            }
        }

        public HttpResponseMessage Delete(int personId)
        {
            _repository.DeletePerson(personId);
            var response = Request.CreateResponse(HttpStatusCode.OK);

            return response;
        }

        public HttpResponseMessage Post(IPerson person)
        {
            try
            {
                var newPerson = _repository.AddPerson(person);

                var response = Request.CreateResponse(HttpStatusCode.Created, newPerson);
                string uri = Url.Link("DefaultApi", new { id = person.PersonId });
                response.Headers.Location = new Uri(uri);

                return response;
            }
            catch(Exception e)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, e.Message); //<--Generally you don't want to do this. Rather, you'd want to map the exception to a user-friendly error message and log the real exception.
            }
        }
    }
}