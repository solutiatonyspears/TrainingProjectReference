using Microsoft.Practices.Unity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http.Controllers;
using System.Web.Http.Dispatcher;

namespace SolutiaCMS
{
    public class UnityHttpControllerActivator : IHttpControllerActivator
    {
        private IUnityContainer _container;

        public UnityHttpControllerActivator(IUnityContainer container)
        {
            _container = container;
        }

        public IHttpController Create(HttpControllerContext controllerContext, Type controllerType)
        {
            return (IHttpController)_container.Resolve(controllerType);
        }

        public IHttpController Create(System.Net.Http.HttpRequestMessage request, HttpControllerDescriptor controllerDescriptor, Type controllerType)
        {
            return (IHttpController)_container.Resolve(controllerType);
        }
    }
}