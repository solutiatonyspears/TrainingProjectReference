using DataAccess.DataContracts;
using DataAccess.DataModels;
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
    public class ProjectTests
    {
        public ProjectController CreateMockProjectController()
        {
            var controller = new ProjectController(new MockProjectBusinessLogic());
            controller.Request = new HttpRequestMessage();
            controller.Configuration = new HttpConfiguration();
            return controller;
        }

        [TestMethod]
        public void TestGetReturnExpectedProject()
        {
            var controller = CreateMockProjectController();

            var response = controller.Get(1);
            IProject project;
            Assert.IsTrue(response.TryGetContentValue<IProject>(out project));
            Assert.AreEqual(1, project.ProjectId);
        }

        [TestMethod]
        public void TestDeleteExpectedProject()
        {
            var controller = CreateMockProjectController();
            controller.Delete(1);
            var response = controller.Get(1);

            IProject project;
            Assert.IsFalse(response.TryGetContentValue<IProject>(out project));

        }

        [TestMethod]
        public void TestUpdateExpectedProject()
        {
            var controller = CreateMockProjectController();
            var response = controller.Get(1);

            IProject project;
            Assert.IsTrue(response.TryGetContentValue<IProject>(out project));
            project.Name = "Edited Project";

            controller.Put((Project)project);

            response = controller.Get(1);
            Assert.IsTrue(response.TryGetContentValue<IProject>(out project));
            Assert.AreEqual("Edited Project", project.Name);

        }

        [TestMethod]
        public void TestAddNewProject()
        {
            var controller = CreateMockProjectController();
            var project = new Project();
            project.Name = "New Project";
            project.ProjectId = 3;

            var response = controller.Post(project);

            IProject newProject;
            Assert.IsTrue(response.TryGetContentValue<IProject>(out newProject));
            Assert.AreEqual(project.ProjectId, newProject.ProjectId);


        }

    }
}
