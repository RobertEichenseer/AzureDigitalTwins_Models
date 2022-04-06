# Azure Digital Twins Models
## Companion Twin Model 

### Purpose
Example of a simplified Azure Digital Twins Model to highlight / demonstrate manufacturing use cases

### Content
Model highlights the interaction between physical assets like: 
- 3D-Printer
- Conveyor Belt
- Robot
- Production Line 
and non-physical objects like: 
- Production Order 

All physical assets inherit or extend ProdAsset (Telemetry & Property). 

### Relationships
![Relationships](SimplifiedManufacturingModel/img/Relationships.png)

### Graph creation
Executing [this Powershell script](./SimplifiedManufacturingModel/src/CreateADTGraph/CreateGraph.ps1) creates: 
- Azure Resource Group named "AdtSample<< Guid >>"
- Azure Digital Twins instance name "adtsample<< Guid >>"
- Azure Digital Twins instance role assingment "Azure Digital Twins Data Owner" for the logged in User
- Twin Instances + Relationships + Property Values




