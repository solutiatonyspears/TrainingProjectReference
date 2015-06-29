using DataAccess;
using DataAccess.DataContracts;
using DataAccess.DataModels;
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
    [RoutePrefix("api/person")]
    public class PersonController:ApiController
    {
        IPersonRepository _repository;

        public PersonController(IPersonRepository repository)
        {
            _repository = repository;
        }

        [HttpGet]
        [Route("{personId}")]
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
        
        [HttpPut]
        public HttpResponseMessage Put(Person person)
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

        [HttpDelete]
        public HttpResponseMessage Delete(int personId)
        {
            _repository.DeletePerson(personId);
            var response = Request.CreateResponse(HttpStatusCode.OK);

            return response;
        }

        [HttpPost]
        public HttpResponseMessage Post(Person person)
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

        [HttpGet]
        public HttpResponseMessage Search([FromUri]PersonSearchParameters parameters)
        {
            var people = _repository.Search(parameters);

            return Request.CreateResponse(people);
        }
    }
}