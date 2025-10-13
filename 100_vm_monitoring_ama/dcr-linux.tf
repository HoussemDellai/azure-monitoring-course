resource "azurerm_monitor_data_collection_rule" "dcr_linux" {
  name                = "dcr-linux"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  kind                = "Linux"

  identity {
    type = "SystemAssigned"
  }

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.law.id
      name                  = "destination-log"
    }

    azure_monitor_metrics {
      name = "destination-metrics"
    }

    # event_hub {
    #   event_hub_id = azurerm_eventhub.example.id
    #   name         = "example-destination-eventhub"
    # }

    # storage_blob {
    #   storage_account_id = azurerm_storage_account.example.id
    #   container_name     = azurerm_storage_container.example.name
    #   name               = "example-destination-storage"
    # }
  }

  data_flow {
    streams       = ["Custom-Json-MyApplication_CL"]
    destinations  = ["destination-log"]
    output_stream = "Custom-MyApplication_CL"
    transform_kql = "source"
    #     transform_kql = <<EOT
    #     source
    #     | project TimeGenerated = now(),
    #               Computer = "",
    #               FilePath = "",
    #               Message = "",
    #               Level = "",
    #               SourceLine = "",
    #               ThreadId = 0,
    #               RawData = "",
    #               FixedValue = ""
    #   EOT
    # transform_kql = "source | project TimeGenerated = Timestamp, ThreadId, SourceLine, Level, Message, FixedValue"
    # transform_kql = "source | project TimeGenerated = now()" # "source | project TimeGenerated = Time, Computer, Message = AdditionalContext"
    # transform_kql = "source | project TimeGenerated = now() | project LogMessage = 'RawData'" # "source | project TimeGenerated = Time, Computer, Message = AdditionalContext"
    # transform_kql = "source | project d = split(RawData,",") | project TimeGenerated=todatetime(d[0]), Code=toint(d[1]), Severity=tostring(d[2]), Module=tostring(d[3]), Message=tostring(d[4])"
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]
    destinations = ["destination-log"]
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["destination-metrics"]
  }

  data_sources {
    syslog {
      facility_names = ["*"] # ["daemon", "syslog"]
      log_levels     = ["*"] # ["Warning", "Error", "Critical", "Alert", "Emergency"]
      name           = "datasource-syslog"
      streams        = ["Microsoft-Syslog"]
    }

    log_file {
      name          = "Custom-Json-MyApplication_CL"
      format        = "json" # "text"
      streams       = ["Custom-Json-MyApplication_CL"]
      file_patterns = ["/var/log/myapplication.log"]
    }

    performance_counter {
      name    = "CustomPerfCounters"
      streams = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 30
      counter_specifiers = [
        "Processor(*)\\% Processor Time",
        "Processor(*)\\% Idle Time",
        "Processor(*)\\% User Time",
        "Memory(*)\\Available MBytes Memory",
        "Memory(*)\\Used Memory MBytes",
        "Logical Disk(*)\\Free Megabytes",
        "Logical Disk(*)\\% Free Space",
        "Logical Disk(*)\\% Used Space",
        "Network(*)\\Total Packets Transmitted",
        "Network(*)\\Total Packets Received",
        "System(*)\\Uptime",
        "System(*)\\Unique Users",
        "System(*)\\CPUs"
      ]
    }
  }

  stream_declaration {
    stream_name = "Custom-Json-MyApplication_CL"
    column {
      name = "TimeGenerated"
      type = "datetime"
    }
    column {
      name = "DateTime"
      type = "string"
    }
    column {
      name = "Computer"
      type = "string"
    }
    column {
      name = "FilePath"
      type = "string"
    }
    column {
      name = "Level"
      type = "string"
    }
    column {
      name = "LogMessage"
      type = "string"
    }
    column {
      name = "MachineName"
      type = "string"
    }
    column {
      name = "MachineIP"
      type = "string"
    }
    column {
      name = "FixedValue"
      type = "string"
    }
  }
}
