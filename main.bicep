param appName string = 'myFunctionApp'
param location string = 'westus2'
param runtimeVersion string = '3'

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: '${appName}-plan'
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {
    reserved: true
    targetWorkerCount: 0
    targetWorkerSizeId: 0
  }
}

resource functionApp 'Microsoft.Web/sites@2020-06-01' = {
  name: appName
  location: location
  dependsOn: [
    appServicePlan
  ]
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
      ]
    }
    httpsOnly: true
  }
}

output functionAppUrl string = functionApp.properties.defaultHostName
