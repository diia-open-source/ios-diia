# Diia


This repository provides an overview over the flagship product [**Diia**](https://diia.gov.ua/) developed by the [**Ministry of Digital Transformation of Ukraine**](https://thedigital.gov.ua/).
 
**Diia** is an app with access to citizen’s digital documents and government services.
 
The application was created so that Ukrainians could interact with the state in a few clicks, without spending their time on queues and paperwork - **Diia** open source application will help countries, companies and communities build a foundation for long-term relationships. At the heart of these relations are openness, efficiency and humanity.
 
We're pleased to share the **Diia** project with you.

## Useful Links

|Topic|Link|Description|
|--|--|--|
|Ministry of Digital Transformation of Ukraine|https://thedigital.gov.ua/|The Official homepage of the Ministry of Digital Transformation of Ukraine| 
|Diia App|https://diia.gov.ua/|The Official website for the Diia application

## Getting Started

### Installing

1.1. Clone the repository and open the Xcode project file.

```bash
git clone https://github.com/diia-open-source/ios-diia.git
cd ios-diia
open DiiaOpenSource.xcodeproj
```
1.2. Wait for the SPM packages to finish resolving. 

### Executing program

Build and run the project on iOS device or simulator.

## How to test

To get mock user for testing please refer to the [TESTING.md](https://github.com/diia-open-source/diia-setup-howto/blob/main/TESTING.md) file for details.

## Configuration Details

For configuring project we are using `.xcconfig` settings files:

__Development Environment (DiiaDev.xcconfig)__
```text
// API
API_BASE_URL = api2oss.diia.gov.ua

// APP SETTINGS
APP_NAME = Diia OpenSource
APP_BUNDLE_ID = ua.gov.diia.opensource.app
SCHEME = DiiaDev
```

- `API_BASE_URL`: Set this to the URL of your backend server.
- `APP_NAME`: Defines the name of the application.
- `APP_BUNDLE_ID`: Specifies the bundle identifier of the application.
- `SCHEME`: Indicates the scheme used for the application.

## Features

### Authorization
- Presenting authentication available methods
- Bank-ID authorization method
- PinCode. Enteing, changing pincode plust enabling the using biometry option
  
### Documents
- Presenting collection of available documents with the ability to change the order
- Driver License document

### Public Services
- Presenting list of avalable public services
- Criminal Record Extract service

### Settings Menu
It serves as the go-to hub for personalized control and management within the app, offering features like the ability to reorder documents, change the app's pin code, toggle biometry on/off, contact support, read about the app and policies, and log out.

## Dependencies

Almost all features and core components such as network core and UI library are shipped as separate SPM packages.

### 1st party

* [DiiaMVPModule](https://github.com/diia-open-source/ios-mvpmodule.git): Model-View-Presenter basic protocols
* [DiiaNetwork](https://github.com/diia-open-source/ios-network.git): The foundational network layer
* [DiiaUIComponents](https://github.com/diia-open-source/ios-uicomponents.git): Basic UI components and primitives.
* [DiiaCommonTypes](https://github.com/diia-open-source/ios-commontypes.git): Types (classes, strucutres, protocols) that have to be shared amond several packages.
* [DiiaCommonServices](https://github.com/diia-open-source/ios-commonservices.git): Foundational utilities and modules providing essential support for Diia on iOS.
* [DiiaAuthorization](https://github.com/diia-open-source/ios-authorization.git): Core of authorization, authorization methods and pin code.
* [DiiaDocuments](https://github.com/diia-open-source/ios-documents.git): Documents core functionality and particular documents
* [DiiaPublicServices](https://github.com/diia-open-source/ios-publicservices.git): Public services core functionality and particular public services.

### 3rd party

* [RNCryptor](https://github.com/RNCryptor/RNCryptor.git)
* [Lottie](https://github.com/airbnb/lottie-spm.git)

## How to contribute

The Diia project welcomes contributions into this solution; please refer to the [CONTRIBUTING](./CONTRIBUTING.md) file for details

## Licensing

Copyright (C) Diia and all other contributors.

Licensed under the  **EUPL**  (the "License"); you may not use this file except in compliance with the License. Re-use is permitted, although not encouraged, under the EUPL, with the exception of source files that contain a different license.

You may obtain a copy of the License at  [https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12](https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12).

Questions regarding the Diia project, the License and any re-use should be directed to [modt.opensource@thedigital.gov.ua](mailto:modt.opensource@thedigital.gov.ua).
