
resource "azapi_resource" "table" {
  type      = "Microsoft.OperationalInsights/workspaces/tables@2025-02-01"
  parent_id = azurerm_log_analytics_workspace.law.id
  name      = "MyApplication_CL"
  body = {
    properties = {
      plan            = "Analytics"
      retentionInDays = 30
      schema = {
        name = "MyApplication_CL"
        columns = [
          {
            name = "TimeGenerated"
            type = "datetime"
          },
          {
            name = "Computer"
            type = "string"
          },
          {
            name = "FilePath"
            type = "string"
          },
          {
            name = "Level"
            type = "string"
          },
          {
            name = "LogMessage"
            type = "string"
          },
          {
            name = "MachineName"
            type = "string"
          },
          {
            name = "MachineIP"
            type = "string"
          },
          {
            name = "FixedValue"
            type = "string"
          }
        ]
      }
      totalRetentionInDays = 30
    }
  }
}
