﻿using BusinessLogic.DTOs;
using BusinessLogic.Interfaces;
using BusinessLogic.UtilityClasses;
using DataAccess.DataContracts;
using DataAccess.Interfaces;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLogic.Company
{
    public class CompanyBusinessLogic : ICompanyBusinessLogic
    {
        private ICompanyRepository _repository;
        private IEmployeeRepository _empRepository;
        private IProjectRepository _projectRepository;
        private IPersonRepository _personRepository;

        public CompanyBusinessLogic(ICompanyRepository repository, IProjectRepository projectRepository, IPersonRepository personRepository)
        {
            _repository = repository;
            _empRepository = (IEmployeeRepository)repository;
            _projectRepository = projectRepository;
            _personRepository = personRepository;
        }

        public DataAccess.DataContracts.ICompany CreateCompany(DataAccess.DataContracts.ICompany company)
        {
            CompanyValidator validator = new CompanyValidator();
            List<string> errors = new List<string>();
            errors = validator.validateCompany(company);
            if(errors.Count == 0)
            {
                return _repository.AddCompany(company);
            }
            else
            {
                var e = new ValidationException("A validation error has occured.", errors);
                throw e;
            }
        }

        public DataAccess.DataContracts.ICompany UpdateCompany(DataAccess.DataContracts.ICompany company)
        {
            CompanyValidator validator = new CompanyValidator();
            List<string> errors = new List<string>();
            errors = validator.validateCompany(company);

            if (company.CompanyId == 0)
            {
                errors.Add("CompanyId cannot be 0.");
            }
            if (errors.Count == 0)
            {
                return _repository.UpdateCompany(company);
            }
            else
            {
                var e = new ValidationException("A validation error has occured.", errors);
                throw e;

            }
          
        }


        public DataAccess.DataContracts.ICompany GetCompanyById(int companyId)
        {
            try
            {
               return _repository.GetCompanyById(companyId);
            }
            catch(Exception e)
            {
                Debug.WriteLine(e.Message);
                throw new Exception("Unable to retrieve companyId: " + companyId);
            }
        }


        public DataAccess.DataContracts.ICompany DeleteCompany(int companyId)
        {
            List<string> errors = new List<string>();

            if(_projectRepository.GetProjectsForCompanyId(companyId).Count() != 0)
            {
                errors.Add("Cannot delete because one or more projects are associated with this company.");
            }
            if (_empRepository.GetAllEmployeeIds(companyId).Count() != 0)
            {
                errors.Add("Cannot delete because one or more employees are associated with this company.");
            }
            if (errors.Count == 0)
            {
                var deletedCompany = _repository.GetCompanyById(companyId);
                if (deletedCompany != null)
                {
                    _repository.DeleteCompany(companyId);
                }
                return deletedCompany;
            }
            else
            {
                var e = new ValidationException("A validation error has occured.", errors);
                throw e;
            }
        }

        public bool AddEmployee(int employeeId, int companyId)
        {
            List<string> errors = new List<string>();
            var employee = _empRepository.GetEmployeeById(employeeId);

            if (employee != null && employee.CompanyId != 0)
            {
                if (employee.CompanyId != companyId)
                {
                    errors.Add("Person is already an employee of another company.");
                }
            }
            if (errors.Count != 0)
            {
                var e = new ValidationException("A validation error has occured.", errors);
                throw e;
            }

           if( _empRepository.AddPersonToCompany(employeeId, companyId) != null)
           {
               return true;
           }
           else
           {
               return false;
           }
        }

        public bool RemoveEmployee(int employeeId, int companyId)
        {
            if (_empRepository.RemoveEmployeeFromCompany(employeeId, companyId) != null)
            {
                return true;
            }

            return false;
        }

        public IEnumerable<int> GetAllEmployeeIds(int companyId)
        {
           return _empRepository.GetAllEmployeeIds(companyId);
        }


        public IEnumerable<IEmployee> GetAllEmployees(int companyId)
        {
            return _empRepository.GetAllEmployees(companyId)
                .OrderBy(e => e.Person.LastName)
                .ThenBy(e => e.Person.FirstName)
                .ThenBy(e => e.Person.MiddleName);
        }

        public IEnumerable<ICompany> SearchForCompanies(DataAccess.CompanySearchParameters parameters)
        {
            var companies = _repository.Search(parameters);
            return companies.OrderBy(c => c.Name)
                .ThenBy(c => c.Address.StateCode)
                .ThenBy(c => c.Address.Street1);
        }

        public IEnumerable<IProject> GetProjectsForCompany(int companyId)
        {
            var projects = _projectRepository.GetProjectsForCompanyId(companyId);
            return projects.OrderBy(p => p.Name);
        }
    }
}
