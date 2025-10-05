# #!/bin/bash

# # Variáveis
# RESOURCE_GROUP_NAME="rg-playmix-mvc"
# WEBAPP_NAME="playmix-mvc-rm554424"
# APP_SERVICE_PLAN="playmix-mvc"
# LOCATION="brazilsouth"
# RUNTIME="JAVA:17-java17"
# GITHUB_REPO_NAME="dinozindev/playmix-mvc"
# BRANCH="main"
# APP_INSIGHTS_NAME="ai-playmix-mvc"
# SERVER_NAME="sqlserverplaymixrm5544242tdsb"   # corrigido
# DB_USER="user-playmix"
# DB_PASS="Fiap@2tdsvms"
# DB_NAME="db-playmix"

# # Criar Resource Group
# az group create \
#     --name $RESOURCE_GROUP_NAME \
#     --location "$LOCATION"

# # Criar SQL Server
# az sql server create \
#     --name $SERVER_NAME \
#     --resource-group $RESOURCE_GROUP_NAME \
#     --location $LOCATION \
#     --admin-user $DB_USER \
#     --admin-password $DB_PASS \
#     --enable-public-network true

# # Criar Database
# az sql db create \
#     --resource-group $RESOURCE_GROUP_NAME \
#     --server $SERVER_NAME \
#     --name $DB_NAME \
#     --service-objective Basic \
#     --backup-storage-redundancy Local \
#     --zone-redundant false

# # Liberar firewall (acesso geral)
# az sql server firewall-rule create \
#     --resource-group $RESOURCE_GROUP_NAME \
#     --server $SERVER_NAME \
#     --name liberaGeral \
#     --start-ip-address 0.0.0.0 \
#     --end-ip-address 255.255.255.255

# # Criar Application Insights
# az monitor app-insights component create \
#     --app $APP_INSIGHTS_NAME \
#     --location "$LOCATION" \
#     --resource-group $RESOURCE_GROUP_NAME \
#     --application-type web

# # Criar App Service Plan
# az appservice plan create \
#     --name $APP_SERVICE_PLAN \
#     --resource-group $RESOURCE_GROUP_NAME \
#     --location "$LOCATION" \
#     --sku B1 \
#     --is-linux

# # Criar Web App
# az webapp create \
#     --name $WEBAPP_NAME \
#     --resource-group $RESOURCE_GROUP_NAME \
#     --plan $APP_SERVICE_PLAN \
#     --runtime "$RUNTIME"

# # Habilitar autenticação SCM
# az resource update \
#     --resource-group $RESOURCE_GROUP_NAME \
#     --namespace Microsoft.Web \
#     --resource-type basicPublishingCredentialsPolicies \
#     --name scm \
#     --parent sites/$WEBAPP_NAME \
#     --set properties.allow=true

# # Recuperar connection string do App Insights
# CONNECTION_STRING=$(az monitor app-insights component show \
#     --app $APP_INSIGHTS_NAME \
#     --resource-group $RESOURCE_GROUP_NAME \
#     --query connectionString \
#     --output tsv)

# # Configurar App Settings
# az webapp config appsettings set \
#     --name "$WEBAPP_NAME" \
#     --resource-group "$RESOURCE_GROUP_NAME" \
#     --settings \
#     APPLICATIONINSIGHTS_CONNECTION_STRING="$CONNECTION_STRING" \
#     ApplicationInsightsAgent_EXTENSION_VERSION="~3" \
#     XDT_MicrosoftApplicationInsights_Mode="Recommended" \
#     XDT_MicrosoftApplicationInsights_PreemptSdk="1" \
#     SPRING_DATASOURCE_USERNAME="$DB_USER" \
#     SPRING_DATASOURCE_PASSWORD="$DB_PASS" \
#     SPRING_DATASOURCE_URL="jdbc:sqlserver://$SERVER_NAME.database.windows.net:1433;database=$DB_NAME;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"

# # Restart Web App
# az webapp restart --name $WEBAPP_NAME --resource-group $RESOURCE_GROUP_NAME

# # Conectar Web App ao App Insights
# az monitor app-insights component connect-webapp \
#     --app $APP_INSIGHTS_NAME \
#     --web-app $WEBAPP_NAME \
#     --resource-group $RESOURCE_GROUP_NAME

# # Aguardar para garantir que o Web App já esteja disponível
# echo "Aguardando o provisionamento do WebApp..."
# sleep 15

# # Configurar GitHub Actions (vai pedir login no GitHub na primeira vez)
# az webapp deployment github-actions add \
#     --name $WEBAPP_NAME \
#     --resource-group $RESOURCE_GROUP_NAME \
#     --repo $GITHUB_REPO_NAME \
#     --branch $BRANCH \
#     --login-with-github

#!/bin/bash

# Variáveis
RESOURCE_GROUP_NAME="rg-playmix-mvc-2tdsb"
WEBAPP_NAME="playmix-mvc-rm554424-2tdsb"
APP_SERVICE_PLAN="playmix-mvc"
LOCATION="eastus2"
RUNTIME="JAVA:17-java17"
GITHUB_REPO_NAME="dinozindev/playmix-mvc"
BRANCH="main"
APP_INSIGHTS_NAME="ai-playmix-mvc"
SERVER_NAME="sql-server-playmix-rm554424-2tdsb"
DB_USER=user-playmix
DB_PASS="Fiap@2tdsvms"
DB_NAME=db-playmix

# Criação do Grupo de Recursos
az group create \
  --name $RESOURCE_GROUP_NAME \
  --location "$LOCATION"

# Criação do SQL Server
az sql server create \
  --name $SERVER_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --location $LOCATION \
  --admin-user $DB_USER \
  --admin-password $DB_PASS \
  --enable-public-network true

# Criação do Banco de Dados
az sql db create \
  --resource-group $RESOURCE_GROUP_NAME \
  --server $SERVER_NAME \
  --name $DB_NAME \
  --service-objective Basic \
  --backup-storage-redundancy Local \
  --zone-redundant false

#PermitiracessopúblicoliberandotodososIPsnoFirewalldoServidor
az sql server firewall-rule create \
  --resource-group $RESOURCE_GROUP_NAME \
  --server $SERVER_NAME \
  --name liberaGeral \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 255.255.255.255

# Criar Application Insights
az monitor app-insights component create \
  --app $APP_INSIGHTS_NAME \
  --location "$LOCATION" \
  --resource-group $RESOURCE_GROUP_NAME \
  --application-type web

# Criar o Plano de Serviço
az appservice plan create \
  --name $APP_SERVICE_PLAN \
  --resource-group $RESOURCE_GROUP_NAME \
  --location "$LOCATION" \
  --sku F1 \
  --is-linux

# Criar o Serviço de Aplicativo
az webapp create \
  --name $WEBAPP_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --plan $APP_SERVICE_PLAN \
  --runtime "$RUNTIME"

# Habilita a autenticação Básica (SCM)
az resource update \
  --resource-group $RESOURCE_GROUP_NAME \
  --namespace Microsoft.Web \
  --resource-type basicPublishingCredentialsPolicies \
  --name scm \
  --parent sites/$WEBAPP_NAME \
  --set properties.allow=true

# Recuperar a String de Conexão do Application Insights (assim podemos nos conectar a esse App Insights)
CONNECTION_STRING=$(az monitor app-insights component show \
  --app $APP_INSIGHTS_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --query connectionString \
  --output tsv)

# Configurar as Variáveis de Ambiente necessárias do nosso App e do Application Insights
az webapp config appsettings set \
  --name "$WEBAPP_NAME" \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --settings \
    APPLICATIONINSIGHTS_CONNECTION_STRING="$CONNECTION_STRING" \
    ApplicationInsightsAgent_EXTENSION_VERSION="~3" \
    XDT_MicrosoftApplicationInsights_Mode="Recommended" \
    XDT_MicrosoftApplicationInsights_PreemptSdk="1" \
    SPRING_DATASOURCE_USERNAME="$DB_USER" \
    SPRING_DATASOURCE_PASSWORD="$DB_PASS" \
    SPRING_DATASOURCE_URL="jdbc:sqlserver://$SERVER_NAME.database.windows.net:1433;database=$DB_NAME;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"

# Reiniciar o Web App
az webapp restart --name $WEBAPP_NAME --resource-group $RESOURCE_GROUP_NAME

# Criar a conexão do nosso Web App com o Application Insights
az monitor app-insights component connect-webapp \
  --app $APP_INSIGHTS_NAME \
  --web-app $WEBAPP_NAME \
  --resource-group $RESOURCE_GROUP_NAME

# Configurar GitHub Actions para Build e Deploy automático
az webapp deployment github-actions add \
  --name $WEBAPP_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --repo $GITHUB_REPO_NAME \
  --branch $BRANCH \
  --login-with-github
