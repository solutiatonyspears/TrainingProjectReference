using DataAccess.DataContracts;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.DataAdapters
{
    public class ProjectAdapter
    {
        public IProject Resolve(IProject project, SqlDataReader reader)
        {
            project.ProjectId = Convert.ToInt32(reader["projectId"]);
            project.Name = Convert.ToString(reader["name"]);
            project.StatusId = Convert.ToInt32(reader["statusId"]);

            if(!reader.IsDBNull(reader.GetOrdinal("PlannedEndDate"))) project.PlannedEndDate = Convert.ToDateTime(reader["PlannedEndDate"]);
            if (!reader.IsDBNull(reader.GetOrdinal("ActualEndDate"))) project.ActualEndDate = Convert.ToDateTime(reader["ActualEndDate"]);
            if (!reader.IsDBNull(reader.GetOrdinal("PlannedStartDate"))) project.PlannedStartDate = Convert.ToDateTime(reader["PlannedStartDate"]);
            if (!reader.IsDBNull(reader.GetOrdinal("ActualStartDate"))) project.ActualEndDate = Convert.ToDateTime(reader["ActualStartDate"]);

           project.CompanyId = Convert.ToInt32(reader["companyId"]);

            return project; 
        }

        public IList<SqlParameter> ResolveToParameters(IProject project)
        {
            var parameters = new List<SqlParameter>();

            parameters.Add(new SqlParameter("@projectId", project.ProjectId));
            parameters.Add(new SqlParameter("@name", project.Name));
            parameters.Add(new SqlParameter("@plannedStartDate", (object)project.PlannedStartDate ?? DBNull.Value));
            parameters.Add(new SqlParameter("@plannedEndDate", (object)project.PlannedEndDate ?? DBNull.Value));
            parameters.Add(new SqlParameter("@actualStartDate", (object)project.ActualStartDate ?? DBNull.Value));
            parameters.Add(new SqlParameter("@actualEndDate", (object)project.ActualEndDate ?? DBNull.Value));
            parameters.Add(new SqlParameter("@companyId", (object)project.CompanyId));
            parameters.Add(new SqlParameter("@statusId", (object)project.StatusId));
            return parameters;
        }
    }
}
