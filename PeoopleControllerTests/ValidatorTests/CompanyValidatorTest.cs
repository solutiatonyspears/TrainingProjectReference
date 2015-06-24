using BusinessLogic.Company;
using DataAccess.DataModels;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PeoopleControllerTests.ValidatorTests
{
    [TestClass]
    public class CompanyValidatorTest
    {
        [TestMethod]
        public void TestProperlyConstructedCompanyPasses()
        {
            var company = new Company {Name = "Solutia Consulting", 
                                       Address = new Address{Street1 = "123 Main St.", City = "St. Paul", PostalCode="55117", StateCode="MN"},
                                       PhoneNumber = "7153388711",
                                       };
            var validator = new CompanyValidator();

           var result = validator.validateCompany(company);

           Assert.AreEqual(0,result.Count);
        }

        [TestMethod]
        public void TestCompanyDoesntHaveName()
        {
            var company = new Company
            {
                Address = new Address { Street1 = "123 Main St.", City = "St. Paul", PostalCode = "55117", StateCode = "MN" },
                PhoneNumber = "7153388711",
            };
            var validator = new CompanyValidator();

            var result = validator.validateCompany(company);

            Assert.AreEqual(1, result.Count);
        }

        [TestMethod]
        public void TestCompanyDoesntHaveAddress()
        {
            var company = new Company
            {   Name = "Solutia Consulting",
                PhoneNumber = "7153388711",
            };
            var validator = new CompanyValidator();

            var result = validator.validateCompany(company);

            Assert.AreNotEqual(0, result.Count);
        }

        [TestMethod]
        public void TestCompanyDoesntHavePhoneNumber()
        {
            var company = new Company
            {
                Name = "Solutia Consulting",
                Address = new Address { Street1 = "123 Main St.", City = "St. Paul", PostalCode = "55117", StateCode = "MN" }
            };
            var validator = new CompanyValidator();

            var result = validator.validateCompany(company);

            Assert.AreNotEqual(0, result.Count);
        }
    }
}
