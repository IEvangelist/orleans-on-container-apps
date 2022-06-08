param appName string
param location string
param appInsightsInstrumentationKey string
param appInsightsConnectionString string
param storageConnectionString string

resource containerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: appName
  location: location
}
