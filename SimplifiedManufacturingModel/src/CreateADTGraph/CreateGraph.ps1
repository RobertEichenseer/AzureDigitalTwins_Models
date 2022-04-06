#Ensure latest version of IoT tooling
az provider register --namespace 'Microsoft.DigitalTwins'
az extension add --upgrade --name azure-iot

#login to subscription
az login

#Basic Definitions
$resourceGroup = "AdtSample" + (New-Guid).ToString()
$location = "WestEurope"

#ADT
$adtName= "adtsample" + (New-Guid).ToString()
$modelFolder = "$(Get-Location)\SimplifiedManufacturingModel\src\Models"

##ADT Twin Definition
$dtmiConveyerBeltId = "dtmi:Demo:AdditiveManufacturing:ConveyorBelt;1"
$ConveyerBeltTwinId = "blt_Muc_01"

$dtmiPrinterId = "dtmi:Demo:AdditiveManufacturing:Printer;1"
$PrinterTwinId = "prn_Muc_01"

$dtmiProductionLineId = "dtmi:Demo:AdditiveManufacturing:ProductionLine;1"
$ProductionLineTwinId = "pl_Muc_01"

$dtmiRobotId = "dtmi:Demo:AdditiveManufacturing:Robot;1"
$RobotTwinId = "rbt_Muc_01"

$dtmiProductionOrderId = "dtmi:Demo:AdditiveManufacturing:ProductionOrder;1"
$ProductionOrderTwinId = "ord_Muc_01"

#ADT Access Policy - User
$adtPolicyUserId = (az ad signed-in-user show --query objectId).Trim('"')

#Create resource group
az group create `
    --location $location `
    --resource-group $resourceGroup

#Create ADT Instance
az dt create `
    --dt-name $adtName `
    --resource-group $resourceGroup 

##Create ADT Data Owner role for logged in user

az dt role-assignment create `
    --dt-name $adtName `
    --assignee $adtPolicyUserId `
    --role "Azure Digital Twins Data Owner"

##Create/Upload models
az dt model create `
    --dt-name $adtName `
    --from-directory $modelFolder

##Create Twin Instances
az dt twin create `
    --dt-name $adtName `
    --dtmi $dtmiConveyerBeltId `
    --twin-id $ConveyerBeltTwinId 

az dt twin update `
    --dt-name $adtName `
    --twin-id $ConveyerBeltTwinId `
    --json-patch '[{""op"":""add"", ""path"":""/avgSpeed"", ""value"": 10.5},{""op"":""add"", ""path"":""/inventoryId"", ""value"": ""Muc-4711""},{""op"":""add"", ""path"":""/energyConsumptionLast5Minutes"", ""value"": ""19.5 kW""}]'

az dt twin create `
    --dt-name $adtName `
    --dtmi $dtmiPrinterId `
    --twin-id $PrinterTwinId 

az dt twin update `
    --dt-name $adtName `
    --twin-id $PrinterTwinId `
    --json-patch '[{""op"":""add"", ""path"":""/powderConsumption"", ""value"": 3.75},{""op"":""add"", ""path"":""/inventoryId"", ""value"": ""Muc-4712""},{""op"":""add"", ""path"":""/energyConsumptionLast5Minutes"", ""value"": ""8.3 kW""}]'


az dt twin create `
    --dt-name $adtName `
    --dtmi $dtmiProductionLineId `
    --twin-id $ProductionLineTwinId 

az dt twin update `
    --dt-name $adtName `
    --twin-id $ProductionLineTwinId `
    --json-patch '[{""op"":""add"", ""path"":""/location"", ""value"": ""109.453|48.879""},{""op"":""add"", ""path"":""/inventoryId"", ""value"": ""Muc-4713""},{""op"":""add"", ""path"":""/energyConsumptionLast5Minutes"", ""value"": ""35.3 kW""}]'

az dt twin create `
    --dt-name $adtName `
    --dtmi $dtmiRobotId `
    --twin-id $RobotTwinId 

az dt twin update `
    --dt-name $adtName `
    --twin-id $RobotTwinId `
    --json-patch '[{""op"":""add"", ""path"":""/robotType"", ""value"": ""KJO/98/098""},{""op"":""add"", ""path"":""/inventoryId"", ""value"": ""Muc-4714""},{""op"":""add"", ""path"":""/energyConsumptionLast5Minutes"", ""value"": ""7.5 kW""}]'


az dt twin create `
    --dt-name $adtName `
    --dtmi $dtmiProductionOrderId `
    --twin-id $ProductionOrderTwinId 

az dt twin update `
    --dt-name $adtName `
    --twin-id $ProductionOrderTwinId `
    --json-patch '[{""op"":""add"", ""path"":""/orderId"", ""value"": ""DYN34508-0808""}]'


##Create Relationship(s)
az dt twin relationship create `
    --dt-name $adtName `
    --relationship-id (New-Guid).ToString() `
    --relationship 'assignedProductionLine' `
    --twin-id 'ord_Muc_01' `
    --target 'pl_Muc_01'

az dt twin relationship create `
    --dt-name $adtName `
    --relationship-id (New-Guid).ToString() `
    --relationship 'mountedConveyorBelt' `
    --twin-id 'pl_Muc_01' `
    --target 'blt_Muc_01'

az dt twin relationship create `
    --dt-name $adtName `
    --relationship-id (New-Guid).ToString() `
    --relationship 'mountedRobot' `
    --twin-id 'pl_Muc_01' `
    --target 'rbt_Muc_01'

az dt twin relationship create `
    --dt-name $adtName `
    --relationship-id (New-Guid).ToString() `
    --relationship 'mountedPrinter' `
    --twin-id 'pl_Muc_01' `
    --target 'prn_Muc_01'

az dt twin relationship create `
    --dt-name $adtName `
    --relationship-id (New-Guid).ToString() `
    --relationship 'feeds' `
    --twin-id 'prn_Muc_01' `
    --target 'blt_Muc_01'

az dt twin relationship create `
    --dt-name $adtName `
    --relationship-id (New-Guid).ToString() `
    --relationship 'forwards' `
    --twin-id 'blt_Muc_01' `
    --target 'rbt_Muc_01'



