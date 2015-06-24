using BusinessLogic.Company;
using BusinessLogic.Interfaces;
using DataAccess.Interfaces;
using DataAccess.Repositories;
using Microsoft.Practices.Unity;
using SolutiaCMS.Controllers;
using System.Web.Http;
using System.Web.Http.Dispatcher;
using Unity.WebApi;

namespace SolutiaCMS
{
    public static class UnityConfig
    {
        public static void RegisterComponents(HttpConfiguration config)
        {
			var container = new UnityContainer();
            container.RegisterInstance<IHttpControllerActivator>(new UnityHttpControllerActivator(container));


            // register all your components with the container here
            // it is NOT necessary to register your controllers
            
            // e.g. container.RegisterType<ITestService, TestService>();
            
            GlobalConfiguration.Configuration.DependencyResolver = new UnityDependencyResolver(container);
            RegisterTypes(container);

            config.DependencyResolver = new UnityResolver(container);
        }

        public static void RegisterTypes(UnityContainer container)
        {
            container.RegisterType<IEmployeeRepository, EmployeeRepository>(new PerResolveLifetimeManager());
            container.RegisterType<ICompanyRepository, CompanyRepository>(new PerResolveLifetimeManager());
            container.RegisterType<IProjectRepository, ProjectRepository>(new PerResolveLifetimeManager());
            container.RegisterType<IPersonRepository, PersonRepository>(new PerResolveLifetimeManager());
            container.RegisterType<ICompanyBusinessLogic, CompanyBusinessLogic>(new PerResolveLifetimeManager());
            container.RegisterType<CompanyController>(new InjectionConstructor(new ResolvedParameter<ICompanyBusinessLogic>()));
            container.RegisterType<CompanyBusinessLogic>(new InjectionConstructor(new ResolvedParameter<ICompanyRepository>(), new ResolvedParameter<IEmployeeRepository>(), new ResolvedParameter<IProjectRepository>(), new ResolvedParameter<IPersonRepository>()));

        }
    }
}