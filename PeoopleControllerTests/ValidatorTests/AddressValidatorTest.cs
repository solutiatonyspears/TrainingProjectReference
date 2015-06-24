using BusinessLogic.Address;
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
    public class AddressValidatorTest
    {
        [TestMethod]
        public void TestValidAddressPasses()
        {
           var address = new Address { Street1 = "123 Main St.", City = "St. Paul", PostalCode = "55117", StateCode = "MN" };
           AddressValidator validator = new AddressValidator();

           List<string> errors = new List<string>();

           errors = validator.validateAddress(address);

           Assert.AreEqual(0, errors.Count);
        }

        [TestMethod]
        public void TestAddressDoesntHaveStreet()
        {
            var address = new Address {City = "St. Paul", PostalCode = "55117", StateCode = "MN" };
            AddressValidator validator = new AddressValidator();

            List<string> errors = new List<string>();

            errors = validator.validateAddress(address);

            Assert.AreNotEqual(0, errors.Count);
        }

        [TestMethod]
        public void TestAddressDoesntHaveCity()
        {
            var address = new Address { Street1 = "123 Main St.", PostalCode = "55117", StateCode = "MN" };
            AddressValidator validator = new AddressValidator();

            List<string> errors = new List<string>();

            errors = validator.validateAddress(address);

            Assert.AreNotEqual(0, errors.Count);
        }

        [TestMethod]
        public void TestAddressDoesntHavePostalCode()
        {
            var address = new Address { Street1 = "123 Main St.", City = "St. Paul", StateCode = "MN" };
            AddressValidator validator = new AddressValidator();

            List<string> errors = new List<string>();

            errors = validator.validateAddress(address);

            Assert.AreNotEqual(0, errors.Count);
        }

        [TestMethod]
        public void TestAddressDoesntHaveStateCode()
        {
            var address = new Address { Street1 = "123 Main St.", City = "St. Paul", PostalCode = "55117"};
            AddressValidator validator = new AddressValidator();

            List<string> errors = new List<string>();

            errors = validator.validateAddress(address);

            Assert.AreNotEqual(0, errors.Count);
        }

        [TestMethod]
        public void TestAddressDoesntHaveValidStateCode()
        {
            var address = new Address { Street1 = "123 Main St.", City = "St. Paul", PostalCode = "55117", StateCode = "MINNESOTA" };
            AddressValidator validator = new AddressValidator();

            List<string> errors = new List<string>();

            errors = validator.validateAddress(address);

            Assert.AreNotEqual(0, errors.Count);
        }

        [TestMethod]
        public void TestAddressDoesntHaveValidPostalCode()
        {
            var address = new Address { Street1 = "123 Main St.", City = "St. Paul", PostalCode = "fivefivefivefive", StateCode = "MN" };
            AddressValidator validator = new AddressValidator();

            List<string> errors = new List<string>();

            errors = validator.validateAddress(address);

            Assert.AreNotEqual(0, errors.Count);
        }
        
        [TestMethod]
        public void TestAddressIsEmpty()
        {
            var address = new Address();
            AddressValidator validator = new AddressValidator();

            List<string> errors = new List<string>();

            errors = validator.validateAddress(address);

            Assert.AreNotEqual(0, errors.Count);
        }
    }
}
