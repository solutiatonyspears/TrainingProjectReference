using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SolutiaCMS.Controllers;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using PeoopleControllerTests.Mocks;
using DataAccess.DataContracts;
using System.Web.Http.Routing;
using DataAccess.DataModels;

namespace PeopleControllerTests
{
    [TestClass]
    public class Tests
    {

        [TestMethod]
        public void TestGetReturnsExpectedPerson()
        {
            var controller = CreateMockPersonController();

            var response = controller.Get(1);

            IPerson person;
            Assert.IsTrue(response.TryGetContentValue<IPerson>(out person));
            Assert.AreEqual(1, person.PersonId);
        }

        [TestMethod]
        public void TestDeleteExpectedPerson()
        {
            var controller = CreateMockPersonController();
            controller.Delete(1);

            var response = controller.Get(1);
            IPerson person;
            Assert.IsFalse(response.TryGetContentValue<IPerson>(out person));
        }
        [TestMethod]
        public void TestUpdateExpectedPerson()
        {
            var controller = CreateMockPersonController();
            var response = controller.Get(1);

            IPerson person;
            Assert.IsTrue(response.TryGetContentValue<IPerson>(out person));
            person.FirstName = "Tony";
            controller.Put(person);

            response = controller.Get(1);
            Assert.IsTrue(response.TryGetContentValue<IPerson>(out person));

            Assert.AreEqual("Tony", person.FirstName);
        }

        public PersonController CreateMockPersonController()
        {
            var controller = new PersonController(new MockPersonRepository());
            controller.Request = new HttpRequestMessage();
            controller.Configuration = new HttpConfiguration();
            return controller;
        }

        [TestMethod]
        public void TestPostSetsLocationHeader()
        { 
            var controller = new PersonController(new MockPersonRepository());

            controller.Request = new HttpRequestMessage
            {
                RequestUri = new Uri("http://localhost/api/people")
            };

            controller.Configuration = new HttpConfiguration();
            controller.Configuration.Routes.MapHttpRoute(
                name: "DefaultApi", 
                routeTemplate: "api/{controller}/{id}", 
                defaults: new { id = RouteParameter.Optional });

            controller.RequestContext.RouteData = new HttpRouteData(route: new HttpRoute(),
                values: new HttpRouteValueDictionary { { "controller", "people" } });

            var person = new Person { FirstName = "Added", MiddleName = "The", LastName = "NewPerson" };
            var response = controller.Post(person);

            IPerson resultPerson;
            response.TryGetContentValue<IPerson>(out resultPerson);

            Assert.AreEqual("http://localhost/api/people/" + resultPerson.PersonId, response.Headers.Location.AbsoluteUri);
        }
    }
}
