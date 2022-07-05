param appName string
param location string
param containerAppEnvironmentId string
param repositoryImage string = 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
param envVars array = []
param registry string
param registryUsername string
@secure()
param registryPassword string

resource scalerContainerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: '${appName}scaler'
  location: location
  properties: {
    managedEnvironmentId: containerAppEnvironmentId
    configuration: {
      activeRevisionsMode: 'single'
      secrets: [
        {
          name: 'container-registry-password'
          value: registryPassword
        }
      ]
      registries: [
        {
          server: registry
          username: registryUsername
          passwordSecretRef: 'container-registry-password'
        }
      ]
      ingress: {
        external: false
        targetPort: 80
        allowInsecure: true
        transport: 'http2'
      }
    }
    template: {
      containers: [
        {
          image: repositoryImage
          name: appName
          env: envVars
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
    }
  }
}

output fqdn string = scalerContainerApp.properties.configuration.ingress.fqdn
