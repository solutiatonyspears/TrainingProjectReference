using DataAccess.DataContracts;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using PeoopleControllerTests.Mocks;
using SolutiaCMS.Controllers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;

namespace PeoopleControllerTests
{
    [TestClass]
   public class EmployeeTests
    {
        public EmployeeController CreateMockEmployeeController()
        {
            var controller = new EmployeeController(new MockEmployeeRepository());
            controller.Request = new HttpRequestMessage();
            controller.Configuration = new HttpConfiguration();
            return controller;
        }

        [TestMethod]
        public void TestGetReturnsExpectedEmployee()
        {
            var controller = CreateMockEmployeeController();

            var response = controller.Get(1);

            IEmployee employee;
            Assert.IsTrue(response.TryGetContentValue<IEmployee>(out employee));
            Assert.AreEqual(1, employee.EmployeeId);
        }

        [TestMethod]
        public void TestDeleteExpectedEmployee()
        {
            var controller = CreateMockEmployeeController();
            controller.Delete(1);
            var response = controller.Get(1);

            IEmployee employee;
            Assert.IsFalse(response.TryGetContentValue<IEmployee>(out employee));
        }

        [TestMethod]
        public void TestUpdateExpectedEmployee()
        {
            var controller = CreateMockEmployeeController();
            var response = controller.Get(1);

            IEmployee employee;
            Assert.IsTrue(response.TryGetContentValue<IEmployee>(out employee));
            employee.IsActive = false;
            controller.Put(employee);

            response = controller.Get(1);
            Assert.IsTrue(response.TryGetContentValue<IEmployee>(out employee));
            Assert.AreEqual(false, employee.IsActive);
        }
    }
}
