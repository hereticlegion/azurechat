param chatGptDeploymentName string
param openai_name string
param chatGptModelName string
param chatGptModelVersion string
param chatGptDeploymentCapacity int

var llmDeployments = [
  {
    name: chatGptDeploymentName
    model: {
      format: 'OpenAI'
      name: chatGptModelName
      version: chatGptModelVersion
    }
    sku: {
      name: 'GlobalStandard'
      capacity: chatGptDeploymentCapacity
    }
  }
  // {
  //   name: embeddingDeploymentName
  //   model: {
  //     format: 'OpenAI'
  //     name: embeddingModelName
  //     version: '2'
  //   }
  //   capacity: embeddingDeploymentCapacity
  // }
]

resource azureopenai 'Microsoft.CognitiveServices/accounts@2023-05-01' existing = {
  name: openai_name
}

@batchSize(1)
resource llmdeployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = [for deployment in llmDeployments: {
  parent: azureopenai
  name: deployment.name
  properties: {
    model: deployment.model
    // raiPolicyName: contains(deployment, 'raiPolicyName') ? deployment.raiPolicyName : null
  }
  sku: deployment.sku
}]

output AZURE_OPEN_AI_KEY string = azureopenai.listKeys().key1
