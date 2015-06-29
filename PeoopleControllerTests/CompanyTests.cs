using CompanyControllerTests.Mocks;
using DataAccess.DataContracts;
using DataAccess.DataModels;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using PeoopleControllerTests.Mocks;
using SolutiaCMS.Controllers;
using System;
using System.Linq;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using System.Web.Http.Routing;

namespace CompanyControllerTests
{
    [TestClass]
    public class CompanyTests
    {
        public CompanyController CreateMockCompanyController(List<ICompany> list = null)
        {
            if(list == null)
            {
                list = new List<ICompany>();
                list.Add(new Company
                {
                    Name = "Solutia",
                    Address = new Address { Street1 = "1234 Main", City = "St.Paul", StateCode = "MN", PostalCode = "55117" },
                    PhoneNumber = "7153388711",
                    CompanyId = 1
                });
            }
            var controller = new CompanyController(new MockCompanyBusinessLogic(list));
            controller.Request = new HttpRequestMessage();
            controller.Configuration = new HttpConfiguration();
            return controller;
        }

        [TestMethod]
        public void TestGetReturnsExpectedCompany()
        {
            var controller = CreateMockCompanyController();
            
            var response = controller.Get(1);

            ICompany company;
            Assert.IsTrue(response.TryGetContentValue<ICompany>(out company));
            Assert.AreEqual(1, company.CompanyId);
        }

        [TestMethod]
        public void TestDeleteExpectedCompany()
        {
            var controller = CreateMockCompanyController();
            controller.Delete(1);
            var response = controller.Get(1);

            ICompany company;
            Assert.IsFalse(response.TryGetContentValue<ICompany>(out company));
        }

        [TestMethod]
        public void TestUpdateExpectedCompany()
        {
            var controller = CreateMockCompanyController();
            var response = controller.Get(1);

            ICompany company;
            Assert.IsTrue(response.TryGetContentValue<ICompany>(out company));
            company.Name = "ABCD Plumbing";
            controller.Put((Company)company);

            response = controller.Get(1);
            Assert.IsTrue(response.TryGetContentValue<ICompany>(out company));
            Assert.AreEqual("ABCD Plumbing", company.Name);
        }

        [TestMethod]
        public void TestAddEmployeeToCompany()
        {
            var controller = CreateMockCompanyController();
            var companyId = 1;
            var empId = 3;
            controller.AddEmployee(companyId, empId);

            var response = controller.GetAllEmployeeIds(companyId);

            IList<int> employeelist;
            Assert.IsTrue(response.TryGetContentValue<IList<int>>(out employeelist));
            
            var employeeId = (from e in employeelist where e == empId select e).SingleOrDefault();
            Assert.AreEqual(empId, employeeId);

        }

    }
}
